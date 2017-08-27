url = require 'url'
{CompositeDisposable} = require 'atom'

MarkdownMindmapView = null # Defer until used

createMarkdownMindmapView = (state) ->
  MarkdownMindmapView ?= require './markdown-mindmap-view'
  new MarkdownMindmapView(state)

isMarkdownMindmapView = (object) ->
  MarkdownMindmapView ?= require './markdown-mindmap-view'
  object instanceof MarkdownMindmapView

atom.deserializers.add
  name: 'MarkdownMindmapView'
  deserialize: (state) ->
    createMarkdownMindmapView(state) if state.constructor is Object

module.exports =
  config:
    liveUpdate:
      type: 'boolean'
      default: true
    autoOpen:
      type: 'boolean'
      default: false
    openPreviewInSplitPane:
      type: 'boolean'
      default: true
    parseListItems:
      type: 'boolean'
      default: true
    theme:
      type: 'string'
      default: 'default'
      enum: ['default', 'colorful', 'default-dark', 'colorful-dark']
    linkShape:
      type: 'string'
      default: 'diagonal'
      enum: ['diagonal', 'bracket']
    truncateLabels:
      type: 'integer'
      default: 40
      minimum: 0
      description: "Set to 0 to disable truncating"
    grammars:
      type: 'array'
      default: [
        'source.gfm'
        'source.litcoffee'
        'text.html.basic'
        'text.plain'
        'text.plain.null-grammar'
        'text.md'
      ]

  activate: ->
    @disposables = new CompositeDisposable

    @disposables.add atom.workspace.onDidChangeActivePaneItem (editor) =>
      @autoOpen(editor)

    atom.commands.add 'atom-workspace',
      'markdown-mindmap:toggle-auto-mode': =>
        @toggleAutoOpen()
      'markdown-mindmap:toggle': =>
        @toggle()
      #'markdown-mindmap:copy-html': =>
      #  @copyHtml()
      'markdown-mindmap:toggle-break-on-single-newline': ->
        keyPath = 'markdown-mindmap.breakOnSingleNewline'
        atom.config.set(keyPath, not atom.config.get(keyPath))

    previewFile = @previewFile.bind(this)
    atom.commands.add '.tree-view .file .name[data-name$=\\.markdown]', 'markdown-mindmap:preview-file', previewFile
    atom.commands.add '.tree-view .file .name[data-name$=\\.md]', 'markdown-mindmap:preview-file', previewFile
    atom.commands.add '.tree-view .file .name[data-name$=\\.mdown]', 'markdown-mindmap:preview-file', previewFile
    atom.commands.add '.tree-view .file .name[data-name$=\\.mkd]', 'markdown-mindmap:preview-file', previewFile
    atom.commands.add '.tree-view .file .name[data-name$=\\.mkdown]', 'markdown-mindmap:preview-file', previewFile
    atom.commands.add '.tree-view .file .name[data-name$=\\.ron]', 'markdown-mindmap:preview-file', previewFile
    atom.commands.add '.tree-view .file .name[data-name$=\\.txt]', 'markdown-mindmap:preview-file', previewFile

    atom.workspace.addOpener (uriToOpen) ->
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        return

      return unless protocol is 'markdown-mindmap:'

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return

      if host is 'editor'
        createMarkdownMindmapView(editorId: pathname.substring(1))
      else
        createMarkdownMindmapView(filePath: pathname)

  deactivate: ->
    @disposables.dispose()

  toggle: ->
    if isMarkdownMindmapView(atom.workspace.getActivePaneItem())
      atom.workspace.destroyActivePaneItem()
      return

    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    grammars = atom.config.get('markdown-mindmap.grammars') ? []
    return unless editor.getGrammar().scopeName in grammars

    @addPreviewForEditor(editor) unless @removePreviewForEditor(editor)

  toggleAutoOpen: ->
    key = 'markdown-mindmap.autoOpen'
    atom.config.set(key, !atom.config.get(key))

  uriForEditor: (editor) ->
    "markdown-mindmap://editor/#{editor.id}"

  removePreviewForEditor: (editor) ->
    uri = @uriForEditor(editor)
    previewPane = atom.workspace.paneForURI(uri)
    if previewPane?
      previewPane.destroyItem(previewPane.itemForURI(uri))
      true
    else
      false

  autoOpen: (editor) ->
    return unless atom.config.get('markdown-mindmap.autoOpen') and editor?.getPath?
    return if editor.element?.classList.contains('markdown-mindmap')

    grammars = atom.config.get('markdown-mindmap.grammars') ? []
    newPath = editor.getPath()
    return unless newPath and @activeEditor != newPath and editor.getGrammar?()?.scopeName in grammars

    @activeEditor = newPath
    @addPreviewForEditor(editor)

  addPreviewForEditor: (editor) ->
    uri = @uriForEditor(editor)
    previousActivePane = atom.workspace.getActivePane()
    options =
      searchAllPanes: true
    if atom.config.get('markdown-mindmap.openPreviewInSplitPane')
      options.split = 'right'
    atom.workspace.open(uri, options).then (markdownMindmapView) ->
      if isMarkdownMindmapView(markdownMindmapView)
        previousActivePane.activate()

  previewFile: ({target}) ->
    filePath = target.dataset.path
    return unless filePath

    for editor in atom.workspace.getTextEditors() when editor.getPath() is filePath
      @addPreviewForEditor(editor)
      return

    atom.workspace.open "markdown-mindmap://#{encodeURI(filePath)}", searchAllPanes: true

  # copyHtml: ->
  #   editor = atom.workspace.getActiveTextEditor()
  #   return unless editor?
  #
  #   renderer ?= require './renderer'
  #   text = editor.getSelectedText() or editor.getText()
  #   renderer.toHTML text, editor.getPath(), editor.getGrammar(), (error, html) ->
  #     if error
  #       console.warn('Copying Markdown as HTML failed', error)
  #     else
  #       atom.clipboard.write(html)
