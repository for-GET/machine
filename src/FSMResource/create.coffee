define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Create
  {
    create_is_method_put: () -> # : in
      @is_method_put()
    create_path: () -> # : in
      return false  unless @path()
      true
  }
