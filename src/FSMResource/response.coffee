define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Response
  {
    to_content: () -> # : in
      # FIXME

      return false  unless @response.representation?

      @response.headers['content-encoding'] = @response.content.encoding.toString()
  }
