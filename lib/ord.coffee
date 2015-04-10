
had     = require('had') id:'ordering'
needier = require 'needier'

module.exports = ord =

  order: (options) ->

    if had.nullArg 'options', options
      return had.results()

    unless options?.array? # TODO: use had.nullProp
      return had.error error:'null', type:'options', name:'array'

    needs = needier()

    for item,index in options.array

      if had.nullArg "array[#{index}]", item
        return had.results type:'item', index:index

      if had.nullProp 'options', item
        return had.results type:'ordering', name:'options'

      if had.nullProp 'id', item.options
        return had.results type:'ordering', name:'id'

      need = needs.of item.options.id

      if item.options?.before?
        for beforeId in item.options.before
          need.are beforeId # TODO: doesn't read well like this!

      if item.options?.after?
        for afterId in item.options.after
          needs.of(afterId).are item.options.id

    results = needs.ordered()

    unless had.isSuccess results
      return had.error results

    return had.success sorted:results.ordered
