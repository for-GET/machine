define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'otw/like/HTTP/AcceptHeader'
  'otw/like/HTTP/AcceptCharsetHeader'
  'otw/like/HTTP/AcceptEncodingHeader'
  'otw/like/HTTP/AcceptLanguageHeader'
], (
  AcceptHeader
  AcceptCharsetHeader
  AcceptEncodingHeader
  AcceptLanguageHeader
) ->
  "use strict"

  # Accept
  {
    has_accept: () -> # : in
      accept = @request.headers.accept
      return true  if accept? and accept.toString() isnt '*/*'
      @response.content.type = @default_content_type_provided()
      false
    accept_matches: () -> # : in
      provided = @content_types_provided()
      tokenHandler = @request.headers.accept.chooseTokenHandler(provided) or {}
      return false  unless tokenHandler?.token
      @response.content.type = tokenHandler
      true
    has_accept_language: () -> # : in
      acceptLanguage = @request.headers['accept-language']
      return true  if acceptLanguage? and acceptLanguage.toString() isnt '*'
      @response.content.language = @default_language_provided()
      false
    accept_language_matches: () -> # : in
      provided = @languages_provided()
      tokenHandler = @request.headers['accept-language'].chooseTokenHandler(provided) or {}
      return false  unless tokenHandler?.token
      @response.content.language = tokenHandler
      true
    has_accept_charset: () -> # : in
      acceptCharset = @request.headers['accept-charset']
      return true  if acceptCharset? and acceptCharset.toString() isnt '*'
      @response.content.charset = @default_charset_provided()
      false
    accept_charset_matches: () -> # : in
      provided = @charsets_provided()
      tokenHandler = @request.headers['accept-charset'].chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @response.content.charset = tokenHandler
      true
    has_accept_encoding: () -> # : in
      acceptEncoding = @request.headers['accept-encoding']
      return true  if acceptEncoding? and acceptEncoding.toString() isnt '*'
      @response.content.encoding = @default_encoding_provided()
      false
    accept_encoding_matches: () -> # : in
      provided = @encodings_provided()
      tokenHandler = @request.headers['accept-encoding'].chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @response.content.encoding = tokenHandler
      true
  }
