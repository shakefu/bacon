Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'home', path: '/'
  @route 'test'
  @route 'notFound', path: '*'


if Meteor.isClient
  Template.home.events 'click button': -> Router.go 'test'
  Template.test.events 'click button': -> Router.go 'home'


if Meteor.isServer
  Meteor.startup ->
    console.log "Would you like eggs with that?"

