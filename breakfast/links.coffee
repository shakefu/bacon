
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
  Session.get 'link.currentlyEditing'


createNew = ->
  return if currentlyEditing()
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


Template.links.all_links = -> Links.find()

Template.links.rendered = ->
  $('.link-edit .link-tags')
    .suggest key: 'AIzaSyATgp60c0YT8qc8MdMmxulPrI5e4C6z_dg'
    .bind 'fb-select', (event, data) ->
      console.log event
      # throw err if err
      console.log data

Template.links.editing = currentlyEditing
