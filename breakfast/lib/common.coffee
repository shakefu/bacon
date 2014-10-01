# No server side code here
if Meteor.isServer
  return

###
# Client
###

# node.js like syntax for exposing these methods globally
exports = global ? window

###
# Helper to make it easy to delay a function with CoffeeScript syntax.
###
exports.delay = (timeout, func) ->
  if timeout instanceof Function
    func = timeout
    timeout = 0
  setTimeout func, timeout


###
# Event handler wrapper to stop normal event handling easily.
###
exports.handle = (func) -> (event) ->
  event.preventDefault()
  event.stopPropagation()
  func(event)


###
# Increment the given session key
###
exports.increment = (key) ->
  val = Session.get key
  val = (val or 0) + 1
  Session.set key, val
  val


