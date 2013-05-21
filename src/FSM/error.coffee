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
      true:     () -> @transition 'error_accept_matches'
      false:    () -> @transition 'last'

    error_accept_matches:
      _onEnter: () -> @handle @resource.error_accept_matches()
      true:     () -> @transition 'error_to_content'
      false:    () -> @transition 'last'

    error_to_content:
      _onEnter: () ->
        @handle @resource.error_to_content()
        @transition 'last'
  }
