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
    css = ''
    for k,v of document.styleSheets
      css += v.ownerNode.innerHTML if v.ownerNode?

    console.log css


    atom.workspaceView.command 'react-minimap:toggle', => @toggle()
    @toggle() if atom.config.get 'react-minimap.autoToggle'

    atom.workspaceView.toggleClass 'react-minimap-on-left', atom.config.get('react-minimap.displayMinimapOnLeft')
    atom.config.observe 'react-minimap.displayMinimapOnLeft', =>
      atom.workspaceView.toggleClass 'react-minimap-on-left', atom.config.get('react-minimap.displayMinimapOnLeft')

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
