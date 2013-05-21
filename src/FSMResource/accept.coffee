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
      accept = @operation.h.accept
      unless accept instanceof AcceptHeader or accept?.toString() is '*/*'
        @operation.response.chosen.contentType = @default_content_type_provided()
        return false
      true
    accept_matches: () -> # : in
      provided = @content_types_provided()
      tokenHandler = @operation.h.accept.chooseTokenHandler(provided) or {}
      return false  unless tokenHandler?.token
      @operation.response.chosen.contentType = tokenHandler
      true
    has_accept_language: () -> # : in
      acceptLanguage = @operation.h.acceptLanguage
      unless acceptLanguage instanceof AcceptLanguageHeader or acceptLanguage?.toString() is '*'
        @operation.response.chosen.canguage = @default_language_provided()
        return false
      true
    accept_language_matches: () -> # : in
      provided = @languages_provided()
      tokenHandler = @operation.h.acceptLanguage.chooseTokenHandler(provided) or {}
      return false  unless tokenHandler?.token
      @operation.response.chosen.language = tokenHandler
      true
    has_accept_charset: () -> # : in
      acceptCharset = @operation.h.acceptCharset
      unless acceptCharset instanceof AcceptCharsetHeader or chosenCharset?.toString() is '*'
        @operation.response.chosen.charset = @default_charset_provided()
        return false
      true
    accept_charset_matches: () -> # : in
      provided = @charsets_provided()
      tokenHandler = @operation.h.acceptCharset.chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @operation.response.chosen.charset = tokenHandler
      true
    has_accept_encoding: () -> # : in
      acceptEncoding = @operation.h.acceptEncoding
      unless acceptEncoding instanceof AcceptEncodingHeader or acceptEncoding?.toString() is '*'
        @operation.response.chosen.encoding = @default_encoding_provided()
        return false
      true
    accept_encoding_matches: () -> # : in
      provided = @encodings_provided()
      tokenHandler = @operation.h.acceptEncoding.chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @operation.response.chosen.encoding = tokenHandler
      true
  }
