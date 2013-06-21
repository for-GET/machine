define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  status = httpWell.statusPhrasesToCodes

  # Request
  {
    block_request:
      _onEnter: () -> @transition 'is_method_implemented'

    is_method_implemented:
      _onEnter: () -> @handle @resource.is_method_implemented()
      true:     () -> @transition 'is_authorized'
      false:    () ->
        @operation.response.h.allow or= @resource.allow_header()
        @operation.response.statusCode or= status.METHOD_NOT_ALLOWED
        @transition 'block_error'

    is_authorized:
      _onEnter: () -> @handle @resource.is_authorized()
      true:     () -> @transition 'is_method_trace'
      false:    () ->
        @operation.response.wwwAuthenticate or= @resource.www_authenticate_header()
        @operation.response.statusCode or= status.UNAUTHORIZED
        @transition 'block_error'

    is_method_trace:
      _onEnter: () -> @handle @resource.is_method_trace()
      false:    () -> @transition 'is_method_options'
      true:     () ->
        @resource.process_trace()
        @operation.response.statusCode or= status.OK
        @transition 'last'

    is_method_options:
      _onEnter: () -> @handle @resource.is_method_options()
      false:    () -> @transition 'expects_continue'
      true:     () ->
        @resource.process_options()
        @operation.response.statusCode or= status.OK
        @transition 'last'

    expects_continue:
      _onEnter: () -> @handle @resource.expects_continue()
      false:    () -> @transition 'content_exists'
      true:     () ->
        @operation._res.writeContinue()
        @transition 'content_exists'

    content_exists:
      _onEnter: () -> @handle @resource.content_exists()
      true:     () -> @transition 'is_content_too_large'
      false:    () -> @transition 'is_forbidden'

    is_content_too_large:
      _onEnter: () -> @handle @resource.is_content_too_large()
      false:    () -> @transition 'is_content_type_accepted'
      true:     () ->
        @operation.response.statusCode or= status.PAYLOAD_TOO_LARGE
        @transition 'block_error'

    is_content_type_accepted:
      _onEnter: () -> @handle @resource.is_content_type_accepted()
      true:     () -> @transition 'process_request'
      false:    () ->
        method = @operation.method.toLowerCase()
        @operation.response.h["accept-#{method}"] or= @resource["accept_#{method}_header"]()
        @operation.response.statusCode or= status.UNSUPPORTED_MEDIA_TYPE
        @transition 'block_error'

    process_request:
      _onEnter: () -> @handle @resource.process_request()
      true:     () -> @transition 'is_forbidden'
      false:    () ->
        @operation.response.statusCode or= status.BAD_REQUEST
        @transition 'block_error'

    is_forbidden:
      _onEnter: () -> @handle @resource.is_forbidden()
      false:    () -> @transition 'is_request_block_ok'
      true:     () ->
        @operation.response.statusCode or= status.FORBIDDEN
        @transition 'block_error'

    is_request_block_ok:
      _onEnter: () -> @handle @resource.is_request_block_ok()
      true:     () -> @transition 'block_accept'
      false:    () ->
        @operation.response.statusCode or= status.BAD_REQUEST
        @transition 'block_error'
  }
