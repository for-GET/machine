define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  status = httpWell.statusPhrasesToCodes

  # Accept
  {
    block_accept:
      _onEnter: () -> @transition 'has_accept'

    has_accept:
      _onEnter: () -> @handle @resource.has_accept()
      true:     'accept_matches'
      false:    'has_accept_language'

    accept_matches:
      _onEnter: () -> @handle @resource.accept_matches()
      true:     'has_accept_language'
      false:    'ignore_accept_block_mismatches'

    has_accept_language:
      _onEnter: () -> @handle @resource.has_accept_language()
      true:     'accept_language_matches'
      false:    'has_accept_charset'

    accept_language_matches:
      _onEnter: () -> @handle @resource.accept_language_matches()
      true:     'has_accept_charset'
      false:    'ignore_accept_block_mismatches'

    has_accept_charset:
      _onEnter: () -> @handle @resource.has_accept_charset()
      true:     'accept_charset_matches'
      false:    'has_accept_encoding'

    accept_charset_matches:
      _onEnter: () -> @handle @resource.accept_charset_matches()
      true:     'has_accept_encoding'
      false:    'ignore_accept_block_mismatches'

    has_accept_encoding:
      _onEnter: () -> @handle @resource.has_accept_encoding()
      true:     'accept_encoding_matches'
      false:    'block_retrieve'

    accept_encoding_matches:
      _onEnter: () -> @handle @resource.accept_encoding_matches()
      true:     'block_retrieve'
      false:    'ignore_accept_block_mismatches'

    ignore_accept_block_mismatches:
      _onEnter: () -> @handle @resource.ignore_accept_block_mismatches()
      true:     'block_retrieve'
      false:    () ->
        @operation.response.statusCode or= status.NOT_ACCEPTABLE
        'block_error'
  }
