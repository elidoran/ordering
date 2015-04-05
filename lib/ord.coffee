
defaults = require './defaults'

module.exports = ord =

  order: (options) ->

    # if no options... nothing to do, send error tho
    unless options?
      return ord._error
        error: 'null'
        type: 'options'

    # if array is null/undefined return error
    unless options.array?
      return ord._error
        error: 'null'
        type: 'array'

    # if length is zero, return it
    if options.array.length is 0
      return ord._result
        array: options.array
        sorted: options.array
        note: 'empty input array'
        options: options

    # else length is greater than 1, process it
    # to "process" it, we need to look at the options
    # to see if it's something which wants to see the whole array, or each item

    # first, check if that info is specified in the options
    # if it's *not*, then only check for nulls
    switch options.method
      when 'sorter'
        result = ord._sorter options

      when 'iterator'
        result = ord._iterator options

      when 'alpha'
        options.sortBy ?= 'name'
        if not options.sortDiff
          options.sortDiff = defaults.alphaDiff
          setSortDiff = true
        result = ord._arraySort options
        if setSortDiff?
          delete options.sortDiff

      when 'numeric'
        options.sortBy ?= 'index'
        result = ord._arraySort options

      else
        # nothing specified, check for nulls, and in result note there was no
        # method specified.
        # add info to result before returning it
        previousError =
          error: 'unknown ordering method'
          type : 'warning'
          warning : 'only checked for nulls'
        result = ord._check options
        result.previousError = previousError

    return if result?.error? then ord._error result else ord._result result

  _error: (info) -> info
  _result: (info) -> info

  # TODO: iterate in an iteration function for both null checks and iterator
  _check: (options) ->
    # loop array and return error for null
    index = 0
    checker = options.iterator ? () -> # a noop
    result = {} # hold result as it processes
    for item in options.array
      if not item?
        return ord._error
          error: 'null'
          type: 'item'
          index: index
          options: options

      # use the checker
      result = checker item, result
      # if there was an error, return it
      if result?.error?
        # add the current index
        result.index = index
        return ord._error result

      # increment index
      index++

    # we made it, no nulls, so return result
    return ord._result
      sorted: options.array # not really sorted, but, no nulls
      options: options

  _sorter: (options) ->
    # we have a function to run on the whole array.
    # NOTE: we still check for nulls, have to do it first
    result = ord._check options
    # if there wasn't an error, run the sorter on it
    if not result?.error?
      # is the sorter specified?
      if options?.sorter?
        result = options.sorter options
        if result?.error?
          result.type ?= 'sorter'
          result = ord._error result
        else
          result = ord._result result
      else # there's no sorter... woops
        result = ord._error
          error: 'options.sorter not specified'
          type: 'options'
          options: options

    # else where is an error, add any stuff to it before returning?

    return result

  _iterator: (options) ->
    # we have a function to run on each item in the array.
    # NOTE: we still check for nulls
    result = ord._check options
    if not result?
      return ord._error
        error: 'no result'
        type: 'iterator'
        options: options

    if result.error?
      result.options ?= options # TODO: do an extendOwn into it?
      result.type ?= 'iterator'
      return ord._error result

    # otherwise, it's a good result, so return that
    return ord._result result

  _arraySort: (options) ->
    options.sortOrder ?= 'asc'
    getField = options.getField ? defaults.getField
    if options.sortDiff?
      diff = options.sortDiff
    else
      diff = if options.sortOrder is 'asc' then defaults.asc else defaults.desc
    options.sorter = do (array=options.array, get=getField,
      field=options.sortBy, diff=diff) ->
        return (options) ->
          return {
            options: options
            sorted: array.sort (a,b) ->
              #return diff get(a, field), get(b, field)
              fieldA = get a, field
              fieldB = get b, field
              theDiff = diff fieldA, fieldB
              return theDiff
          }
    result = ord._sorter options
    delete options.sorter # delete the sorter we added in there
    return result
