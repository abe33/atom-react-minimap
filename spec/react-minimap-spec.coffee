{WorkspaceView} = require 'atom'
ReactMinimap = require '../lib/react-minimap'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ReactMinimap", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('react-minimap')

  describe "when the react-minimap:toggle event is triggered", ->
    describe 'with an editor actually on screen', ->
      beforeEach ->
        waitsForPromise ->
          atom.workspaceView.open 'sample.js'

      it "attaches and then detaches the view", ->
        expect(atom.workspaceView.find('.minimap')).not.toExist()

        # This is an activation event, triggering it will cause the package to be
        # activated.
        atom.workspaceView.trigger 'minimap:toggle'

        waitsForPromise ->
          activationPromise

        runs ->
          expect(atom.workspaceView.find('.minimap').length).toEqual(1)
