define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'querystring'
  'otw/like/HTTP/AcceptHeader'
  'otw/like/HTTP/AllowHeader'
  'otw/like/HTTP/ExpectHeader'
  'otw/like/HTTP/ContentTypeHeader'
], (
  QueryString
  AcceptHeader
  AllowHeader
  ExpectHeader
  ContentTypeHeader
) ->
  "use strict"

  accept_header = (contentTypes) ->
    contentTypes = contentTypes.map (contentType) -> new ContentTypeHeader contentType
    acceptHeader = new AcceptHeader()
    acceptHeader.tokens = contentTypes.map (contentTypeHeader) -> contentTypeHeader.token
    acceptHeader

  # Request
  {
    is_method_allowed: () -> # : in
      @method() in @allowed_methods()
    allow_header: () -> # : in
      allowHeader = new AllowHeader()
      allowHeader.tokens = @allowed_methods().map (method) -> {method}
      allowHeader
    www_authenticate_header: () -> # : in
      # FIXME
    process_trace: () -> # : in
      response = @operation.response
      headers = @operation.headers
      sensitiveHeaders= @trace_sensitive_headers()
      headersRepresentation = []
      for header, value of headers
        continue  if header in sensitiveHeaders
        headersRepresentation.push "#{header}: #{value}"
      response.headers['content-type'] = 'message/http'
      response.representation = headersRepresentation
      true
    accept_patch_header: () -> # : in
      accept_header Object.keys @patch_content_types_accepted()
    accept_post_header: () -> # : in
      accept_header Object.keys @post_content_types_accepted()
    accept_put_header: () -> # : in
      accept_header Object.keys @put_content_types_accepted()
    process_options: () -> # : in
      @operation.response.h.allow = @allow_header()
      @operation.response.h['accept-patch'] = @accept_patch_header()
      @operation.response.h['accept-post'] = @accept_post_header()
      @operation.response.h['accept-put'] = @accept_put_header()
    has_expect: () -> # : in
      expect = @operation.h.expect
      expect instanceof ExpectHeader
    expects_continue: () -> # : in
      @has_expect() and @operation.h.expect.matchesToken '100-continue'
    content_exists: () -> # : in
      @operation.headers['content-length'] or @operation.representation?.length
    content_types_accepted: () -> # : in
      method = @method().toLowerCase()
      fun = "#{method}_content_types_accepted"
      return {}  unless @[fun]
      @[fun]()
    is_content_type_accepted: () -> # : in
      accepted = new AcceptHeader Object.keys(@content_types_accepted()).join ','
      accepted.matchesToken @operation.headers['content-type']
  }
