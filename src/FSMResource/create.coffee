define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Create
  {
    existed_is_method_create: () -> # : in
      @is_method_create()
    create_is_method_put: () -> # : in
      @is_method_put()
    create_path: () -> # : in
      return false  unless @path()
      true
    create_is_location_set: () -> # : in
      @is_location_set()
  }
