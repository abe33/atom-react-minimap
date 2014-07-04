{View} = require 'atom'
React = require 'react-atom-fork'
MinimapComponent = require './minimap-component'
{defaults} = require 'underscore-plus'

module.exports =
class MinimapView extends View
  @content: -> @div class: 'minimap'

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

    console.log 'there'

    node = @component.getDOMNode()

  destroy: ->

  attach: ->
    @paneView.addClass('with-minimap')
    @paneView.append(this)

  detach: ->
    @paneView.removeClass('with-minimap')
    super
