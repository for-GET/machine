define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Alternative
  {
    block_response_alternative:
      _onEnter: () -> @transition 'is_alternative_response'

    is_alternative_response:
      _onEnter: () -> @handle @resource.is_alternative_response()
      true:     'alternative_has_accept'
      false:    'last'


    alternative_has_accept:
      _onEnter: () -> @handle @resource.alternative_has_accept()
      true:     'alternative_accept_matches'
      false:    'last'

    alternative_accept_matches:
      _onEnter: () -> @handle @resource.alternative_accept_matches()
      true:     'alternative_to_content'
      false:    'last'

    alternative_to_content:
      _onEnter: () ->
        @handle @resource.to_content()
        'last'
  }
