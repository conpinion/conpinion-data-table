Polymer

  is: 'conpinion-data-table'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    resource: {type: Object}
    model: {type: String, value: 'model'}
    heading: {type: String}
    titleAttribute: {type: String, value: 'href'}

  attached: ->
    @data = []
    @loading = false
    columnNodes = Polymer.dom(@).querySelectorAll 'conpinion-data-table-column'
    @columns = (column for column in columnNodes)

  load: ->
    delayedLoadingSpinner = setInterval (=> @loading = true), 1000
    @resource.index().then (success) =>
      @data = success.data
      clearTimeout delayedLoadingSpinner
      @loading = false
    , (error) =>
      @fire 'conpinion-data-table-error', error.data

  editResource: (e) ->
    @fire 'conpinion-data-table-edit', {href: e.model.item.href}

  deleteResource: (e) ->
    item = e.model.item
    modelName = "models.#{@model}.one"
    message = "Soll #{@i18n(modelName)} <b>#{@_getAttribute(item, @titleAttribute)}</b> wirklich gelöscht werden?"
    @$.deleteConfirmation.ask(message).then =>
      @resource.destroy(item.href).then (success) =>
        @data = @data.filter (it) -> it.href != item.href
      , (error) =>
        @fire 'conpinion-data-table-error', error.data
    , ->

  _getAttribute: (item, column) ->
    column.split('.').reduce(((o, x) -> o[x]), item)

  _totalColumnsCount: (columns) ->
    columns.length + 1

  _columnTitle: (name, label, model) ->
    if label then label
    else @i18n "attributes.#{model}.#{name}"
