
assert = require 'assert'
ord = require '../index'
{buildExpected, checkResult} = require './helpers'

describe 'test alpha algorithm', ->

  describe 'test no other options (ascending order)', ->

    before 'create some objects', ->
      this.object1 = {name: 'can I be first?'}
      this.object2 = {name: 'i\'ll be second'}
      this.object3 = {name: 'third\'s fine, I guess'}
      this.object4 = {name: 'why do I have to be fourth?'}
      options = {method: 'alpha'}

    describe 'already sorted order retains the order', ->

      it 'one', ->
        expected = buildExpected
          array: [this.object1]

        options =
          method: 'alpha'
          array: [this.object1]

        result = ord.order options

        checkResult result, expected

      it 'two', ->
        expected = buildExpected
          array: [this.object1, this.object2]

        options =
          method: 'alpha'
          array: [this.object1, this.object2]

        result = ord.order options

        checkResult result, expected

      it 'three', ->
        expected = buildExpected
          array: [this.object1, this.object2, this.object3]

        options =
          method: 'alpha'
          array: [this.object1, this.object2, this.object3]

        result = ord.order options

        checkResult result, expected

    describe 'one out of order', ->

      before 'expect three in order', ->
        this.expected = [this.object1, this.object2, this.object3]

      it '[2,3,1] -> [1,2,3]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object2, this.object3, this.object1]

        result = ord.order options

        checkResult result, expected

      it '[2,1,3] -> [1,2,3]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object2, this.object1, this.object3]

        result = ord.order options
        checkResult result, expected

    describe 'four in mixed order', ->

      before 'expect four in order', ->
        this.expected = [this.object1, this.object2, this.object3, this.object4]

      it '[2,1,3,4] -> [1,2,3,4]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object2, this.object1, this.object3, this.object4]

        result = ord.order options
        checkResult result, expected

      it '[2,3,1,4] -> [1,2,3,4]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object2, this.object3, this.object1, this.object4]

        result = ord.order options
        checkResult result, expected

      it '[2,3,4,1] -> [1,2,3,4]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object2, this.object3, this.object4, this.object1]

        result = ord.order options
        checkResult result, expected

      it '[2,1,4,3] -> [1,2,3,4]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object2, this.object1, this.object4, this.object3]

        result = ord.order options
        checkResult result, expected

      it '[2,4,1,3] -> [1,2,3,4]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object2, this.object4, this.object1, this.object3]

        result = ord.order options
        checkResult result, expected

      it '[1,4,3,2] -> [1,2,3,4]', ->
        expected = buildExpected
          array: this.expected

        options =
          method: 'alpha'
          array: [this.object1, this.object4, this.object3, this.object2]

        result = ord.order options
        checkResult result, expected
