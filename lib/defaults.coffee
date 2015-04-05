
module.exports =
  asc : (a, b) -> a - b
  desc: (a, b) -> b - a
  getField: (o, field) -> o[field]
  alphaDiff: (a, b) -> a.localeCompare b
