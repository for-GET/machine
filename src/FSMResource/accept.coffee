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
      accept = @transaction.request.h.accept
      unless accept? and (accept instanceof AcceptHeader or accept.toString() is '*/*')
        @transaction.response.chosen.contentType = @default_content_type_provided()
        return false
      true
    accept_matches: () -> # : in
      provided = @content_types_provided()
      tokenHandler = @transaction.request.h.accept.chooseTokenHandler(provided) or {}
      return false  unless tokenHandler?.token
      @transaction.response.chosen.contentType = tokenHandler
      true
    has_accept_language: () -> # : in
      acceptLanguage = @transaction.request.h.acceptLanguage
      unless acceptLanguage? and (acceptLanguage instanceof AcceptLanguageHeader or acceptLanguage.toString() is '*')
        @transaction.response.chosen.canguage = @default_language_provided()
        return false
      true
    accept_language_matches: () -> # : in
      provided = @languages_provided()
      tokenHandler = @transaction.request.h.acceptLanguage.chooseTokenHandler(provided) or {}
      return false  unless tokenHandler?.token
      @transaction.response.chosen.language = tokenHandler
      true
    has_accept_charset: () -> # : in
      acceptCharset = @transaction.request.h.acceptCharset
      unless acceptCharset? and (acceptCharset instanceof AcceptCharsetHeader or acceptCharset.toString() is '*')
        @transaction.response.chosen.charset = @default_charset_provided()
        return false
      true
    accept_charset_matches: () -> # : in
      provided = @charsets_provided()
      tokenHandler = @transaction.request.h.acceptCharset.chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @transaction.response.chosen.charset = tokenHandler
      true
    has_accept_encoding: () -> # : in
      acceptEncoding = @transaction.request.h.acceptEncoding
      unless acceptEncoding and (acceptEncoding instanceof AcceptEncodingHeader or acceptEncoding.toString() is '*')
        @transaction.response.chosen.encoding = @default_encoding_provided()
        return false
      true
    accept_encoding_matches: () -> # : in
      provided = @encodings_provided()
      tokenHandler = @transaction.request.h.acceptEncoding.chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @transaction.response.chosen.encoding = tokenHandler
      true
  }
