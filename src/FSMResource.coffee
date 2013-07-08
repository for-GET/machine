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
  './FSMResource/alternative'
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
  alternativeBlock
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
    alternativeBlock
  ]

  #
  class FSMResource
    transaction: undefined
    context: undefined


    for callbackBlock in callbackBlocks
      for callback, fun of callbackBlock
        @::[callback] = fun


    constructor: (@transaction) ->
      undefined
