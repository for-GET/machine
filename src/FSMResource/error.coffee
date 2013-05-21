define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'otw/like/HTTP/AcceptHeader'
], (
  AcceptHeader
) ->
  "use strict"

  # Error
  {
    error_has_accept: () -> # : in
      accept = @operation.h.accept
      unless accept instanceof AcceptHeader or accept.toString() is '*/*'
        @operation.response.chosen.contentType = @error_default_content_type_provided()
        return false
      true
    error_accept_matches: () -> # : in
      provided = @error_content_types_provided()
      tokenHandler = @operation.h.accept.chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @operation.response.chosen.contentType = tokenHandler
      true
    error_to_content: () -> # : in
      # FIXME
  }
