###
# Routes
###
Router.configure
  onAfterAction: ->
    # This action sends pageview to GA with the correct location, since it
    # doesn't always pick up the pushState location correctly
    console.log "On page: #{window.location.pathname}"
    tryGa = ->
      if not ga?
        setTimeout tryGa, 10
      ga 'send', 'pageview',
        page: window.location.pathname
        location: window.location.toString()

    tryGa()


Router.map ->
  @route 'ga', path: '/ga'


# This module doesn't have any strictly server side code
if Meteor.isServer
  return


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
    console.log "ga", getParams()
    ga.apply ga, getParams()


