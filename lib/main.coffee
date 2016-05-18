
module.exports =

  provider: null

  activate: ->

  deactivate: ->
    @provider = null

  provide: ->
    unless @provider?
      Provider = require('./provider.coffee')
      @provider = new Provider();
    @provider
