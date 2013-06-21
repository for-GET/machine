define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Error
  {
    block_error:
      _onEnter: () -> @transition 'error_has_accept'

    error_has_accept:
      _onEnter: () -> @handle @resource.error_has_accept()
      true:     'error_accept_matches'
      false:    'last'

    error_accept_matches:
      _onEnter: () -> @handle @resource.error_accept_matches()
      true:     'error_to_content'
      false:    'last'

    error_to_content:
      _onEnter: () ->
        @handle @resource.error_to_content()
        'last'
  }
