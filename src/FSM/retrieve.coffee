define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Retrieve
  {
    block_retrieve:
      _onEnter: () -> @transition 'missing'

    missing:
      _onEnter: () -> @handle @resource.missing()
      true:     'block_missing_precondition'
      false:    'block_precondition'

    # Moved
    block_retrieve_moved:
      _onEnter: () -> @transition 'moved'

    moved:
      _onEnter: () -> @handle @resource.moved()
      false:    'block_create'
      true:     'moved_permanently'

    moved_permanently:
      _onEnter: () -> @handle @resource.moved_permanently()
      false:    'moved_temporarily'
      true:     () ->
        @operation.response.statusCode or= status.MOVED_PERMANENTLY
        'block_error'

    moved_temporarily:
      _onEnter: () -> @handle @resource.moved_temporarily()
      false:    'moved_is_method_create'
      true:     () ->
        @operation.response.statusCode or= status.TEMPORARY_REDIRECT
        'block_error'

    moved_is_method_create:
      _onEnter: () -> @handle @resource.moved_is_method_create()
      true:     'block_create'
      false:    () ->
        @operation.response.statusCode or= status.GONE
        'block_error'
  }
