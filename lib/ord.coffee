
had     = require('had') id:'ordering'
needier = require 'needier'

module.exports = ord =

  order: (options) ->

    if had.nullArg 'options', options
      return had.results()

    if had.nullProp 'array', options
      return had.results type:'options'

    unless options.array.length > 0
      return had.success array:options.array

    needs = needier()
    things = {}

    for item,index in options.array

      if had.nullArg index, item # TODO: Had should support array check
        return had.results type:'item', index:index, name:"array[#{index}]"

      if had.nullProp 'options', item
        return had.results()

      if had.nullProp 'id', item.options
        return had.results()

      need = id:item.options.id, object:item
      need.needs = item.options.needs if item.options?.needs?
      need.needs = item.options.after if item.options?.after?

      needs.add need

      if item.options?.before?
        for beforeId in item.options.before
          needs.update id:beforeId, needs:[need.id], type:'combine'

    results = needs.ordered()

    unless had.isSuccess results
      return had.error results

    # review results array. if any are a string, then there's no object for
    # it, so, just remove it.
    array = (item for item in results.array when typeof item isnt 'string')

    return had.success array:array
