# ReaSyntax in Vim!
Drawing some inspiration from the lovely  [ReaSyntax project in Sublime Text](https://github.com/Breeder/ReaSyntax), this is a plugin that provides functions for generating [UltiSnips](https://github.com/SirVer/ultisnips) snippets for all languages straight from the official REAPER ReaScript API.

## Installation
Add this to your favourite plugin manager like [vim-plug](https://github.com/junegunn/vim-plug) as such:
```vim
Plug 'NlGHT/vim-reasyntax'
```
**This requires [UltiSnips](https://github.com/SirVer/ultisnips) to also be installed to do anything.**

**You probably also want to install [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe) or another library that provides autocomplete suggestions that UltiSnips uses for the full effect!**

## Usage
The easiest way to use Vim-ReaSyntax is to configure it with your .vimrc as such:

```vim
let g:reasyntax_languages = 'elc' " available: 'elcp', default: ''
let g:reasyntax_delete_unused_languages = 1 " default: 1
let g:reasyntax_silent = 0 " default: 0
```

- `g:reasyntax_languages` is for specifying the languages to sync snippets for by first letter denoting each.  So if you wanted just EEL2 and Lua you would do: `= 'el'` and just CPP would be `= 'c'`.  Default is none (`''`).
- `g:reasyntax_delete_unused_languages` is an option to delete the snippet files for languages not in the synced languages. Default is on (`1`).
- `g:reasyntax_silent` is an option if you don't want any noise.  Turning off will result in no printing.  Maybe useful if you have everything setup and want to set and forget.  Default is off (`0`).

Only `g:reasyntax_languages` is required for syncing via config.

**After snippets have been generated you will need to restart vim or reload the snippets in UltiSnips another way.**

### Updating Snippets
Currently there are the following commands:
- `:ReaSyntaxUpdateEEL`
- `:ReaSyntaxUpdateLua`
- `:ReaSyntaxUpdateCPP`
- `:ReaSyntaxUpdatePython`
- `:ReaSyntaxUpdateAll`

These are available to run from anywhere and will generate the corresponding language snippets, overwriting current snippets (equivalent of updating). For UltiSnips to then load them, **you must restart vim**.

## No Syntax/Indentation Files?
Due to there being so many languages supported with vim, no syntax files have been added here to avoid conflicts people will experience from those other implementations.

However here are projects you will likely want for the respective languages missing:
### [vim-eel](https://github.com/NlGHT/vim-eel)
This plugin provides **everything for working with EEL2** (also made by me!) including proper good syntax and indentation files.  These are made from the ground up **(none of the terrible ones that try to just use one for C!)**.
### [vim-polyglot](https://github.com/sheerun/vim-polyglot)
This is a large language pack that many people likely already have installed to extend the supported languages in vim.  This for example **provides Lua support!**
