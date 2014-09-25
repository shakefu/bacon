###
# Routes
###
Router.map ->
  @route 'ga', path: '/ga'


# This module doesn't have any strictly server side code
if Meteor.isServer
  return


###
# Client
###

###
# Helper to make it easy to delay a function with CoffeeScript syntax.
###
delay = (timeout, func) ->
  if timeout instanceof Function
    func = timeout
    timeout = 0
  setTimeout func, timeout


###
# Event handler wrapper to stop normal event handling easily.
###
handle = (func) -> (event) ->
  event.preventDefault()
  event.stopPropagation()
  func(event)


###########################
# Google Analytics template
###########################

# Initialize the session
Session.setDefault 'ga.params', (value: '' for i in [0..5])

###
# Return Google Analytic params filtering out empty values.
###
getParams = -> (p.value for p in Session.get 'ga.params' when p.value isnt '')

###
# Template variables
###
#
# The currently set params
Template.ga.params = -> Session.get 'ga.params'

# The ga JS snippet
Template.ga.js = ->
  params = ("'#{p}'" for p in getParams()).join ', '
  "ga(#{params})"

# Template events 
Template.ga.events
  'click .btn': handle (e) ->
    Session.set 'ga.params', $('#ga').serializeArray()
    ga.apply ga, getParams()


