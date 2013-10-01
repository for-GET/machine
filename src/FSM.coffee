define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'machina'
  'lodash'
  './FSM/system'
  './FSM/request'
  './FSM/accept'
  './FSM/retrieve'
  './FSM/precondition'
  './FSM/create'
  './FSM/process'
  './FSM/response'
  './FSM/alternative'
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
  alternativeStates
) ->
  "use strict"

  machinaFsm = machina(_, global).Fsm

  #
  class FSM extends machinaFsm
    transaction: undefined
    context: undefined
    resource: undefined

    constructor: (@resource) ->
      @transaction = @resource.transaction
      @context = @resource.context

      states =
        init:
          '*': 'block_system'

      _.assign states,
        systemStates,
        requestStates,
        acceptStates,
        retrieveStates,
        preconditionStates,
        createStates,
        processStates,
        responseStates,
        alternativeStates

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
        transition.transaction = _.omit @transaction, (prop) -> prop[0] is '_'
        @transaction.log.transitions.push transition

      # Keep track of callback results
      for k, v of @resource
        continue  unless _.isFunction v
        do () =>
          callback = k
          fun = v
          @resource[callback] = () =>
            state = @state
            result = fun.apply @resource, arguments
            @transaction.log.callbacks.push {
              state
              callback
              result
            }
            result

      @handle()


    handle: (inputType) ->
      inputType = Boolean inputType
      super inputType
