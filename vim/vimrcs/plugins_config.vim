"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Important:
"       This requries that you install https://github.com/amix/vimrc !
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""""""""""""""""""""""""""""""
" => Load pathogen paths
""""""""""""""""""""""""""""""
call pathogen#infect('~/.vim/plugins_git')
call pathogen#infect('~/.vim/plugins_nogit')
call pathogen#helptags()

""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>


"" """"""""""""""""""""""""""""""
"" " => YankRing
"" """"""""""""""""""""""""""""""
"" if has("win16") || has("win32")
""     " Don't do anything
"" else
""     let g:yankring_history_dir = '~/.vim/temp_dirs/'
"" endif


""""""""""""""""""""""""""""""
" => CTRL-P
""""""""""""""""""""""""""""""
let g:ctrlp_working_path_mode = 0

"" let g:ctrlp_map = '<c-f>'
"" map <c-b> :CtrlPBuffer<cr>

let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'


""""""""""""""""""""""""""""""
" => snipMate (beside <TAB> support <CTRL-j>)
""""""""""""""""""""""""""""""
ino <c-j> <c-r>=snipMate#TriggerSnippet()<cr>
snor <c-j> <esc>i<right><c-r>=snipMate#TriggerSnippet()<cr>


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Nerd Tree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>

function! TNERDTree()
    NERDTreeToggle
    TbToggle
endfunction

map <F4> :call TNERDTree()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => TabBar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <F5> :TbToggle<CR>
map <S-F5> :TbAup<CR>
let g:Tb_SplitBelow     = 0
let g:Tb_VSplit         = 1
let g:Tb_MinSize        = 30
let g:Tb_MaxSize        = 30
let g:Tb_AutoUpdt       = 1
let g:Tb_UseSingleClick = 1
let g:Tb_MoreThanOne    = 2
let s:thisBufMod        = 0
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

autocmd  BufWritePost       * TbAup

autocmd! InsertChange       * TbAup
autocmd! InsertLeave        * TbAup
autocmd! CursorHold         * TbAup
autocmd! CursorHoldI        * TbAup
autocmd! CursorMoved        * :call CheckModified()
autocmd! CursorMovedI       * :call CheckModified()
autocmd! StdinReadPost      * TbAup

"autocmd! BufReadPre         * TbStop
"autocmd! BufReadPost        * TbStart

autocmd! VimEnter           * wincmd l
autocmd! VimLeave           * TbStop

"autocmd! VimEnter           * :call GlobalOptions#SetWindowLocal('scrolloff', 7)       " Complementary to so=7 in basic.vim, but for tabbar (does not appear to work, per Jerias)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => surround.vim config
" Annotate strings with gettext http://amix.dk/blog/post/19678
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap Si S(i_<esc>f)
au FileType mako vmap Si S"i${ _(<esc>2f"a) }<esc>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => AirLine
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline#extensions#tabline#enabled = 0
let g:airline_powerline_fonts = 0
" unicode symbols
let g:airline_symbols = {}
if has("gui_running")
    let g:airline_left_sep = '▶'
    let g:airline_right_sep = '◀'
    let g:airline_symbols.linenr = '␊'
    let g:airline_symbols.branch = '⎇'
    "let g:airline_symbols.paste = 'ρ'
    "let g:airline_symbols.whitespace = 'Ξ'
endif

"let g:airline_theme=
set showtabline=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Powerline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if has("gui_running")
"    "let g:Powerline_symbols = 'unicode'
"    let g:Powerline_symbols = 'fancy'
"else
""    let g:Powerline_symbols = 'unicode'
"    let g:Powerline_symbols = 'compatible'
"endif
""    let g:Powerline_symbols = 'fancy'
"
"call Pl#Theme#RemoveSegment('fileencoding')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Indent guide
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:indent_guides_enable_on_vim_startup=1
"Override the defaults below - applicable if the line above is active. This provides colorful
"markation for spaces at the beginning of the line to highlight lines at same indentation level.
"""let g:indent_guides_auto_colors = 0
"""autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#151515 ctermbg=black
"""autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#111111 ctermbg=darkgrey
