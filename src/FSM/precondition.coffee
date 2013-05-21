define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  status = httpWell.statusPhrasesToCodes

  # Precondition
  {
    # Create
    block_create_precondition:
      _onEnter: () -> @transition 'has_create_if_match'

    has_create_if_match:
      _onEnter: () -> @handle @resource.has_if_match()
      false:    () -> @transition 'create'
      true:     () ->
        @operation.response.statusCode or= status.PRECONDITION_FAILED
        @transition 'block_error'

    # Process
    block_precondition:
      _onEnter: () -> @transition 'has_if_match'

    has_if_match:
      _onEnter: () -> @handle @resource.has_if_match()
      true:     () -> @transition 'if_match_matches'
      false:    () -> @transition 'has_if_unmodified_since'

    if_match_matches:
      _onEnter: () -> @handle @resource.if_match_matches()
      true:     () -> @transition 'has_if_unmodified_since'
      false:    () ->
        @operation.response.statusCode or= status.PRECONDITION_FAILED
        @transition 'block_error'

    has_if_unmodified_since:
      _onEnter: () -> @handle @resource.has_if_unmodified_since()
      true:     () -> @transition 'if_unmodified_since_matches'
      false:    () -> @transition 'has_if_none_match'

    if_unmodified_since_matches:
      _onEnter: () -> @handle @resource.if_unmodified_since_matches()
      false:    () -> @transition 'has_if_unmodified_since'
      true:     () ->
        @operation.response.statusCode or= status.PRECONDITION_FAILED
        @transition 'block_error'

    has_if_none_match:
      _onEnter: () -> @handle @resource.has_if_none_match()
      true:     () -> @transition 'if_none_match_matches'
      false:    () -> @transition 'has_if_modified_since'

    if_none_match_matches:
      _onEnter: () -> @handle @resource.if_none_match_matches()
      false:    () -> @transition 'has_if_modified_since'
      true:     () -> @transition 'is_precondition_safe'

    has_if_modified_since:
      _onEnter: () -> @handle @resource.has_if_modified_since()
      true:     () -> @transition 'if_modified_since_matches'
      false:    () -> @transition 'is_precondition_ok'

    if_modified_since_matches:
      _onEnter: () -> @handle @resource.if_modified_since_matches()
      true:     () -> @transition 'is_precondition_ok'
      false:    () -> @transition 'is_precondition_safe'

    is_precondition_safe:
      _onEnter: () -> @handle @resource.is_precondition_safe()
      true:     () ->
        @operation.response.statusCode or= status.NOT_MODIFIED
        @transition 'last'
      false:    () ->
        @operation.response.statusCode or= status.PRECONDITION_FAILED
        @transition 'block_error'

    is_precondition_ok:
      _onEnter: () -> @handle @resource.is_precondition_safe()
      true:     () -> @transition 'block_process'
      false:    () ->
        @operation.response.statusCode or= status.PRECONDITION_FAILED
        @transition 'block_error'
  }
