
assert = require 'assert'
ord = require '../index'

describe 'test successful ordering', ->

  describe 'test empty array', ->

    it 'should return an empty array', ->

      expected =
        had:'ordering'
        success: true
        array: []

      result = ord.order array:[]

      assert.deepEqual result, expected

  describe 'test single item', ->

    it 'should return array with item', ->
      object = {options:{id:'test'}}
      expected =
        had:'ordering'
        success: true
        array: [object]

      result = ord.order array:[object]

      assert.deepEqual result, expected

  describe 'test two unneedy items', ->

    it 'should return A,B', ->
      object1 = {options:{id:'A'}}
      object2 = {options:{id:'B'}}
      expected =
        had:'ordering'
        success: true
        array: [object1,object2]

      result = ord.order array:[object1,object2]

      assert.deepEqual result, expected

  describe 'test an item needing a non-existent object', ->

    it 'should return B', ->
      object = {options:{id:'B', needs:['A']}}
      expected =
        had:'ordering'
        success:true
        array: [object]

      result = ord.order array:[object]

      assert.deepEqual result, expected

  describe 'test an item needing another object', ->

    it 'should return A,B', ->
      object1 = {options:{id:'A'}}
      object2 = {options:{id:'B', needs:['A']}}
      expected =
        had:'ordering'
        success: true
        array: [object1,object2]

      result = ord.order array:[object2,object1]

      assert.deepEqual result, expected

  describe 'test an item needing two objects', ->

    it 'should return A,B,C', ->
      object1 = {options:{id:'A'}}
      object2 = {options:{id:'B'}}
      object3 = {options:{id:'C', needs:['A','B']}}
      expected =
        had:'ordering'
        success: true
        array: [object1,object2,object3]

      result = ord.order array:[object2,object3,object1]

      assert.deepEqual result, expected

  describe 'test three needs in series', ->

    it 'should return A,B,C', ->
      object1 = {options:{id:'A'}}
      object2 = {options:{id:'B', needs:['A']}}
      object3 = {options:{id:'C', needs:['B']}}
      expected =
        had:'ordering'
        success: true
        array: [object1,object2,object3]

      result = ord.order array:[object2,object3,object1]

      assert.deepEqual result, expected
