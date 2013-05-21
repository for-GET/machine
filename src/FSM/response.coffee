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
    block_response:
      _onEnter: () -> @transition 'is_process_done'

    is_process_done:
      _onEnter: () -> @handle @resource.is_process_done()
      true:     () -> @transition 'to_content'
      false:    () ->
        @operation.response.statusCode or= status.ACCEPTED
        @transition 'last'

    to_content:
      _onEnter: () -> @handle @resource.to_content()
      true:     () -> @transition 'has_multiple_choices'
      false:    () ->
        @operation.response.statusCode or= status.NO_CONTENT
        @transition 'last'

    has_multiple_choices:
      _onEnter: () -> @handle @resource.has_multiple_choices()
      true:     () ->
        @operation.response.statusCode or= status.MULTIPLE_CHOICES
        @transition 'last'
      false:    () ->
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
