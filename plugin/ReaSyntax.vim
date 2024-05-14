if exists('did_plugin_reasyntax') || &cp
    finish
endif
let did_plugin_reasyntax=1

if version < 800
   echohl WarningMsg
   echom  "UltiSnips requires Vim >= 8.0"
   echohl None
   finish
endif

if !has('python3')
  echo "Error: Required vim compiled with +python3"
  finish
endif

let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

python3 << EOF

import sys
from os.path import normpath, join
import vim
from pathlib import Path
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
ultisnips_root_dir = normpath(join(plugin_root_dir, '..', 'UltiSnips'))
Path(ultisnips_root_dir).mkdir(parents=True, exist_ok=True)
sys.path.insert(0, python_root_dir)
import ReaSyntax

EOF

function! ReaSyntaxUpdateEEL()
python3 << EOF
ultisnips = ReaSyntax.make_ultisnips("e")
if len(ultisnips) > 0:
	with open(join(ultisnips_root_dir, "eel2.snippets"), 'w') as f:
		for snippet in ultisnips:
			f.write(f"{snippet}\n")
	print("Snippets generated successfully. Restart vim to load them.")
else:
	print("Failed to get snippets")
EOF
endfunction

function! ReaSyntaxUpdateLua()
python3 << EOF
ultisnips = ReaSyntax.make_ultisnips("l")
if len(ultisnips) > 0:
	with open(join(ultisnips_root_dir, "lua.snippets"), 'w') as f:
		for snippet in ultisnips:
			f.write(f"{snippet}\n")
	print("Snippets generated successfully. Restart vim to load them.")
else:
	print("Failed to get snippets")
EOF
endfunction

function! ReaSyntaxUpdateCPP()
python3 << EOF
ultisnips = ReaSyntax.make_ultisnips("c")
if len(ultisnips) > 0:
	with open(join(ultisnips_root_dir, "cpp.snippets"), 'w') as f:
		for snippet in ultisnips:
			f.write(f"{snippet}\n")
	print("Snippets generated successfully. Restart vim to load them.")
else:
	print("Failed to get snippets")
EOF
endfunction

function! ReaSyntaxUpdatePython()
python3 << EOF
ultisnips = ReaSyntax.make_ultisnips("p")
if len(ultisnips) > 0:
	with open(join(ultisnips_root_dir, "python.snippets"), 'w') as f:
		for snippet in ultisnips:
			f.write(f"{snippet}\n")
	print("Snippets generated successfully. Restart vim to load them.")
else:
	print("Failed to get snippets")
EOF
endfunction

command! -nargs=0 ReaSyntaxUpdateEEL    call ReaSyntaxUpdateEEL()
command! -nargs=0 ReaSyntaxUpdateLua    call ReaSyntaxUpdateLua()
command! -nargs=0 ReaSyntaxUpdateCPP    call ReaSyntaxUpdateCPP()
command! -nargs=0 ReaSyntaxUpdatePython call ReaSyntaxUpdatePython()
