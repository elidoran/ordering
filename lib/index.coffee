
had     = require('had') id:'ordering'
needier = require 'needier'

module.exports = (options) ->

  if had.nullArg 'options', options
    return had.results()

  # first, check if the options are an array
  if Array.isArray options then array = options

  # or, maybe they provided the stuff to order as individual arguments
  # Note: we're assuming multiple args means they did...
  else if arguments.length > 1 then array = Array.prototype.slice.call arguments

  # otherwise, check if they didn't specify an `array` property
  else if had.nullProp 'array', options
    return had.results type:'options'

  # they did, so, get it :)
  else array = options.array

  # if the array is empty then we succeed at nothing...
  unless array.length > 0
    return had.success array:array

  needs = needier()
  beforeAll = []
  afterAll = []
  all = {}

  for item,index in array

    if had.nullArg index, item # TODO: Had should support array check
      return had.results type:'item', index:index, name:"array[#{index}]"

    # if item doesn't have `options`, then set an empty one
    item.options ?= {}

    # if options doesn't have an `id` and item is a function
    # then use `function.name`
    if not item.options?.id? and typeof item is 'function'
      item.options.id = item.name

    # must have an id, or, return results with the null prop error
    if had.nullProp 'id', item.options
      return had.results()

    # create a `need` object for `needier`
    need = id:item.options.id, object:item

    # in case they use the `needier` constraint name
    need.needs = item.options.needs if item.options.needs?

    # if it has non-needer 'after' constraints then we'll handle them special
    # Note, if they used both `needs` and `after` then `after` will overwrite
    if item.options.after?.length > 0

      # if they did after: [ '*' ] then remember in `afterAll`
      if item.options.after.length is 1 and item.options.after[0] is '*'
        afterAll.push need.id

      else # otherwise, use the 'after' as 'needs' cuz they mean the same thing
        need.needs = item.options.after

    # if we have some 'needs' from 'needs' or 'after' then remember them
    all[id] = true for id in need.needs if need.needs?.length > 0

    # track all needs added in
    all[need.id] = true

    # add the `need` we've created to our `needs`
    result = needs.add need

    unless had.isSuccess result
      return had.error result

    # now look for the `before` constraints
    if item.options?.before?.length > 0

      # if they did before: [ '*' ] then remember in `beforeAll`
      if item.options.before.length is 1 and item.options.before[0] is '*'
        beforeAll.push need.id

      else # otherwise, for each before constraints

        for beforeId in item.options.before

          # make the other thing "need" this need before it
          result =
            # if we've already added this one
            if all[beforeId]
              # then update it
              needs.update id:beforeId, needs:[need.id], type:'combine'
            # otherwise, add it now
            else
              needs.add id:beforeId, needs:[need.id], object:beforeId

          unless had.isSuccess result
            return had.error result

          # remember in `all`
          all[beforeId] = true

  # for each thing which wants to be before all others
  while beforeAll.length > 0
    # get the first one which declared it should be before all others
    # Note, must leave it in there, so, don't shift(). the loop checks `beforeAll`
    id = beforeAll[0]

    # build a need which says this one is needed before
    need = needs:[id], type:'combine'

    # for every constraint *not* in the `beforeAll`
    for own key of all when key not in beforeAll
      # set the `id` of the need update and then call update()
      need.id = key
      result = needs.update need
      unless had.isSuccess result
        return had.error result

    # now remove it
    beforeAll.shift()

  # for each thing which wants to be after all others, load all others into
  # its `needs`
  while afterAll.length > 0
    # get the first one which declared it should be after all others
    # Note, must leave it in there, so, don't shift(). the loop checks `afterAll`
    id = afterAll[0]

    # build the `need` we'll add
    need = id:id, needs:[]

    # put all others into its needs, except those also in `afterAll`
    need.needs.push key for own key of all when key not in afterAll

    # now remove it
    afterAll.shift()

    # add the need... not update? not 'combine' ?
    # no, we just add each need into it and its `needs` has all the other
    result = needs.add need
    unless had.isSuccess result
      return had.error result

  results = needs.ordered()

  # if it's a certain kind of cyclical error then it contains the `needs`
  # which were cyclical.

  unless had.isSuccess results
    return had.error results

  # review results array. if any are a string, then there's no object for
  # it, so, just remove it.
  array = (item for item in results.array when typeof item isnt 'string')

  return had.success array:array

# used to export the primary function as 'order'.
# now, we're exporting the order() function as the export object.
# so, to be backwards compatible, let's make an `order` property on it
# which calls the function.
module.exports.order = module.exports
