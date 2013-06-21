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
      true:     () -> @transition 'block_missing_precondition'
      false:    () -> @transition 'block_precondition'

    # Moved
    block_retrieve_moved:
      _onEnter: () -> @transition 'moved'

    moved:
      _onEnter: () -> @handle @resource.moved()
      false:    () -> @transition 'block_create'
      true:     () -> @transition 'moved_permanently'

    moved_permanently:
      _onEnter: () -> @handle @resource.moved_permanently()
      false:    () -> @transition 'moved_temporarily'
      true:     () ->
        @operation.response.statusCode or= status.MOVED_PERMANENTLY
        @transition 'block_error'

    moved_temporarily:
      _onEnter: () -> @handle @resource.moved_temporarily()
      false:    () -> @transition 'moved_is_method_create'
      true:     () ->
        @operation.response.statusCode or= status.TEMPORARY_REDIRECT
        @transition 'block_error'

    moved_is_method_create:
      _onEnter: () -> @handle @resource.moved_is_method_create()
      true:     () -> @transition 'block_create'
      false:    () ->
        @operation.response.statusCode or= status.GONE
        @transition 'block_error'
  }
