set nu
set optimize
set noerrorbells
" Opensrs defaults
set tabstop=8
set softtabstop=4
set shiftwidth=4
set noexpandtab
" end Opensrs defaults
set autoindent
set wrapscan
set bg=dark
set history=50 " keep 50 lines of command line history
" scrolloff=5 means when you search (e.g. via "n") you'll see 5 lines of context.
" Instead of sometimes getting the search result as the last line on the screen.
set scrolloff=5
if has("syntax")
"    syntax on
endif

" map f4 to a diagnostic message first.  Then if vim version allows it, actually have f4 do something useful
" echo may not be supported so don't even add a terminal <cr> to the echo.  Let the user see the message
nmap <f4> :echo "requires vim version 7.2 or greater (as reported by vim -h)"
if v:version >= 702
    " This version supports fun!;   vi -h version 7.2 -> v:version 702
    nmap <f4> :call BlameCurrentLine()<cr>
    " Get the current file name and line number, pass them to cvsBlame.pl
    fun! BlameCurrentLine()
	let lnum = line(".")
	let file = @%
	exec "!cvsBlame.pl " file lnum
    endfun
    " Get the current file name and line number, pass them to gitBlame.pl
    " Shift F4 mapping from here http://superuser.com/questions/508655/map-shift-f3-in-vimrc
    set <S-F4>=O1;2S
    nmap <S-F4> :call BlameCurrentLineGit()<cr>
    fun! BlameCurrentLineGit()
	let lnum = line(".")
	let file = @%
	exec "!gitBlame2.0.pl " file lnum
    endfun
else
    " This line is not even reached in my version of vim 7.1 (aka 701)
    " It doesn't support v:verison which is odd cause I see example vimrcs testing v:version against 600 etc.
    " And my version of 7.1 also doesn't support fun!
    nmap <f4> :echo "requires vim version 7.2 or greater (as reported by vim -h).."
endif

"A used
"a used
" B = Read from buffer
map B :r /tmp/mnieweglowski
" ^B insert script header
map  :0O#!/bin/bash
"b used
" C = Append C style Comment at end of line
map C A /*  */hh
"c used
"D used
"d used
" E = show numbers on
map E :set nu
" e = show numbers off
map e :set nonu
" F = Add a new line before current line
map F O
" f = Add a new line after current line
map f o
" G = Delete standard buffer. Standard buffer = mark a to mark b inclusive
map G :'a,'bd

" comment mark a to mark b
" g = prepend shell comment # to current region (mark a to mark b)
map g :'a,'bs/^/#/
"map g :'a,'bs/^/\/\//
" ^G = undo shell comment # to current region (mark a to mark b)
map  :'a,'bs/^#//
"map  :'a,'bs/^\/\///


if v:version >= 702
"  for .sql files comment/uncomment region with -- instead of #
autocmd BufRead *.sql map g :'a,'bs/^/--/
autocmd BufRead *.sql map  :'a,'bs/^--//
autocmd BufRead *.go,*.java  map g :'a,'bs#^#//#
autocmd BufRead *.go,*.java  map  :'a,'bs#^//##
autocmd BufRead *.go set tabstop=4
autocmd BufRead *.go set softtabstop=4
autocmd BufRead *.go set shiftwidth=4
autocmd BufRead *.go set noexpandtab
endif

" H = page down
map H 
" ^H Join next line but remove space at join point
"map  $Jdl
" ^H insert Common debugging structure HIT:MISS
map  oif () {print "HIT:".__LINE__."\n";} else {print "MISS:".__LINE__."\n";}
"h used
"I used
"i used
"J used
"j used
" K = dump the variable. For debuggins scripts.
"map  :s/^.*/print "&       is (".$&.")\\n";
"map K :s/^.*/print "&       is (".Dumper($&).")\\n";
map K :s/^\(\s*\)\(.*\)/\1print '\2       is ('.Dumper($\2).")\\n";:s/Dumper($\([%@$]\)/Dumper(\\\1/
map  :s/^\(\s*\)\(.*\)/\1print '\2       is ('.\2.")\\n";:s/'\.\([^%@$]\)/'.$\1/

if v:version >= 702
autocmd BufRead *.pm map  :s/^\(\s*\)\(.*\)/\1$Log->error('MARK at '.__PACKAGE__.':'.__LINE__.' \2 is ('.Dumper($\2).')');:s/Dumper($\([%@$]\)/Dumper(\\\1/
endif


"map K :s/^.*/print "&       is (".Dumper($&).")  at " .sprintf("%s:%s %s", __FILE__, __LINE__, (map{@{$_}>3?$_->[3]:'main'}[caller(0)])[0]) . "\\n";
"map K :s/^.*/print "&       is (".ref($&).")\\n";
"map K :s/^.*/print "&       is ("+str(&)+")"
"map K :s/^.*/print "&       is (%s)" % str(&)
"map K :s/^.*/echo "&       is ($&)";

if v:version >= 702
"  for .sh files use echo instead of print Dumper
autocmd BufRead *.sh map K :s/^\(\s*\)\(.*\)/\1echo  "\2       is ($\2)"
autocmd BufRead *.go map K :s/^\(\s*\)\(.*\)/\1fmt.Printf("MARK \2       is (%+v)\\n", \2)
endif

"k used
"l used
"L used
" ^L = prepend //
"map  I// 
" ^L = insert line column thingy
"map  :r ~/l
" ^L = insert print __LINE__ thing
map  oprint "at " . __PACKAGE__ . ":" . __LINE__ . "\n";
" fmt line. rm leading space, insert line break at word before 81st char.
map M :s/^[ 	]*//g0081lbi
"m used
" N = skip to Next file.
map N :n
" ^N = insert standard pythoN header
map  :00i#!/usr/bin/env python
"n used
" ^O = delete lines matching /oracle/ etc
map  :g#/oracle/#d:g#/foo.[0-9]*:#d:g#/bar.[0-9]*:#d
"O used
"o used
"P used
" ^P insert perl script header
map  :0O#!/usr/bin/perl -wuse strict;use Data::Dumper; $Data::Dumper::Sortkeys = 1; $Data::Dumper::Indent = 1; $Data::Dumper::Quotekeys = 0;:2,5s/^#//
"p used
" Q = Repeat last substitution for current line to end of file.
"map Q mz:.,$~`z
" Q = quit!
"map Q :q!
map Q :r!curl -s 'http://whatthecommit.com/index.txt'<cr>
" q = quit
map q :q
" R = Prepare for paste.  Set auto indent off and remove leading spaces to end of file
"map R mz:set noautoindentI	:.,$s/^[	 ]/`zo
" R = Prepare for paste.  Set auto indent off
"map R :set noautoindento
" R = Prepare for paste.
map R :set pasteo
" S = undo wrap line in XML comment
map S ^5dl$dldldldl
" s = wrap line in XML comment
map s I<!-- A -->
" T = rm leading tab from current line
map T :.<
"map T 0dl
"map T :.s/^\(    \\|	\)//
" t = add leading tab to current line
map t :.>
" CTRL-T Unused.
"map   :r /home/mniewegl/foo
" U = page Up
map U 
"u used
" V = Append line to buffer
map V :.w>>/tmp/mnieweglowski
" v change tab to 8 spaces
"map v :s/	/        /g
" ^W = delete common stuff after a grep
map  :g#/docs/#d:g#/tests.old/#d:g#/tests/#d:g#/CVS/#d:g/^[^ #]*[ ]*#/d:g/^Binary file .* matches/d
" W = write file
map W :w
"w used
" X = Overwrite buffer file with current line
map X :.w!/tmp/mnieweglowski
" x = move character forward
map x dlp
" Y = Overwrite buffer file with standard buffer.
map Y :'a,'bw!/tmp/mnieweglowski

" Z = undo shell comment to current line  (uses mark x to store and restore cursor position)
map Z mx0dl`x
" z = prepend shell comment # to current line  (uses mark x to store and restore cursor position)
map z mx0i#`x

if v:version >= 702
"  for .sql files comment/uncomment with -- instead of #
autocmd BufRead *.sql map Z mx02dl`x
autocmd BufRead *.sql map z mx0i--`x
autocmd BufRead *.go,*.java map Z mx02dl`x
autocmd BufRead *.go,*.java map z mx0i//`x
endif

" " = remove trailing spaces from file
map " :%s/[ 	]\+$//
" < = rm leading tabs from current region (mark a to mark b)
map < :'a,'b<
" < = add leading tabs from current region (mark a to mark b)
map > :'a,'b>

" destructive syntax test
map <f1> :%!perl -I/home/mnieweglowski/opensrs/lib -c

" Make SQL in clause from current buffer
map <f2> :%!mk.in
map <f3> :%!mk.in.no.quote

" Make grep clause from current buffer
map <f5> :%!mk.grep.pl
map <f6> :%!mk.vi.grep.pl

" sort uniq current buffer
map <f7> :%!sort -u
map <f8> :%!sort -un

" pretty print current buffer
map <f9> :%!ppxml
map <f10> :%!pretty_print_data_dumper.pl
map <f12> :%!pretty_print_perl_stack_trace.pl

" In insert mode CTRL-O adds a block braces after current line
map!  {}O
" In insert mode scroll up and down with CTRL-Y and CTRL-E (Just like outside of insert mode)
map!  a
map!  a

"set hlsearch

" Doesn't work on the "vi" installed on masterlog :(
" From Instantly Better Vim 2013
    " This rewires n and N to do the highlighing...
    nnoremap <silent> n   n:call HLNext(0.3)<cr>
    nnoremap <silent> #   #:call HLNext(0.3)<cr>
    nnoremap <silent> *   *:call HLNext(0.3)<cr>

    " OR ELSE just highlight the match in red...
"    function! HLNext (blinktime)
"	highlight WhiteOnRed ctermfg=white ctermbg=red
"        let [bufnum, lnum, col, off] = getpos('.')
"        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
"        let target_pat = '\c\%#'.@/
"        let ring = matchadd('WhiteOnRed', target_pat, 101)
"        redraw
"        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
"        call matchdelete(ring)
"        redraw
"    endfunction

    " OR ELSE ring the match in red...
    function! HLNext (blinktime)
        highlight RedOnRed ctermfg=red ctermbg=red
        let [bufnum, lnum, col, off] = getpos('.')
        let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
        let col_with_tabs = virtcol('.')
        "echo 'col=' . col . ' col_with_tabs=' .col_with_tabs
        let col = col_with_tabs
        let ring_pat = (lnum > 1 ? '\%'.(lnum-1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.\|' : '')
                \ . '\%'.lnum.'l\%>'.max([col-4,1]) .'v\%<'.col.'v.'
                \ . '\|'
                \ . '\%'.lnum.'l\%>'.max([col+matchlen-1,1]) .'v\%<'.(col+matchlen+3).'v.'
                \ . '\|'
                \ . '\%'.(lnum+1).'l\%>'.max([col-4,1]) .'v\%<'.(col+matchlen+3).'v.'
        let ring = matchadd('RedOnRed', ring_pat, 101)
        redraw
        exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
        call matchdelete(ring)
        redraw
    endfunction

    nnoremap  ;  :

    nnoremap    v   <C-V>
    nnoremap <C-V>     v

    vnoremap    v   <C-V>
    vnoremap <C-V>     v


" Neat remap a typo, but it has an annoying delay so :( don't use it.
"map q: :q
