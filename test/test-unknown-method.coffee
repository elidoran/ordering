
assert = require 'assert'
ord = require '../index'
{buildExpected, checkResult} = require './helpers'

describe 'test default behavior (leaves them alone...)', ->

  describe 'test with non-null objects', ->

    before 'create some objects', ->
      this.object1 = {}
      this.object2 = {}
      this.object3 = {}

    it 'should return array with exact same ordering', ->
      expected = buildExpected
        method: ''
        array: [this.object1, this.object2]
        noSortBy: true
        noSortOrder: true
      expected.error = 'unknown ordering method'
      expected.type = 'warning'
      expected.warning = 'only checked for nulls'

      options =
        array: [this.object1, this.object2]

      result = ord.order options
      checkResult result, expected

    it 'should return array with exact same ordering', ->
      expected = buildExpected
        method: ''
        array: [this.object1, this.object2, this.object3]
        noSortBy: true
        noSortOrder: true
      expected.error = 'unknown ordering method'
      expected.type = 'warning'
      expected.warning = 'only checked for nulls'

      options =
        array: [this.object1, this.object2, this.object3]

      result = ord.order options
      checkResult result, expected

    it 'should return array with exact same ordering', ->
      expected = buildExpected
        method: ''
        array: [this.object2, this.object3, this.object1]
        noSortBy: true
        noSortOrder: true
      expected.error = 'unknown ordering method'
      expected.type = 'warning'
      expected.warning = 'only checked for nulls'

      options =
        array: [this.object2, this.object3, this.object1]

      result = ord.order options
      checkResult result, expected
