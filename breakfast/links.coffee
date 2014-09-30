
#############
# Collections
#############

Links = new Mongo.Collection 'links'


########
# Routes
########

Router.map ->
  @route 'links', path: '/links'


########
# Server
########

if Meteor.isServer
  Meteor.publish 'all-links', -> Links.find()

  if not Links.find().count()
    Links.insert
      text: "Google"
      url: "http://google.com"
      description: "Search for things"

  return


########
# Client
########
Meteor.subscribe 'all-links'

Template.links.all_links = ->
  Links.find()


