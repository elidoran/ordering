# ordering
[![Build Status](https://travis-ci.org/elidoran/ordering.svg?branch=master)](https://travis-ci.org/elidoran/ordering)
[![Dependency Status](https://gemnasium.com/elidoran/ordering.png)](https://gemnasium.com/elidoran/ordering)
[![npm version](https://badge.fury.io/js/ordering.svg)](http://badge.fury.io/js/ordering)


[Tapestry-IoC](https://tapestry.apache.org/tapestry-ioc-configuration.html#TapestryIoCConfiguration-Ordered_List) anyone?

## Install

    npm install ordering --save

## Usage

[JavaScript Usage Example](#javascript-style-usage)

```coffeescript
# get it
ordering = require 'ordering'

# make some functions
func1 = () -> console.log 'I am a function'
func2 = () -> console.log 'Me too!'
func3 = () -> console.log 'Me three!!!'
func4 = () -> console.log 'enough already'

# put them, unsorted, into an array
array = [ func4, func2, func3, func1 ]

# how to control their order?
func1.options =
  id: 'f1'
  before: [ '*' ]

func2.options =
  id: 'f2'
  after: [ 'f3', 'f4' ]

func3.options =
  id: 'f3'
  before: [ 'f4' ]
  after : [ 'f1' ]

sorted = ordering.order array:array

# results in sorted array will be:
isNow = [ func1, func3, func4, func2 ]

# another module can add more functions to the array.
func5 = () -> console.log 'contributed function'
func5.options =
  id: 'f5'
  before: [ 'f3' ]

func6 = () -> console.log 'another contribution'
func6.options =
  id: 'f6'
  before: [ 'f4']
  after: [ 'f5' ]

array.push func5, func6

sorted = ordering.order array:array

# results in sorted array will now be:
isNow = [ func1, func5, func3, func6, func4, func2 ]
```

## API


### **ordering.order(options)**


## MIT License
