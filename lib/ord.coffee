
# does nothing. means the overall result is we just check for nulls
defaultAlgorithm = () ->


class Ord
  constructor: (options) ->
    this.algorithm = options?.algorithm ? defaultAlgorithm

  # by default, return the error info. someone else may have it do something
  # else before, and maybe return something else.
  _error: (info) -> info

  # handles null item considerations
  # uses an algorithm to sort the array into a new array
  _sort: (array) ->
    # new array to hold results
    sorted = []
    # where we are? or do we use shift/pop to go thru them? it would alter the
    # original array, we don't want to do that, or, do we?
    index = 0
    for item in array
      # check if null, freak out if so
      if not item? # TODO: check for an error callback from options?
        return this._error
          array: array
          error: 'null'
          type: 'item'
          index: index

      # TODO: figure out how to use algorithm on each item as we progress thru

      # for now, just add the non-null item
      sorted.push item

      index++

    array = sorted

  # handles null/undefined/empty array considerations
  order: (array) ->
    if array?
      if array.length > 1
        # call with *this* as context so it has the state stuff
        return this._sort array
      #else it's an empty array, just return it

    else # null or undefined array
      return this._error
        error: 'null'
        type: 'array'

    return array

module.exports = (options) -> new Ord(options)
