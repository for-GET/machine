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
      true:     () -> @transition 'accept_matches'
      false:    () -> @transition 'has_accept_language'

    accept_matches:
      _onEnter: () -> @handle @resource.accept_matches()
      true:     () -> @transition 'has_accept_language'
      false:    () -> @transition 'ignore_accept_block_mismatches'

    has_accept_language:
      _onEnter: () -> @handle @resource.has_accept_language()
      true:     () -> @transition 'accept_language_matches'
      false:    () -> @transition 'has_accept_charset'

    accept_language_matches:
      _onEnter: () -> @handle @resource.accept_language_matches()
      true:     () -> @transition 'has_accept_charset'
      false:    () -> @transition 'ignore_accept_block_mismatches'

    has_accept_charset:
      _onEnter: () -> @handle @resource.has_accept_charset()
      true:     () -> @transition 'accept_charset_matches'
      false:    () -> @transition 'has_accept_encoding'

    accept_charset_matches:
      _onEnter: () -> @handle @resource.accept_charset_matches()
      true:     () -> @transition 'has_accept_encoding'
      false:    () -> @transition 'ignore_accept_block_mismatches'

    has_accept_encoding:
      _onEnter: () -> @handle @resource.has_accept_encoding()
      true:     () -> @transition 'accept_encoding_matches'
      false:    () -> @transition 'block_retrieve'

    accept_encoding_matches:
      _onEnter: () -> @handle @resource.accept_encoding_matches()
      true:     () -> @transition 'block_retrieve'
      false:    () -> @transition 'ignore_accept_block_mismatches'

    ignore_accept_block_mismatches:
      _onEnter: () -> @handle @resource.ignore_accept_block_mismatches()
      true:     () -> @transition 'block_retrieve'
      false:    () ->
        @operation.response.statusCode or= status.NOT_ACCEPTABLE
        @transition 'block_error'
  }
