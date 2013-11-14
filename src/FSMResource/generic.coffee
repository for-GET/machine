define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  {
    # Generic
    is_method_trace: () -> # : in
      @method() is 'TRACE'
    is_method_options: () -> # : in
      @method() is 'OPTIONS'
    is_method_head_get: () -> # : in
      @method() in ['HEAD', 'GET']
    is_method_put: () -> # : in
      @method() is 'PUT'
    is_method_delete: () -> # : in
      @method() is 'DELETE'
    is_method_safe: () -> # : in
      @method() in @safe_methods()
    is_method_create: () -> # : in
      @method() in @create_methods()
    is_method_process: () -> # : in
      @method() in @process_methods()
    is_location_set: () -> # : in
      @response.headers.location isnt undefined
  }
