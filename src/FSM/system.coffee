define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  status = httpWell.statusPhrasesToCodes

  # System
  {
    block_system:
      _onEnter: () -> @transition 'start'

    start:
      _onEnter: () ->
        @resource.start()
        @transition 'is_service_available'

    is_service_available:
      _onEnter: () -> @handle @resource.is_service_available()
      true:     () -> @transition 'is_uri_too_long'
      false:    () ->
        @operation.response.statusCode or= status.SERVICE_NOT_AVAILABLE
        @transition 'block_error'

    is_uri_too_long:
      _onEnter: () -> @handle @resource.is_uri_too_long()
      false:    () -> @transition 'is_method_implemented'
      true:     () ->
        @operation.response.statusCode or= status.URI_TOO_LONG
        @transition 'block_error'

    is_method_implemented:
      _onEnter: () -> @handle @resource.is_method_implemented()
      true:     () -> @transition 'are_content_headers_implemented'
      false:    () ->
        @operation.response.statusCode or= status.NOT_IMPLEMENTED
        @transition 'block_error'

    are_content_headers_implemented:
      _onEnter: () -> @handle @resource.are_content_headers_implemented()
      true:     () -> @transition 'is_functionality_implemented'
      false:    () ->
        @operation.response.statusCode or= status.NOT_IMPLEMENTED
        @transition 'block_error'

    is_functionality_implemented:
      _onEnter: () -> @handle @resource.is_functionality_implemented()
      true:     () -> @transition 'are_expect_extensions_implemented'
      false:    () ->
        @operation.response.statusCode or= status.NOT_IMPLEMENTED
        @transition 'block_error'

    are_expect_extensions_implemented:
      _onEnter: () -> @handle @resource.are_expect_extensions_implemented()
      true:     () -> @transition 'block_request'
      false:    () ->
        @operation.response.statusCode or= status.EXPECTATION_FAILED
        @transition 'block_error'

    last:
      _onEnter: () ->
        @resource.last()
        @transition 'finish'

    finish:
      _onEnter: () ->
        @resource.finish()
  }