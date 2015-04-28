
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
    beforeAll = []
    afterAll = []
    all = {}

    for item,index in options.array

      if had.nullArg index, item # TODO: Had should support array check
        return had.results type:'item', index:index, name:"array[#{index}]"

      if had.nullProp 'options', item
        return had.results()

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
