
assert = require 'assert'
ord = require '../index'

describe 'test invalid args', ->

  describe 'test passing null', ->

    it 'should return an error', ->

      expected =
        had:'ordering'
        error:'null'
        type :'arg'
        name :'options'

      result = ord.order null

      assert.deepEqual result, expected

  describe 'test passing undefined', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error:'null'
        type:'arg'
        name:'options'

      result = ord.order undefined

      assert.deepEqual result, expected

  describe 'test passing empty object', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'options'
        name: 'array'

      result = ord.order {}

      assert.deepEqual result, expected

  describe 'test passing object with null array only', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'options'
        name: 'array'

      result = ord.order array:null

      assert.deepEqual result, expected

  describe 'test passing item without options', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'ordering'
        name: 'options'

      result = ord.order array:[{}]

      assert.deepEqual result, expected

  describe 'test passing item without id', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'ordering'
        name: 'id'

      result = ord.order array:[{options:{}}]

      assert.deepEqual result, expected

  describe 'test null item', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'item'
        name:'array[0]'
        index: 0

      result = ord.order array:[null]

      assert.deepEqual result, expected

  describe 'test null second item', ->

    it 'should return an error', ->
      expected =
        had: 'ordering'
        error: 'null'
        type: 'item'
        name:'array[1]'
        index:1

      result = ord.order array:[{options:{id:'one'}}, null]

      assert.deepEqual result, expected
