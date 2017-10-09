# Markdown Mindmap package

Type `mind` in the Atom command palette to open a mindmap view of the current markdown file. The full command name is `Markdown Mindmap: Toggle`.

By default there is no keyboard shortcut to avoid conflicts. If you want to use one open menu `Edit -> Keymap...` and add this to the file:

```
'atom-workspace':
  'ctrl-alt-m': 'markdown-mindmap:toggle'
```

![Mindmap screenshot](https://github.com/dundalek/atom-markdown-mindmap/blob/master/screenshot.gif?raw=true)

You can switch between different themes in package settings. Dark themes variants are also available.

![Different theme](https://github.com/dundalek/atom-markdown-mindmap/blob/master/screenshot2.png?raw=true)

This extension is built using the [markmap](https://github.com/dundalek/markmap) component.

Suggestions for new featues are welcome, feel free to open an [issue](https://github.com/dundalek/atom-markdown-mindmap/issues).

## Changelog

### 0.4.2

- Fix node width for non-lation characters (using canvas to measure text width)
- Add support for markdown numbered lists 

### v0.4.1

- Fixes Block size for capital letters #29

### v0.4.0

- Make node width dynamic based on content
- Truncate long labels (can be switched off in settings)
- Parse markdown lists and display them as nodes (can be switched off in settings)
- Fix: navigation bug after collapsing and re-expanding nodes
