
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
    unless item?.options? then item.options = {}

    # if options doesn't have an `id` and item is a function
    # then use `function.name`
    if not item.options?.id? and typeof item is 'function'
      item.options.id = item?.name

    if had.nullProp 'id', item.options
      return had.results()

    need = id:item.options.id, object:item
    need.needs = item.options.needs if item.options?.needs?
    if item.options?.after?
      if item.options.after.length is 1 and item.options.after[0] is '*'
        afterAll.push need.id
      else
        need.needs = item.options.after

    all[id] = true for id in need.needs if need?.needs?

    # track all needs added in (what about IDs in needs/before/after?)
    all[need.id] = true

    needs.add need

    if item.options?.before?
      if item.options.before.length is 1 and item.options.before[0] is '*'
        beforeAll.push need.id
      else
        for beforeId in item.options.before
          all[beforeId] = true
          needs.update id:beforeId, needs:[need.id], type:'combine'

  while beforeAll.length > 0
    id = beforeAll[0]
    need = needs:[id], type:'combine'
    for own key of all when key not in beforeAll
      need.id = key
      needs.update need
    beforeAll.shift()

  while afterAll.length > 0
    id = afterAll[0]
    need = id:id, needs:[]
    need.needs.push key for own key of all when key not in afterAll
    afterAll.shift()
    needs.add need

  results = needs.ordered()

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
