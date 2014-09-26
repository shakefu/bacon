Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'home',
    path: '/'
    onBeforeAction: -> Session.set 'layout.homeLink', false


if Meteor.isClient
  show = (toggle) -> Session.equals toggle, true

  ###
  # Home template
  ###
  Template.home.apps = -> [{
    name: "Google Analytics"
    id: "ga"
  }]

  ###
  # Layout template
  ###
  Template.layout.homeLink = -> show 'layout.homeLink'


if Meteor.isServer
  Meteor.startup ->
    console.log "Would you like eggs with that?"

