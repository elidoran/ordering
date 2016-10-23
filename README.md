# ordering
[![Build Status](https://travis-ci.org/elidoran/ordering.svg?branch=master)](https://travis-ci.org/elidoran/ordering)
[![Dependency Status](https://gemnasium.com/elidoran/ordering.png)](https://gemnasium.com/elidoran/ordering)
[![npm version](https://badge.fury.io/js/ordering.svg)](http://badge.fury.io/js/ordering)

Order array elements based on before/after constraints.

See [needier](https://www.npmjs.com/package/needier) for more on how the dependencies are handled.

See [had](https://www.npmjs.com/package/had) for more on how the return results/errors are produced.

[Tapestry-IoC](https://tapestry.apache.org/tapestry-ioc-configuration.html#TapestryIoCConfiguration-Ordered_List) anyone?

## Install

    npm install ordering --save

## Usage: JavaScript

[CoffeeScript Usage](#usage-coffeescript)

```javascript
// get it
var order = require('ordering')

// make some functions
function func1() { console.log('I am a function'); }
function func2() { console.log('Me too!'); }
function func3() { console.log('Me three!!!'); }
function func4() { console.log('enough already'); }

// put them, unsorted, into an array
var array = [ func4, func2, func3, func1 ];

// how to control their order?
func1.options = { id: 'f1',  before: [ '*' ] }

func2.options = { id: 'f2', after: [ 'f3', 'f4' ] }

func3.options = {
  id: 'f3'
  , before: [ 'f4' ]
  , after : [ 'f1' ]
}

// order the array contents
var sorted = order(array);
//  OR:
// sorted = order({ array:array });
//  OR:
// sorted = order(func4, func2, func3, func1);

// results in sorted array will be:
sorted = [ func1, func3, func4, func2 ]

// another module can add more functions to the array.
function func5() { console.log('contributed function'); }
func5.options =  { id: 'f5',  before: [ 'f3' ] }

function func6() { console.log('another contribution'); }
func6.options = {
  id: 'f6'
  , before: [ 'f4']
  , after: [ 'f5' ]
}

array.push(func5, func6);

sorted = order({array:array});

// results in sorted array will now be:
sorted = [ func1, func5, func3, func6, func4, func2 ];
```


## Usage: CoffeeScript

[JavaScript Usage](#usage-javascript)


```coffeescript
# get it
order = require 'ordering'

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

sorted = order array:array
#  OR:
# sorted = order array:array
#  OR:
# sorted = order func4, func2, func3, func1

# results in sorted array will be:
sorted = [ func1, func3, func4, func2 ]

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

sorted = order array

# results in sorted array will now be:
sorted = [ func1, func5, func3, func6, func4, func2 ]
```


## API


### **ordering(options)**

Orders the provided array based on the `options` on each member of the array.

The accepted arguments:

1. individual arguments will be converted to an array when there are **at least two** of them.
2. the first argument may be an array
3. the first argument is an object with an `array` property

The array members `options` property should specify:

1. `id` : a unique identifier within the members of the array
2. `before`: an array of IDs the member should be *before* when ordered.
3. `after`: an array of IDs the member should be *after* when ordered.

When `options` is undefined an empty object will be put in its place.

When `options.id` is undefined the `name` property will be used. A named function has a `name` property. If the member is missing both an `id` and a `name` then an error will be added to the result.


## MIT License
