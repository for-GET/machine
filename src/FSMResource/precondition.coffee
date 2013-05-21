define = require('amdefine')(module)  if typeof define isnt 'function'
define [
], (
) ->
  "use strict"

  # Precondition
  {
    has_if_match: () -> # : in
      # FIXME
      false
    if_match_matches: () -> # : in
      # FIXME
    has_if_unmodified_since: () -> # : in
      # FIXME
      false
    if_unmodified_since_matches: () -> # : in
      # FIXME
    has_if_none_match: () -> # : in
      # FIXME
      false
    if_none_match_matches: () -> # : in
      # FIXME
    has_if_modified_since: () -> # : in
      # FIXME
      false
    if_modified_since_matches: () -> # : in
      # FIXME
    is_precondition_safe: () -> # : in
      @is_method_safe()
  }
