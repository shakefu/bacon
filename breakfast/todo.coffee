# Todo item collection
Items = new Mongo.Collection 'todo.items'


# Routes
Router.map ->
  @route 'todo', path: '/todo'


# Server side code
if Meteor.isServer
  return


# Client side code

