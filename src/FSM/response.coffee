define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'know-your-http-well'
], (
  httpWell
) ->
  "use strict"

  statusWell = httpWell.statusPhrasesToCodes

  # Response
  {
    # Create
    block_response_create:
      _onEnter: () -> @transition 'is_create_done'

    is_create_done:
      _onEnter: () -> @handle @resource.is_create_done()
      true:     'create_see_other'
      false:    () ->
        @operation.response.status or= statusWell.ACCEPTED
        'last'

    create_see_other:
      _onEnter: () -> @handle @resource.create_see_other()
      false:    () ->
        # FIXME set Location
        @operation.response.status or= statusWell.CREATED
        'last'
      true:     () ->
        # FIXME set Location
        @operation.response.status or= statusWell.SEE_OTHER
        'last'

    # Process
    block_process_response:
      _onEnter: () -> @transition 'is_process_done'

    is_process_done:
      _onEnter: () -> @handle @resource.is_process_done()
      true:     'to_content'
      false:    () ->
        @operation.response.status or= statusWell.ACCEPTED
        'last'

    # Others
    block_response:
      _onEnter: () -> @transition 'is_process_done'

    see_other:
      _onEnter: () -> @handle @resource.see_other()
      false:    'has_multiple_choices'
      true:     () ->
        # FIXME set Location
        @operation.response.status or= statusWell.SEE_OTHER
        'last'

    has_multiple_choices:
      _onEnter: () -> @handle @resource.has_multiple_choices()
      true:     () ->
        @operation.response.status or= statusWell.MULTIPLE_CHOICES
        'last'
      false:    'to_content'

    to_content:
      _onEnter: () -> @handle @resource.to_content()
      false:    () ->
        @operation.response.status or= statusWell.NO_CONTENT
        'last'
      true:     () ->
        # FIXME
        # @operation.h.vary = @resource.vary_header()
        # @operation.h.etag = @resource.etag_header()
        # @operation.h['last-modified'] = @resource.last_modified_header()
        # @operation.h.expires = @resource.expires_header()
        # @operation.h['cache-control'] = @resource.cache_control_header()
        # @operation.h.date = @resource.date_header()
        @operation.response.status or= statusWell.OK
        'last'
  }
