define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'otw/like/HTTP/AcceptHeader'
], (
  AcceptHeader
) ->
  "use strict"

  # Alternative
  {
    trace_content_types_provided: () -> # : in
      {
        'message/http': () ->
          # FIXME
      }
    default_trace_content_type_provided: () -> # : in
      ['message/http', @trace_content_types_provided()['message/http']]
    alternative_type: () -> # : in
      status = @operation.response.status.toString()
      return 'error'  if status? and status[0] in ['4', '5']
      return 'trace'  if @operation.method is 'TRACE'
      return 'options'  if @operation.method is 'OPTIONS'
      return 'choice'  if status? and statusWell.MULTIPLE_CHOICES
      undefined
    is_alternative_response: () -> # : in
      type = @alternative_type()
      type?
    alternative_content_types_provided: () -> # : in
      type = @alternative_type()
      return {}  unless type?
      @["#{type}_content_types_provided"]()
    default_alternative_content_type_provided: () -> # : in
      type = @alternative_type()
      return {}  unless type?
      @["default_#{type}_content_type_provided"]()
    alternative_has_accept: () -> # : in
      accept = @operation.h.accept
      unless accept instanceof AcceptHeader or accept.toString() is '*/*'
        @operation.response.chosen.contentType = @default_alternative_content_type_provided()
        return false
      true
    alternative_accept_matches: () -> # : in
      provided = @alternative_content_types_provided()
      tokenHandler = @operation.h.accept.chooseTokenHandler provided
      return false  unless tokenHandler?.token
      @operation.response.chosen.contentType = tokenHandler
      true
    alternative_to_content: () -> # : in
      # FIXME
  }
