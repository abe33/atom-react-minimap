{View} = require 'atom'
React = require 'react-atom-fork'
MinimapComponent = require './minimap-component'
{defaults} = require 'underscore-plus'

module.exports =
class MinimapView extends View
  @content: -> @div class: 'react-minimap'

  constructor: (@editorView, @props) ->
    super
    @editor = @editorView.getEditor()
    @paneView = @editorView.getPane()

  afterAttach: (onDom) ->
    return unless onDom
    return if @attached

    @attached = true
    props = defaults({@editor, parentView: this}, @props)
    @component = React.renderComponent(MinimapComponent(props), @element)

    node = @component.getDOMNode()

  destroy: ->

  attach: ->
    @paneView.addClass('with-react-minimap')
    @paneView.append(this)
    @afterAttach(true)

  detach: ->
    @paneView.removeClass('with-react-minimap')
    super
