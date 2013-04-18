filetype on  " Automatically detect file types.
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set nocompatible  " We don't want vi compatibility.

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Add recently accessed projects menu (project plugin)
set viminfo^=!

let mapleader=","

" Minibuffer Explorer Settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" alt+n or alt+p to navigate between entries in QuickFix
map <silent> <m-p> :cp <cr>
map <silent> <m-n> :cn <cr>

" Change which file opens after executing :Rails command
let g:rails_default_file='config/database.yml'

syntax on
" Keep more context when scrolling off the end of a buffer
set scrolloff=3

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" GRB: sane editing configuration"
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
" set smartindent
set laststatus=2
set showmatch
set incsearch

" set colum width bar
set colorcolumn=81

set ruler
set hls

" prevent creation of *~ and .swp files
set nobackup
set nowritebackup
set noswapfile

if has("gui_running")
  " GRB: set font"
  ":set nomacatsui anti enc=utf-8 gfn=Monaco:h12

  " GRB: set window size"
  :set lines=100
  :set columns=171

  " GRB: highlight current line"
  :set cursorline
endif

" GRB: set the color scheme
:set t_Co=256 " 256 colors
":color lucius
:color zenburn

" GRB: hide the toolbar in GUI mode
if has("gui_running")
    set go-=T
end


function! ExtractVariable()
    let name = input("Variable name: ")
    if name == ''
        return
    endif
    " Enter visual mode (not sure why this is needed since we're already in
    " visual mode anyway)
    normal! gv

    " Replace selected text with the variable name
    exec "normal c" . name
    " Define the variable on the line above
    exec "normal! O" . name . " = "
    " Paste the original selected text to be the variable value
    normal! $p
endfunction

function! InlineVariable()
    " Copy the variable under the cursor into the 'a' register
    " XXX: How do I copy into a variable so I don't pollute the registers?
    :normal "ayiw
    " It takes 4 diws to get the variable, equal sign, and surrounding
    " whitespace. I'm not sure why. diw is different from dw in this respect.
    :normal 4diw
    " Delete the expression into the 'b' register
    :normal "bd$
    " Delete the remnants of the line
    :normal dd
    " Go to the end of the previous line so we can start our search for the
    " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
    " work; I'm not sure why.
    normal k$
    " Find the next occurence of the variable
    exec '/\<' . @a . '\>'
    " Replace that occurence with the text we yanked
    exec ':.s/\<' . @a . '\>/' . @b
endfunction

vnoremap <leader>rv :call ExtractVariable()<cr>
nnoremap <leader>ri :call InlineVariable()<cr>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" Open files with <leader>f
" map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
let g:fuf_file_exclude = '\v\~$|\.(pyo|pyc|o|exe|dll|bak|orig|swp)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
map <leader>ff :FufFile<cr>
map <leader>fc :CommandT<cr>
map <leader>fb :CommandTBuffer<cr>
nnoremap <leader><leader> <C-^>
nnoremap <leader>ww <C-w><C-w>
nnoremap <leader>wv <C-w><C-v>
nnoremap <leader>wh :split<cr>
nnoremap <leader>n <C-n>
nnoremap <leader>t :tnext<cr>
map <leader>2t :set tabstop=2 shiftwidth=2 softtabstop=2<cr>
map <leader>4t :set tabstop=4 shiftwidth=4 softtabstop=4<cr>

nnoremap <S-Tab> :bnext<cr>:redraw<cr>:ls<cr>

"set pastetoggle=<leader>v     "turn paste mode on and off with <leader>v
imap <leader>v <C-O>:set paste<CR><C-r>*<C-O>:set nopaste<CR>
au! BufNewFile,BufRead *.coffee setf coffee
au! BufNewFile,BufRead Cakefile setf coffee
au! BufNewFile,BufRead *.mustache setf html
au! BufNewFile,BufRead *.json setf javascript
au! BufNewFile,BufRead *.eco setf html
au! BufNewFile,BufRead *.jade setf jade
au! BufNewFile,BufRead *.handlebars setf handlebars

highlight ColorColumn ctermbg=gray ctermfg=black

" Show trailing whitespace:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Strip trailing whitespace on save
autocmd BufWritePre *.rb,*.py :%s/\s\+$//e
