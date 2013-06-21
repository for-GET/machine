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

      @operation.log = _.extend (@operation.log or {}),
        callbacks: []
        transitions: []

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

      # Keep track of transitions
      @on 'transition', (transition) =>
        transition = {
          from: transition.fromState
          to: transition.toState
        }
        if false # FIXME check for debug
          transition.operation = _.omit @operation, (prop) -> prop[0] is '_'
        @operation.log.transitions.push transition

      # Keep track of callback results
      for k, v of @resource
        continue  unless _.isFunction v
        do () =>
          callback = k
          fun = v
          @resource[callback] = () =>
            state = @state
            result = fun.apply @resource, arguments
            @operation.log.callbacks.push {
              state
              callback
              result
            }
            result

      @handle true


    handle: (inputType) ->
      inputType = Boolean inputType
      super inputType
