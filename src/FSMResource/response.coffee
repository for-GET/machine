define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Response
  {
    to_content: () -> # : in
      # FIXME

      return false  unless @transaction.response.chosen.contentType
      hasContent = @transaction.response.chosen.contentType.handler()
      return false  unless hasContent

      @transaction.response.headers['content-encoding'] = @transaction.response.chosen.encoding.toString()
  }
