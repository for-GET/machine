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
      false:    'found'
      true:     'block_missing_precondition'

    found:
      _onEnter: () -> @handle @resource.found()
      false:    'block_precondition'
      true:     () ->
        @transaction.response.status or= statusWell.FOUND
        'block_response_alternative'

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
        @transaction.response.status or= statusWell.MOVED_PERMANENTLY
        'block_response_alternative'

    moved_temporarily:
      _onEnter: () -> @handle @resource.moved_temporarily()
      false:    'moved_is_method_create'
      true:     () ->
        @transaction.response.status or= statusWell.TEMPORARY_REDIRECT
        'block_response_alternative'

    moved_is_method_create:
      _onEnter: () -> @handle @resource.moved_is_method_create()
      true:     'block_create'
      false:    () ->
        @transaction.response.status or= statusWell.GONE
        'block_response_alternative'
  }
