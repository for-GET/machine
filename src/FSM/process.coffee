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
      _onEnter: () -> @transition 'is_method_delete'

    is_method_delete:
      _onEnter: () -> @handle @resource.is_method_delete()
      true:     () -> @transition 'process_delete'
      false:    () -> @transition 'is_method_put'

    process_delete:
      _onEnter: () -> @handle @resource.process_delete()
      true:     () -> @transition 'block_response'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        @transition 'block_error'

    is_method_put:
      _onEnter: () -> @handle @resource.is_method_put()
      true:     () -> @transition 'process_put'
      false:    () -> @transition 'is_method_process'

    process_put:
      _onEnter: () -> @handle @resource.process_put()
      true:     () -> @transition 'block_response'
      false:    () ->
        @operation.response.statusCode or= status.CONFLICT
        @transition 'block_error'

    is_method_process:
      _onEnter: () -> @handle @resource.is_method_process()
      true:     () -> @transition 'process'
      false:    () -> @transition 'block_response'

    process:
      _onEnter: () -> @handle @resource.process()
      true:     () -> @transition 'is_location_set'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        @transition 'block_error'

    is_location_set:
      _onEnter: () -> @handle @resource.is_location_set()
      true:     () -> @transition 'block_response'
      false:    () ->
        @operation.response.statusCode or= status.SEE_OTHER
        @transition 'last'

  }
