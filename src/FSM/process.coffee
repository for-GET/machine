define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  statusWell = httpWell.statusPhrasesToCodes

  # Process
  {
    block_process:
      _onEnter: () -> @transition 'is_method_head_get'

    # HEAD/GET
    is_method_head_get:
      _onEnter: () -> @handle @resource.is_method_head_get()
      true:     'block_response'
      false:    'is_method_delete'

    # DELETE
    is_method_delete:
      _onEnter: () -> @handle @resource.is_method_delete()
      true:     'process_delete'
      false:    'is_method_put'

    process_delete:
      _onEnter: () -> @handle @resource.process_delete()
      true:     'block_response'
      false:    () ->
        @operation.response.status or= statusWell.INTERNAL_SERVER_ERROR
        'block_response_alternative'

    # PUT
    is_method_put:
      _onEnter: () -> @handle @resource.is_method_put()
      true:     'process_put'
      false:    'is_method_process'

    process_put:
      _onEnter: () -> @handle @resource.process_put()
      true:     'block_response'
      false:    () ->
        @operation.response.status or= statusWell.CONFLICT
        'block_response_alternative'

    # Others
    is_method_process:
      _onEnter: () -> @handle @resource.is_method_process()
      true:     'process'
      false:    () ->
        @operation.response.status or= statusWell.INTERNAL_SERVER_ERROR
        'block_response_alternative'

    process:
      _onEnter: () -> @handle @resource.process()
      true:     'block_response'
      false:    () ->
        @operation.response.status or= statusWell.INTERNAL_SERVER_ERROR
        'block_response_alternative'
  }
