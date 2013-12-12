set dir=$HOME/.vim/my_dirs/swp                  " vim saves 'lock' files here
set backupdir=$HOME/.vim/my_dirs/bkup           " vim saves backup of files, if created, here
set undodir=$HOME/.vim/my_dirs/undodir          " ???
set undofile                                    " ???
set undolevels=1000                             " Maximum number of changes that can be undone
set undoreload=10000                            " Maximum number lines to save for undo on a buffer reload

" Tell vim to remember certain things when we exit
"  '20  :  marks will be remembered for up to 20 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :25  :  up to 25 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
"set viminfo='20,\"100,:25,%,n~/.vim/my_dirs/viminfo
set viminfo='20,\"100,:25,n~/.vim/my_dirs/viminfo

" Remember where in the buffer the cursor line was at after loading the same buffer into the new vim.
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" The only reason for the following guifont line is because of gvim on windows, because it sources this file.
" gvim on linux has its own rc file, ~/.gvimrc, where a font line exists for it.
" Since Windows and Linux gvim require different font settings, this is one way to solve the problem.
" vim does not use the following font solution.
"set guifont=ProggyCleanTTSZBP\ 12
"set guifont=ProggyCleanTTSZBP:h12
set guifont=Liberation\ Mono\ 10

set t_Co=256

" The following is what provides colorization (on a terminal?)
if &t_Co > 2 || has("gui_running")
   syntax on
   set hlsearch
endif

colo ir_white                               " Set color management to be light color background based profile (~/.vim/color/ir_white.vim)

set wrap!                                   " Make sure long lines are not wrapped: wrap!
"noremap j gj                                                                                    " Help navigate long lines when wrapped. TODO: Test this
"noremap k gk                                                                                    " Help navigate long lines when wrapped. TODO: Test this
"nnoremap <M-8> :set invhls<CR>:exec "let @/='\\<".expand("<cword>")."\\>'"<CR>/<BS>             " Help navigate long lines when wrapped. TODO: Test this
"nnoremap <F10> :set invhls<CR>:exec "let @/='\\<".expand("<cword>")."\\>'"<CR>/<BS>             " Help navigate long lines when wrapped. TODO: Test this
"set wrap linebreak textwidth=0                                                                  " Help navigate long lines when wrapped. TODO: Test this

set incsearch                               " Turn on incremental search

:set number                                 " Display line numbers


"------------------------------------------------------------------------------------------
"------------------------------------------------------------------------------------------
"------------------------------------------------------------------------------------------
filetype indent on                          " Hitting '=' in non-insert mode (regular or visual) indents comments the same way. Same thing with hitting '=='.

" When '#' is typed on a new line as the first character, the following remapping insures
" that it is indented relative to the previous line just like a non-# character is hit.
" The default behavior is without this remapping, i.e. hitting # on a new line as the first
" character to enter always moves that character to column 1.
" Note that ^H is entered using Ctrl+V Ctrl+H (lower case - don't use shift key)
" http://stackoverflow.com/questions/385327/what-setting-in-vim-counteracts-smartindents-refusal-to-indent-comments-in-she
"set smartindent                             " This does not seem to have any effect
"set cindent                                 " Messes up indendentation
"set autoindent                              " May mess up (did not try)
inoremap # X#

set bs=indent,eol,start                     " allow backspacing over everything in insert mode

" TAB management - All these operations are for new TAB characters inserted into the file under edit.
"set noet                                    " set noexpandtab   (Insert the newly inserted TAB's as tab's, as opposed to replacing it with spaces)
set et                                      " set expandtab     (Expand new TAB characters into spaces. How many? That's determined by ts)
set ts=4                                    " set tabstop       (Sets how many space-width will be used for every (new) TAB added to a file)
set sts=4                                   " set softtabstop   (Makes the spaces feel like real tabs)
autocmd FileType make setlocal noexpandtab  " When editing Makefile's (files of type 'make'), do not automatically expand new TAB chars into spaces, i.e. declare an exception to 'set et'.
"autocmd VimEnter * tab all
"autocmd BufAdd * exe 'tablast | tabe "' . expand( "<afile").'"'

set ai                                      " Always auto indent
set sw=4                                    " TODO: What is this for?
set nu                                      " TODO: What is this for?
set sta                                     " TODO: What is this for?
set sr                                      " TODO: What is this for?
set si                                      " TODO: What is this for?

set pastetoggle=<F12>                       " Toggle between ':set paste' and ':set nopaste'.  Pasting mouse-selected multi-line text appears staggered in 'nopaste' mode. Hit F12, then paste to prevent that.

nmap <C-i> i_<Esc>r                         " Maps control-i to single caracter insertion


"------------------------------------------------------------------------------------------
"------------------------------------------------------------------------------------------
"------------------------------------------------------------------------------------------
" Add toggling function to turn on/off the display of tree while performing the opposite action
" on the tabbar (Tb). The two do not play nice with each other. Also, .gvimrc should include (set showtabline=1).
"
" If using gtab to open up new files from linux command prompt that opens tab as a new tab on
" an already running gvim (server) window or on a new window, stop using it. Instead, create
" 'gbuf' where new tab creation is not happening. Let tabbar (Tb..) handle the navigation of
" files that are open through its intuitive vertical window.
"
" What makes this possible are the following files:
"   ~/.vim/plugin/NERD_tree.vim
"   ~/.vim/plugin/genutils.vim
"   ~/.vim/plugin/minibufexpl.vim
function TNERDTree()
    NERDTreeToggle
    TbToggle
endfunction

map <F4> :call TNERDTree()<CR>

map <F5> :TbToggle<CR>
map <S-F5> :TbAup<CR>
let g:Tb_SplitBelow     = 0
let g:Tb_VSplit         = 1
let g:Tb_MinSize        = 35
let g:Tb_MaxSize        = 35
let g:Tb_AutoUpdt       = 1
"let g:Tb_UseSingleClick = 1

"--------------------------------------------------------------------------------
function! SetWindowName()
    let filename        =expand("%:t")
    let filepath        =expand("%:p")
    let mypwd           =expand("%:{getcwd()}")
    let modified        ="%M"
    let viewname        =substitute(filepath, "\/2510_fpga\/\.\*", "", 0)
    let viewname        =substitute(viewname, "\.\*\/", "", 0)
    let myfilepath      =substitute(filepath, "\/net\/nfs\/atlantic", "", 0)
    if viewname == filename
        let &titlestring    =modified . v:servername . " - " . myfilepath
    else
        let &titlestring    =modified . v:servername . " - <" . viewname . "> - " . myfilepath
    endif
endfunction

"--------------------------------------------------------------------------------
let s:thisBufMod=0
function! CheckModified()
    if &modified
        if s:thisBufMod == 0
            TbAup
            let s:thisBufMod=1
            "echo s:thisBufMod
        endif
    else
        if s:thisBufMod == 1
            TbAup
            let s:thisBufMod=0
            "echo s:thisBufMod
        endif
    endif
endfunction

"------------------------------------------------------------------------------------------
" Trim trailing spaces (at the end of each line) and replace existing TAB's in the entire file with 4 spaces.
function CleanUp()
    if &fileformat != "unix"    " Force UNIX file format (I guess for new files?)
        silent! e ++ff=unix
        " For some reason the ff=unix stuff above is disabling syntax highlighting
        silent! syntax on
    endif
    silent! %s/\r//g            " Remove DOS line feeds so that file is saved in unix format
    if &filetype != "make"
        silent! %s/\t/    /g    " Replaces tab's with 4 spaces. Don't do this on Makefile's
    endif
    silent! %s/\s\+$//          " Remove trailing spaces at the end of lines
endfunction

"------------------------------------------------------------------------------------------
" Set up some auto-updating (End of ~/.vim/plugin/tabbar.vim is quite informative - Read it)
"autocmd! BufWinEnter        *       call SetWindowName()
autocmd! BufEnter           *       call SetWindowName()

autocmd! BufWrite           *       call CleanUp()              " On save, call this function.
autocmd  BufWritePost       *       TbAup
autocmd! BufRead,BufNewFile *.sv    set filetype=verilog
autocmd! FileType                   make setlocal noexpandtab

autocmd! InsertChange       *       TbAup
autocmd! InsertLeave        *       TbAup
autocmd! CursorHold         *       TbAup
autocmd! CursorHoldI        *       TbAup
autocmd! CursorMoved        *       :call CheckModified()
autocmd! CursorMovedI       *       :call CheckModified()
autocmd! StdinReadPost      *       TbAup

"------------------------------------------------------------------------------------------
" Clearcase macros
" Add a function to be able to call 'ctdiff' from inside vim
" In order to use it, type
"    :call Ctdiff()       (Equivalent to running 'ctdiff file1' on bash prompt
"    :call Ctdiff("pre")  (Equivalent to running 'ctdiff -pre file1' on bash prompt
" or use the assigned shortcut keys (see noremap's after the function definition)
" This works only if you have 'ctdiff' in your path.
" As of Oct 7, 2010, it is available in /tools/rational/clearcase/user_scripts/.
"
" I'm not sure if the following file is necessary in order to have the ct functionality:
"   ~/.vim/plugin/ctdiff.vim
" 2013.01 - Switched to git: function Ctdiff(...)
" 2013.01 - Switched to git:     let cmd = exists("a:1") ? a:1 : ''
" 2013.01 - Switched to git:     let fname = bufname("%")
" 2013.01 - Switched to git:     if fname == ""
" 2013.01 - Switched to git:         echom "Buffer has no file name, can not do a ct diff"
" 2013.01 - Switched to git:         return
" 2013.01 - Switched to git:     endif
" 2013.01 - Switched to git:
" 2013.01 - Switched to git:     if cmd == ''
" 2013.01 - Switched to git:         let diff = system("ctdiff " . fname . "&")
" 2013.01 - Switched to git:     end
" 2013.01 - Switched to git:
" 2013.01 - Switched to git:     if cmd == 'pre'
" 2013.01 - Switched to git:         let diff = system("ctdiff -pre " . fname . "&")
" 2013.01 - Switched to git:     end
" 2013.01 - Switched to git: endfunction
" 2013.01 - Switched to git:
" 2013.01 - Switched to git: function CCCheckOut(comment,res)
" 2013.01 - Switched to git:     let s:comment=a:comment
" 2013.01 - Switched to git:     ! cleartool co -unres -c s:comment %
" 2013.01 - Switched to git: endfunction
" 2013.01 - Switched to git:
" 2013.01 - Switched to git: " Assign shortcut keys to the Ctdiff function
" 2013.01 - Switched to git: noremap <F1> :call Ctdiff("pre")<CR>
" 2013.01 - Switched to git: noremap <F2> :call Ctdiff()<CR>
" 2013.01 - Switched to git: map     <F3> :call CCCheckOut('debug','unres')<CR>

"------------------------------------------------------------------------------------------
" Git macros
function! GitDiff()
    exe '!git diff % 2>&1'
endfunction
map <F2> :call GitDiff()<CR>

"------------------------------------------------------------------------------------------
function! <SID>FindWindow(bufName, doDebug)
  " Try to find an existing window that contains our buffer.
  let l:bufNum = bufnr(a:bufName)
  if l:bufNum != -1
    let l:winNum = bufwinnr(l:bufNum)
  else
    let l:winNum = -1
  endif

  return l:winNum

endfunction

"------------------------------------------------------------------------------------------
" Session management
nmap <C-F12> <ESC>:call LoadSession()<CR>
nmap <C-F11> <ESC>:call SaveSession()<CR>
nmap <C-F10> <ESC>:call GetSessionName()<CR>

" don't store any options in sessions
if version >= 700
    set sessionoptions=blank,buffers,curdir,tabpages,winpos,folds
endif

" automatically update session, if loaded
let s:sessionloaded = 0
let s:sessionName = ""
function! LoadSession()
    echo "Loading Session..."
    if s:sessionName == ""
        echo "No session name set"
        call GetSessionName()
    endif

    let l:winNum = <SID>FindWindow('-TabBar-', 1)
    TbStop

    execute "source ".s:sessionName
    let s:sessionloaded = 1
    if l:winNum != -1
        TbStart
    endif
    echo "Loaded session:".s:sessionName
endfunction

function! SaveSession()
    echo "Saving Session..."
    if s:sessionName == ""
        echo "No session name set"
        call GetSessionName()
    endif

    " Close minibufexplorer
    let l:winNum = <SID>FindWindow('-TabBar-', 1)
    TbStop
    execute "mksession! ".s:sessionName
    if l:winNum != -1
        TbStart
    endif
    echo "Saving session:".s:sessionName
endfunction

function! GetSessionName()
    let curline = getline('.')
    call inputsave()
    let s:sessionName = input('Enter Session Name: ')
    call inputrestore()
    let s:sessionName = $HOME."/.vim/my_dirs/sessions/".s:sessionName
    echo "Session is :".s:sessionName
endfunction

function! SaveSessionOnClose()
    if s:sessionName == ""
        let s:sessionName = $HOME."/.vim/my_dirs/sessions/"."lastsession"
    endif
    call SaveSession()
endfunction

autocmd VimLeave * call SaveSessionOnClose()
