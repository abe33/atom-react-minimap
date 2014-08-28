{WorkspaceView} = require 'atom'
ReactMinimap = require '../lib/react-minimap'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "ReactMinimap", ->
  [activationPromise] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    atom.config.set 'editor.lineHeight', '1.5'
    atom.config.set 'editor.fontSize', '10'

    activationPromise = atom.packages.activatePackage('react-minimap')

  afterEach ->
    atom.workspaceView.trigger 'minimap:toggle'

  describe "when the react-minimap:toggle event is triggered", ->
    describe 'with an editor actually on screen', ->
      beforeEach ->
        waitsForPromise ->
          atom.workspaceView.open 'sample.js'

      it "attaches and then detaches the view", ->
        expect(atom.workspaceView.find('.minimap')).not.toExist()

        atom.workspaceView.trigger 'minimap:toggle'

        waitsForPromise -> activationPromise

        runs ->
          expect(atom.workspaceView.find('.react-minimap').length).toEqual(1)

      it 'decorates the pane with a with-react-minimap class', ->
        expect(atom.workspaceView.find('.with-react-minimap').length).toEqual(0)

        atom.workspaceView.trigger 'minimap:toggle'

        waitsForPromise -> activationPromise

        runs ->
          expect(atom.workspaceView.find('.with-react-minimap').length).toEqual(1)
