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
      if @transaction.headers.accept
        @transaction.h.accept = new AcceptHeader @transaction.headers.accept
      if @transaction.headers['content-type']
        @transaction.h.contentType = new ContentTypeHeader @transaction.headers['content-type']
      true
    is_method_implemented: () -> # : in
      @method() in @implemented_methods()
    are_content_headers_implemented: () -> # : in
      implemented_content_headers = @implemented_content_headers()
      for header, value of @transaction.headers
        continue  unless /^content\-/.test header
        return false  unless header in implemented_content_headers
      true
    are_expect_extensions_implemented: () -> # : in
      implemented_expect_extensions = @implemented_expect_extensions()
      for extension in implemented_expect_extensions
        return false  unless @transaction.h.expect.matchesToken extension
      true
    camelcase_response_headers: () -> # : in
      @transaction.response.headers = camelize @transaction.response.headers
    last: () -> # : in
      res = @transaction._res
      res.sendDate = false # Disable automation
      res.statusCode = @transaction.response.status
      @transaction.response.headers[header] ?= h.toString()  for header, h of @transaction.response.h
      res.setHeader header, value  for header, value of @transaction.response.headers
      @camelcase_response_headers()  if @need_camelcased_response_headers()
      if @transaction.response.representation
        res.write @transaction.response.representation, @transaction.response.chosen.charset[0]
      @override()
    finish: () -> # : in
      @transaction._res.end()
  }
