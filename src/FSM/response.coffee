define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  status = httpWell.statusPhrasesToCodes

  # Response
  {
    # Create
    block_response_create:
      _onEnter: () -> @transition 'is_create_done'

    is_create_done:
      _onEnter: () -> @handle @resource.is_create_done()
      false:    () ->
        @operation.response.statusCode or= status.ACCEPTED
        @transition 'last'
      true:     () ->
        @operation.response.statusCode or= status.CREATED
        @transition 'last'

    # Process
    block_process_response:
      _onEnter: () -> @transition 'is_process_done'

    is_process_done:
      _onEnter: () -> @handle @resource.is_process_done()
      true:     () -> @transition 'to_content'
      false:    () ->
        @operation.response.statusCode or= status.ACCEPTED
        @transition 'last'

    # Others
    block_response:
      _onEnter: () -> @transition 'is_process_done'

    see_other:
      _onEnter: () -> @handle @resource.see_other()
      false:    () -> @transition 'has_multiple_choices'
      true:     () ->
        @operation.response.statusCode or= status.SEE_OTHER
        @transition 'last'

    has_multiple_choices:
      _onEnter: () -> @handle @resource.has_multiple_choices()
      true:     () ->
        @operation.response.statusCode or= status.MULTIPLE_CHOICES
        @transition 'last'
      false:    () -> @transition 'to_content'

    to_content:
      _onEnter: () -> @handle @resource.to_content()
      false:    () ->
        @operation.response.statusCode or= status.NO_CONTENT
        @transition 'last'
      true:     () ->
        # FIXME
        # @operation.h.vary = @resource.vary_header()
        # @operation.h.etag = @resource.etag_header()
        # @operation.h['last-modified'] = @resource.last_modified_header()
        # @operation.h.expires = @resource.expires_header()
        # @operation.h['cache-control'] = @resource.cache_control_header()
        # @operation.h.date = @resource.date_header()
        @operation.response.statusCode or= status.OK
        @transition 'last'
  }
