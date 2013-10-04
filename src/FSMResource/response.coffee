define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Response
  {
    to_content: () -> # : in
      # FIXME

      hasContent = @transaction.response.chosen.contentType[1]?()
      return false  unless hasContent

      @transaction.response.headers['content-encoding'] = @transaction.response.chosen.encoding.toString()
  }
