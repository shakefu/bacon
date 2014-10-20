
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
  # This is just temporary
  Links.allow
    insert: -> true
    update: -> true
    remove: -> true

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

currentlyEditing = ->
  doc = Session.get 'link.currentlyEditing'
  doc or {}


createNew = ->
  return if Session.get 'link.currentlyEditing'
  doc = {}
  doc._id = Links.insert doc
  Session.set 'link.currentlyEditing', doc


updateDoc = (template) ->
  doc = Session.get 'link.currentlyEditing'
  doc ?= {}
  for field in ['link-text', 'link-desc', 'link-url']
    field = $ template.find '.link-form .' + field
    doc[field.attr 'name'] = field.val()

  Session.set 'link.currentlyEditing', doc
  Links.update _id: doc._id
  ,
    $set:
      text: doc.text
      description: doc.description
      url: doc.url


Template.links.events =
  'focus .link-edit input': (event) ->
    createNew()

  'blur .link-edit input': (event) ->
    updateDoc Template.instance()

  'submit .link-edit .link-form': (event) ->
    updateDoc Template.instance()
    Session.set 'link.currentlyEditing'

Template.links.all_links = -> Links.find()

Template.links.rendered = ->
  $('.link-edit .link-tags')
    .suggest key: 'AIzaSyATgp60c0YT8qc8MdMmxulPrI5e4C6z_dg'
    .bind 'fb-select', (event, data) ->
      console.log event
      console.log data

Template.links.editing = currentlyEditing


Template.link.events = 'click .link-delete': ->
  self = $ event.target
  console.log self.data 'id'
  Links.remove _id: self.data 'id'

