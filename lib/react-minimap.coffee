{Emitter} = require 'emissary'
Debug = require 'prolix'
semver = require 'semver'

ViewManagement = require './mixins/view-management'

class ReactMinimap
  Emitter.includeInto(this)
  Debug('minimap').includeInto(this)
  ViewManagement.includeInto(this)

  version: require('../package.json').version

  configDefaults:
    plugins: {}
    autoToggle: false
    displayMinimapOnLeft: false
    minimapScrollIndicator: true
    lineOverdraw: 10

  active: false

  activate: ->

    atom.workspaceView.command 'minimap:toggle', => @toggleNoDebug()
    atom.workspaceView.command 'minimap:toggle-debug', => @toggleDebug()
    @toggleNoDebug() if atom.config.get 'minimap.autoToggle'
    atom.workspaceView.toggleClass 'minimap-on-left', atom.config.get('minimap.displayMinimapOnLeft')
    atom.config.observe 'minimap.displayMinimapOnLeft', =>
      atom.workspaceView.toggleClass 'minimap-on-left', atom.config.get('minimap.displayMinimapOnLeft')

  deactivate: ->
    @destroyViews()
    @emit('deactivated')

  toggleDebug: ->
    @getChannel().activate()
    @toggle()

  toggleNoDebug: ->
    @getChannel().deactivate()
    @toggle()

  versionMatch: (expectedVersion) -> semver.satisfies(@version, expectedVersion)

  getCharWidthRatio: -> 0.72

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
