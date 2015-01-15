Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  onBeforeAction: ->
    # Toggle the top menu based on the page
    Session.set 'layout.homeLink', @route.name != 'home'
    @next()


Router.map ->
  @route 'home', path: '/'


if Meteor.isServer
  Meteor.startup ->
    console.log "Would you like eggs with that?"
  return


show = (toggle) -> Session.equals toggle, true

###
# Home template
###
Template.home.apps = ->
  [
    name: "Google Analytics", id: "ga"
  ,
    name: "Links", id: "links"
  , name: "TODO", id: "todo"
  ]

###
# Layout template
###
Template.layout.homeLink = -> show 'layout.homeLink'


