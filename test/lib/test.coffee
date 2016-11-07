
assert = require 'assert'
order = require '../../lib'

describe 'test old order()', ->

  it 'should be the same as the primary export object', ->
    assert.deepEqual order.order, order

describe 'test failed ordering', ->

  describe 'with both wanting after each other', ->

      object1 = options: { id:'A', after:['B'] }
      object2 = options: { id:'B', after:['A'] }

      expected =
        had  : 'needs'
        error: 'none without need'
        type : 'cyclical'

      result = order array:[object1, object2]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected

  describe 'with both wanting after each other, flipped', ->

      object1 = options: { id:'A', after:['B'] }
      object2 = options: { id:'B', after:['A'] }

      expected =
        had  : 'needs'
        error: 'none without need'
        type : 'cyclical'

      result = order array:[object2, object1]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected

  describe 'with both wanting before each other', ->

      object1 = options: { id:'A', before:['B'] }
      object2 = options: { id:'B', before:['A'] }

      expected =
        had  : 'needs'
        error: 'none without need'
        type : 'cyclical'

      result = order array:[object1, object2]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected

  describe 'with both wanting before each other, flipped', ->

      object1 = options: { id:'A', before:['B'] }
      object2 = options: { id:'B', before:['A'] }

      expected =
        had  : 'needs'
        error: 'none without need'
        type : 'cyclical'

      result = order array:[object2, object1]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected


  describe 'with 2 of 3 wanting after each other', ->

      object1 = options: { id:'A', after:['B'] }
      object2 = options: { id:'B', after:['A'] }
      object3 = options: { id:'C' }

      expected =
        had  : 'needs'
        error: 'cyclical needs'
        type : 'cyclical'
        needs: [ object1, object2 ]

      result = order array:[object1, object2, object3]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected

  describe 'with 2 cyclical and an extra wanting one', ->

      object1 = options: { id:'A', after:['B'] }
      object2 = options: { id:'B', after:['A'] }
      object3 = options: { id:'C', after:['B'] }

      expected =
        had  : 'needs'
        error: 'cyclical need'
        type : 'cyclical'
        name : 'B'

      result = order array:[object1, object2, object3]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected

  describe 'with both wanting before each other', ->

      object1 = options: { id:'A', before:['B'] }
      object2 = options: { id:'B', before:['A'] }
      object3 = options: { id:'C' }

      expected =
        had  : 'needs'
        error: 'cyclical needs'
        type : 'cyclical'
        needs: [ object1, object2 ]

      result = order array:[object1, object2, object3]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected

  describe 'with both wanting before each other,flipped', ->

      object1 = options: { id:'A', before:['B'] }
      object2 = options: { id:'B', before:['A'] }
      object3 = options: { id:'C' }

      expected =
        had  : 'needs'
        error: 'cyclical needs'
        type : 'cyclical'
        needs: [ object2, object1 ]

      result = order array:[object2, object1, object3]

      it 'should contain a cyclical error', ->
        assert.deepEqual result, expected


describe 'test successful ordering', ->

  describe 'test empty array', ->

    it 'should return an empty array', ->

      expected =
        had:'ordering'
        success: true
        array: []

      result = order array:[]

      assert.deepEqual result, expected

  describe 'test single item in an array property', ->

    it 'should return array with item', ->
      object = {options:{id:'test'}}
      expected =
        had:'ordering'
        success: true
        array: [object]

      result = order array:[object]

      assert.deepEqual result, expected

  describe 'test single item in an array as argument', ->

    it 'should return array with item', ->
      object = {options:{id:'test'}}
      expected =
        had:'ordering'
        success: true
        array: [object]

      result = order [object]

      assert.deepEqual result, expected

  describe 'test two items as arguments', ->

    it 'should return array with items', ->
      object1 = {options:{id:'test1'}}
      object2 = {options:{id:'test2'}}
      expected =
        had:'ordering'
        success: true
        array: [object1, object2]

      result = order object1, object2

      assert.deepEqual result, expected

  describe 'test two unneedy items', ->

    it 'should return A,B', ->
      object1 = {options:{id:'A'}}
      object2 = {options:{id:'B'}}
      expected =
        had:'ordering'
        success: true
        array: [object1,object2]

      result = order array:[object1,object2]

      assert.deepEqual result, expected

  describe 'test an item needing a non-existent object', ->

    it 'should return B', ->
      object = {options:{id:'B', needs:['A']}}
      expected =
        had:'ordering'
        success:true
        array: [object]

      result = order array:[object]

      assert.deepEqual result, expected

  describe 'test an item needing another object', ->

    it 'should return A,B', ->
      object1 = {options:{id:'A'}}
      object2 = {options:{id:'B', needs:['A']}}
      expected =
        had:'ordering'
        success: true
        array: [object1,object2]

      result = order array:[object2,object1]

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

      result = order array:[object2,object3,object1]

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

      result = order array:[object2,object3,object1]

      assert.deepEqual result, expected

  describe 'test before:*', ->

    describe 'alone', ->

      it 'should return A', ->
        object1 = {options:{id:'A',before:['*']}}
        expected =
          had:'ordering'
          success: true
          array: [object1]

        result = order array:[object1]

        assert.deepEqual result, expected

    describe 'with one other', ->

      it 'should return A,B', ->
        object1 = {options:{id:'A',before:['*']}}
        object2 = {options:{id:'B'}}
        expected =
          had:'ordering'
          success: true
          array: [object1,object2]

        result = order array:[object2,object1]

        assert.deepEqual result, expected

    describe 'with two others', ->

      it 'should return A,B,C', ->
        object1 = {options:{id:'A', before:['*']}}
        object2 = {options:{id:'B'}}
        object3 = {options:{id:'C'}}
        expected =
          had:'ordering'
          success: true
          array: [object1,object2,object3]

        result = order array:[object2,object3,object1]

        assert.deepEqual result, expected

    describe 'with another having a need', ->

      it 'should return A,B,C', ->
        object1 = {options:{id:'A', before:['*']}}
        object2 = {options:{id:'B'}}
        object3 = {options:{id:'C', needs:['B']}}
        expected =
          had:'ordering'
          success: true
          array: [object1,object2,object3]

        result = order array:[object2,object3,object1]

        assert.deepEqual result, expected

  describe 'test after:*', ->

    describe 'alone', ->

      it 'should return A', ->
        object1 = {options:{id:'A',after:['*']}}
        expected =
          had:'ordering'
          success: true
          array: [object1]

        result = order array:[object1]

        assert.deepEqual result, expected

    describe 'with one other', ->

      it 'should return A,B', ->
        object1 = {options:{id:'A'}}
        object2 = {options:{id:'B',after:['*']}}
        expected =
          had:'ordering'
          success: true
          array: [object1,object2]

        result = order array:[object2,object1]

        assert.deepEqual result, expected

    describe 'with two others', ->

      it 'should return A,B,C', ->
        object1 = {options:{id:'A'}}
        object2 = {options:{id:'B'}}
        object3 = {options:{id:'C', after:['*']}}
        expected =
          had:'ordering'
          success: true
          array: [object1,object2,object3]

        result = order array:[object1,object3,object2]

        assert.deepEqual result, expected

    describe 'with another having a need', ->

      it 'should return A,B,C', ->
        object1 = {options:{id:'A'}}
        object2 = {options:{id:'B', needs:['A']}}
        object3 = {options:{id:'C', after:['*']}}
        expected =
          had:'ordering'
          success: true
          array: [object1,object2,object3]

        result = order array:[object2,object3,object1]

        assert.deepEqual result, expected
