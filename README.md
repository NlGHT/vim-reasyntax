# ReaSyntax in Vim!
Heavily inspired by the ReaSyntax project in Sublime Text, this is a plugin that provides functions for generating UltiSnips snippets for all languages straight from the official REAPER ReaScript API.

## Functions Overview
Currently there are the following commands:
- `:ReaSyntaxUpdateEEL`
- `:ReaSyntaxUpdateLua`
- `:ReaSyntaxUpdatePython`
- `:ReaSyntaxUpdateCPP`

These will be available to run from anywhere and will generate the corresponding language snippets. For UltiSnips to then load them, you must restart vim.

## Installation
Add this to your favourite plugin manager like [vim-plug](https://github.com/junegunn/vim-plug) as such:
```vim
Plug 'NlGHT/vim-reasyntax'
```
