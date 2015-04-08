" ir_white color scheme
" Converted from Textmate theme IR_White using Coloration v0.2.4 (http://github.com/sickill/coloration)


" ********************************************************************************
" Standard colors used in all ir_white themes:
" Note, x:x:x are RGB values
"
"  normal: #f6f3e8
"
"  string: #A8FF60  168:255:96
"    string inner (punc, code, etc): #00A0A0  0:160:160
"  number: #FF73FD  255:115:253
"  comments: #7C7C7C  124:124:124
"  keywords: #96CBFE  150:203:254
"  operators: white
"  class: #FFFFB6  255:255:182
"  method declaration name: #FFD2A7  255:210:167
"  regular expression: #E9C062  233:192:98
"    regexp alternate: #FF8000  255:128:0
"    regexp alternate 2: #B18A3D  177:138:61
"  variable: #C6C5FE  198:197:254
"
" Misc colors:
"  red color (used for whatever): #FF6C60   255:108:96
"     light red: #FFB6B0   255:182:176
"
"  brown: #E18964  good for special
"
"  lightpurpleish: #FFCCFF
"
" Interface colors:
"  background color: white
"  cursor (where underscore is used): #FFA560  255:165:96
"  cursor (where block is used): white
"  visual selection: #1D1E2C
"  current line: #151515  21:21:21
"  search selection: #07281C  7:40:28
"  line number: #3D3D3D  61:61:61


" ********************************************************************************
" The following are the preferred 16 colors for your terminal
"           Colors      Bright Colors
" Black     #4E4E4E     #7C7C7C
" Red       #FF6C60     #FFB6B0
" Green     #A8FF60     #CEFFAB
" Yellow    #FFFFB6     #FFFFCB
" Blue      #96CBFE     #FFFFCB
" Magenta   #FF73FD     #FF9CFE
" Cyan      #C6C5FE     #DFDFFE
" White     #EEEEEE     #FFFFFF


" ********************************************************************************
set background=dark
hi clear

if exists("syntax_on")
      syntax reset
  endif

  let g:colors_name = "IR_White"

"hi Example                     guifg=NONE      guibg=NONE      gui=NONE            ctermfg=NONE        ctermbg=NONE        cterm=NONE

" General colors
hi Normal                       guifg=#010101   guibg=#d0d0d0   gui=NONE
"hi Normal                       guifg=#010101   guibg=#ffffff   gui=NONE
hi NonText                      guifg=#f3f8fe   guibg=#ffffff   gui=NONE

hi Cursor                       guifg=NONE      guibg=#a0a0a0   gui=NONE
hi LineNr                       guifg=#808080   guibg=#ffffff   gui=NONE

hi VertSplit                    guifg=#cfcfcf   guibg=#cfcfcf   gui=NONE
hi StatusLine                   guifg=#414141   guibg=#21e101   gui=bold
hi StatusLineNC                 guifg=#e1e1e1   guibg=#1f1f1f   gui=NONE

hi Folded                       guifg=#898989   guibg=#ffffff   gui=NONE
hi Title                        guifg=#010101   guibg=NONE      gui=bold
hi Visual                       guifg=NONE      guibg=#e0e0ed   gui=NONE

hi SpecialKey                   guifg=#f3f8fe   guibg=#ffffff   gui=NONE

hi ErrorMsg                     guifg=NONE      guibg=NONE      gui=NONE
hi WarningMsg                   guifg=NONE      guibg=NONE      gui=NONE

hi CursorLine                   guifg=NONE      guibg=#c0c0c0   gui=NONE            ctermfg=NONE        ctermbg=NONE        cterm=BOLD
"hi CursorLine                   guifg=NONE      guibg=#eeeeee   gui=NONE            ctermfg=NONE        ctermbg=NONE        cterm=BOLD
"hi CursorLine                   guifg=NONE      guibg=#ffffff   gui=NONE
hi CursorColumn                 guifg=NONE      guibg=#c0c0c0   gui=NONE
"hi CursorColumn                 guifg=NONE      guibg=#ffffff   gui=NONE
"hi MatchParen                   guifg=#016692   guibg=NONE      gui=NONE
hi MatchParen                   guifg=#f6f3e8   guibg=#857b6f   gui=BOLD            ctermfg=white       ctermbg=darkgray    cterm=NONE
hi Pmenu                        guifg=#a15001   guibg=NONE      gui=NONE
hi PmenuSel                     guifg=NONE      guibg=#e0e0ed   gui=NONE
"hi Search                       guifg=NONE      guibg=#cdcdd8   gui=NONE
hi Search                       guifg=NONE      guibg=yellow    gui=NONE            ctermfg=black       ctermbg=yellow      cterm=NONE
hi IncSearch                    guifg=NONE      guibg=orange    gui=NONE
"hi IncSearch                    guifg=NONE      guibg=#cdcdd8   gui=NONE
hi Directory                    guifg=#333366   guibg=NONE      gui=NONE

" Syntax highlighting
hi Comment                      guifg=#898989   guibg=NONE      gui=NONE
hi String                       guifg=#009f78   guibg=NONE      gui=NONE
hi Number                       guifg=#8c008a   guibg=NONE      gui=NONE

hi Keyword                      guifg=#016692   guibg=NONE      gui=NONE
hi PreProc                      guifg=#016692   guibg=NONE      gui=NONE
hi Conditional                  guifg=#016692   guibg=NONE      gui=NONE

hi Todo                         guifg=#8f8f8f   guibg=yellow    gui=NONE            ctermfg=red         ctermbg=NONE        cterm=NONE
"hi Todo                         guifg=#898989   guibg=NONE      gui=inverse,bold
hi Constant                     guifg=#333366   guibg=NONE      gui=NONE

hi Identifier                   guifg=#877611   guibg=NONE      gui=NONE
hi Function                     guifg=#a15001   guibg=NONE      gui=NONE
hi Type                         guifg=#646409   guibg=NONE      gui=underline
hi Statement                    guifg=#016692   guibg=NONE      gui=NONE

hi Special                      guifg=#010101   guibg=NONE      gui=NONE
hi Operator                     guifg=#016692   guibg=NONE      gui=NONE

hi Character                    guifg=#333366   guibg=NONE      gui=NONE
hi Boolean                      guifg=#333366   guibg=NONE      gui=NONE
hi Float                        guifg=#8c008a   guibg=NONE      gui=NONE
hi Label                        guifg=#009f78   guibg=NONE      gui=NONE
hi Define                       guifg=#016692   guibg=NONE      gui=NONE
hi StorageClass                 guifg=#877611   guibg=NONE      gui=NONE
hi Tag                          guifg=#a15001   guibg=NONE      gui=NONE
hi Underlined                   guifg=NONE      guibg=NONE      gui=underline


" Special for Ruby
hi rubyRegexp                   guifg=#9d7416   guibg=NONE      gui=NONE
hi rubyRegexpDelimiter          guifg=#9d7416   guibg=NONE      gui=NONE
hi rubyEscape                   guifg=#333366   guibg=NONE      gui=NONE
hi rubyInterpolationDelimiter   guifg=NONE      guibg=NONE      gui=NONE
hi rubyControl                  guifg=#016692   guibg=NONE      gui=NONE
hi rubyGlobalVariable           guifg=#696989   guibg=NONE      gui=NONE
hi rubyInclude                  guifg=#016692   guibg=NONE      gui=NONE

hi rubyClass                    guifg=#016692   guibg=NONE      gui=NONE
hi rubyFunction                 guifg=#a15001   guibg=NONE      gui=NONE
hi rubySymbol                   guifg=#333366   guibg=NONE      gui=NONE
hi rubyInstanceVariable         guifg=#696989   guibg=NONE      gui=NONE
hi rubyClassVariable            guifg=#696989   guibg=NONE      gui=NONE
hi rubyConstant                 guifg=#646409   guibg=NONE      gui=NONE
hi rubyStringDelimiter          guifg=#009f78   guibg=NONE      gui=NONE
hi rubyBlockParameter           guifg=#696989   guibg=NONE      gui=NONE
hi rubyOperator                 guifg=#016692   guibg=NONE      gui=NONE
hi rubyException                guifg=#016692   guibg=NONE      gui=NONE
hi rubyPseudoVariable           guifg=#696989   guibg=NONE      gui=NONE

hi rubyRailsUserClass           guifg=#646409   guibg=NONE      gui=NONE
hi rubyRailsARAssociationMethod guifg=#7a7025   guibg=NONE      gui=NONE
hi rubyRailsARMethod            guifg=#7a7025   guibg=NONE      gui=NONE
hi rubyRailsRenderMethod        guifg=#7a7025   guibg=NONE      gui=NONE
hi rubyRailsMethod              guifg=#7a7025   guibg=NONE      gui=NONE

hi erubyDelimiter               guifg=NONE      guibg=NONE      gui=NONE
hi erubyComment                 guifg=#898989   guibg=NONE      gui=NONE
hi erubyRailsMethod             guifg=#7a7025   guibg=NONE      gui=NONE

" Special for HTML
hi htmlTag                      guifg=#0067c2   guibg=NONE      gui=NONE
hi htmlTagName                  guifg=#0067c2   guibg=NONE      gui=NONE
hi htmlEndTag                   guifg=#0067c2   guibg=NONE      gui=NONE
hi htmlArg                      guifg=#0067c2   guibg=NONE      gui=NONE
hi htmlSpecialChar              guifg=#333366   guibg=NONE      gui=NONE

" Special for Javascript
hi javaScriptFunction           guifg=#877611   guibg=NONE      gui=NONE
hi javaScriptRailsFunction      guifg=#7a7025   guibg=NONE      gui=NONE
hi javaScriptBraces             guifg=NONE      guibg=NONE      gui=NONE

hi yamlKey                      guifg=#a15001   guibg=NONE      gui=NONE
hi yamlAnchor                   guifg=#696989   guibg=NONE      gui=NONE
hi yamlAlias                    guifg=#696989   guibg=NONE      gui=NONE
hi yamlDocumentHeader           guifg=#009f78   guibg=NONE      gui=NONE

hi cssURL                       guifg=#696989   guibg=NONE      gui=NONE
hi cssFunctionName              guifg=#7a7025   guibg=NONE      gui=NONE
hi cssColor                     guifg=#333366   guibg=NONE      gui=NONE
hi cssPseudoClassId             guifg=#bc4d00   guibg=NONE      gui=NONE
hi cssClassName                 guifg=#bc4d00   guibg=NONE      gui=NONE
hi cssValueLength               guifg=#8c008a   guibg=NONE      gui=NONE
hi cssCommonAttr                guifg=#582b00   guibg=NONE      gui=NONE
hi cssBraces                    guifg=NONE      guibg=NONE      gui=NONE


" Special for minibufexpl
hi MBEVisibleActive             guifg=#A6DB29   guibg=#888888
hi MBEVisibleChangedActive      guifg=#FF5555   guibg=fg
"hi MBEVisibleChanged           guifg=#FF0000
"hi MBEVisibleNormal            guifg=#5DC2D6   guibg=fg
hi MBEChanged                   guifg=#FF0000
hi MBENormal                    guifg=#808080

" Special for tabbar
hi Tb_VisibleNormal             guifg=#A6DB29   guibg=#888888
hi Tb_VisibleChanged            guifg=#FF5555   guibg=fg
hi Tb_Changed                   guifg=#FF0000
hi Tb_Normal                    guifg=#808080
