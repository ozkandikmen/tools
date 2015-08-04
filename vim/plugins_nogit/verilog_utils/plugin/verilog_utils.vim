" Original version copied from http://www.vim.org/scripts/script.php?script_id=4151 (ver 1.4)

" vimscript the hard way - a very helpful web site for teaching vimscripting
"   http://learnvimscriptthehardway.stevelosh.com
" Type ':help max()' where max() is the function you want to get help on
"             \@     where \@ is the operation you want to get help on

" Note: Multi line comments (/* ... */) in the middle of a code line followed by more code on the same line are NOT ignored.
"       In fact, it may interfere with the simplistic parsing of such lines going on in this file. If such commentary looking
"       entries are indeed for synthesis tool, expand this parser to handle such cases properly. If they are just regular comments
"       please update such code to place those comments to the end of the line.
"       Remember that emacs verilog-mode does use such comments that occasionally could be in the middle of a code line.
"       Some example such comment looking directives are:  /*AUTOARGS*/, /*AUTOINST*/, /*AUTO_TEMPLATE*/
"               AUTOINPUT, AUTOOUTPUT, AUTOINOUT        appears when defining module interface/signature
"               AUTOWIRE                                appears when defining internal wires within a module
"              *AUTO_TEMPLATE
"               AUTOINSTPARAM
"               AUTOINST
"
"       In all these cases, every single one of these directives, once expanded, end with the following line
"               // End of automatics
"
"       AUTO_TEMPLATE is a bit different than the others. It appears in the context of determining what wire
"       names should be used, if any specified, as the instance of a module whose name is specified right
"       before AUTO_TEMPLATE is created.
"               /* my_favorite_module AUTO_TEMPLATE (
"                .inp1 (my_name1),
"                .inp2 (1'b0),
"                .inp_data_\(.+\) (my_inp_dataname_\1[@"(- (* (+ 3 1) (string-to-number vl-width)) 1)":@"(* 0 (string-to-number vl-width))"])
"                );
"                */
"               my_favorite_module
"               #(/*AUTOINSTPARAM*/
"                   .
"                   .
"               )
"               my_favorite_inst
"               (/*AUTOINST*/
"                   .
"                   .
"               );
"       Find elisp interpreter in vimscript, and use it to interpret the statement above.

" TODO: Use /*AUTO_TEMPLATE .../*, specified for emacs verilog-mode, and provide proper instantiation
"       of the referenced module. The addition to the existing functionality is to obviously parse
"       such an AUTO_TEMPLATE directive. The rest of the puzzle is already available, i.e. we can already
"       locate the file containing the implementation of the module under the cursor (<leader>f invokes that),
"       and we can generate an instantiation of a module defined in a file (<leader>g invokes that) albeit
"       using same names for the connectivity as the port names themselves. What needs to be done is to
"       update the connectivity to what is in AUTO_TEMPLATE, if matching entries exist, otherwise leave it alone.
"       Remember that the "output" of invoking <leader>g is in vim's scratch buffer (could be in global buffer
"       as well, accessed as @+). Two last pieces:
"       - The connection wires do need to be defined (pretty straightforward).
"         Produce all required declarations for each of the connected lines and let user delete the duplicate ones.
"       - The default parameter values are used in the returned "output" of invoking <leader>g, which
"         need to be updated if there are matching entries in AUTO_TEMPLATE
"       This would be a primitive version of what emacs verilog-mode does. Since verilog-mode uses a
"       true verilog parser (lexer & grammar) under the hood, though, such a vim implementation will never
"       be as accurate as that one.

" TODO: Remove or modify Locate_Inst_Position. It's a primitive way of locating the instantiation of the
"       module implemented in the current file by searching the current file from its line no 1 until the
"       implementation of that module (line containing 'module ...'), which obviously is not as useful.
"       Primary reason is that the modern convention defines/implements only one module per file.
"       Secondly, this function relies on locating its own comments when such an instance is created to
"       begin with, which obviously very error prone.
"       What it can be morphed into, though, is to locate all module instantiations in a file whose
"       implementation is in some other file(s), and automatically update them based on their latest
"       implementation (the work described above for one instantiation, corresponding to the module
"       instantiation under the cursor, needs to be invoked for each instantiation of a module detected
"       in the current file).

" TODO: Consider removing support for handling more than one module being implemented in a single file.


if exists('b:verilog_utils') || &cp || version < 700
    finish
endif
let b:verilog_utils = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"       Key-Mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command     VlogInstGen     :call Vlog_Inst_Gen()
command     VlogInstMod     :call Vlog_Inst_Gen_Mode_Change()
command     VlogModOpen     :call Vlog_Module_Open()
if maparg("<leader>g") != ""
    silent! unmap <leader>g
endif
if maparg("<leader>m") != ""
    silent! unmap <leader>m
endif
if maparg("<leader>f") != ""
    silent! unmap <leader>f
endif
nmap        <leader>g        :VlogInstGen<CR>
nmap        <leader>m        :VlogInstMod<CR>
nmap        <leader>f        :VlogModOpen<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global Variables & Settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vlog_inst_gen_mode = 0                "default working mode
let g:check_port_declaration = 1
let g:is_copy_inst_to_doublequotation = 1   "copy instance to clickboard so you can use 'p' to paste..

"hi  Vlog_Inst_Gen_Msg_0     gui=bold        guifg=#2E0CED       "lan tai liang
hi  Vlog_Inst_Gen_Msg_0     gui=bold        guifg=#1E56DB       "lan
"hi  Vlog_Inst_Gen_Msg_1     gui=NONE        guifg=#A012BA       "zi
hi  Vlog_Inst_Gen_Msg_1     gui=NONE        guifg=#DB26D2       "fen
"hi  Vlog_Inst_Gen_Msg_1     gui=NONE        guifg=#10E054       "lv


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Clear_Parameter_List
"   Input           : a list
"   Output          : none
"   Return value    : none
"   Description     : clear given list.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Clear_Parameter_List(para_list)
    if empty(a:para_list) == 0
        call remove(a:para_list, 0, -1)
    endif
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Get_Lib_Search_Paths_Line
"   Input           : start_line, end_line
"   Output          : none
"   Return value    : A list, containing library search paths
"   Description     : search current file from a:start_line to a:end_line,
"                     and extract the line that is emacs verilog-mode
"                     compliant listing space separated paths, relative
"                     to the directory containing the current file.
"       Ex:  // verilog-library-directories:("." "sub1" "../sub2")
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Get_Lib_Search_Paths(start_line, end_line)
    " The line we are after normally appears after endmodule, however, we will
    " it anywhere it appears and will only return the first such line
    let cur = a:start_line
    let end_line = a:end_line
    let lib_search_paths = []
    "start search
    while cur <= end_line
        let cur_line_content = getline(cur)
        if cur_line_content =~ '^\s*//\s*verilog-library-directories:(.*")$'
            let cur_line_content = substitute(cur_line_content, '^\s*//\s*verilog-library-directories:(', '', '')   "delete header
            let cur_line_content = substitute(cur_line_content, ')$', '', '')                                       "delete footer
            let cur_line_content = substitute(cur_line_content, '"\s\+"', '","', 'g')                               "substitute space(s) with a single ,
            let lib_search_paths = split(cur_line_content, ",")
            break
        else
            let cur = cur + 1
            continue
        endif
    endw
    "Get rid of the surrounding double quotes as they are interpreted literally, i.e. assumed to be part of the path, but they are not
    let path_num = len(lib_search_paths)     "number of paths
    let ind = 0
    while ind < path_num
        let lib_search_paths[ind] = substitute(lib_search_paths[ind], '"', '', 'g')
        let ind = ind  + 1
    endw
    return lib_search_paths
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Filter_Comment_Lines
"   Input           : start_line, end_line
"   Output          : non_comment_lines
"   Return value    : none
"   Description     : search from a:start_line to a:end_line, filter
"                     out the comment lines, store non_comment lines in
"                     a:non_comment_lines list.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Filter_Comment_Lines(start_line, end_line, non_comment_lines)
    "check and clear non-comment line list
    call <SID>Clear_Parameter_List(a:non_comment_lines)
    let cur = a:start_line
    let end_line = a:end_line
    let mline_comment_flag = 0      "initial multi-line comment flag
    "start search
    while cur <= end_line
        let cur_line_content = getline(cur)
        "In multi-line comment
        if mline_comment_flag
            if cur_line_content =~ '^.*\*/\s*$'     "end of multi-line comment
                let cur = cur + 1
                let mline_comment_flag = 0
                continue
            else
                let cur = cur + 1
                continue
            endif
        "Not in multi-line comment
        else
            if cur_line_content =~ '\(^\s*//.*$\|^\s*/\*.*\*/\s*$\)'    "single line, starting with a comment character, preceeded possibly with spaces
                let cur = cur + 1
                continue
            elseif cur_line_content =~ '^\s*/\*.*$'                     "detect start of mcomment on a line by itself, preceeded possibly with spaces
                let cur = cur + 1
                let mline_comment_flag = 1
                continue
            elseif cur_line_content =~ '^\s*$'                          "remove empty lines
                let cur = cur + 1
                continue
            else                                                        "Non-comment lines
                call add(a:non_comment_lines, cur)
                let cur = cur + 1
                continue
            endif
        endif
    endw
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Search_Module
"   Input           : non_comment_lines
"   Output          : module_info_list
"   Return value    : module_num
"   Description     : search modules from given non_commentlines, and
"       record module location infomation to list.
"   More            :
"       structure of module_info_list:
"               module_start_line   : keyword module appeare line
"               module_declare_line : the first ';' after keyword module
"               module_end_line     : keyword endmodule after module
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Search_Module(non_comment_lines, module_info_list)
    let line_num = len(a:non_comment_lines)     "number of lines
    let module_num = 0
    let i = 0
    "clear module_info_list
    if empty(a:module_info_list) == 0   "if not empty
        call remove(a:module_info_list, 1, -1)
    endif
    "search modules
    let in_module_flag = 0
    let find_declare_flag = 0
    let module_start_line = 0
    let module_declare_line = 0
    let module_end_line = 0
    while i < line_num
        let cur_line = a:non_comment_lines[i]   "get current search line
        let line_content = getline(cur_line)
        "search module start line
        if in_module_flag == 0
            if line_content =~ '^\s*\<module\>.*$'
                let module_start_line = cur_line
                let in_module_flag = 1
                let find_declare_flag = 0
            endif
            "incase declare in the same line
            if in_module_flag == 1
                if find_declare_flag == 0
                    if line_content =~ '^.*;.*$'        "the first semicolon is end of declareation
                        let module_declare_line = cur_line
                        let find_declare_flag = 1
                    endif
                endif
            endif
        "search module declare info and end module info
        else
            if find_declare_flag == 0       "find declare first
                if line_content =~ '^.*);.*$'
                    let module_declare_line = cur_line
                    let find_declare_flag = 1
                endif
            else
                if line_content =~ '^\s*\<endmodule\>\(\s*$\|\s*//.*$\|\s*/\*.*\*/\s*$\)'
                    let module_end_line = cur_line
                    call add(a:module_info_list, [module_start_line, module_declare_line, module_end_line])
                    let module_num = module_num + 1
                    let in_module_flag = 0
                endif
            endif
        endif
        let i = i+1
    endw
    return module_num
endfun




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Line_Pre_Process
"   Input           : a list
"   Output          : none
"   Return value    : none
"   Description     : preprocess given line's content
"       1. delete the spaces at the start of line;
"       2. delete the comment at the end of line;
"       3. delete keyword(reg, wire);
"       "4. delete vector identifier(eg. [7:0], [WIDTH-1:0]..);
"       5. delete attribute specified in verilog-2001(eg. (* keep=1*);
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Line_Pre_Process(line_content)
    let lc = a:line_content
    "del the spaces at the beginning of line
    let lc = substitute(lc, '^\s*', '', '')
    "del comment at the end of line
    let lc = substitute(lc, '\s*\(//.*$\|/\*.*\*/\s*$\)', '', '')
    "del unused keyword: reg wire
    let lc = substitute(lc, '\(\<reg\>\|\<wire\>\)', '', 'g')
    "del vector identifier (eg: [1:0])
    "let lc = substitute(lc, '\[.\{-}\]', '', 'g')
    "del attributes
    let lc = substitute(lc, '(\*.\{-}\*)', '', 'g')
    return lc
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Merge_Module_Head
"   Input           : non_comment_lines, module_num, module_info_list
"   Output          : module_merged_list
"   Return value    : 0     Success         non_0   Error
"   Description     : merge module's head(eg. module xx(i1,i2,..);)
"                     into one line. So, \n's are all eliminated, too.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Merge_Module_Head(non_comment_lines, module_num, module_info_list, module_merged_list)
    "parameter pre process
    call <SID>Clear_Parameter_List(a:module_merged_list)
    "merge module head
    let i = 0
    while i < a:module_num
        "get info
        let line_index = index(a:non_comment_lines, a:module_info_list[i][0])
        let line_index_end = index(a:non_comment_lines, a:module_info_list[i][1])
        "initial variable
        let module_merged_line = ""
        let line_content = ""
        while line_index <= line_index_end
            "get line content
            let line_content = getline(a:non_comment_lines[line_index])
            let line_content = <SID>Line_Pre_Process(line_content)
            let module_merged_line = module_merged_line.line_content
            let line_index = line_index+1
        endw
        "del useless spaces and/or reduce them down to 1
        "   1. spaces after module/parameter/input/output/inout only keep one
        "   1. spaces not after module/parameter/input/output/inout delete all
        "Example:
        "   'module   abc....' will be 'module abc...'
        "          ^           will be left alone because it follows 'module'. Magic is achieved with \(module\)\@<!\s\+  (particularly \@<!), which says any 1 or more spaces (\s\+) not following 'module'.
        "           ^^         will be replaced by ''
        let module_merged_line = substitute(module_merged_line, '\(\<module\>\|\<parameter\>\|\<input\>\|\<output\>\|\<inout\>\)\@<!\s\+', '', 'g')
        "store merged module info
        call add(a:module_merged_list, module_merged_line)
        let i = i+1
        echo "DEBUG: module_merged_line='".module_merged_line."'\n"
    endw
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Analysis_Module_Head
"   Input           : module_num, module_merged_list
"   Output          : module_name, para, vlog_95_flag,
"                       port, port_i, port_o, port_io, max_key_len, max_val_len
"   Return value    : 0     success         1   error
"   Description     : analysis module head from module_merged_list,
"       find the module_name, parameters, verilog_format, port info
"       and store into output list.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Analysis_Module_Head(module_num, module_merged_list, module_name, para, vlog_95_flag, port, port_i, port_o, port_io, max_key_len, max_val_len)
    "initiciate parameters
    call <SID>Clear_Parameter_List(a:module_name)
    call <SID>Clear_Parameter_List(a:para)
    call <SID>Clear_Parameter_List(a:vlog_95_flag)
    call <SID>Clear_Parameter_List(a:port)
    call <SID>Clear_Parameter_List(a:port_i)
    call <SID>Clear_Parameter_List(a:port_o)
    call <SID>Clear_Parameter_List(a:port_io)
    call <SID>Clear_Parameter_List(a:max_key_len)
    call <SID>Clear_Parameter_List(a:max_val_len)
    "begin analysis
    let i = 0
    while i < a:module_num
        let module_head = a:module_merged_list[i]
        let max_key_length_para = 0
        let max_key_length_port = 0
        let max_val_length = 0
        "***********************************************
        "step 1: search module identifier
        "***********************************************
        let mname = ""
        "del key word: module
        if module_head =~ '^\<module\>\s'
            let module_head = substitute(module_head, '^\<module\>\s', '', '')
        else
            return 3            "Error 3: can't find keyword
        endif
        let mname = substitute(module_head, '^[a-zA-Z_][a-zA-Z_0-9]*\zs.*$', '', '')        "get module name
        let module_head = substitute(module_head, '^[a-zA-Z_][a-zA-Z_0-9]*', '', '')       "delete module name
        "add info to list
        call add(a:module_name, mname)
        "***********************************************
        "step 2: judge whether this is a top module
        "***********************************************
        if module_head =~ '^;$'     "end of module
            call add(a:para, [])
            call add(a:vlog_95_flag, 0)
            call add(a:port, [])
            call add(a:port_i, [])
            call add(a:port_o, [])
            call add(a:port_io, [])
            call add(a:max_key_len, 0)
            call add(a:max_val_len, 0)
            let i = i+1
            continue
        endif
        "***********************************************
        "step 3: get parameter info
        "***********************************************
        if module_head =~ '^#(.*$'
            let para_key = ''
            let para_val = ''
            let para_size = ''
            let para_list = []
            let module_head = substitute(module_head, '^#(', '', '')                "del #(
            let module_head = substitute(module_head, '\<parameter\>\s*', '', 'g')  "del keyword: parameter
            while 1
                if module_head =~ '^)'      "parameter fetch end
                    let module_head = substitute(module_head, '^)', '', '')         "del )
                    break
                elseif module_head =~ '^,'  "del ,
                    let module_head = substitute(module_head, '^,', '', '')
                    continue
                elseif module_head =~ '^\[.\{-}\]'                                  "extract parameter size info, if available
                    let para_size = para_size . substitute(module_head, '^\[.\{-}\]\zs.*$', '', '')
                    let module_head = substitute(module_head, '^\[.\{-}\]', '', '')
                    continue
                elseif module_head =~ '^[a-zA-Z_][a-zA-Z0-9_]*=.*[,)]'   "find para
                    let para_key = substitute(module_head, '^[a-zA-Z_][a-zA-Z0-9_]*\zs.*$', '', '')
                    let max_key_length_para = max([strwidth(para_key), max_key_length_para])
                    let module_head = substitute(module_head, '^[a-zA-Z_][a-zA-Z0-9_]*=', '', '')
                    let para_val = substitute(module_head, '^.\{-}\zs[,)].*$', '', '')  "match the first , or )
                    let max_val_length = max([strwidth(para_val), max_val_length])
                    let module_head = substitute(module_head, '^.\{-}\ze[,)]', '', '')
                    call add(para_list, [para_key, para_val, para_size])
                    let para_size = ''
                    continue
                else
                    return 4            "Error 4: when find parameter
                endif
            endw
            call add(a:para, para_list)     "store parameter list
        else        "if has none parameter, then fullfill the position of module in list with empty value
            call add(a:para, [])
        endif
        "***********************************************
        "step 4: judge vlog version 95 or 2001
        "***********************************************
        if module_head =~ '\(\<input\>\|\<output\>\|\<inout\>\)'
            call add(a:vlog_95_flag, 0)
        else
            call add(a:vlog_95_flag, 1)
        endif
        "***********************************************
        "step 5: analysis port
        "***********************************************
        if module_head !~ '^('
            return 5            "Error 5: start of analysis port
        endif
        let module_head = substitute(module_head, '^(', '', '')
        let pid = ''
        let p_dir = 'none'
        let pid_size = ''
        let pid_type = ''
        let p_list = []
        let pi_list = []
        let po_list = []
        let pio_list = []
        while 1
            if module_head =~ '^);'         "end of analysis
                break
            elseif module_head =~ '^,'      "del ,
                let module_head = substitute(module_head, '^,', '', '')
                continue
            elseif module_head =~ '^\(\<input\>\|\<output\>\|\<inout\>\)'       "find port direction
                if module_head =~ '^\<input\>'
                    let p_dir = 'input'
                elseif module_head =~ '^\<output\>'
                    let p_dir = 'output'
                elseif module_head =~ '^\<inout\>'
                    let p_dir = 'inout'
                endif
                let module_head = substitute(module_head, '^\(\<input\>\|\<output\>\|\<inout\>\)\s*', '', '')
                continue
            elseif module_head =~ '^\[.\{-}\]'                                     "extract port size info, if available
                let pid_size = pid_size . substitute(module_head, '^\[.\{-}\]\zs.*$', '', '')
                let module_head = substitute(module_head, '^\[.\{-}\]', '', '')
                continue
            elseif module_head =~ '^\(\<signed\>\)'                                "find port type
                let pid_type = 'signed'
                let module_head = substitute(module_head, '^\(\<signed\>\)\s*', '', '')
                continue
            elseif module_head =~ '^[a-zA-Z_][a-zA-Z0-9_]*[,)]'                    "find port
                let pid = substitute(module_head, '^[a-zA-Z_][a-zA-Z0-9_]*\zs[,)].*$', '', '')
                let module_head = substitute(module_head, '^[a-zA-Z_][a-zA-Z0-9_]*', '', '')
                let max_key_length_port = max([strwidth(pid), max_key_length_port])
                call add(p_list, [pid, p_dir, pid_size, pid_type])
                if p_dir == 'input'
                    call add(pi_list, [pid, pid_size, pid_type])
                elseif p_dir == 'output'
                    call add(po_list, [pid, pid_size, pid_type])
                elseif p_dir == 'inout'
                    call add(pio_list, [pid, pid_size, pid_type])
                endif
                let pid_size = ''
                let pid_type = ''
                continue
            else
                return 6        "Error 6: when analysising port
            endif
        endw
        call add(a:port, p_list)
        call add(a:port_i, pi_list)
        call add(a:port_o, po_list)
        call add(a:port_io, pio_list)
        call add(a:max_key_len, max([max_key_length_para, max_key_length_port]))
        call add(a:max_val_len, max([max_val_length,      max_key_length_port]))
        let i = i+1
    endw
    "check output list
    if          len(a:module_name)      != a:module_num     ||
            \   len(a:para)             != a:module_num     ||
            \   len(a:vlog_95_flag)     != a:module_num     ||
            \   len(a:port)             != a:module_num     ||
            \   len(a:port_i)           != a:module_num     ||
            \   len(a:port_o)           != a:module_num     ||
            \   len(a:port_io)          != a:module_num     ||
            \   len(a:max_key_len)      != a:module_num     ||
            \   len(a:max_val_len)      != a:module_num
        return 7                "Error 7: invalid return value
    endif
    return 0
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Analysis_Module_Body
"   Input           : non_comment_lines, module_num, module_info_list
"                       vlog_95_flag
"   Output          : port_declare
"   Return value    : 0     success         1   error
"   Description     : analysis module body to find port declaration
"                     information, then update them to port io lists.
"   TODO            : Consider extracting 'parameter's from the body
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Analysis_Module_Body(non_comment_lines, module_num, module_info_list, vlog_95_flag, port_declare)
    "initiciate parameters
    call <SID>Clear_Parameter_List(a:port_declare)
    "start analysis
    let i = 0
    while i < a:module_num
        let pid = ''
        let p_dir = 'none'
        let pid_size = ''
        let pid_type = ''
        let p_list = []
        if a:vlog_95_flag[i] == 1   "need analysis
            let line_index = index(a:non_comment_lines, a:module_info_list[i][1])
            let line_index_end = index(a:non_comment_lines, a:module_info_list[i][2])
            while line_index <= line_index_end
                let line_content = getline(a:non_comment_lines[line_index])
                let line_content = <SID>Line_Pre_Process(line_content)          "remove unused parts
                if line_content =~ '^\s*\(\<input\>\|\<output\>\|\<inout\>\)\s*'
                    let line_content = substitute(line_content, '\(\<input\>\|\<output\>\|\<inout\>\)\@<!\s\+', '', 'g') "'remove' spaces (See Merge_Module_Head for comments)
                    if line_content =~ '^\<input\>'
                        let p_dir = 'input'
                    elseif line_content =~ '^\<output\>'
                        let p_dir = 'output'
                    elseif line_content =~ '^\<inout\>'
                        let p_dir = 'inout'
                    else
                        let p_dir = 'none'
                    endif
                    let line_content = substitute(line_content, '^\(\<input\>\|\<output\>\|\<inout\>\)\s*', '', '')
                    while 1
                        if line_content =~ '^;'
                            break
                        elseif line_content =~ '^,'
                            let line_content = substitute(line_content, '^,', '', '')
                            continue
                        elseif line_content =~ '^\[.\{-}\]'
                            let pid_size = pid_size . substitute(line_content, '^\[.\{-}\]\zs.*$', '', '')
                            let line_content = substitute(line_content, '^\[.\{-}\]', '', '')
                            continue
                        elseif line_content =~ '^\(\<signed\>\)'
                            let pid_type = 'signed'
                            let line_content = substitute(line_content, '^\(\<signed\>\)\s*', '', '')
                            continue
                        elseif line_content =~ '^[a-zA-Z_][a-zA-Z0-9_]*[,;]'
                            "get pid
                            let pid = substitute(line_content, '^[a-zA-Z_][a-zA-Z0-9_]*\zs[,;].*$', '', '')
                            "store pid
                            call add(p_list, [pid, p_dir, pid_size, pid_type])
                            "del this pid
                            let line_content = substitute(line_content, '^[a-zA-Z_][a-zA-Z0-9_]*\ze[,;]', '', '')
                            let pid_size = ''
                            let pid_type = ''
                            continue
                        else
                            return 4        "Error 4: when processing port declare line.
                        endif
                    endw
                endif
                let line_index = line_index+1
            endw
        endif
        call add(a:port_declare, p_list)
        let i = i+1
    endw
    "check output list
    if len(a:port_declare) != a:module_num
        return 7                "Error 7: invalid return value
    endif
    return 0
endfun




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   function        : Exists
"   Input           : list, item
"   Output          : none
"   Return value    : 0 if item is not in list, 1 otherwise
"   Description     : list contains one or more of [a, b], and item is
"                     searched in the position of 'a' across all the
"                     elements of list.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Exists(complex_list, item)
    let found = 0
    let ind = 0
    let list_len = len(a:complex_list)
    while ind < list_len
        if a:complex_list[ind][0] == a:item
            let found = 1
            break
        endif
        let ind = ind + 1
    endw
    return found
endfun













""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Locate_Inst_Position
"   Input           : first_module_line
"   Output          : inst_start, inst_end
"   Return value    : 0     success     1   error
"   Description     : find whether there is a instance existing in file,
"       if so, return it's start_line and end_line information; else
"       let start_line and end_line to empty.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Locate_Inst_Position(first_module_line, inst_start, inst_end)
    "init parameter
    call <SID>Clear_Parameter_List(a:inst_start)
    call <SID>Clear_Parameter_List(a:inst_end)
    let line_flag = 0
    let exist_flag = 0
    "search given lines
    let i = 1
    while i < a:first_module_line
        let line_content = getline(i)
        if line_flag == 0       "find none of the inst
            if line_content =~ '/\*\{77}'
                call add(a:inst_start, i)
                let line_flag = 1
            else
                call <SID>Clear_Parameter_List(a:inst_start)
            endif
        elseif line_flag == 1
            if line_content =~ '\*\{14}\s\{5}INST\sGENERATED\sBY\sVLOG_INST_GEN\sPLUGIN\s\{5}\*\{16}'
                let line_flag = 2
            else
                let line_flag = 0
            endif
        elseif line_flag == 2
            if line_content =~ '\*\{78}'
                let line_flag = 3
            else
                let line_flag = 0
            endif
        elseif line_flag == 3
            if line_content =~ '\*\{77}/'
                call add(a:inst_end, i)
                let exist_flag = 1
                break
            endif
        else
            return 1        "unknown flag
        endif
        let i = i+1
    endw
    "return value
    if exist_flag == 1
        if empty(a:inst_start)!=0 || empty(a:inst_end)!=0 || a:inst_start[0]>=a:inst_end[0]
            return 2
        endif
    endif
    return 0
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Inst_Module
"   Input           : module_num, module_name, para_list, port_list, max_key_len, max_val_len
"   Output          : none
"   Return value    : inst_part
"   Description     : generate and return instance from given
"       information.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! <SID>Inst_Module(module_num, module_name, para_list, port_list, max_key_len, max_val_len)
    let inst = ""
    let has_para_flag = 0
    let i = 0
    while i < a:module_num
        "parameter process
        if empty(a:para_list[i])    "has no parameter
            let has_para_flag = 0
            let inst = inst.a:module_name[i]."\nU_".toupper(a:module_name[i])."_0\n(\n"
        else                        "has parameters
            let has_para_flag = 1
            let inst = inst.a:module_name[i]."\n#(\n"
            let list_len = len(a:para_list[i])
            let list_index = 0
            " TODO: Vertically align the text 'default value = ...' across all rows. Do it as a function, and replace the poor man's job in the case of port processing below. Also print port[3] before port[2], however, if port[3] is '' for all entries, do not push port[2] by 7 chars to the right unnecessarily (all 7 would be blank).
            while 1
                let para = a:para_list[i][list_index]
                let line_content = "    .".para[0]
                while strwidth(line_content) < (4 + 1 + a:max_key_len[i] + 1)
                    let line_content = line_content." "
                endw
                let line_content = line_content."(".para[1]
                while strwidth(line_content) < (4 + 1 + a:max_key_len[i] + 1 + 1 + a:max_val_len[i])
                    let line_content = line_content." "
                endw
                if list_index == list_len-1     "the last item
                    let line_content = line_content.")    // size = ".para[2].", default value = ".para[1]."\n)\n"
                    let inst = inst.line_content
                    break
                else
                    let line_content = line_content."),   // size = ".para[2].", default value = ".para[1]."\n"
                    let inst = inst.line_content
                    let list_index = list_index+1
                    continue
                endif
            endw
        endif
        "port process
        if has_para_flag == 1           "has parameter
            let inst = inst."U_".toupper(a:module_name[i])."_0\n(\n"
        endif
        if empty(a:port_list[i]) == 0   "has port
            let list_len = len(a:port_list[i])
            let list_index = 0
            while 1
                let port = a:port_list[i][list_index]
                let line_content = "    .".port[0]
                let port[1] = (port[1] != "output") ? port[1]." " : port[1]     " poor man's job of vertical alignment of the text after input/output/inout
                while strwidth(line_content) < (4 + 1 + a:max_key_len[i] + 1)
                    let line_content = line_content." "
                endw
                let line_content = line_content."(".port[0]
                while strwidth(line_content) < (4 + 1 + a:max_key_len[i] + 1 + 1 + a:max_val_len[i])
                    let line_content = line_content." "
                endw
                if list_index == list_len-1     "the last item
                    let line_content = line_content.")    // ".port[1]." ".port[2]." ".port[3]."\n"
                    let inst = inst.line_content
                    break
                else
                    let line_content = line_content."),   // ".port[1]." ".port[2]." ".port[3]."\n"
                    let inst = inst.line_content
                    let list_index = list_index+1
                    continue
                endif
            endw
        endif
        "add );
        let inst = inst.");\n\n"
        "next module
        let i = i+1
    endw
    return inst
endfun




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   function        : Vlog_Inst_Gen
"   Input           : none
"   Output          : none
"   Return value    : 0     success     non_0   error
"   Description     : generate inst and work in given mode.
"   More            :
"       supported mode: 0, 1, 2, 3
"           mode 0(default):
"               copy to clipboard and echo inst in commandline
"           mode 1:
"               only copy to clipboard
"           mode 2:
"               copy to clipboard and echo inst in split window
"           mode 3:
"               copy to clipboard and update inst_comment to file
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! Vlog_Inst_Gen()
    "step 1:    search non-comment lines
    let non_comment_lines = []
    call <SID>Filter_Comment_Lines(1, line("$"), non_comment_lines)
    "step 2:    search module
    let module_info = []
    let module_num = <SID>Search_Module(non_comment_lines, module_info)
    if module_num == 0
        echohl ErrorMsg
        echo "None module found."
        echohl None
        return 1
    endif
    "step 3:    merge module head
    let merged_head_list = []
    let merge_result = <SID>Merge_Module_Head(non_comment_lines, module_num, module_info, merged_head_list)
    if merge_result != 0
        echohl ErrorMsg
        echo "Error ".merge_result.": when merging module head."
        echohl None
        return 2
    endif
    "step 4:    analysis module head
    let module_name_list = []
    let para_list = []
    let vlog_95_flag_list = []
    let port_list = []
    let port_i_list = []
    let port_o_list = []
    let port_io_list = []
    let max_key_len = []
    let max_val_len = []
    let analysis_head_result = <SID>Analysis_Module_Head(module_num, merged_head_list, module_name_list,
                                \   para_list, vlog_95_flag_list, port_list, port_i_list, port_o_list, port_io_list, max_key_len, max_val_len)
    if analysis_head_result != 0
        echohl ErrorMsg
        echo "Error ".analysis_head_result.": when analysis module head."
        echohl None
        return 3
    endif
    "step 5: check port declaration(optional by g:check_port_declaration)
    if g:check_port_declaration == 1
        let port_declare_list = []
        let analysis_body_result = <SID>Analysis_Module_Body(non_comment_lines, module_num, module_info, vlog_95_flag_list, port_declare_list)
        if analysis_body_result != 0
            echohl ErrorMsg
            echo "Error ".analysis_body_result.": when analysis module body."
            echohl None
            return 4
        endif
        "Compare port_list against port_declare_list regarding port names (Note that it is not possible to compare the direction or size)
        let module_index = 0
        while module_index < module_num
            if vlog_95_flag_list[module_index] == 1
                for mp in port_list[module_index]
                    if <SID>Exists(port_declare_list[module_index], mp[0]) == 0
                        echohl ErrorMsg
                        echo "Port ".mp[0].": has no declaration."
                        echohl None
                        return 5
                    endif
                endfor
                for mpc in port_declare_list[module_index]
                    if <SID>Exists(port_list[module_index], mpc[0]) == 0
                        echohl ErrorMsg
                        echo "Port ".mpc[0].": not appeared in port list."
                        echohl None
                        return 6
                    endif
                endfor
                let port_list[module_index] = port_declare_list[module_index]
                "TODO: Update port_i_list, port_o_list, port_io_list if they will be needed later.
            endif
            let module_index = module_index+1
        endw
    endif
    "step 6: get inst part and copy to clipboard
    let inst_part = <SID>Inst_Module(module_num, module_name_list, para_list, port_list, max_key_len, max_val_len)
    let @+ = inst_part
    if g:is_copy_inst_to_doublequotation
        let @" = inst_part
    endif
    "step 6: get inst insert location
    if g:vlog_inst_gen_mode == 0
        echohl Vlog_Inst_Gen_Msg_0
        echo "\n"
        echo module_num." insts as follows copyed:"
        echo "\n"
        echohl Vlog_Inst_Gen_Msg_1
        echo inst_part
        echohl Vlog_Inst_Gen_Msg_0
        echohl None
    elseif g:vlog_inst_gen_mode == 1
        echohl Vlog_Inst_Gen_Msg_0
        echo module_num." insts has been copyed."
        echohl None
    elseif g:vlog_inst_gen_mode == 2
        exe "split __Instance_File__"
        silent put! =inst_part
        exe "normal gg"
        "set buffer
        setlocal noswapfile
        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal filetype=verilog
    elseif g:vlog_inst_gen_mode == 3
        "get inst update location
        let inst_start = []
        let inst_end = []
        let inst_locate_result = <SID>Locate_Inst_Position(module_info[0][0], inst_start, inst_end)
        if inst_locate_result != 0
            echohl ErrorMsg
            echo "Error ".inst_locate_result.": when locate inst postion."
            echohl None
        endif
        if empty(inst_start)==1 && empty(inst_end)==1   "no inst exists
            let inst_loc = module_info[0][0]
        else                                            "delete existing instance
            silent exe inst_start[0].",".inst_end[0]."d"
            let inst_loc = inst_start[0]
        endif
        call append(inst_loc-1, "/*****************************************************************************")
        call append(inst_loc+0, "**************     INST GENERATED BY VLOG_INST_GEN PLUGIN     ****************")
        call append(inst_loc+1, "******************************************************************************")
        call append(inst_loc+2, "*****************************************************************************/")
        "update instance
        exe inst_loc+3
        silent put! =inst_part
        exe inst_loc
        exe "ks"
        exe "'s"
        echohl Vlog_Inst_Gen_Msg_0
        echo module_num." insts has been copyed and updated."
        echohl None
    endif
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Vlog_Inst_Gen_Mode_Change
"   Input           : none
"   Output          : none
"   Return value    : none
"   Description     : cycle through various working modes of Vlog_inst_gen
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! Vlog_Inst_Gen_Mode_Change()
    if g:vlog_inst_gen_mode == 0
        let g:vlog_inst_gen_mode = 1
        echohl Vlog_Inst_Gen_Msg_0
        echo "Vlog_Inst_Gen Use Mode 1: only copy to clipboard."
        echohl None
    elseif g:vlog_inst_gen_mode == 1
        let g:vlog_inst_gen_mode = 2
        echohl Vlog_Inst_Gen_Msg_0
        echo "Vlog_Inst_Gen Use Mode 2: copy to clipboard and display in split window."
        echohl None
    elseif g:vlog_inst_gen_mode == 2
        let g:vlog_inst_gen_mode = 3
        echohl Vlog_Inst_Gen_Msg_0
        echo "Vlog_Inst_Gen Use Mode 3: copy to clipboard and update in file."
        echohl None
    elseif g:vlog_inst_gen_mode == 3
        let g:vlog_inst_gen_mode = 0
        echohl Vlog_Inst_Gen_Msg_0
        echo "Vlog_Inst_Gen Use Mode 0: copy to clipboard and echo in commandline."
        echohl None
    else
        let g:vlog_inst_gen_mode = 0
        echohl Vlog_Inst_Gen_Msg_0
        echo "Vlog_Inst_Gen Use Mode 0: copy to clipboard and echo in commandline."
        echohl None
    endif
endfun


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"   Subfunction     : Vlog_Module_Open
"   Input           : none
"   Output          : none
"   Return value    : none
"   Description     : Open the file containing the definition of the
"                     module under cursor
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! Vlog_Module_Open()
    let origsuffix = &suffixesadd       "Preserve existing suffix list
    exe "set suffixesadd+=.v,.sv"

    " Per http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file, change
    " the local vim current directory to be that of the file you are currently editing
    " before interpreting the lib search paths listed at the end of that file.
    exe "lcd %:p:h"

    let origpath = &path                "Preserve existing path list
    let libpath = <SID>Get_Lib_Search_Paths(1, line("$"))
    for path in libpath
        exe "set path+=".path
    endfor

    exe "normal gf"

    let &path = origpath                "Restore original path list
    let &suffixesadd = origsuffix       "Restore original suffix list
endfun
