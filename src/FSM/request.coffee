define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  statusWell = httpWell.statusPhrasesToCodes

  # Request
  {
    block_request:
      _onEnter: () -> @transition 'is_method_implemented'

    is_method_implemented:
      _onEnter: () -> @handle @resource.is_method_implemented()
      true:     'is_authorized'
      false:    () ->
        @transaction.response.h.allow or= @resource.allow_header()
        @transaction.response.status or= statusWell.METHOD_NOT_ALLOWED
        'block_response_alternative'

    is_authorized:
      _onEnter: () -> @handle @resource.is_authorized()
      true:     'is_method_trace'
      false:    () ->
        @transaction.response.wwwAuthenticate or= @resource.www_authenticate_header()
        @transaction.response.status or= statusWell.UNAUTHORIZED
        'block_response_alternative'

    is_method_trace:
      _onEnter: () -> @handle @resource.is_method_trace()
      false:    'is_method_options'
      true:     () ->
        @resource.process_trace()
        @transaction.response.status or= statusWell.OK
        'last'

    is_method_options:
      _onEnter: () -> @handle @resource.is_method_options()
      false:    'expects_continue'
      true:     () ->
        @resource.process_options()
        @transaction.response.status or= statusWell.OK
        'last'

    expects_continue:
      _onEnter: () -> @handle @resource.expects_continue()
      false:    'content_exists'
      true:     () ->
        @transaction._res.writeContinue()
        'content_exists'

    content_exists:
      _onEnter: () -> @handle @resource.content_exists()
      true:     'is_content_too_large'
      false:    'is_forbidden'

    is_content_too_large:
      _onEnter: () -> @handle @resource.is_content_too_large()
      false:    'is_content_type_accepted'
      true:     () ->
        @transaction.response.status or= statusWell.PAYLOAD_TOO_LARGE
        'block_response_alternative'

    is_content_type_accepted:
      _onEnter: () -> @handle @resource.is_content_type_accepted()
      true:     'process_request'
      false:    () ->
        method = @transaction.method.toLowerCase()
        @transaction.response.h["accept-#{method}"] or= @resource["accept_#{method}_header"]()
        @transaction.response.status or= statusWell.UNSUPPORTED_MEDIA_TYPE
        'block_response_alternative'

    process_request:
      _onEnter: () -> @handle @resource.process_request()
      true:     'is_forbidden'
      false:    () ->
        @transaction.response.status or= statusWell.BAD_REQUEST
        'block_response_alternative'

    is_forbidden:
      _onEnter: () -> @handle @resource.is_forbidden()
      false:    'is_request_block_ok'
      true:     () ->
        @transaction.response.status or= statusWell.FORBIDDEN
        'block_response_alternative'

    is_request_block_ok:
      _onEnter: () -> @handle @resource.is_request_block_ok()
      true:     'block_accept'
      false:    () ->
        @transaction.response.status or= statusWell.BAD_REQUEST
        'block_response_alternative'
  }
