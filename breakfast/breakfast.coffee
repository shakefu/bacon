Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  onBeforeAction: ->
    # Toggle the top menu based on the page
    Session.set 'layout.homeLink', @route.name != 'home'

Router.map ->
  @route 'home', path: '/'


if Meteor.isClient
  show = (toggle) -> Session.equals toggle, true

  ###
  # Home template
  ###
  Template.home.apps = -> [
    {name: "Google Analytics", id: "ga"},
    {name: "Links", id: "links"}
  ]

  ###
  # Layout template
  ###
  Template.layout.homeLink = -> show 'layout.homeLink'


if Meteor.isServer
  Meteor.startup ->
    console.log "Would you like eggs with that?"

