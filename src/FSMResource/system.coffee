define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'otw/like/HTTP/AcceptHeader'
  'otw/like/HTTP/ContentTypeHeader'
], (
  AcceptHeader
  ContentTypeHeader
) ->
  "use strict"

  camelcase = (str) ->
    str = str[0].toUpperCase() + str.substr(1).toLowerCase()
    str = str.replace /-([a-z])/g, (matches) -> matches.toUpperCase()
    str

  # System
  {
    start: () -> # : in
      if @operation.headers.accept
        @operation.h.accept = new AcceptHeader @operation.headers.accept
      if @operation.headers['content-type']
        @operation.h.contentType = new ContentTypeHeader @operation.headers['content-type']
      true
    is_service_available: () -> # :bin
      true
    is_method_implemented: () -> # : in
      @method() in @implemented_methods()
    are_content_headers_implemented: () -> # : in
      implemented_content_headers = @implemented_content_headers()
      for header, value of @operation.headers
        continue  unless /^content\-/.test header
        return false  unless header in implemented_content_headers
      true
    are_expect_extensions_implemented: () -> # : in
      implemented_expect_extensions = @implemented_expect_extensions()
      for extension in implemented_expect_extensions
        return false  unless @operation.h.expect.matchesToken extension
      true
    camelcase_response_headers: () -> # : in
      camelcaseExceptions =
        'www-authenticate': 'WWW-Authenticate'
        'content-md5': 'Content-MD5'
      map = {}
      for header in @operation.response.headers
        map[header] = camelcaseExceptions[header] or camelcase header
      map
    last: () -> # : in
      res = @operation._res
      res.sendDate = false # Disable automation
      res.statusCode = @operation.response.statusCode
      @operation.response.headers[header] ?= h.toString()  for header, h of @operation.response.h
      res.setHeader header, value  for header, value of @operation.response.headers
      @camelcase_response_headers()  if @need_camelcased_response_headers()
      if @operation.response.representation
        res.write @operation.response.representation, @operation.response.chosen.charset[0]
      @override()
    finish: () -> # : in
      @operation._res.end()
  }
