Mixin = require 'mixto'
MinimapView = require '../minimap-view'

module.exports =
class ViewManagement extends Mixin
  minimapViews: {}

  updateAllViews: -> view.onScrollViewResized() for id,view of @minimapViews

  minimapForEditorView: (editorView) ->
    @minimapForEditor(editorView?.getEditor())

  minimapForEditor: (editor) -> @minimapViews[editor.id] if editor?

  # Public: Calls `iterator` for each present and future minimap views.
  #
  # iterator - A {Function} to call for each minimap view. It will receive
  #            an object with the following property:
  #            * view - The {MinimapView} instance
  #
  # Returns a subscription object with a `off` method so that it is possible to
  # unsubscribe the iterator from being called for future views.
  eachMinimapView: (iterator) ->
    return unless iterator?
    iterator({view: minimapView}) for id,minimapView of @minimapViews
    createdCallback = (minimapView) -> iterator(minimapView)

    @on('minimap-view:created', createdCallback)
    off: => @off('minimap-view:created', createdCallback)

  # Internal: Destroys all views currently in use.
  destroyViews: ->
    view.destroy() for id, view of @minimapViews
    @eachEditorViewSubscription?.off()
    @minimapViews = {}

  # Internal: Registers to each pane view existing or to be created and creates
  # a {MinimapView} instance for each.
  createViews: ->
    # When toggled we'll look for each existing and future editors thanks to
    # the `eacheditorView` method. It returns a subscription object so we'll
    # store it and it will be used in the `deactivate` method to removes
    # the callback.
    @eachEditorViewSubscription = atom.workspaceView.eachEditorView (editorView) =>
      editorId = editorView.editor.id
      paneView = editorView.getPane()
      view = new MinimapView(editorView)

      @minimapViews[editorId] = view
      @emit('minimap-view:created', {view})

      # view.updateMinimapEditorView()
      view.attach()

      editorView.editor.on 'destroyed', =>
        view = @minimapViews[editorId]

        if view?
          @emit('minimap-view:will-be-destroyed', {view})

          view.destroy()
          delete @minimapViews[editorId]
          @emit('minimap-view:destroyed', {view})

          if paneView.activeView.hasClass('editor')
            paneView.addClass('with-react-minimap')
