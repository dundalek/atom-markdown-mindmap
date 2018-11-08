# Markdown Mindmap

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

### [0.6.0](https://github.com/dundalek/atom-markdown-mindmap/compare/v0.5.0...v0.6.0) (2018-11-08)

- Keep state of folded/unfolded nodes on update ([#20](https://github.com/dundalek/atom-markdown-mindmap/issues/20))
- Watch for changes and update nested file trees
- Fix various file links issues
- Add an option to disable link parsing ([#42](https://github.com/dundalek/atom-markdown-mindmap/issues/42))

### [0.5.0](https://github.com/dundalek/atom-markdown-mindmap/compare/v0.4.2...v0.5.0) (2018-09-10)

- Add support for links across files
- Fix syncing scroll position when using [markdown-preview-enhanced](https://github.com/shd101wyy/markdown-preview-enhanced) plugin [#12](https://github.com/dundalek/atom-markdown-mindmap/issues/12)
- Fix deprecated save dialog [#37](https://github.com/dundalek/atom-markdown-mindmap/issues/37)

### 0.4.2

- Fix node width for non-lation characters (using canvas to measure text width)
- Add support for markdown numbered lists

### 0.4.1

- Fixes Block size for capital letters #29

### 0.4.0

- Make node width dynamic based on content
- Truncate long labels (can be switched off in settings)
- Parse markdown lists and display them as nodes (can be switched off in settings)
- Fix: navigation bug after collapsing and re-expanding nodes

## Publishing

Notes to myself:
- Do not use `npm version` before publishing, just use `apm publish major|minor|patch` which takes care of everything.
- If the command asks for username and password then [personal access token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) can be used in place of the password.
