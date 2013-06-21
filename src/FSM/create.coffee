define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  status = httpWell.statusPhrasesToCodes

  # Create
  {
    block_create:
      _onEnter: () -> @transition 'create_is_method_put'

    # PUT
    create_is_method_put:
      _onEnter: () -> @handle @resource.create_is_method_put()
      true:     () -> @transition 'create_put'
      false:    () -> @transition 'is_method_create'

    create_put:
      _onEnter: () -> @handle @resource.create_put()
      true:     () -> @transition 'create_is_location_set'
      false:    () ->
        @operation.response.statusCode or= status.CONFLICT
        @transition 'block_error'

    # Others
    is_method_create:
      _onEnter: () -> @handle @resource.is_method_create()
      true:     () -> @transition 'create_path'
      false:    () ->
        @operation.response.statusCode or= status.NOT_FOUND
        @transition 'block_error'

    create_path:
      _onEnter: () -> @handle @resource.create_path()
      true:     () -> @transition 'create'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        @transition 'block_error'

    create:
      _onEnter: () -> @handle @resource.create()
      true:     () -> @transition 'block_response_create'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        @transition 'block_error'
  }
