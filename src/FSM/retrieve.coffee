define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Retrieve
  {
    block_retrieve:
      _onEnter: () -> @transition 'exists'

    exists:
      _onEnter: () -> @handle @resource.exists()
      false:    () -> @transition 'block_create_precondition'
      true:     () -> @transition 'block_precondition'
  }
