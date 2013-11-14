define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'lodash'
  'machina'
  'httpdd'
  './FSM/transitionFuns'
], (
  _
  machina
  httpdd
  transitionFuns
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
      transitions = _.where httpdd.statements, {__type: 'transition'}

      for transition in transitions
        for state in transition.states
          states[state] ?= {}
          for message in transition.messages
            transitionFun = transitionFuns["#{state}:#{message}"]
            message = '*'  if message is 'anything'

            if state in blockStates
              states[state]._onEnter ?= do () ->
                _transition = transition
                () ->
                  @transition _transition.next_state
            else if state in statusCodeStates
              statusCode = /^\d{3}/.exec(state)[0]
              states[state]._onEnter ?= () ->
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
              states[state]._onEnter ?= do () ->
                _state = state
                () ->
                  fun = @resource[_state]
                  if fun.length is 1
                    fun (err, message) =>
                      throw err  if err?
                      @handle message
                  else
                    message = fun()
                    @handle message

              states[state][message] = do () ->
                _transition = transition
                _transitionFun = transitionFun
                () ->
                  nextState = _transitionFun.call @
                  return nextState  if nextState? and states[nextState]
                  _transition.next_state


      states['__init'] =
        '*': initialState
      states[finalState] =
        _onEnter: do () ->
          _state = finalState
          () ->
            @resource[_state]()

      {
        initialState: '__init'
        states
      }


    config: @_makeConfig()


    constructor: (@resource) ->
      @transaction = @resource.transaction
      @context = @resource.context

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
          @resource[callback] = (next) =>
            next ?= () -> undefined
            state = @state
            innerNext = (err, result) ->
              return next err  if err?
              @transaction.log.callbacks.push {
                state
                callback
                result
              }
              next null, result  if fun.length
              result
            try
              result = fun.call @resource, innerNext
              next null, result  unless fun.length
            catch e
              next e  unless fun.length

      @handle()


    handle: (inputType) ->
      inputType = Boolean inputType
      super inputType


    transition: (state) ->
      console.log state
      super
