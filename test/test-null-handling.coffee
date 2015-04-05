
assert = require 'assert'
ord = require '../index'
{buildExpected, checkResult} = require './helpers'

describe 'call with null/undefined object, or null/undefined array elements', ->
  before ->

  beforeEach 'create object and array', ->

  it 'call with null should return null options error', ->
    expected =
      error:'null'
      type:'options'
    result = ord.order null
    assert.deepEqual result, expected

  it 'call with undefined should return null options error', ->
    expected =
      error:'null'
      type:'options'
    result = ord.order undefined
    assert.deepEqual result, expected

  it 'call with empty options should return an array error', ->
    expected =
      error: 'null'
      type: 'array'
    options = {}
    result = ord.order options
    assert.deepEqual result, expected

  it 'call with empty array should return an empty array', ->
    expected = buildExpected
      array: []
      note: 'empty input array'
      noSortBy: true
      noSortOrder: true
    delete expected.options.method

    options =
      array: []
    result = ord.order options
    checkResult result, expected

  it 'call with a single element should return an array of the single element', ->
    expected = buildExpected
      array: [{}]
      sorted: [{}]
      error: 'unknown ordering method'
      type: 'warning'
      warning: 'only checked for nulls'
      noSortBy: true
      noSortOrder: true
    delete expected.options.method

    options =
      array: [{}]
    result = ord.order options
    checkResult result, expected

  describe 'pass one null and one object', ->
    it '[null, object] should return null item error object with index 0', ->
      expected = buildExpected
        array: [null, {}]
        error: 'null'
        type: 'item'
        index: 0
        previousError:
          error: 'unknown ordering method'
          type: 'warning'
          warning: 'only checked for nulls'
        noSortBy: true
        noSortOrder: true
      delete expected.options.method

      options =
        array: [null, {}]
      result = ord.order options
      checkResult result, expected

    it '[object, null] should return null item error object with index 1', ->
      expected = buildExpected
        array: [{}, null]
        error: 'null'
        type: 'item'
        index: 1
        previousError:
          error: 'unknown ordering method'
          type: 'warning'
          warning: 'only checked for nulls'
        noSortBy: true
        noSortOrder: true
      delete expected.options.method

      options =
        array: [{}, null]
      result = ord.order options
      checkResult result, expected

  describe 'call with three elements, one is null', ->
    it '[null, {}, {}] should return null item error object with index 0', ->
      expected = buildExpected
        array: [null, {}, {}]
        error: 'null'
        type: 'item'
        index: 0
        previousError:
          error: 'unknown ordering method'
          type: 'warning'
          warning: 'only checked for nulls'
        noSortBy: true
        noSortOrder: true
      delete expected.options.method

      options =
        array: [null, {}, {}]
      result = ord.order options
      checkResult result, expected

    it '[{}, null, {}] should return null item error object with index 1', ->
      expected = buildExpected
        array: [{}, null, {}]
        error: 'null'
        type: 'item'
        index: 0
        previousError:
          error: 'unknown ordering method'
          type: 'warning'
          warning: 'only checked for nulls'
        noSortBy: true
        noSortOrder: true
      delete expected.options.method

      options =
        array: [{}, null, {}]
      result = ord.order options
      checkResult result, expected

    it '[{}, {}, null] should return null item error object with index 2', ->
      expected = buildExpected
        array: [{}, {}, null]
        error: 'null'
        type: 'item'
        index: 2
        previousError:
          error: 'unknown ordering method'
          type: 'warning'
          warning: 'only checked for nulls'
        noSortBy: true
        noSortOrder: true
      delete expected.options.method

      options =
        array: [{}, {}, null]
      result = ord.order options
      checkResult result, expected
