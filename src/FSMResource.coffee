define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  './FSMResource/generic'
  './FSMResource/system'
  './FSMResource/request'
  './FSMResource/accept'
  './FSMResource/retrieve'
  './FSMResource/precondition'
  './FSMResource/create'
  './FSMResource/process'
  './FSMResource/response'
  './FSMResource/error'
  './helpers.coffee'
], (
  genericCallbacks
  systemBlock
  requestBlock
  acceptBlock
  retrieveBlock
  preconditionBlock
  createBlock
  processBlock
  responseBlock
  errorBlock
  helpers
) ->
  "use strict"

  callbackBlocks = [
    genericCallbacks
    systemBlock
    requestBlock
    acceptBlock
    retrieveBlock
    preconditionBlock
    createBlock
    processBlock
    responseBlock
    errorBlock
  ]

  #
  class FSMResource
    context: undefined
    operation: undefined


    for callbackBlock in callbackBlocks
      for callback, fun of callbackBlock
        @::[callback] = fun


    constructor: (req, res) ->
      res._headers ?= {} # Pass by reference

      @operation = {
        _req: req
        _res: res
        method: helpers.reqToMethod req
        uri: helpers.reqToURI req
        headers: req.headers
        representation: req.body
        h: {}
        response:
          statusCode: undefined
          headers: res._headers
          representation: undefined
          h: {}
          chosen:
            contentType: undefined
            language: undefined
            charset: undefined
            encoding: undefined
      }


    @middleware: (Resource) ->
      middleware = require './middleware'
      middleware @, Resource
