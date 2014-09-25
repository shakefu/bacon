Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'home', path: '/'


if Meteor.isClient
  # Home template
  home = Template.home
  home.apps = -> [{
    name: "Google Analytics"
    id: "ga"
  }]


if Meteor.isServer
  Meteor.startup ->
    console.log "Would you like eggs with that?"

