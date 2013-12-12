"source ~/.vimrc    - This is automatically sourced

set guifont=Liberation\ Mono\ 10
"set guifont=ProggyCleanTTSZBP\ 13
"set guifont=Anonymous\ Pro\ 11

colo ir_white

" Enable/Disable highlighting of the line   where the cursor is at using the style/color set via 'Highlight CursorLine ...' command
" Enable/Disable highlighting of the column where the cursor is at using the style/color set via 'Highlight CursorColumn ...' command
set cursorline
"set cursorcolumn

" Always start vim GUI (gvim) at 50 wide x 120 high character size
set lines=75
set columns=160

setlocal foldmethod=expr

set showtabline=1    " This needs to be enabled if NERDtree and buffer explorer are used, because TAB's are not needed
":set guioptions-=m  " Remove menu bar of gvim
":set guioptions-=T  " Remove toolbar of gvim
":set guioptions-=r  " Remove right-hand scroll bar

"------------------------------------------------------------------------------
" set up tab labels with tab number, buffer name, number of windows
function! GuiTabLabel()
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)

  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor

  " Append the tab number
  let label .= tabpagenr().': '

  " Append the buffer name
  let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if name == ''
    " give a name to no-name documents
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    " get only the file name
    let name = fnamemodify(name,":t")
  endif
  let label .= name

  " Append the number of windows in the tab page
  let wincount = tabpagewinnr(v:lnum, '$')
  return label . '  [' . wincount . ']'
endfunction

" set up tab tooltips with every buffer name
function! GuiTabToolTip()
  let tip = ''
  let bufnrlist = tabpagebuflist(v:lnum)

  for bufnr in bufnrlist
    " separate buffer entries
    if tip!=''
      let tip .= ' | '
    endif

    " Add name of buffer
    let name=bufname(bufnr)
    if name == ''
      " give a name to no name documents
      if getbufvar(bufnr,'&buftype')=='quickfix'
        let name = '[Quickfix List]'
      else
        let name = '[No Name]'
      endif
    endif
    let tip.=name

    " add modified/modifiable flags
    if getbufvar(bufnr, "&modified")
      let tip .= ' [+]'
    endif
    if getbufvar(bufnr, "&modifiable")==0
      let tip .= ' [-]'
    endif
  endfor

  return tip
endfunction

" Got this from Alex Marschner on March 15, 2010.
" Disable display of the first letter of directories in gvim tabs for open file
" by setting guitablabel to what is shown below.
"set guitablabel=%!expand(\"\%:t\")

set guitablabel=%{GuiTabLabel()}
set guitabtooltip=%{GuiTabToolTip()}
