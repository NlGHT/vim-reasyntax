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
plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
ultisnips_root_dir = normpath(join(plugin_root_dir, '..', 'UltiSnips'))
sys.path.insert(0, python_root_dir)
import ReaSyntax
EOF

function! ReaSyntaxUpdateEEL()

python3 << EOF
ultisnips = ReaSyntax.make_ultisnips("e")
with open(normpath(join(ultisnips_root_dir, "eel2.snippets"), 'w') as f:
    for snippet in ultisnips:
        f.write(f"{snippet}\n")

EOF

endfunction
