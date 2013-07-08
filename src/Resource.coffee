define = require('amdefine')(module)  if typeof define isnt 'function'
define [
  'querystring'
  'know-your-http-well'
  './FSMResource'
], (
  QueryString
  httpWell
  FSMResource
) ->
  "use strict"

  statusWell = httpWell.statusPhrasesToCodes

  #
  class Resource extends FSMResource
    # Methods
    method: () -> # :var
      overridenMethod = @operation._req.headers['x-http-method-override']
      return overridenMethod.toUpperCase()  if overridenMethod
      @operation.method
    safe_methods: () -> # :var
      [
        'HEAD'
        'GET'
        'OPTIONS'
        'TRACE'
      ]
    create_methods: () -> # :var
      [
        'POST'
        'PUT'
      ]
    process_methods: () -> # :var
      [
        'POST'
        'PATCH'
        'PUT'
        'DELETE'
      ]
    allowed_methods: () -> # :var
      @implemented_methods()


    # Implemented
    implemented_methods: () -> # :var
      [].concat @safe_methods(), @create_methods(), @process_methods()
    implemented_content_headers: () -> # :var
      [
        'content-encoding'
        'content-language'
        'content-length'
        'content-md5'
        'content-type'
      ]
    implemented_expect_extensions: () -> # :var
      [
        '100-continue'
      ]
    is_functionality_implemented: () -> # :bin
      true


    # Accepted
    post_content_types_accepted: () -> # :var
      {
        'application/x-www-form-urlencoded': () ->
          @context.entity = QueryString.parse @operation.representation
          true
      }
    patch_content_types_accepted: () -> # :var
      {}
    put_content_types_accepted: () -> # :var
      {}


    # Provided
    content_types_provided: () -> # :var
      {}
    default_content_type_provided: () -> # :var
      []
    choice_content_types_provided: () -> # :var
      {
        'text/uri-list': () ->
          # FIXME
      }
    default_choice_content_type_provided: () -> # :var
      ['text/uri-list', @choice_content_types_provided()['text/uri-list']]
    error_content_types_provided: () -> # :var
      {
        'application/api-problem+json': () ->
          # FIXME
      }
    default_error_content_type_provided: () -> # :var
      ['application/api-problem+json', @error_content_types_provided()['application/api-problem+json']]
    options_content_types_provided: () -> # :var
      {}
    default_options_content_type_provided: () -> # :var
      []
    languages_provided: () -> # :var
      {}
    default_language_provided: () -> # :var
      []
    charsets_provided: () -> # :var
      {
        'utf-8': (x) -> x
      }
    default_charset_provided: () -> # :var
      ['utf-8', @charsets_provided()['utf-8']]
    encodings_provided: () -> # :var
      {
        identity: (x) -> x
      }
    default_encoding_provided: () -> # :var
      ['identity', @encodings_provided().identity]


    # Meta
    vary: () -> # :var
      result = []
      result.push 'accept'  if Object.keys(@content_types_provided()).length > 1
      result.push 'accept-charset'  if Object.keys(@charsets_provided()).length > 1
      result.push 'accept-encoding'  if Object.keys(@encodings_provided()).length > 1
      result.push 'accept-language'  if Object.keys(@languages_provided()).length > 1
      result
    etag: () -> # :var
      # FIXME
    last_modified: () -> # :var
      # FIXME
    expires: () -> # :var
      # FIXME
    cache: () -> # :var
      # FIXME


    # System
    is_service_available: () -> # :bin
      true
    is_uri_too_long: () -> # :bin
      false
    is_system_block_ok: () -> # :bin
      true


    # Request
    is_content_too_large: () -> # :bin
      false
    trace_sensitive_headers: () -> # :var
      [
        'authentication'
        'cookies'
      ]
    auth_challenges: () -> # :var
      [
        'PleaseSetAnAuthChallenge'
      ]
    is_authorized: () -> # :bin
      true
    is_forbidden: () -> # :bin
      false
    is_request_block_ok: () -> # :bin
      true


    # Accept
    ignore_accept_block_mismatches: () -> # :bin
      false


    # Retrieve
    missing: () -> # :bin
      false
    found: () -> # :bin
      false
    moved: () -> # :bin
      false
    moved_permanently: () -> # :bin
      false
    moved_temporarily: () -> # :bin
      false


    # Create
    create_put: () -> # :bin
      false
    path: () -> # :var
      undefined
    create: () -> # :bin
      false

    # Process
    process_delete: () -> # :bin
      false
    process_put: () -> # :bin
      false
    process: () -> # :bin
      false


    # Response
    is_create_done: () -> # :bin
      true
    create_see_other: () -> # :bin
      @see_other()
    is_process_done: () -> # :bin
      true
    see_other: () -> # :bin
      false
    has_multiple_choices: () -> # :bin
      false
    need_camelcased_response_headers: () -> # :bin
      false


    # Override everything
    override: () -> # :bin
      true
