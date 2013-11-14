define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'otw/like/HTTP/AcceptHeader'
  'otw/like/HTTP/ContentTypeHeader'
  'camelize-http-headers'
], (
  AcceptHeader
  ContentTypeHeader
  camelize
) ->
  "use strict"

  # System
  {
    start: () -> # : in
      true
    is_method_implemented: () -> # : in
      @method() in @implemented_methods()
    are_content_headers_implemented: () -> # : in
      implemented_content_headers = @implemented_content_headers()
      for name, value of @request.headers
        continue  unless /^content\-/.test name
        return false  unless name in implemented_content_headers
      true
    are_expect_extensions_implemented: () -> # : in
      expect = @request.headers.expect
      return true  unless expect?
      implemented_expect_extensions = @implemented_expect_extensions()
      for extension in implemented_expect_extensions
        return false  unless expect.matchesToken extension
      true
    has_content: () -> # : in
      return true  if @request.representation?
      false
    camelcase_response_headers: () -> # : in
      @response.headers = camelize @response.headers
    last: () -> # : in
      @camelcase_response_headers()  if @need_camelcased_response_headers()
      if @response.representation?
        # FIXME set content headers
        @response.write @response.representation, @response.content.charset.toString()
      @override()
    finish: () -> # : in
      @response.end()
  }
