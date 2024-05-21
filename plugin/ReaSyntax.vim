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

" Global configurable variables
let g:reasyntax_silent                  = get(g:, 'reasyntax_silent', 0)
let g:reasyntax_languages               = get(g:, 'reasyntax_languages', '')
let g:reasyntax_delete_unused_languages = get(g:, 'reasyntax_delete_unused_languages', 1)

python3 << EOF

import sys
import os
import vim
from pathlib import Path

plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = os.path.normpath(os.path.join(plugin_root_dir, '..', 'python'))
ultisnips_root_dir = os.path.normpath(os.path.join(plugin_root_dir, '..', 'UltiSnips'))
Path(ultisnips_root_dir).mkdir(parents=True, exist_ok=True)
sys.path.insert(0, python_root_dir)

import ReaSyntax

supported_languages = {"e": "EEL2", "l": "Lua", "c": "CPP", "p": "Python"}

# Get user config options
user_langs              = vim.eval("g:reasyntax_languages")
silent                  = int(vim.eval("g:reasyntax_silent"))
delete_unused_languages = int(vim.eval("g:reasyntax_delete_unused_languages"))

def write_snippets(snippets, language):
	if len(snippets) > 0:
		with open(os.path.join(ultisnips_root_dir, "{}.snippets".format(language.lower())), 'w') as f:
			for snippet in snippets:
				f.write(f"{snippet}\n")
		if silent != 1:
			print("ReaSyntax: {} snippets generated successfully...".format(language))
	else:
		if silent != 1:
			print("ReaSyntax: Failed to get {} snippets".format(language))


def check_init_syntax(user_langs):
	for letter in user_langs:
		if letter not in supported_languages.keys():
			if silent != 1:
				print("ReaSyntax Error: Language '{}' in config's g:reasyntax_languages is not supported. Please only use these: 'elcp'.".format(letter))
			return False

	return True


def avoid_existing_langs(user_langs):
	for lang in user_langs:
		full_lang_name = supported_languages[lang]
		filename = "{}.snippets".format(full_lang_name.lower())
		if os.path.isfile(os.path.join(ultisnips_root_dir, filename)):
			user_langs = user_langs.replace(lang, "")

	return user_langs


def produce_lang_snippets(shorthand, full_name, html):
	ultisnips = ReaSyntax.make_ultisnips_from_html(shorthand, html)
	write_snippets(ultisnips, full_name)


def make_snippets_for_langs(user_langs):
	html_content = ReaSyntax.get_html(silent)
	if html_content:
		if silent != 1:
			print("ReaSyntax: Downloaded ReaScript API...")
		for shorthand, full_name in supported_languages.items():
			if shorthand in user_langs:
				produce_lang_snippets(shorthand, full_name, html_content)

def delete_unspecified_langs_snippets(user_langs):
	try:
		files = os.listdir(ultisnips_root_dir)

		for file in files:
			file_path = os.path.join(ultisnips_root_dir, file)

			user_langs_full_names = [supported_languages[lang] for lang in user_langs]
			user_langs_filenames = ["{}.snippets".format(lang.lower()) for lang in user_langs_full_names]
			if os.path.isfile(file_path) and file not in user_langs_filenames:
				os.remove(file_path)
				if silent != 1:
					print(f"ReaSyntax: {file_path} was deleted - is no longer in config.")

	except Exception as e:
		if silent != 1:
			print(f"ReaSyntax: An error occurred: {e}")


def init_snippets(user_langs):
	if check_init_syntax(user_langs):
		if delete_unused_languages == 1:
			delete_unspecified_langs_snippets(user_langs)
		user_langs = avoid_existing_langs(user_langs)
		if len(user_langs) > 0:
			make_snippets_for_langs(user_langs)


init_snippets(user_langs)

EOF


function! s:ReaSyntaxUpdateEEL()
python3 << EOF
make_snippets_for_langs("e")
EOF
endfunction

function! s:ReaSyntaxUpdateLua()
python3 << EOF
make_snippets_for_langs("l")
EOF
endfunction

function! s:ReaSyntaxUpdateCPP()
python3 << EOF
make_snippets_for_langs("c")
EOF
endfunction

function! s:ReaSyntaxUpdatePython()
python3 << EOF
make_snippets_for_langs("p")
EOF
endfunction

function! s:ReaSyntaxUpdateAll()
python3 << EOF
make_snippets_for_langs("elcp")
EOF
endfunction

command! -nargs=0 ReaSyntaxUpdateEEL    call s:ReaSyntaxUpdateEEL()
command! -nargs=0 ReaSyntaxUpdateLua    call s:ReaSyntaxUpdateLua()
command! -nargs=0 ReaSyntaxUpdateCPP    call s:ReaSyntaxUpdateCPP()
command! -nargs=0 ReaSyntaxUpdatePython call s:ReaSyntaxUpdatePython()
command! -nargs=0 ReaSyntaxUpdateAll    call s:ReaSyntaxUpdateAll()
