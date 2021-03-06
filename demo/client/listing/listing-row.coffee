Template.listingRow.onCreated ->
  self          = @
  @showSettings = new ReactiveVar false
  @showPreview  = ->
    if self.data.isImage and /png|jpe?g/i.test self.data.type
      if self.data.versions.thumbnail40
        return true
    return false
  return

Template.listingRow.helpers
  removedIn:    -> moment(@meta.expireAt).fromNow()
  showPreview:  -> Template.instance().showPreview()
  showSettings: -> Template.instance().showSettings.get() is @_id

Template.listingRow.events
  'click [data-remove-file]': (e) ->
    e.stopPropagation()
    e.preventDefault()
    icon = $(e.currentTarget).find 'i.fa'
    icon.removeClass('fa-trash-o').addClass 'fa-spin fa-spinner'
    @remove (error) ->
      if error
        console.log error
      return
    return
  'click [data-change-access]': (e) ->
    e.stopPropagation()
    e.preventDefault()
    icon = $(e.currentTarget).find 'i.fa'
    icon.removeClass('fa-eye-slash fa-eye').addClass 'fa-spin fa-spinner'
    Meteor.call 'changeAccess', @_id, (error) ->
      if error
        console.log error
      return
    return
  'click [data-change-privacy]': (e) ->
    e.stopPropagation()
    e.preventDefault()
    icon = $(e.currentTarget).find 'i.fa'
    icon.removeClass('fa-lock fa-unlock').addClass 'fa-spin fa-spinner'
    Meteor.call 'changePrivacy', @_id, (error) ->
      if error
        console.log error
      return
    return
  'click [data-show-file]': (e) ->
    e.preventDefault()
    FlowRouter.go 'file', _id: @_id
    false
  'click [data-show-settings]': (e, template) ->
    e.stopPropagation()
    e.preventDefault()
    template.showSettings.set if template.showSettings.get() is @_id then false else @_id
    false
  'click [data-close-settings]': (e, template) ->
    e.stopPropagation()
    e.preventDefault()
    template.showSettings.set false
    false