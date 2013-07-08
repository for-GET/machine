define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  statusWell = httpWell.statusPhrasesToCodes

  # Create
  {
    block_create:
      _onEnter: () -> @transition 'create_is_method_put'

    # PUT
    create_is_method_put:
      _onEnter: () -> @handle @resource.create_is_method_put()
      true:     'create_put'
      false:    'is_method_create'

    create_put:
      _onEnter: () -> @handle @resource.create_put()
      true:     'create_is_location_set'
      false:    () ->
        @transaction.response.status or= statusWell.CONFLICT
        'block_response_alternative'

    # Others
    is_method_create:
      _onEnter: () -> @handle @resource.is_method_create()
      true:     'create_path'
      false:    () ->
        @transaction.response.status or= statusWell.NOT_FOUND
        'block_response_alternative'

    create_path:
      _onEnter: () -> @handle @resource.create_path()
      true:     'create'
      false:    () ->
        @transaction.response.status or= statusWell.INTERNAL_SERVER_ERROR
        'block_response_alternative'

    create:
      _onEnter: () -> @handle @resource.create()
      true:     'block_response_create'
      false:    () ->
        @transaction.response.status or= statusWell.INTERNAL_SERVER_ERROR
        'block_response_alternative'
  }
