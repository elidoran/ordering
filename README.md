# ordering

NOTE:
I have yet to implement the main feature I am heading for. Which is order
constraints such as `before` and `after` which reference other objects via name.
This allows adding an object into an array of other objects and having it ordered
according to constraints you specify. When they can't be met, you get an error,
otherwise, you are assured your object will be used in the right order related
to other contributed objects.

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

    # how to control their order? simple example:
    #   use an index property on the function.
    #   spread values out to allow others to use numbers in between them
    func1.index = 100
    func2.index = 200
    func3.index = 300
    func4.index = 400

    sorted = ordering.order
      method: 'numeric'
      array:  array

    # results in sorted array will be:
    isNow = [ func1, func2, func3, func4 ]

    # another module can add more functions to the array.
    func5 = () -> console.log 'contributed function'
    func5.index = 150
    func6 = () -> console.log 'another contribution'
    func6.index = 325

    array.push func5, func6

    sorted = ordering.order
      method: 'numeric'
      array:  array

    # results in sorted array will now be:
    isNow = [ func1, func5, func2, func3, func6, func4 ]
```

## API

### ordering.order(options)

Accepts all configuration values, and the array, inside the options object.

Returns an object containing the result or error information

Regardless of varying behavior according to the options it always checks for
nulls, array and elements, and sees nulls as an error. It will tell you exactly
where it encountered a null. For example:

```coffeescript
{
  error: 'null'
  type:  'item'
  index: '7'
}
```

#### Result object

When successfully ordered a result object is returned.

```coffeescript
{
  sorted: []      # the sorted results in a new array
  options: {}     # the options provided to the call
  # The below values *may* be there
  error: string   # a non-fatal error which occurred
  type: string    # the type of the non-fatal error
  warning: string # an extra warning message
}
```

#### Error object

```coffeescript
{
  options:         # the options provided to the call
  error: string    # a non-fatal error which occurred
  type: string     # the type of the non-fatal error
  warning: string  # an extra warning message
  index: number    # index in the source array where null was encountered
  # not sure if i'll make this link to each other, or put an array here...
  previousError {} # a non-fatal error which occurred before the fatal one
}
```

#### Common Error responses

```coffeescript
{
  error: 'null'
  type: 'array' # or: 'item', 'options', 'sorter'
  warning: 'unknown ordering method' # or: 'empty input array'
}
```

#### Altering error/result

Errors and results are passed through two corresponding functions before they are
returned:

1. `ordering._result`
2. `ordering._error`

Their default simply returns the object provided them. You can extend that by
setting new functions in their place.

### Options:

key       |  type    | use
---------:|:---------|:----------
array     | Array    | the array containing
method    | String   | sorter or iterator or alpha or numeric *[1]*
sortBy    | String   | name of the field on the object to use for ordering (orderBy?)
sortOrder | String   | 'asc' or 'desc' for ascending/descending
iterator  | Function | looks at each item in the array and places it in the result array
sorter    | Function | runs a sort on the array using provided options
sortDiff  | Function | function to compare two strings. Currently uses `String.localeCompare`
getField  | Function | function to get the desired field from the object for comparison


#### Notes

1. *[1]* Method

sorter looks at the whole array and processes it. Array.sort for example.

iterator looks at items one at a time and places them into the array. Using
ordering constraints is an example.

alpha/numeric are standard Array.sort style actions comparing either string or
number properties on the array element.

alpha looks at `name` property by default. Override with `options.sortBy`.

numeric looks at `index` property by default. Override with `options.sortBy`.



## Array.sort ??

Ignore the heavy array.sort similarities. I'm headed towards ordering constraints
which are far more valuable than simply sorting an array by a property value.


## MIT License


## JavaScript Style Usage

```javascript
ordering = require('ordering');

func1 = function() { return console.log('I am a function'); };

func2 = function() { return console.log('Me too!'); };

func3 = function() { return console.log('Me three!!!'); };

func4 = function() { return console.log('enough already'); };

array = [func4, func2, func3, func1];

func1.index = 100;

func2.index = 200;

func3.index = 300;

func4.index = 400;

sorted = ordering.order({ method: 'numeric', array: array });

isNow = [func1, func2, func3, func4];

func5 = function() { return console.log('contributed function'); };

func5.index = 150;

func6 = function() { return console.log('another contribution'); };

func6.index = 325;

array.push(func5, func6);

sorted = ordering.order({ method: 'numeric', array: array });

isNow = [func1, func5, func2, func3, func6, func4];

```
