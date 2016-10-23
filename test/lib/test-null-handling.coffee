
assert = require 'assert'
order = require '../../lib'

describe 'test invalid args', ->

  describe 'test passing null', ->

    it 'should return an error', ->

      expected =
        had:'ordering'
        error:'null'
        type :'arg'
        name :'options'

      result = order null

      assert.deepEqual result, expected

  describe 'test passing undefined', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error:'null'
        type:'arg'
        name:'options'

      result = order undefined

      assert.deepEqual result, expected

  describe 'test passing empty object', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'options'
        name: 'array'

      result = order {}

      assert.deepEqual result, expected

  describe 'test passing object with null array only', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'options'
        name: 'array'

      result = order array:null

      assert.deepEqual result, expected

  describe 'test passing item without id', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'prop'
        name: 'id'

      result = order array:[{options:{}}]

      assert.deepEqual result, expected

  describe 'test null item', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'item'
        name:'array[0]'
        index: 0

      result = order array:[null]

      assert.deepEqual result, expected

  describe 'test null second item', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'item'
        name:'array[1]'
        index:1

      result = order array:[{options:{id:'one'}}, null]

      assert.deepEqual result, expected
