define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  './FSM'
  './Resource'
], (
  BuiltInFSM
  BuiltInResource
) ->
  "use strict"

  #
  (Resource, FSM) ->
    Resource ?= BuiltInResource
    FSM ?= BuiltInFSM

    (req, res, next) ->
      resource = new Resource req, res
      new FSM resource
