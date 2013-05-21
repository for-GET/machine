define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'machina'
  'otw/like/lodash'
  './FSM/system'
  './FSM/request'
  './FSM/accept'
  './FSM/retrieve'
  './FSM/precondition'
  './FSM/create'
  './FSM/process'
  './FSM/response'
  './FSM/error'
], (
  machina
  _
  systemStates
  requestStates
  acceptStates
  retrieveStates
  preconditionStates
  createStates
  processStates
  responseStates
  errorStates
) ->
  "use strict"

  machinaFsm = machina(_, global).Fsm

  #
  class FSM extends machinaFsm
    context: undefined
    operation: undefined
    resource: undefined

    constructor: (@resource) ->
      @context = @resource.context
      @operation = @resource.operation

      states =
        init:
          true: () -> @transition 'block_system'

      _.extend states,
        systemStates,
        requestStates,
        acceptStates,
        retrieveStates,
        preconditionStates,
        createStates,
        processStates,
        responseStates,
        errorStates

      super {
        initialState: 'init'
        states
      }

      @on 'transition', (transition) -> console.log JSON.stringify transition
      @handle true


    handle: (inputType) ->
      inputType = Boolean inputType
      super inputType
