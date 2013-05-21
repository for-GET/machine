define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Response
  {
    to_content: () -> # : in
      # FIXME

      return false  unless @operation.response.chosen.contentType
      hasContent = @operation.response.chosen.contentType.handler()
      return false  unless hasContent

      @operation.response.headers['content-encoding'] = @operation.response.chosen.encoding.toString()
  }
