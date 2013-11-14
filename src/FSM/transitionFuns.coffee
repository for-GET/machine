define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  statusWell = httpWell.statusPhrasesToCodes

  {
    # Status code
    '100_CONTINUE:anything': () ->
      @response.writeStatus statusWell.CONTINUE

    # Request
    'is_method_implemented:false': () ->
      @response.headers.allow or= @resource.allow_header()

    'is_authorized:false': () ->
      @response.headers['www-authenticate'] or= @resource.www_authenticate_header()

    'is_method_trace:true': () ->
      @resource.process_trace()

    'is_method_options:true': () ->
      @resource.process_options()

    'is_content_type_accepted:false': () ->
      method = @request.method.toLowerCase()
      @response.headers["accept-#{method}"] or= @resource["accept_#{method}_header"]()

    # Response
    'create_see_other:true': () ->
      # FIXME set Location

    'create_see_other:false': () ->
      # FIXME set Location

    'to_content:true': () ->
      # FIXME
      # @transaction.request.h.vary = @resource.vary_header()
      # @transaction.request.h.etag = @resource.etag_header()
      # @transaction.request.h['last-modified'] = @resource.last_modified_header()
      # @transaction.request.h.expires = @resource.expires_header()
      # @transaction.request.h['cache-control'] = @resource.cache_control_header()
      # @transaction.request.h.date = @resource.date_header()
  }
