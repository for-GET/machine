define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'lodash'
  'machina'
  './httpdd.fsm.json'
  './FSM/transitions'
], (
  _
  machina
  httpdd
  transitions
) ->
  "use strict"

  machinaFsm = machina(_, global).Fsm

  #
  class FSM extends machinaFsm
    transaction: undefined
    context: undefined
    resource: undefined

    @_makeConfig: () ->
      states = {}
      initialState = _.find(httpdd.statements, {__type: 'assignment', name: 'Initial'}).value
      finalState = _.find(httpdd.statements, {__type: 'assignment', name: 'Final'}).value
      blockStates = _.where(httpdd.statements, {__type: 'declaration', value: 'block'})[0].names
      statusCodeStates = _.where(httpdd.statements, {__type: 'declaration', value: 'status_code'})[0].names

      for transition in _.where httpdd.statements, {__type: 'transition'}
        for state in transition.states
          states[state] ?= {}
          for message in transition.messages
            transitionFun = transitions["#{state}:#{message}"]
            message = '*'  if message is 'anything'

            if state in blockStates
              states[state]._onEnter = do () ->
                _transition = transition
                () ->
                  @transition _transition.next_state
            else if state in statusCodeStates
              statusCode = /^\d{3}/.exec(state)[0]
              states[state]._onEnter = () ->
                @handle()
              transitionFun ?= do () ->
                _statusCode = statusCode
                () ->
                  @transaction.response.status = _statusCode
              states[state][message] = do () ->
                _transition = transition
                _transitionFun = transitionFun
                () ->
                  nextState = _transitionFun.call @
                  return nextState  if states[nextState]
                  _transition.next_state
            else
              transitionFun ?= () ->
              states[state]._onEnter = do () ->
                _state = state
                () ->
                  @handle @resource[_state]()

              states[state][message] = do () ->
                _transition = transition
                _transitionFun = transitionFun
                () ->
                  nextState = _transitionFun.call @
                  return nextState  if states[nextState]
                  _transition.next_state

      states[finalState] =
        _onEnter: do () ->
          _state = finalState
          () ->
            @resource[_state]()

      {
        initialState
        states
      }
    config: @_makeConfig()


    constructor: (@resource) ->
      @transaction = @resource.transaction
      @context = @resource.context

      @config.states.__init =
        '*': @config.initialState
      @config.initialState = '__init'
      super @config

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


    transition: (state) ->
      console.log state
      super
