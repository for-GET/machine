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
    resource: undefined
    context: undefined
    transaction: undefined
    request: undefined
    response: undefined
    error: undefined
    log: undefined

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
                  @response.status_code = _statusCode
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
      {@transaction, @context} = @resource
      {@response, @request, @error, @log} = @transaction

      super @config

      # Keep track of transitions
      @on 'transition', (transition) =>
        transition = {
          from: transition.fromState
          to: transition.toState
          transaction: @transaction.toJSON()
        }
        @log.transitions.push transition

      # Keep track of callback results
      for callback, fun of @resource
        continue  unless _.isFunction(fun) and callback isnt 'constructor'
        do () =>
          _callback = callback
          _fun = fun
          makeInnerNext = (state, callback, next) =>
            (err, result) =>
              if err?
                if next?
                  return next err
                else
                  throw err
              @log.callbacks.push {
                state
                callback
                result
              }
              return next null, result  if next?
              result

          if _fun.length
            @resource[_callback] = (next) =>
              state = @state
              innerNext = makeInnerNext state, _callback, next
              try
                _fun.call @resource, innerNext
              catch e
                innerNext e
          else
            @resource[_callback] = () =>
              state = @state
              innerNext = makeInnerNext state, _callback
              try
                result = _fun.call @resource
                return innerNext null, result
              catch e
                return innerNext e

      @handle()


    handle: (inputType) ->
      inputType = Boolean inputType
      super inputType


    transition: (state) ->
      console.log state
      super
