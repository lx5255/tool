" The default vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2017 Apr 12
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key
" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

" ============================================================================
"				<< ���жϲ���ϵͳ�Ƿ��� Windows ���� Linux >>								
" ============================================================================
let g:iswindows = 0
let g:islinux 	= 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux 	= 1
endif


" ============================================================================
"							<< �����趨 >>								
" ============================================================================
" ע��ʹ��utf-8��ʽ����������Դ�롢�ļ�·�����������ģ����򱨴�
" set encoding=utf-8                                    "����gvim�ڲ�����
" set fileencoding=utf-8                                "���õ�ǰ�ļ�����
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1,gb2312,unicode     "����֧�ִ򿪵��ļ��ı���

" �ļ���ʽ��Ĭ�� ffs=dos,unix
set fileformat=unix                                   "�������ļ���<EOL>��ʽ
set fileformats=unix,dos,mac                          "�����ļ���<EOL>��ʽ����

" if (g:iswindows)
    "����˵�����
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "���consle�������
    language messages zh_CN.utf-8
" endif


" VIM ORIGIN DEFAULT CONFIG---------------------------------------------------------------------------START
set nocompatible "�رռ���ģʽ

" windows�²���Ч��ģ��windows��ݼ� Ctrl+Aȫѡ��Ctrl+C���ơ�Ctrl+Vճ��
if (g:iswindows)
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin

	" Ĭ�ϵ��Լ��Ĳ��������
	set diffexpr=MyDiff()
	function MyDiff()
	  let opt = '-a --binary '
	  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	  let arg1 = v:fname_in
	  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	  let arg2 = v:fname_new
	  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	  let arg3 = v:fname_out
	  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	  let eq = ''
	  if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
		  let cmd = '""' . $VIMRUNTIME . '\diff"'
		  let eq = '"'
		else
		  let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	  else
		let cmd = $VIMRUNTIME . '\diff'
	  endif
	  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif
" VIM ORIGIN DEFAULT CONFIG---------------------------------------------------------------------------END


" VIM CONFIG SET BY huayue_hu*************************************************************************START 
"
" ============================================================================
"							<< �����趨 >>								
" ============================================================================
"
" ---vimrc�ļ��趨
" ��ʹ�ñ��ذ汾��.g(vimrc), .exrc�� 
" set noexrc 
" set cpoptions=aABceFsmq 



" ---��������
if (g:islinux)
	" colorscheme Tomorrow-Night-Eighties         " �趨��ɫ����
	colorscheme elflord         " �趨��ɫ����
	let g:solarized_en = 0
	if (g:solarized_en)
		syntax enable
		" set background=dark
		set background=light
		" let g:solarized_termcolors=256
		colorscheme solarized		" �趨��ɫ����
		" option name default optional ------------------------------------------------
		let g:solarized_termcolors= 16 | 256 
		let g:solarized_termtrans = 0 | 1 
		let g:solarized_degrade = 0 | 1 
		let g:solarized_bold = 1 | 0 
		let g:solarized_underline = 1 | 0 
		let g:solarized_italic = 1 | 0 
		let g:solarized_contrast = "normal"| "high" or "low" 
		let g:solarized_visibility= "normal"| "high" or "low"
	endif
else
	" colorscheme molokai         " �趨��ɫ����
	colorscheme Tomorrow-Night-Eighties         " �趨��ɫ����
	"
	let g:solarized_en = 1
	if (g:solarized_en)
		syntax enable
		set background=dark
		" set background=light
		" let g:solarized_termcolors=256
		colorscheme solarized		" �趨��ɫ����
		" option name default optional ------------------------------------------------
		let g:solarized_termcolors= 16 | 256 
		let g:solarized_termtrans = 0 | 1 
		let g:solarized_degrade = 0 | 1 
		let g:solarized_bold = 1 | 0 
		let g:solarized_underline = 1 | 0 
		let g:solarized_italic = 1 | 0 
		let g:solarized_contrast = "normal"| "high" or "low" 
		let g:solarized_visibility= "normal"| "high" or "low"
	endif
endif



au GUIEnter * simalt ~x		" �����������
syntax on                   " �Զ��﷨����
set number                  " ��ʾ�к�
set cursorline              " ������ʾ��ǰ��
"set cursorcolumn			" ������ʾ��ǰ��
set guioptions-=T           " ���ع�����
set guioptions-=m           " ���ز˵���
set guioptions-=r 			" �ر��Ҳ������
set guioptions-=L 			" �ر���������
" ��״̬������ʾ�������λ�õ��кź��к�(ʹ��powerline�������Ч,���Կɱ���)
set ruler                   " ��״̬�����(Ĭ���Ѵ�)
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%) 


" ---��������
set expandtab				" tabתΪ�ո�
set tabstop=4               " �趨 tab ����Ϊ 4
set shiftwidth=4			" (shift)+(</>)ʱ���볤��Ϊ 4
set smartindent				" ΪC�����ṩ�Զ�����
set cindent					" ʹ��C��ʽ������

" ---��������
set ignorecase				" �������Դ�Сд
set incsearch               " ������������ʱ����ʾ�������
set hlsearch                " ����ʱ������ʾ���ҵ����ı�
set magic                   " ����ħ��(������ʽ:���� $ . * ^ ֮������Ԫ�ַ���Ҫ�ӷ�б��)
set nowrapscan              " ��ֹ���������ļ�����ʱ��������

" ---�ļ�����
set nobackup				"�����ɱ����ļ�
set autowrite				"�Զ�д�뻺����

" ---Set to auto read when a file is changed from the outside
if exists("&autoread")
set autoread
endif

" ---linux��͸����������
	hi Normal  ctermfg=252 ctermbg=none 

" ---�������� undo ��ʷ����
set undofile
if (g:islinux)
	set undodir=~/.undo_history/ "undo��ʷ����·��
else
	set undodir=$vim/vimfiles/undo_history/ "undo��ʷ����·��
endif

" ---�ر� preview����
set completeopt-=preview
set mouse=a


"
" function! Cp_sync()
"     if empty(glob("./sync.sh"))
"         !cp ~/.vim/tools/syn.sh  . 
"     endif
" endfunction


function! ToggleQf()
  for buffer in tabpagebuflist()
    if bufname(buffer) == ''
      " then it should be the quickfix window
      cclose
      " echo "here0"
      return
    endif
  endfor

  " copen
    botright copen 6
  " echo "here1"
endfunction




function!  Cscope_init()
	" ---cscope����
	if has("cscope")
		" �ȶϿ���ǰ��cscope����
		cs kill -1
		" �趨����ʹ�� quickfix �������鿴 cscope ���
		set cscopequickfix=s-,c-,d-,i-,t-,e-
		" ʹ֧���� Ctrl+]  �� Ctrl+t ��ݼ��ڴ������ת
		set cscopetag
		" ������뷴������˳������Ϊ1
		set csto=0
		" �ڵ�ǰĿ¼������κ����ݿ�
		if filereadable("cscope.out") 
			cs add cscope.out
			normal :<CR>
		" ����������ݿ⻷������ָ���� 
		elseif $CSCOPE_DB != "" 
			cs add $CSCOPE_DB 
		endif 
		set cscopeverbose 
		" �Զ����ݼ����ã���Թ�����ļ�����
		nmap <Leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>:botright copen 6<CR>
		vmap <Leader>fs <C-C>:cs find s <S-Insert><CR><CR>:botright copen 6<CR>
		nmap <Leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
		nmap <Leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>:botright copen 6<CR>
		nmap <Leader>ft :cs find t <C-R>=expand("<cword>")<CR><CR>:botright copen 6<CR>	
		vmap <Leader>ft <C-C>:cs find t <S-Insert><CR><CR>:botright copen 6<CR>
		nmap <Leader>fe :cs find e <C-R>=expand("<cword>")<CR><CR>:botright copen 6<CR>	
		nmap <Leader>ff :cs find f <C-R>=expand("<cfile>")<CR><CR>
		nmap <Leader>fi :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>:botright copen 6<CR>
		nmap <Leader>fd :cs find d <C-R>=expand("<cword>")<CR><CR>:botright copen 6<CR>	
		" �Զ����ݼ����ã���Թ�����������봰��
		nmap ;fs :cscope find s 
		nmap ;fg :cscope find g 
		nmap ;fc :cscope find c 
		nmap ;ft :cscope find t 
		nmap ;fe :cscope find e 
		nmap ;ff :cscope find f 
		nmap ;fi :cscope find i 
		nmap ;fd :cscope find d 
	endif
	" ---lookupfile����
	" if filereadable("filenametags")
		let g:LookupFile_TagExpr = '"./filenametags"'
        "
	" endif
endfunction

function!  CscopeSync()
	cs kill -1
    "û���ļ������ļ�
    if empty(glob("./syn.sh"))
        !cp /usr/share/vim/vim81/syn.sh  . 
    endif
       !bash syn.sh
	call Cscope_init()
endfunction


function!  MakeSync()
    "û���ļ������ļ�
    if empty(glob("./Makefile"))
        !cp /usr/share/vim/Makefile  . 
    endif

    if empty(glob("./make.sh"))
        !cp /usr/share/vim/make.sh  . 
    endif

    if empty(glob("./.gitignore"))
        !cp /usr/share/vim/.gitignore  . 
    endif
 
       !bash make.sh 
endfunction


" vundle �������� 
set nocompatible              " be iMproved, required 
filetype off  



set rtp+=/usr/share/vim/vim81/bundle/vundle.vim 

" vundle ����Ĳ���б����λ�� vundle#begin() �� vundle#end() ֮��  
call vundle#begin('/usr/share/vim/vim81/bundle') 

Plugin 'VundleVim/Vundle.vim'

"Plugin 'taglist.vim'
"Plugin 'nerdtree-ack'
 
" ---Define bundles via Github repos
" ~~~ctrlp�����ļ�������ctrlpfunky����������ǰC/C++�ļ���ĺ���
let g:ctrlp_en = 1 
if (g:ctrlp_en)
	Bundle 'kien/ctrlp.vim'
	Bundle 'tacahiroy/ctrlp-funky'
endif
" ~~~�ļ�����(��ctrlp������ȫ)��genutilsΪlookupfile�������������ͬʱ����
let g:lookupfile_en = 1
if (g:lookupfile_en)
	Bundle 'vim-scripts/lookupfile'
	Bundle 'vim-scripts/genutils'
endif
" ~~~��ʾ��ǰ�ļ���Ŀ¼�ṹ
let g:nerdtree_en = 1
if (g:nerdtree_en)
	Bundle 'scrooloose/nerdtree'
endif
" ~~~��ʾ��ǰ�ļ� ����·��/�����ʽ/��������ļ��ٷֱ�/���к�
let g:powerline_en = 1 
if (g:powerline_en)
	Bundle 'Lokaltog/vim-powerline'
endif
" ~~~���ͣ��ʱ��ʾ����ԭ����ʾ
let g:echofunc_en = 1
if (g:echofunc_en)
	Bundle 'mbbill/echofunc'
	" Bundle 'vim-scripts/echofunc.vim'
endif
" ~~~ע���뷴ע����ѡ����(����������Զ�ѡһ)
let g:tcomment_en = 1
if (g:tcomment_en)
	Bundle 'vim-scripts/tComment'
	" Bundle 'scrooloose/nerdcommenter'
endif
" ~~~��ʾ��ǰ�ļ� �궨��/����/���� �б�
let g:taglist_en = 1 
if (g:taglist_en)
	Bundle 'vim-scripts/taglist.vim'
	" Bundle 'taglist.vim'
endif
" ~~~��ȫ�ؼ���
if !empty(glob("./compile_commands.json"))
    let g:neocomplcache_en = 0
else
    let g:neocomplcache_en = 1
endif
if (g:neocomplcache_en)
	Bundle 'Shougo/neocomplcache.vim'
endif
" ~~~C/C++�ṹ�岹ȫ
if !empty(glob("./compile_commands.json"))
    let g:OmniCppComplete_en = 0
else
    let g:OmniCppComplete_en = 1
endif
if (g:OmniCppComplete_en)
	Bundle 'vim-scripts/OmniCppComplete'
endif
" ~~~C�����﷨����
let g:std_c_en = 1
if (g:std_c_en)
	Bundle 'vim-scripts/std_c.zip'
endif
" ~~~�ظ��ϴβ���
let g:repeat_en = 1
if (g:repeat_en)
	Bundle 'tpope/vim-repeat'
endif
" ~~~��ʾ֮ǰ�򿪹��Ĵ��ڵĻ����б�
let g:bufexplorer_en = 1
if (g:bufexplorer_en)
	Bundle 'jlanzarotta/bufexplorer'
endif
" ~~~���Ӷര�ڱ�ǩ����
let g:minibufexpl_en = 0
if (g:minibufexpl_en)
	Bundle 'fholgado/minibufexpl.vim'
endif
" ~~~��ǩ��ʾ
let g:signature = 0
if (g:signature)
	Bundle 'kshenoy/vim-signature'
	" Bundle 'vim-scripts/BOOKMARKS--Mark-and-Highlight-Full-Lines'
endif
" ~~~�ı��������滻
let g:easygrep = 0 
if (g:easygrep)
	Bundle 'dkprice/vim-easygrep'
endif
" ~~~״̬��+minibuf��ʾ����
let g:airline_en = 1 
if (g:airline_en)
	Bundle 'vim-airline/vim-airline'
	Bundle 'vim-airline/vim-airline-themes'
	Bundle 'tpope/vim-fugitive'
endif
" ~~~�﷨�Զ���ȫ
if !empty(glob("./compile_commands.json"))
    let g:youcompleteme_en = 1
else
    let g:youcompleteme_en = 0
endif
if (g:youcompleteme_en)
	Bundle 'Valloric/YouCompleteMe'
endif
" ~~~ctrlsf�ı�����
let g:ctrlsf_en = 0
if (g:ctrlsf_en)
	Bundle 'dyng/ctrlsf.vim'
endif
" ~~~ͬʱѡ�б༭ͬһ�ļ�����ͬ�ַ���
let g:multiple_cursors_en = 1
if (g:multiple_cursors_en)
	Bundle 'terryma/vim-multiple-cursors'
endif
" ~~~��֧undo
let g:gundo_en = 1
if (g:gundo_en)
	Bundle 'sjl/gundo.vim'
endif
" ~~~�����ٶ����ƶ�
let g:easymotion_en = 1
if (g:easymotion_en)
    Bundle 'easymotion/vim-easymotion'
endif
" ~~~����ؼ��ָ���
let g:interestingwords_en = 1
if (g:interestingwords_en)
    Bundle 'lfv89/vim-interestingwords'
endif
" ~~~��ͬ��ɫ��ʶƥ������
let g:rainbow_parentheses = 1
if (g:rainbow_parentheses)
    Bundle 'kien/rainbow_parentheses.vim'
endif
" ~~~������������
let g:indentLine_en = 1
if (g:indentLine_en)
    Bundle 'Yggdroot/indentLine'
endif
" ~~~���벹ȫ
let g:code_complete = 1
if (g:code_complete)
    Bundle 'mbbill/code_complete'
endif

" ����б����  
call vundle#end()  
filetype plugin indent on 
" ��������
":BundleList      - ��ʾ����б�
":BundleInstall   - ��װ���
":BundleInstall!  - ���²��
":BundleClean     - �������ò��

" ---��������
"filetype on
"filetype plugin on
"filetype indent on
"set noerrorbells            " �رմ�����Ϣ����
"'set nocompatible  

nmap csy :call Cp_sync()<CR> 
nmap qqq :q<CR>
nmap qa  :qa!<CR>
vmap <C-c> y
imap <C-v> <Esc>pi
nmap <C-v> p
nmap <Tab>  :vertical res 95<CR>
"imap <C-> <Esc>:set paste<CR>i 
"imap <C-m>  <Esc>0wi//
nmap mm 0i//<Esc>
"imap <C-n> <Esc>0xxi
"nmap nn 0xx
nmap co :!find . -depth -name "*.format_orig" -exec rm -f {} \;<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>  
 
nmap gr :grep --include "*.c" --include "*.h"-n "" . -r<Left><Left><Left><Left><Left><Left>
nmap en /<<<<<<<CR>
nmap mk :make libs -j&&make -j<CR> 
nmap cl :make clean -j&&make clean_libs -j<CR> 
nmap <F2> :NERDTreeToggle<CR>
nmap <c-g> :CtrlP<CR>
nmap <F1> :call ToggleQf()<CR>
nmap <F7> :call MakeSync()<CR><CR>
nmap sy :call CscopeSync()<CR> 


set nocompatible
set backspace=indent,eol,start				" ʹ�ظ����backspace����������indent, eol, start��

" map <backspace> <Del>

"set whichwrap+=<,>,h,l		" ����backspace�͹�����Խ�б߽�
"set nowrap 				" ��ֹ�۵���





" ============================================================================
"							<< �Զ����ݼ����� >>								
" ��ϸmap�ο� "http://www.jianshu.com/p/8ae25a680ed7"
" ============================================================================
"
" ---����ģʽ�� �ո��(space)���ٽ�����������(:)
nmap <SPACE> :
" ---����ģʽ�� �������� 88 ȡ����������
nmap 88 :nohlsearch<CR>
" ---����ģʽ�� ���� / ��ȫ��ƥ������
nmap ;/ 	/\<\><Left><Left>
" ---����ģʽ�� ����ӳ��ϵͳĬ�ϴ����л���ݼ�
nmap <c-k> <c-w>k
nmap <c-j> <c-w>j
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l

" ---����ģʽ�� ������������ƶ�
" �����ã������� neocomplcache/lookupfile/ctrlpfunky/ctrlp ���ֱ��"ctrl + j"��"ctrl + k"����ѡ��
"         ����� neocomplcache "Enter" ��ѡ��ȫ��Ϣʱ��໻һ�е�����
imap <c-k> <Up>
imap <c-j> <Down>
imap <c-h> <Left>
imap <c-l> <Right>

" ---����ģʽ�� ���ڴ�С����
" ʹ��˵����"shift + ="��Ϊ"+" Y�����󴰿�
"			"shift + -"��Ϊ"_" Y����С����
"			"shift + ."��Ϊ">" X�����󴰿�
"			"shift + ,"��Ϊ"<" X����С����
nmap + <c-w>+
nmap _ <c-w>-
nmap > <c-w>>
nmap < <c-w><

" ---����ģʽ�� ���� cS �����β�ո����� cM �����β ^M ����
nmap cS :%s/\s\+$//g<cr>:noh<cr>
nmap cM :%s/\r$//g<cr>:noh<cr>

" ---����ģʽ�� ��ݼ�
" uart��ӡ��ݼ�
imap pu<Enter> puts("\n");<Esc>F\i
imap pc<Enter> putchar('');<Esc>F'i
" imap pfx<Enter> printf("=0x%x\n", );<Esc>F=i
" imap pfd<Enter> printf("=%d\n", );<Esc>F=i
imap pff<Enter> printf("\n--func=%s\n", __FUNCTION__);<Esc>
" bit������ݼ�
imap ba<Enter>  &= ~BIT();<Esc>F)i
imap bo<Enter>  \|= BIT();<Esc>F)i
imap or<Enter>  \|= <Esc>i
imap an<Enter>  &= ~<Esc>a
" �������Զ����� ����"{"�󰴻س����Զ�����"}"���������ģʽ
imap {<Enter> {<Esc>o<tab><Esc>o}<Esc>ka<tab><Esc>lDa
" С�����Զ����� ����"("�󰴻س����Զ�����")"���������ģʽ
" imap (<Enter> ()<Esc>i

" ---����ģʽ�� quickfix ��ת��ݼ�
" ʹ��˵����"F9" ��һ��ҪѰ�ҵ�Ŀ��
"			"F10" ��һ��ҪѰ�ҵ�Ŀ��
nmap <F9>   :cp<CR>
nmap <F10>  :cn<CR>

" ---����ģʽ�� minibufexpl ��ת��ݼ�
" ʹ��˵����"1" ��һ����ǩ
"			"2" ��һ����ǩ
nmap 1 :bp<CR>
nmap 2 :bn<CR>


map ;e $
map ;h ^

" ---ʹ�ø��ƻ���Ĵ�������ճ��
map ;p "0p
map ;P "0P


" ---����ģʽ�� tab��ǩҳ����
nmap - :tabp<CR>
nmap = :tabn<CR>

" ---����ģʽ�� ������ת
nnoremap fo <c-]>

" ---ָ����ֵ����ƶ�
map H 5h
map J 5j
map K 5k
map L 5l

" ---�Զ���ת��ճ���ı������ 
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" ---{}/()����ƥ��
nmap {	%

" ---����������ڹؼ���(���λ�ò��ƶ�)
nmap * *N
" ---��ɫ����visualģʽ��ѡ�йؼ���(���λ�ò��ƶ�)
"  ע��/��������ģʽ������ģʽ������<S-Insert>�������Ҫcmapһ��
vmap <C-C> 			"+y
cmap <S-Insert> 	<C-R>+
vmap * 				<C-C>/<S-Insert><Enter>N

"��ʾ��������
set ruler

"��������
set cursorline

"�Զ�����
set noautoindent
set cindent
set smartindent

"Tab���Ŀ��
set shiftwidth=4
set tabstop=4

" �رո��ְ�����������������
set vb t_vb=
au GuiEnter * set t_vb=

"  
"  "����buffer������
"   let g:airline_theme='solarized' 
"
"   set laststatus=2  "��Զ��ʾ״̬��
"   let g:airline_powerline_fonts = 1
"   let g:airline#extensions#tabline#enabled = 1
"
"     if !exists('g:airline_symbols')
"     let g:airline_symbols = {}
"   endif 
"   
"   " unicode symbols
"   let g:airline_left_sep = '>>'
"   let g:airline_left_sep = '>'
"   let g:airline_right_sep = '<<'
"   let g:airline_right_sep = '<'
"



" -------------------------------------------------------------
"  < TagList ������� >
" -------------------------------------------------------------
" ����˵�����г��˵�ǰ�ļ��е����� ��/ȫ�ֱ���/������ �б�����vc�е�workpace
" ʹ��˵��������ģʽ�¼��� tl ���ò�����������������б���
" ����������⣺�½� quickfix ����ʱ�ἷ�� taglist �����·���Ӱ�� quickfix ����
" �����ļ����У�����(:h taglist)
" �Դ���ݼ���û��
" �Զ����ݼ���"tl"
if (g:taglist_en)
	" ����д� Tagbar �������Ƚ���ر�
	" nmap tl :TagbarClose<CR>:Tlist<CR>
	nmap tl :Tlist<CR>
	let Tlist_Show_One_File=1                   "ֻ��ʾ��ǰ�ļ���tags
	" let Tlist_Enable_Fold_Column=0              "ʹtaglist�������ʾ��ߵ��۵���
	let Tlist_Exit_OnlyWindow=1                 "���Taglist���������һ���������˳�Vim
	let Tlist_File_Fold_Auto_Close=1            "�Զ��۵�
	let Tlist_WinWidth=30                       "���ô��ڿ��
	let Tlist_Use_Right_Window=1                "���Ҳര������ʾ
endif


" -------------------------------------------------------------
"  < omnicppcomplete ������� >
" -------------------------------------------------------------
" ����C/C++���벹ȫ�����ֲ�ȫ��Ҫ��������ռ䡢�ࡢ�ṹ����ͬ��Ƚ��в�ȫ
" ʹ��ǰ��ִ������ ctags ����������п���ֱ��ʹ�� ccvext �����ִ���������
" ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
if (g:OmniCppComplete_en)
	set nocp
	filetype plugin on
	" set completeopt=menu,menuone  
	" set completeopt=menu
	 let OmniCpp_MayCompleteDot=1    "��  . ������
	 let OmniCpp_MayCompleteArrow=1  "�� -> ������
	" let OmniCpp_MayCompleteScope=1  "�� :: ������
	 let OmniCpp_NamespaceSearch=1   "�������ռ�
	" let OmniCpp_GlobalScopeSearch=1  
	" let OmniCpp_DefaultNamespace=["std"]  
	" let OmniCpp_ShowPrototypeInAbbr=1  		"����ʾ����ԭ��
	 let OmniCpp_SelectFirstItem = 2			"�Զ�����ʱ�Զ�������һ��
	"
	" set completeopt=longest,menu "�رղ˵�
	" let OmniCpp_NamespaceSearch = 2     " search namespaces in the current buffer   and in included files
	let OmniCpp_ShowPrototypeInAbbr = 1 " ��ʾ���������б�
	" let OmniCpp_MayCompleteScope = 1    " ���� :: ���Զ���ȫ
	" let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
	"
	" set autochdir
	" set tags=tags;
endif



" -------------------------------------------------------------
"  < nerdcommenter ������� >
" -------------------------------------------------------------
if (g:tcomment_en)
	" <Leader>ci ��ÿ��һ�� /* */ ע��ѡ����(ѡ������������)����������ȡ��ע��
	" <Leader>cm ��һ�� /* */ ע��ѡ����(ѡ������������)������������ظ�ע��
	" <Leader>cc ��ÿ��һ�� /* */ ע��ѡ���л���������������ظ�ע��
	" <Leader>cu ȡ��ѡ������(��)��ע�ͣ�ѡ������(��)��������һ�� /* */
	" <Leader>ca ��/*...*/��//������ע�ͷ�ʽ���л����������Կ��ܲ�һ���ˣ�
	" <Leader>cA ��βע��
	let NERDSpaceDelims = 1                     "����ע�ͷ�֮����ע�ͷ�֮ǰ���пո�
endif



" -------------------------------------------------------------
"  < ctrlp-funky ������� >
" -------------------------------------------------------------
"---���ã�������ǰ�����ļ�ƥ��Ĺؼ��֣���ȫ�������ƥ��ѡ����ʾ��ctrlp����
if (g:ctrlp_en)
	nnoremap <Leader>fu :CtrlPFunky<Cr>
	" narrow the list down with a word under cursor
	nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<Cr>
	" highlight feature
	let g:ctrlp_funky_matchtype = 'path'
	" ������ʾ�߼����Թؼ���
	let g:ctrlp_funky_syntax_highlight = 1
    let g:ctrlp_working_path_mode = 'c'
endif

" -------------------------------------------------------------
"  < vim-powerline ������� >
" -------------------------------------------------------------
"---���ã������������ʾ��ǰ�ļ������뷽ʽ�������ļ����͡�������ǰ��������ļ�λ�á��������кš�
"---�����ã���ctrlp,ctrlp-funky�����ɫ���ÿ�
if (g:powerline_en)
	" open a powerline quickly when vim starts up
	let g:Powerline_symbols = 'fancy'

	" Always show the statusline
	set laststatus=2   

	" ���windows & linux�²������������ʾ��������⣬��Ҫ��װ4���������嵽ϵͳ
	" ����Դ��ַ��https://github.com/eugeii/consolas-powerline-vim
	" ��װ��������"LINUX_TOOL/vim/.vim/fonts/consolas-powerline-vim-master"��˫��.ttf��β�������ļ�����(windows �� linux�°�װ������ͬ)
	" set guifont=Courier_New:h13:cANSI " �����ֺ����ã�h13�����ֺ�
	set guifont=Consolas\ for\ Powerline\ FixedD:h13 " �����ֺ����ã�h13�����ֺ�
endif

" -------------------------------------------------------------
"  < vim-airline ������� >
" -------------------------------------------------------------
if (g:airline_en)
	" Always show the statusline
	set laststatus=2   

	let g:airline_powerline_fonts = 1

	let g:airline#extensions#syntastic#enabled = 1

	" enable/disable fugitive/lawrencium integration
	" let g:airline#extensions#branch#enabled = 1
	" let g:airline#extensions#branch#vcs_priority = ["git"]
	"
	" enable/disable detection of whitespace errors. >
	let g:airline#extensions#whitespace#enabled = 0
	let g:airline#extensions#whitespace#symbol = '!'

	" enable/disable enhanced tabline. (c)
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#buffer_nr_show = 0
	let g:airline#extensions#tabline#buffer_idx_mode = 1

	" switch position of buffers and tabs on splited tabline (c)
	" let g:airline#extensions#tabline#switch_buffers_and_tabs = 1

	let g:airline#extensions#tabline#show_splits = 1
	" let g:airline#extensions#tabline#show_buffers = 0
	" let g:airline#extensions#tabline#show_tabs= 1
	" let g:airline#extensions#tabline#show_tab_nr = 0
	let g:airline#extensions#tabline#show_tab_type = 0 "����ʾ"buffers"

	" Show just the filename
	let g:airline#extensions#tabline#fnamemod = ':t'
	""
	nmap <leader>1 <Plug>AirlineSelectTab1
	nmap <leader>2 <Plug>AirlineSelectTab2
	nmap <leader>3 <Plug>AirlineSelectTab3
	nmap <leader>4 <Plug>AirlineSelectTab4
	nmap <leader>5 <Plug>AirlineSelectTab5
	nmap <leader>6 <Plug>AirlineSelectTab6
	nmap <leader>7 <Plug>AirlineSelectTab7
	nmap <leader>8 <Plug>AirlineSelectTab8
	nmap <leader>9 <Plug>AirlineSelectTab9
	" nmap <leader>- <Plug>AirlineSelectPrevTab
	" nmap <leader>+ <Plug>AirlineSelectNextTab
	"

	" fix exit insert mode delay
	set ttimeoutlen=50   
	" theme:dark light simple badwolf molokai base16 murmur luna wombat bubblegum jellybeans laederon
	"papercolor kolor kalisi behelit base16color 
	if (g:iswindows)
		let g:airline_theme='kolor'
	else
		let g:airline_theme='molokai'
	endif


  " unicode symbols
  let g:airline_left_sep = '>>'
  let g:airline_left_sep = '>'
  let g:airline_right_sep = '<<'
  let g:airline_right_sep = '<'

	" set guifont=Ubuntu_Mono_derivative_Powerline:h15:cANSI " �����ֺ����ã�h13�����ֺ�
	set guifont=Ubuntu\Mono\derivative\Powerline:h15:cANSI " �����ֺ����ã�h13�����ֺ�
    let g:airline_powerline_fonts = 1 
    " set guifont=DejaVu_Sans_Mono_for_Powerline:h12:cANSI   
    " set helplang=cn
	" set guifont=Ubuntu\ Mono\ derivative\ Powerline\ Regular:h13:cANSI " �����ֺ����ã�h13�����ֺ�
	" set guifont=Droid_Sans_Mono_Slashed_for_Pow:h13:cANSI " �����ֺ����ã�h13�����ֺ�
	" set guifont=Hack:h13:cANSI " �����ֺ����ã�h13�����ֺ�
	"set guifont=Consolas\ for\ Powerline\ FixedD:h13 " �����ֺ����ã�h13�����ֺ�
" function! MyOverride(...)
"     	call a:1.add_section('StatusLine'       ,           'all')
"     	call a:1.add_section('Tag'       ,           'your')
"     	call a:1.add_section('Search'       ,           'base')
"     	call a:1.add_section('Title'       ,           'are')
"     	call a:1.add_section('TabLineSel'       ,           'belong')
"     	call a:1.add_section('ErrorMsg'       ,           'to')
"     	call a:1.add_section('StatusLineNC'       ,           '%f')
"     	call a:1.split()
"     	call a:1.add_section('Error'       ,           '%p%%')
" 	return 1
" endfunction
" call airline#add_statusline_func('MyOverride')

" function! AccentDemo()
"   let keys = ['a','b','c','d','e','f','g','h']
"   for k in keys
"     call airline#parts#define_text(k, k)
"   endfor
"   call airline#parts#define_accent('a', 'red')
"   call airline#parts#define_accent('b', 'green')
"   call airline#parts#define_accent('c', 'blue')
"   call airline#parts#define_accent('d', 'yellow')
"   call airline#parts#define_accent('e', 'orange')
"   call airline#parts#define_accent('f', 'purple')
"   call airline#parts#define_accent('g', 'bold')
"   call airline#parts#define_accent('h', 'italic')
"   let g:airline_section_a = airline#section#create(keys)
" endfunction
" autocmd VimEnter * call AccentDemo()

" function! AirlineInit()
	" let g:airline_section_b = airline#section#create_left(['%{EchoFuncGetStatusLine()}'])
" endfunction
" autocmd VimEnter * call AirlineInit()
endif

" -------------------------------------------------------------
"  < nerdtree ������� >
" -------------------------------------------------------------
if (g:nerdtree_en)
	" open a NERDTree automatically when vim starts up
	" autocmd vimenter * NERDTree
	" open a NERDTree automatically when vim starts up if no files were specified
	"autocmd StdinReadPre * let s:std_in=1
	"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
	" close vim if the only window left open is a NERDTree
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	map <F2> :NERDTreeToggle<CR>
endif
    "�ļ�(��)����
    let NERDTreeIgnore=['\.d$[[file]]', '\.o$[[file]]']
    " let NERDTreeIgnore=['temp$[[dir]]']
    "��ʾ��ǿ
    " let NERDChristmasTree=1
    "���ļ����Զ��ر�
    let NERDTreeQuitOnOpen=0
    "������ʾ��ǰ�ļ���Ŀ¼
    let NERDTreeHighlightCursorline=1
    "����λ��
    let NERDTreeWinPos='left'
    "���ڿ��
    let NERDTreeWinSize=31
    "����ʾ'Bookmarks' label 'Press ? for help'
    let NERDTreeMinimalUI=1
    "��ʾ�к�
    let NERDTreeShowLineNumbers=0

" ���ÿ�ݼ�(Ҫ���������NERDTree����)
	" I : ��ʾ�����ļ�
	" o : ��Ŀ¼�۵����ߴ��ļ����������ļ�����
	" O : �ݹ� ��ѡ�н���µ�����Ŀ¼
	" x : ��£ѡ�н��ĸ�Ŀ¼
	" X : �ݹ� ��£ѡ�н���µ�����Ŀ¼
	" r : �ݹ�ˢ��ѡ��Ŀ¼
	" R : �ݹ�ˢ�¸����

" -------------------------------------------------------------
"  < nerdcommenter ������� >
" -------------------------------------------------------------
if (g:tcomment_en)
	" <Leader>ci ��ÿ��һ�� /* */ ע��ѡ����(ѡ������������)����������ȡ��ע��
	" <Leader>cm ��һ�� /* */ ע��ѡ����(ѡ������������)������������ظ�ע��
	" <Leader>cc ��ÿ��һ�� /* */ ע��ѡ���л���������������ظ�ע��
	" <Leader>cu ȡ��ѡ������(��)��ע�ͣ�ѡ������(��)��������һ�� /* */
	" <Leader>ca ��/*...*/��//������ע�ͷ�ʽ���л����������Կ��ܲ�һ���ˣ�
	" <Leader>cA ��βע��
	let NERDSpaceDelims = 1                     "����ע�ͷ�֮����ע�ͷ�֮ǰ���пո�
endif

" -------------------------------------------------------------
"  < lookupfile ������� >
" -------------------------------------------------------------
" ����˵����������ʾC�����﷨
" ʹ��˵����vim ����ʱ�Զ���Ч
" �����ļ����У�����(:h lookupfile)
" �Դ���ݼ���û��
" �Զ����ݼ���"ctrl + f"
if (lookupfile_en)
	let g:LookupFile_MinPatLength = 2               "��������2���ַ��ſ�ʼ����
	let g:LookupFile_PreserveLastPattern = 0        "�������ϴβ��ҵ��ַ���
	let g:LookupFile_PreservePatternHistory = 1     "���������ʷ
	let g:LookupFile_AlwaysAcceptFirst = 1          "�س��򿪵�һ��ƥ����Ŀ
	let g:LookupFile_AllowNewFiles = 0              "�������������ڵ��ļ�
	if filereadable("filenametags")                "����tag�ļ�������
		let g:LookupFile_TagExpr = '"./filenametags"'
	endif
	nmap <c-f> :LookupFile<CR>
endif

" -------------------------------------------------------------
"  < std_c ������� >
" -------------------------------------------------------------
" ����˵����������ʾC�����﷨
" ʹ��˵����vim ����ʱ�Զ���Ч
" �����ļ����У�����(:h std_c)
" �Դ���ݼ���û��
" �Զ����ݼ���û��
if (g:std_c_en)
	" ֹͣ // ��ɫע�ӷ��
	let c_cpp_comments = 1
endif

" -------------------------------------------------------------
"  < neocomplcache ������� >
" -------------------------------------------------------------
" ����˵������ȫ �ؼ���/������/����/�ṹ���Ա
" 			(��ʵvim������Я���˹��ܣ���û�иò��ʱ��Ҫ�ֶ� "ctrl + n" ���ȫ����
" ʹ��˵����vim ����ʱ�Զ���Ч������ͨ�� "ctrl + j" "ctrl + k" ����ѡ�񣬰���"Enter"��ȷ��
" ���ȱ�ݣ��ڵ�����ȫ�б���� <c-p> �� <c-n> ��������ѡ����� "Enter" ���ᵼ�»���
" �����ļ����У�����(:h neocomplcache)
" �Դ���ݼ���	"ctrl + n"	ѡ����һ��
" 				"ctrl + p"	ѡ����һ��
" �Զ����ݼ���û��
if (g:neocomplcache_en)
	" �ؼ��ֲ�ȫ���ļ�·����ȫ��tag��ȫ�ȵȣ����֣��ǳ����ã��ٶȳ��졣
	let g:neocomplcache_enable_at_startup = 1     "vim ����ʱ���ò��
	" let g:neocomplcache_disable_auto_complete = 1 "���Զ�������ȫ�б�
endif


" -------------------------------------------------------------
"  < TagList ������� >
" -------------------------------------------------------------
" ����˵�����г��˵�ǰ�ļ��е����� ��/ȫ�ֱ���/������ �б�����vc�е�workpace
" ʹ��˵��������ģʽ�¼��� tl ���ò�����������������б���
" ����������⣺�½� quickfix ����ʱ�ἷ�� taglist �����·���Ӱ�� quickfix ����
" �����ļ����У�����(:h taglist)
" �Դ���ݼ���û��
" �Զ����ݼ���"tl"
if (g:taglist_en)
	" ����д� Tagbar �������Ƚ���ر�
	" nmap tl :TagbarClose<CR>:Tlist<CR>
	nmap tl :Tlist<CR>
	let Tlist_Show_One_File=1                   "ֻ��ʾ��ǰ�ļ���tags
	" let Tlist_Enable_Fold_Column=0              "ʹtaglist�������ʾ��ߵ��۵���
	let Tlist_Exit_OnlyWindow=1                 "���Taglist���������һ���������˳�Vim
	let Tlist_File_Fold_Auto_Close=1            "�Զ��۵�
	let Tlist_WinWidth=30                       "���ô��ڿ��
	let Tlist_Use_Right_Window=1                "���Ҳര������ʾ
endif

" -------------------------------------------------------------
"  < echofunc ������� >
" -------------------------------------------------------------
if (g:echofunc_en)
    "Because the message line often cleared by some other plugins (e.g. ominicomplete), an other choice is to show message in status line.First, add  %{EchoFuncGetStatusLine()}  to your 'statusline' option.
    let g:EchoFuncShowOnStatus = 0
    set statusline=%{EchoFuncGetStatusLine()}
    let g:EchoFuncAutoStartBalloonDeclaration = 1
endif

" -------------------------------------------------------------
"  < easygrep ������� >
" -------------------------------------------------------------
" ��ϸ�ο� "~/.vim/bundle/vim-easygrep/README.md"
if (g:easygrep)
	nmap <silent><Leader>vs <Leader>vv :ccl<CR> :botright copen 6<CR>
	nmap <silent><Leader>vt <Leader>vV :ccl<CR> :botright copen 6<CR>
	nmap <silent><Leader>vr <Leader>vr :ccl<CR> :botright copen 6<CR>
	vmap <silent><Leader>vs <Leader>vv :ccl<CR> :botright copen 6<CR>
	vmap <silent><Leader>vt <Leader>vV :ccl<CR> :botright copen 6<CR>
	vmap <silent><Leader>vr <Leader>vr :ccl<CR> :botright copen 6<CR>
	nmap <silent><Leader>vo :GrepOptions<CR>
	nmap <silent><Leader>vu :ReplaceUndo<CR>

	nmap ;vs :Grep 
	nmap ;vr :Replace 
endif	

" -------------------------------------------------------------
"  < omnicppcomplete ������� >
" -------------------------------------------------------------
" ����C/C++���벹ȫ�����ֲ�ȫ��Ҫ��������ռ䡢�ࡢ�ṹ����ͬ��Ƚ��в�ȫ
" ʹ��ǰ��ִ������ ctags ����������п���ֱ��ʹ�� ccvext �����ִ���������
" ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
if (g:OmniCppComplete_en)
	set nocp
	filetype plugin on
	" set completeopt=menu,menuone  
	" set completeopt=menu
	" let OmniCpp_MayCompleteDot=1    "��  . ������
	" let OmniCpp_MayCompleteArrow=1  "�� -> ������
	" let OmniCpp_MayCompleteScope=1  "�� :: ������
	" let OmniCpp_NamespaceSearch=1   "�������ռ�
	" let OmniCpp_GlobalScopeSearch=1  
	" let OmniCpp_DefaultNamespace=["std"]  
	" let OmniCpp_ShowPrototypeInAbbr=1  		"����ʾ����ԭ��
	" let OmniCpp_SelectFirstItem = 2			"�Զ�����ʱ�Զ�������һ��
	"
	" set completeopt=longest,menu "�رղ˵�
	" let OmniCpp_NamespaceSearch = 2     " search namespaces in the current buffer   and in included files
	let OmniCpp_ShowPrototypeInAbbr = 1 " ��ʾ���������б�
	" let OmniCpp_MayCompleteScope = 1    " ���� :: ���Զ���ȫ
	" let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
	"
	" set autochdir
	" set tags=tags;
endif

" -------------------------------------------------------------
"  < ctrlsf ������� >
" -------------------------------------------------------------
if (g:ctrlsf_en)
	nmap     <C-F>f <Plug>CtrlSFPrompt
	vmap     <C-F>f <Plug>CtrlSFVwordPath
	vmap     <C-F>F <Plug>CtrlSFVwordExec
	nmap     <C-F>n <Plug>CtrlSFCwordPath
	nmap     <C-F>p <Plug>CtrlSFPwordPath
	nnoremap <C-F>o :CtrlSFOpen<CR>
	nnoremap <C-F>t :CtrlSFToggle<CR>
	inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
	nmap     <C-F>l <Plug>CtrlSFQuickfixPrompt
	vmap     <C-F>l <Plug>CtrlSFQuickfixVwordPath
	vmap     <C-F>L <Plug>CtrlSFQuickfixVwordExec
endif

" -------------------------------------------------------------
"  < multiple-cursors ������� >
" -------------------------------------------------------------
if (g:multiple_cursors_en)
	" Default mapping
	" let g:multi_cursor_next_key='<C-n>'
	" let g:multi_cursor_prev_key='<C-p>'
	" let g:multi_cursor_skip_key='<C-x>'
	" let g:multi_cursor_quit_key='<Esc>'
endif

" -------------------------------------------------------------
"  < gundo ������� >
" -------------------------------------------------------------
if (g:gundo_en)
	" ���� gundo ��
	nnoremap <Leader>ud :GundoToggle<CR>
endif

" ------------------------------------------------------------- "  
"  < easymotion ������� >
" -------------------------------------------------------------
if (g:easymotion_en)
    let g:EasyMotion_do_mapping = 0 " Disable default mappings
    " Jump to anywhere you want with minimal keystrokes, with just one key binding.
    " `s{char}{label}`
    nmap 's <Plug>(easymotion-overwin-f)
    " or
    " `s{char}{char}{label}`
    " Need one more keystroke, but on average, it may be more comfortable.
    nmap 's <Plug>(easymotion-overwin-f2)
       
    " Turn on case insensitive feature
    let g:EasyMotion_smartcase = 1
       
    " JK motions: Line motions
    map ;j <Plug>(easymotion-j)
    map ;k <Plug>(easymotion-k)
endif  

" ------------------------------------------------------------- 
"  < interestingwords ������� >
" -------------------------------------------------------------
if (g:interestingwords_en)
	" nnoremap <silent> <leader>k :call InterestingWords('n')<cr>
	" nnoremap <silent> <leader>K :call UncolorAllWords()<cr>
	" nnoremap <silent> n :call WordNavigation('forward')<cr>
	" nnoremap <silent> N :call WordNavigation('backward')<cr>
	"
	" set gui colors
	" 			 						 ǳ��    ǳ��   ����   ǳ��    �ۺ�   ǳ��
	let g:interestingWordsGUIColors = ['#71dcff', '#A4E57E', '#F5E1AE', '#FF7272', '#FFB3FF', '#9999FF']

	" set terminal colors
	" let g:interestingWordsTermColors = ['154', '121', '211', '137', '214', '222']
	"                                    ��ɫ    ����    ��     ����   ��ɫ   ���
	let g:interestingWordsTermColors = ['blue', 'cyan', 'red', '118', '135', '161']

	" randomise the colors (applied to each new buffer):��ɫ�����
	let g:interestingWordsRandomiseColors = 1
endif

" ------------------------------------------------------------- 
"  < rainbow_parentheses ������� >
" -------------------------------------------------------------
if (g:rainbow_parentheses)
	" Options
    " ['linux',         'windows],'
	let g:rbpt_colorpairs = [
    \ ['brown',         'brown'],
    \ ['Darkblue',      'Darkblue'],
    \ ['darkgray',      'darkgray'],
    \ ['darkgreen',     'darkgreen'],
    \ ['darkcyan',      'darkcyan'],
    \ ['darkred',       'darkred'],
    \ ['darkmagenta',   'darkmagenta'],
    \ ['brown',         'brown'],
    \ ['gray',          'gray'],
    \ ['cyan',          'cyan'],
    \ ['161',           'DarkOrchid3'],
    \ ['118',           'SeaGreen3'],
    \ ['135',           'RoyalBlue3'],
    \ ['blue',          'blue'],
    \ ['red',           'red'],
    \ ['white',         'white'],
    \ ]

	let g:rbpt_max = 16
	let g:rbpt_loadcmd_toggle = 0

	" Commands
	" :RainbowParenthesesToggle       " Toggle it on/off
	" :RainbowParenthesesLoadRound    " (), the default when toggling
	" :RainbowParenthesesLoadSquare   " []
	" :RainbowParenthesesLoadBraces   " {}
	" :RainbowParenthesesLoadChevrons " <>
	
	" Always On
	au VimEnter * RainbowParenthesesToggle
	" au Syntax * RainbowParenthesesLoadRound
	" au Syntax * RainbowParenthesesLoadSquare
	au Syntax * RainbowParenthesesLoadBraces
endif

" ------------------------------------------------------------- 
"  < indentLine_en ������� >
" -------------------------------------------------------------
if (g:indentLine_en)
	" ������������
	" let g:indentLine_setColors = 0
	
	" ����������ɫ����
	let g:indentLine_color_term = 'grey'
	let g:indentLine_color_gui = '#71dcff'

	" let g:indentLine_setConceal = 2
	" let g:indentLine_concealcursor = 'inc'
	" let g:indentLine_conceallevel = 2
endif

" ------------------------------------------------------------- 
"  < YouCompleteMe ������� >
" -------------------------------------------------------------
if (g:youcompleteme_en)
    let g:ycm_server_python_interpreter = '/usr/bin/python'
    " ����ʾ����vimʱ���ycm_extra_conf�ļ�����Ϣ  
    let g:ycm_confirm_extra_conf = 0

	"��ע��������Ҳ�ܲ�ȫ
	let g:ycm_complete_in_comments = 1
	"���ַ���������Ҳ�ܲ�ȫ
	let g:ycm_complete_in_strings = 1

    "��ת�����崦
    nnoremap go :YcmCompleter GoToDefinitionElseDeclaration<CR>
    "���ļ�ʱ�رմ���
    " au BufReadPost * silent YcmDiags
endif

" ------------------------------------------------------------- 
"  < code_complete ������� >
" -------------------------------------------------------------
if (g:code_complete)
    let g:huayue_add = 1 "�޸Ĳ��
    if (g:huayue_add)
        let g:rs = '< '     "region start
        let g:re = ' >'     "region stop
        let g:completekey = "<c-b>"     "hotkey
        let g:template = {}
        let g:template['c'] = {}

        "---�Զ���ģ��
        " C templates
        let g:template['c']['de'] = "#define "
        let g:template['c']['in'] = "#include \"\"\<left>"
        let g:template['c']['is'] = "#include <>\<left>"
        let g:template['c']['ff'] = "#ifndef  \_\_\<c-r>=GetFileName()\<cr>\_\_\<CR>#define  \_\_\<c-r>=GetFileName()\<cr>\_\_\<CR>".repeat("\<CR>",5)."#endif  /*\_\_\<c-r>=GetFileName()\<cr>\_\_*/".repeat("\<up>",3)
        let g:template['c']['for'] = "for (".g:rs."...".g:re."; ".g:rs."...".g:re."; ".g:rs."...".g:re.") {\<cr>".g:rs."...".g:re."\<cr>}\<cr>"
        let g:template['c']['switch'] = "switch (".g:rs."...".g:re.") {\<cr>case ".g:rs."...".g:re.":\<cr>break;\<cr>case ".g:rs."...".g:re.":\<cr>break;\<cr>default :\<cr>break;\<cr>}"
        let g:template['c']['while'] = "while (".g:rs."...".g:re.") {\<cr>".g:rs."...".g:re."\<cr>}"
        let g:template['c']['if'] = "if (".g:rs."...".g:re." ) {\<cr>".g:rs."...".g:re."\<cr>}"
        let g:template['c']['ife'] = "if (".g:rs."...".g:re." ) {\<cr>".g:rs."...".g:re."\<cr>} else {\<cr>".g:rs."...".g:re."\<cr>}"
        let g:template['c']['pfx'] = "printf(\"".g:rs."...".g:re."=0x%x\\n\", ".g:rs."...".g:re.");"
        let g:template['c']['pfd'] = "printf(\"".g:rs."...".g:re."=%d\\n\", ".g:rs."...".g:re.");"
        let g:template['c']['pfb'] = "printf_buf(".g:rs."u8 *buf".g:re.", ".g:rs."u32 len".g:re.");"
        let g:template['c']['memset'] = "memset(".g:rs."void *buf".g:re.", ".g:rs."int value".g:re.", ".g:rs."u32 len".g:re.");"
        let g:template['c']['memcpy'] = "memcpy(".g:rs."void *to".g:re.", ".g:rs."const void *from".g:re.", ".g:rs."u32 len".g:re.");"
        let g:template['c']['memcmp'] = "memcmp(".g:rs."const void *".g:re.", ".g:rs."const void *".g:re.", ".g:rs."u32 len".g:re.");"
        let g:template['c']['st'] = "struct ".g:rs."NAME".g:re." {\<cr>".g:rs."type".g:re."     ".g:rs."name".g:re.";\<cr>".g:rs."type".g:re."     ".g:rs."name".g:re.";\<cr>"."};"
        let g:template['c']['tst'] = "typedef struct ".g:rs."\_\_NAME".g:re." {\<cr>".g:rs."type".g:re."     ".g:rs."name".g:re.";\<cr>".g:rs."type".g:re."     ".g:rs."name".g:re.";\<cr>"."}\_NAME;"
        let g:template['c']['enum'] = "enum {\<cr>".g:rs."NAME0".g:re." = 0,\<cr>".g:rs."NAME1".g:re.",\<cr>};"
    endif
endif



" ============================================================================
"							<< �������� >>								
" ============================================================================
"
" -------------------------------------------------------------
"  < cscope �������� >
" -------------------------------------------------------------
" ����˵����C/C++�� ����/����/�궨��/ͷ�ļ� ��ת������������ʱ��quickfix����ʾ�������
" ʹ��˵�����뽫toolsĿ¼(���߰���cscope.exe��ctags.exe��sync.bat��sync.sh���ļ���)�ӵ�ϵͳ����������
"			�ڹ��̸�Ŀ¼��vim������ģʽ�¼���sy���ڴ�Ŀ¼����cscope.out��tags�ļ���ʹ�ܸù��߹���
" �Դ���ݼ���û��
" �Զ����ݼ���"\fs"����"fs"		Find this C symbol
"				"\fg"����"fg"		Find this definition
"				"\fc"����"fc"		Find functions calling this function
"				"\ft"����"ft"		Find this text string	
"				"\fe"����"fe"		Find this egrep pattern
"				"\ff"����"ff"		Find this file
"				"\fi"����"fi"		Find files #including this file
"				"\fd"����"fd"		Find functions called by this function	
function! Session_load()
	" if &filetype == 'svim'
	" if has("workspace.svim")
		source 		workspace.svim
	" endif
	" if &filetype == 'viminfo'
	" if has("workspace.viminfo")
		rviminfo 	workspace.viminfo
	" endif
endfunction

function! Session_save()
	" if &filetype == 'svim'
		!rm 		workspace.svim
	" endif
	mksession! 	workspace.svim
	" if &filetype == 'viminfo'
		!rm 		workspace.viminfo
	" endif
	wviminfo! 	workspace.viminfo
endfunction

" -------------------------------------------------------------
"  < vimtweak �������� > 
" -------------------------------------------------------------
" ����˵�������ڴ���͸�����ö���������Windowsʹ��
" ʹ��˵������ȷ��vim74�ļ��д���vimtweak.dll������vim74�ļ��м���ϵͳ��������
" �Դ���ݼ���û��
" �Զ����ݼ���"shift + Up(�Ϸ����)" 		���Ӳ�͸����
"				"shift + Down(�·����)" 	���ٲ�͸����
"				"<Leader>t" 				�����ö�����л�
if (g:iswindows)
    let g:Current_Alpha = 220
    let g:Top_Most = 0
	
    func! Alpha_add()
        let g:Current_Alpha = g:Current_Alpha + 10
        if g:Current_Alpha > 255
            let g:Current_Alpha = 255
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Alpha_sub()
        let g:Current_Alpha = g:Current_Alpha - 10
        if g:Current_Alpha < 155
            let g:Current_Alpha = 155
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Top_window()
        if  g:Top_Most == 0
            call libcallnr("vimtweak.dll","EnableTopMost",1)
            let g:Top_Most = 1
        else
            call libcallnr("vimtweak.dll","EnableTopMost",0)
            let g:Top_Most = 0
        endif
    endfunc

	" �����Զ�͸��
	autocmd GUIEnter * call libcallnr("vimtweak.dll", "SetAlpha", g:Current_Alpha)
    " ��ݼ�����
    map <s-up> :call Alpha_add()<CR>
    map <s-down> :call Alpha_sub()<CR>
    map <leader>t :call Top_window()<CR>
endif

" -------------------------------------------------------------
"  < gvimfullscreen �������� >
" -------------------------------------------------------------
" ����˵����ȫ������(���������)��������Windowsʹ��
" ʹ��˵������ȷ��vim74�ļ��д���gvimfullscreen.dll������vim74�ļ��м���ϵͳ��������
" �Դ���ݼ���û�� 
" �Զ����ݼ���"F11"
if (g:iswindows)
	map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
	" autocmd GUIEnter * call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)
endif
" ---����ģʽ�� ��ݼ�
" uart��ӡ��ݼ�
imap pu<Enter> puts("\n");<Esc>F\i
imap pc<Enter> putchar('');<Esc>F'i
" imap pfx<Enter> printf("=0x%x\n", );<Esc>F=i
" imap pfd<Enter> printf("=%d\n", );<Esc>F=i
imap pff<Enter> printf("\n--func=%s\n", __FUNCTION__);<Esc>
" bit������ݼ�
imap ba<Enter>  &= ~BIT();<Esc>F)i
imap bo<Enter>  \|= BIT();<Esc>F)i
imap or<Enter>  \|= <Esc>i
imap an<Enter>  &= ~<Esc>a
" �������Զ����� ����"{"�󰴻س����Զ�����"}"���������ģʽ
imap {<Enter> {<Esc>o<tab><Esc>o}<Esc>ka<tab><Esc>lDa
" С�����Զ����� ����"("�󰴻س����Զ�����")"���������ģʽ
" imap (<Enter> ()<Esc>i

" ---����ģʽ�� quickfix ��ת��ݼ�
" ʹ��˵����"F9" ��һ��ҪѰ�ҵ�Ŀ��
"			"F10" ��һ��ҪѰ�ҵ�Ŀ��
nmap <F9>   :cp<CR>
nmap <F10>  :cn<CR>

" ---����ģʽ�� minibufexpl ��ת��ݼ�
" ʹ��˵����"1" ��һ����ǩ
"			"2" ��һ����ǩ
nmap 1 :bp<CR>
nmap 2 :bn<CR>


" ---����ģʽ�� �༭vimrc�ļ�
if (g:islinux)
	" nmap <Leader>ev :e ~/.vimrc<CR>
    nmap <Leader>ev :e /usr/share/vim/vim81/defaults.vim<CR>
else
	nmap <Leader>ev :e $vim/_vimrc<CR>
endif
" ---�������׻��߾�β
" ʹ��˵����"; + e" ������β
"			"; + h" ��������
map ;e $
map ;h ^

" ---ʹ�ø��ƻ���Ĵ�������ճ��
map ;p "0p
map ;P "0P

" ---����ģʽ�� ����source .vimrc
if(g:islinux)
    function! SourceVimrc()
        !source ~/.vimrc
        AirlineRefresh      "airline resresh cmd
    endfunction

	nmap ;s :call SourceVimrc()<CR><CR>
endif

" ---����ģʽ�� tab��ǩҳ����
nmap - :tabp<CR>
nmap = :tabn<CR>

" ---����ģʽ�� ������ת
nnoremap fo <c-]>

" ---ָ����ֵ����ƶ�
map H 5h
map J 5j
map K 5k
map L 5l

" ---�Զ���ת��ճ���ı������ 
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" ---{}/()����ƥ��
nmap {	%

" ---����������ڹؼ���(���λ�ò��ƶ�)
nmap * *N
" ---��ɫ����visualģʽ��ѡ�йؼ���(���λ�ò��ƶ�)
"  ע��/��������ģʽ������ģʽ������<S-Insert>�������Ҫcmapһ��
vmap <C-C> 			"+y
cmap <S-Insert> 	<C-R>+
vmap * 				<C-C>/<S-Insert><Enter>N

" ---quickfix ���ڳ�פ���
function! ToggleQf()
  for buffer in tabpagebuflist()
    if bufname(buffer) == ''
      " then it should be the quickfix window
      cclose
      " echo "here0"
      return
    endif
  endfor

  " copen
    botright copen 6
  " echo "here1"
endfunction
map <silent><F1>    :call ToggleQf()<CR>

" ---tComment ���ע����ӳ��
map ;// \__

" ---����sync.sh����ǰ·��
map <silent><F3> :!cp ~/git_hub/LINUX_TOOL/vim/.vim/tools/sync.sh ./<CR><CR><CR>

" ---���� nerdtree �ļ��й���
cmap ntdir          let NERDTreeIgnore+=['$[[dir]]']<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" map  td             :let NERDTreeIgnore+=['$[[dir]]']<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" ---���� nerdtree �ļ�����
cmap ntfile         let NERDTreeIgnore+=['$[[file]]']<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" ---visualģʽ�¹���ѡ���ַ���(ֻ�޶��ļ���)
vmap <silent>^ 		<C-C>:ntdir<S-Insert><Enter>R

" ---F1 ��/�ر�quickfix����
let g:set_paste_flag = 1
function! Set_paste()
    if (g:set_paste_flag)   
        let g:set_paste_flag = 0
        set paste
    else
        let g:set_paste_flag = 1
        set nopaste
    endif
endfunction
map <silent><F4>    :call Set_paste()<CR>

