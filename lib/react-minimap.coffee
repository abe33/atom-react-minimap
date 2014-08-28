{Emitter} = require 'emissary'
semver = require 'semver'

ViewManagement = require './mixins/view-management'

class ReactMinimap
  Emitter.includeInto(this)
  ViewManagement.includeInto(this)

  configDefaults:
    plugins: {}
    autoToggle: false
    displayMinimapOnLeft: false
    minimapScrollIndicator: true
    lineOverdraw: 10

  active: false

  activate: ->

    atom.workspaceView.command 'minimap:toggle', => @toggle()
    @toggle() if atom.config.get 'minimap.autoToggle'

    atom.workspaceView.toggleClass 'minimap-on-left', atom.config.get('minimap.displayMinimapOnLeft')
    atom.config.observe 'minimap.displayMinimapOnLeft', =>
      atom.workspaceView.toggleClass 'minimap-on-left', atom.config.get('minimap.displayMinimapOnLeft')

  deactivate: ->
    @destroyViews()
    @emit('deactivated')

  toggle: () ->
    if @active
      @active = false
      @deactivate()
    else
      @createViews()
      @active = true
      @emit('activated')

# The minimap module is an instance of the {Minimap} class.
module.exports = new ReactMinimap()
