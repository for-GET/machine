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
      _onEnter: () -> @transition 'create_put_filter'

    create_put_filter:
      _onEnter: () -> @handle @resource.create_put_filter()
      true:     () -> @transition 'put_moved_permanently'
      false:    () -> @transition 'previously_existed'

    # PUT
    put_moved_permanently:
      _onEnter: () -> @handle @resource.moved_permanently()
      false:    () -> @transition 'create_put'
      true:     () ->
        @operation.response.statusCode or= status.MOVED_PERMANENTLY
        @transition 'block_error'

    create_put:
      _onEnter: () -> @handle @resource.create_put()
      true:     () -> @transition 'create_is_location_set'
      false:    () ->
        @operation.response.statusCode or= status.CONFLICT
        @transition 'block_error'

    # Others
    previously_existed:
      _onEnter: () -> @handle @resource.previously_existed()
      false:    () -> @transition 'new_and_create_filter'
      true:     () -> @transition 'moved_permanently'

    new_and_create_filter:
      _onEnter: () -> @handle @resource.create_filter()
      true:     () -> @transition 'create_path'
      false:    () ->
        @operation.response.statusCode or= status.NOT_FOUND
        @transition 'block_error'

    moved_permanently:
      _onEnter: () -> @handle @resource.moved_permanently()
      false:    () -> @transition 'moved_temporarily'
      true:     () ->
        @operation.response.statusCode or= status.MOVED_PERMANENTLY
        @transition 'block_error'

    moved_temporarily:
      _onEnter: () -> @handle @resource.moved_temporarily()
      false:    () -> @transition 'create_filter'
      true:     () ->
        @operation.response.statusCode or= status.MOVED_TEMPORARILY
        @transition 'block_error'

    create_filter:
      _onEnter: () -> @handle @resource.create_filter()
      true:     () -> @transition 'create_path'
      false:    () ->
        @operation.response.statusCode or= status.GONE
        @transition 'block_error'

    create_path:
      _onEnter: () -> @handle @resource.create_path()
      true:     () -> @transition 'create'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        @transition 'block_error'

    create:
      _onEnter: () -> @handle @resource.create()
      true:     () -> @transition 'create_is_location_set'
      false:    () ->
        @operation.response.statusCode or= status.INTERNAL_SERVER_ERROR
        @transition 'block_error'

    create_is_location_set:
      _onEnter: () -> @handle @resource.is_location_set()
      true:     () -> @transition 'block_response'
      false:    () ->
        @operation.response.statusCode or= status.CREATED
        @transition 'block_response'
  }
