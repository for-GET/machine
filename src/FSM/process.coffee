define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  status = httpWell.statusPhrasesToCodes

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
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        'block_error'

    # PUT
    is_method_put:
      _onEnter: () -> @handle @resource.is_method_put()
      true:     'process_put'
      false:    'is_method_process'

    process_put:
      _onEnter: () -> @handle @resource.process_put()
      true:     'block_response'
      false:    () ->
        @operation.response.statusCode or= status.CONFLICT
        'block_error'

    # Others
    is_method_process:
      _onEnter: () -> @handle @resource.is_method_process()
      true:     'process'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        'block_error'

    process:
      _onEnter: () -> @handle @resource.process()
      true:     'block_response'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        'block_error'
  }
