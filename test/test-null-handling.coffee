
assert = require 'assert'
ordering = require '../index'

describe 'call with null/undefined object, or null/undefined array elements', ->
  before ->

  beforeEach 'create object and array', ->
    this.object = {} # doesn't have any constraints, but, isn't null
    this.array = []
    this.ord = ordering()

  it 'call with null should return null array error', ->
    expected = {error:'null', type:'array'}
    result = this.ord.order null
    assert.deepEqual result, expected

  it 'call with undefined should return null array error', ->
    expected = {error:'null', type:'array'}
    result = this.ord.order undefined
    assert.deepEqual result, expected

  it 'call with empty array should return an empty array', ->
    expected = []
    result = this.ord.order []
    assert.deepEqual result, expected

  it 'call with a single element should return an array of the single element', ->
    expected = [{}]
    result = this.ord.order [{}]
    assert.deepEqual result, expected

  describe 'pass one null and one object', ->
    it '[null, object] should return null item error object with index 0', ->
      array = [null, {}]
      expected = {array: [null, {}], error: 'null', type:'item', index: 0}
      result = this.ord.order array
      assert.deepEqual result, expected

    it '[object, null] should return null item error object with index 1', ->
      array = [{}, null]
      expected = {array: [{}, null], error: 'null', type:'item', index: 1}
      result = this.ord.order array
      assert.deepEqual result, expected

  describe 'call with three elements, one is null', ->
    it '[null, {}, {}] should return null item error object with index 0', ->
      array = [null, {}, {}]
      expected = {array: [null, {}, {}], error: 'null', type:'item', index: 0}
      result = this.ord.order array
      assert.deepEqual result, expected

    it '[{}, null, {}] should return null item error object with index 1', ->
      array = [{}, null, {}]
      expected = {array: [{}, null, {}], error: 'null', type:'item', index: 1}
      result = this.ord.order array
      assert.deepEqual result, expected

    it '[{}, {}, null] should return null item error object with index 2', ->
      array = [{}, {}, null]
      expected = {array: [{}, {}, null], error: 'null', type:'item', index: 2}
      result = this.ord.order array
      assert.deepEqual result, expected
