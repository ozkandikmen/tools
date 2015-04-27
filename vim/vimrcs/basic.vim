"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Amir Salihefendic
"       http://amix.dk - amix@amix.dk
"
" Version:
"       5.0 - 29/05/12 15:43:36
"
" Blog_post:
"       http://amix.dk/blog/post/19691#The-ultimate-Vim-configuration-on-Github
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Syntax_highlighted:
"       http://amix.dk/vim/vimrc.html
"
" Raw_version:
"       http://amix.dk/vim/vimrc.txt
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Fonts, menu
"    -> Swaps, backups and undo
"    -> Tab insertion and indent related
"    -> Visual mode related
"    -> Moving around, tabs, windows and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let vimdir=".vim"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Sets how many lines of history VIM has to remember
set history=700

" Enable filetype plugins
filetype plugin on
filetype indent on          "hitting '=' in normal or visual mode indents the current line with respect to previous line. Similar with '=='.

" Set to auto read when a file is changed from the outside
"set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k (to achieve the effect of 'Ctrl+E/Ctrl+Y'
"set so=7

" Turn on the WiLd menu
set wildmenu

" Make tab completion more sane (similar to bash). Useful when doing things like ':e ...' to open new files.
set wildmode=longest:full,full

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"Always show current cursor position on the status bar, bottom right (The plugin airline, if activated, overrides this with its own version)
set ruler

" Height of the command bar
set cmdheight=2

" display incomplete commands
set showcmd

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act, i.e. backspace over everything in insert mode
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" See http://vim.wikia.com/wiki/Folding
"setlocal foldmethod=expr       " Carried over from pre-April, 2015 vimrc

" Add a bit extra margin to the left
set foldcolumn=0

" Display line numbers
set number

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fonts, menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set extra options when running in GUI mode
if &t_Co > 2 || has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" This appears to be necessary because the plugins nerd tree and tabbar do not play nice with each other without it
set showtabline=1

if has("gui_running")
    if has("win16") || has("win32") || has("win64")
        set guifont=Courier_New:h11
    elseif $USER == "root"
        set guifont=Monospace\ 12
    else
        "set guifont=ProggyCleanTTSZBP\ 12
        "set guifont=ProggyCleanTTSZBP:h12
        set guifont=Liberation\ Mono\ 10
    endif

    " Set size of window on startup
    set lines=75
    set columns=160

    " Simplify GUI by removing:
    set guioptions-=m   "menu bar
    set guioptions-=T   "toolbar
    set guioptions-=r   "right-hand scrollbar
    set guioptions-=L   "left-hand scrollbar
    set guioptions-=R   "???
    set guioptions-=l   "???

    " Ctrl+F1|F2|F3: Shortcuts for toggling the display of menu bar, toolbar, right hand scrollbar
    nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
    nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
    nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

    " Bring up horizontal scroll bar if line wrap is disabled, or hide it if line wrap is enabled
    nnoremap <silent><expr> <f2> ':set wrap! go'.'-+'[&wrap]."=b\r"

    " Horizontal scroll bindings (Alt-l|h: 1 column at a time;  Alt-L|H: min(80,column-length-of-line) column at a time)
    map <M-l> zl
    map <M-L> zL
    map <M-h> zh
    map <M-H> zH
else
    if has("mac") || has("macunix")
        set guifont=Menlo:h14
        set shell=/bin/bash
    elseif has("win16") || has("win32") || has("win64")
        set guifont=Bitstream\ Vera\ Sans\ Mono:h10
    else
        set guifont=Monospace\ 10
        set shell=/bin/bash
    endif
endif

" Open MacVim in fullscreen mode
if has("gui_macvim")
    set fuoptions=maxvert,maxhorz
    au GUIEnter * set fullscreen
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Swap, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set dir=$HOME/.vim/temp_dirs/swp

    set backupdir=$HOME/.vim/temp_dirs/bkup
    set backup

    " Turn persistent undo on - means that you can undo even when you close a buffer/VIM
    set undodir=$HOME/.vim/temp_dirs/undodir
    set undofile
    set undolevels=1000     "maximum number of changes that can be undone
    set undoreload=10000    "maximum number lines to save for undo on a buffer reload

    " Tell vim to remember certain things when we exit
    "  '10  :  marks will be remembered for up to 10 previously edited files
    "  "100 :  will save up to 100 lines for each register
    "  :20  :  up to 20 lines of command-line history will be remembered
    "  %    :  saves and restores the buffer list
    "  n... :  where to save the viminfo files
    "set viminfo='20,\"100,:20,%,n$HOME/.vim/temp_dirs/viminfo
    set viminfo='20,\"100,:20,n$HOME/.vim/temp_dirs/viminfo
    " Remember info about open buffers on close
    "set viminfo^=%
catch
    "TODO: Quit vim if here - execute "normal! \<C-q>"
endtry

" Most Recently Used. What is the following line for?
let MRU_File = expand("$HOME/.vim/temp_dirs/vim_mru_files")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tab insertion and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab       " vim inserts 'softtabstop' amount of space characters when you press TAB

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4    " affects what happens wehn you press >>, <<, or ==
set softtabstop=4   " makes the spaces feel like real tabs (http://vim.wikia.com/wiki/Indenting_source_code)
set tabstop=4       " width of TAB character

" Display of text (If you want 'proper' wrapped line display, use 'wrap' and enable linebreak/nolist lines)
set wrap!           " Do not display lines wrapped
"set linebreak      " tell vim to only wrap at a character in the 'breakat' option (by default, this includes " !@*-+;:./?")
"set nolist         " list disables linebreak

" Prevent vim from automatically entering in line breaks in newly entered text (until column position 500. It's 78 by default)
set textwidth=500
"set textwidth=0
"set wrapmargin=0

" More on indentation
set autoindent      " copy indentation from the previous line, when starting a new line
set smartindent

" Carried over the following into this file in April, 2015, after adapting the new vimrc files from Jerias. So, not sure if this is necessary or does something useful.
" When '#' is typed on a new line as the first character, the following remapping insures
" that it is indented relative to the previous line just like a non-# character is hit.
" The default behavior is without this remapping, i.e. hitting # on a new line as the first
" character to enter always moves that character to column 1.
" Note that ^H is entered using Ctrl+v Ctrl+h
" http://stackoverflow.com/questions/385327/what-setting-in-vim-counteracts-smartindents-refusal-to-indent-comments-in-she
inoremap # X#


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Stops resetting cursor to begining of line when saving or switching buffers
set nostartofline

" Enable mouse mode in console
" Make sure mouse scroll (up/down) with its wheel has the effect of pressing Ctrl+e/y (move up/down in the buffer being viewed) in vim's running on console.
" This also makes mouse left clicks move the cursor to the clicked spot, again in vim's running on console.
if has('mouse')
    set mouse=a
endif

" Map an to switch to viewing the next buffer. The order of the buffers are as it appears in the window frame on the left)
map an :bn<CR>
map ap :bp<CR>


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ %l/%L,%c%V
"set statusline=\ %m%r%{HasPaste()}%F%h\ %w\ %=[%{&ff}]\ %04l/%04L,%03c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

""  Remap alt-e to go to end of previous word
if has("gui_running")
    nnoremap <m-e> ge
    nnoremap <m-E> gE
else
    nnoremap e ge
    nnoremap E gE
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vimgrep searching and cope displaying
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>

" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgreps in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Do :help cope if you are unsure what cope is. It's super useful!
"
" When you search with vimgrep, display your results in cope by doing:
"   <leader>cc
"
" To go to the next search result do:
"   <leader>n
"
" To go to the previous search results do:
"   <leader>p
"
map <leader>cc :botright cope<cr>
map <leader>co ggVGy:tabnew<cr>:set syntax=qf<cr>pgg
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows  - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scripbble
map <leader>q :e ~/buffer<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>
"set pastetoggle=<F12>          " Toggle between ':set paste' and ':set nopaste'.  Pasting mouse-selected multi-line text appears staggered in 'nopaste' mode. Hit F12, then paste to prevent that.

"Maps control-i to single character insertion
nmap <C-i> i_<Esc>r

" Select word - paste buffer - copy word back into buffer
nnoremap <silent> <M-p> vepbye

"nnoremap <F10> :set invhls<CR>:exec "let @/='\\<".expand("<cword>")."\\>'"<CR>/<BS>
"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.' . a:extra_filter)
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction
