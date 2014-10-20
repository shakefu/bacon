
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

  return


########
# Client
########
Meteor.subscribe 'all-links'

###

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
###

Template.links.all_links = -> Links.find()

###

Template.links.rendered = ->
  return
  $('.link-edit .link-tags')
    .suggest key: 'AIzaSyATgp60c0YT8qc8MdMmxulPrI5e4C6z_dg'
    .bind 'fb-select', (event, data) ->
      console.log event
      console.log data

Template.links.editing = currentlyEditing

###

Template.link.events = 'click .link-delete': ->
  self = $ event.target
  Links.remove _id: self.data 'id'


class LazyForm
  constructor: (@key, @model, @template) ->
    @log 'Constructing.'
    @template.events
      'blur input': @blur
      'submit form': @submit

    _this = @
    @template.helpers
      doc: -> _this.doc

  submit: (e) =>
    @log "Submitted #{@key}"
    field = @$ 'input:focus'
    key = field.attr 'name'
    value = field.val()
    doc = @doc
    doc[key] = value
    @store doc
    @update key, value
    @$ 'form'
      .trigger 'reset'
    @store {}

  blur: (e) =>
    @log "Blurred #{@key}"
    field = $ e.target
    key = field.attr 'name'
    value = field.val()
    return unless value
    doc = @doc
    doc[key] = value
    @store doc
    @update key, value

  update: (key, value) ->
    return @insert() unless @doc._id?
    @log "Updating #{@key}"
    @log "  #{key}: #{value}"
    update = {}
    update[key] = value
    @model.update
      _id: @doc._id
    , $set: update

  insert: ->
    @log "Inserting #{@key}"
    doc = @doc
    doc._id = @model.insert doc
    @store doc

  store: (doc) ->
    @log ' ', doc
    Session.set @key, doc

  Object.defineProperties @::,
    log: value: console.log.bind console

    _: get: -> Template.instance()

    $: get: -> @_.$.bind @_

    doc: get: ->
      # TODO: Figure out a better way to store the live doc since the session
      # doesn't allow object mutation
      doc = Session.get @key
      @store {} unless doc?
      Session.get @key


editLinks = new LazyForm 'linkForm', Links, Template.linkForm


