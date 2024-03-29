filetype on  " Automatically detect file types.
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
set nocompatible  " We don't want vi compatibility.

call pathogen#helptags()
execute pathogen#infect('bundle/{}')

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

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
set wildignore+=bower_components/**,node_modules/**,tmp/**
let g:fuf_file_exclude = '\v\~$|\.(pyo|pyc|o|exe|dll|bak|orig|swp)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
nmap <leader>ff :FufFile<cr>
nmap <leader>fc :CtrlP<cr>
nmap <leader>fb :CtrlPBuffer<cr>
nnoremap <leader><leader> <C-^>
nnoremap <leader>ww <C-w><C-w>
nnoremap <leader>wv <C-w><C-v>
nnoremap <leader>wh :split<cr>
nnoremap <leader>n <C-n>
nnoremap <leader>t :tnext<cr>
nmap <leader>2t :set tabstop=2 shiftwidth=2 softtabstop=2<cr>
nmap <leader>4t :set tabstop=4 shiftwidth=4 softtabstop=4<cr>

nnoremap <S-Tab> :bnext<cr>:redraw<cr>:ls<cr>

"set pastetoggle=<leader>v     "turn paste mode on and off with <leader>v
"imap <leader>v <C-O>:set paste<CR><C-r>*<C-O>:set nopaste<CR>
au! BufNewFile,BufRead *.json setf javascript
au! BufRead,BufNewFile *.ex,*.exs set filetype=elixir
au! BufRead,BufNewFile *.go, set noexpandtab
au! BufRead,BufNewFile *.groovy, set noexpandtab
au! FileType elixir setl sw=2 sts=2 et iskeyword+=!,?

highlight ColorColumn ctermbg=gray ctermfg=black

" Show trailing whitespace:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" Strip trailing whitespace on save
autocmd BufWritePre *.rb,*.py,*.js,*.coffee,*.go,*.scss,*.css :%s/\s\+$//e

let g:ale_python_flake8_options = "--ignore=E501"
