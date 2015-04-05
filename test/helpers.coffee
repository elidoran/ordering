
assert = require 'assert'

module.exports =

  buildExpected: (options) ->
    expected =
      options:
        method: options.method ? 'alpha'
        array: options.array

    expected.note = options.note if options?.note?
    if options?.error?
      expected.error = options.error
      expected.type = options.type if options?.type?
      expected.warning = options.warning if options?.warning

    if not options?.error? or options?.sorted?
      expected.sorted = options.sorted ? options.array

    if options.noSortBy?
      expected.noSortBy = true
    else
      expected.sortBy = options.sortBy ? 'name'

    if options.noSortOrder?
      expected.noSortOrder = true
    else
      expected.sortOrder = options.sortOrder ? 'asc'


    if expected?.array?.length is 0
      expected.note = 'empty input array'

    return expected

  checkResult: (result, expected) ->
    #console.log 'RESULT', result
    #console.log 'EXPECTED', expected
    assert.equal result?, true, 'results should exist'
    assert.equal result.options?, true, 'result.options should exist'
    assert.equal result.options.array?, true, 'result.options.array should exist'

    if result?.note?
      assert.equal result.note, expected.note

    if result?.error?
      assert.equal result.error, expected.error
      assert.equal result.type, expected.type
      if result?.warning?
        assert.equal result.warning, expected.warning

    else
      assert.equal result.sorted?, true, 'result.sorted should exist'
      assert.deepEqual result.sorted, expected.sorted #, 'result.sorted should match'


    if expected?.noSortBy?
      assert.equal result.options.sortBy, undefined,
        'result.options.sortBy should be undefined'
    else
      assert.equal result.options.sortBy, (expected.options.sortBy ? 'name'),
        'result.options.sortBy should be default or expected'

    if expected?.noSortOrder?
      assert.equal result.options.sortOrder, undefined,
        'result.options.sortOrder should be undefined'
    else
      assert.equal result.options.sortOrder, (expected.options.sortOrder ? 'asc'),
        'result.options.sortOrder should be default or expected'
