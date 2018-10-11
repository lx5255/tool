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
"				<< 基判断操作系统是否是 Windows 还是 Linux >>								
" ============================================================================
let g:iswindows = 0
let g:islinux 	= 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux 	= 1
endif


" ============================================================================
"							<< 编码设定 >>								
" ============================================================================
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
"set encoding=utf-8                                    "设置gvim内部编码
"set fileencoding=utf-8                                "设置当前文件编码
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1,gb2312,unicode     "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新文件的<EOL>格式
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

if (g:iswindows)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif


" VIM ORIGIN DEFAULT CONFIG---------------------------------------------------------------------------START
set nocompatible "关闭兼容模式

" windows下才有效：模仿windows快捷键 Ctrl+A全选、Ctrl+C复制、Ctrl+V粘贴
if (g:iswindows)
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin

	" 默认的自己的参数代码段
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
"							<< 基本设定 >>								
" ============================================================================
"
" ---vimrc文件设定
" 不使用本地版本（.g(vimrc), .exrc） 
" set noexrc 
" set cpoptions=aABceFsmq 



au GUIEnter * simalt ~x		" 启动窗口最大化
syntax on                   " 自动语法高亮
set number                  " 显示行号
set cursorline              " 高亮显示当前行
"set cursorcolumn			" 高亮显示当前列
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
set guioptions-=r 			" 关闭右侧滚动条
set guioptions-=L 			" 关闭左侧滚动条
" 在状态行上显示光标所在位置的行号和列号(使用powerline插件后无效,但仍可保留)
set ruler                   " 打开状态栏标尺(默认已打开)
set rulerformat=%20(%2*%<%f%=\ %m%r\ %3l\ %c\ %p%%%) 


" ---缩进设置
set expandtab				" tab转为空格
set tabstop=4               " 设定 tab 长度为 4
set shiftwidth=4			" (shift)+(</>)时对齐长度为 4
set smartindent				" 为C程序提供自动缩进
set cindent					" 使用C样式的缩进

" ---搜索设置
set ignorecase				" 搜索忽略大小写
set incsearch               " 输入搜索内容时就显示搜索结果
set hlsearch                " 搜索时高亮显示被找到的文本
set magic                   " 设置魔术(正则表达式:除了 $ . * ^ 之外其他元字符都要加反斜杠)
set nowrapscan              " 禁止在搜索到文件两端时重新搜索

" ---文件操作
set nobackup				"不生成备份文件
set autowrite				"自动写入缓冲区

" ---Set to auto read when a file is changed from the outside
if exists("&autoread")
set autoread
endif

" ---linux下透明背景设置
if (g:islinux)
	hi Normal  ctermfg=252 ctermbg=none 
endif

" ---开启保存 undo 历史功能
set undofile
if (g:islinux)
	set undodir=~/.undo_history/ "undo历史保存路径
else
	set undodir=$vim/vimfiles/undo_history/ "undo历史保存路径
endif

" ---关闭 preview窗口
set completeopt-=preview
set mouse=a



function! Cp_sync()
    if empty(glob("./sync.sh"))
        !cp ~/.vim/tools/sync.sh  . 
    endif
endfunction


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
	" ---cscope设置
	if has("cscope")
		" 先断开先前的cscope链接
		cs kill -1
		" 设定可以使用 quickfix 窗口来查看 cscope 结果
		set cscopequickfix=s-,c-,d-,i-,t-,e-
		" 使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳转
		set cscopetag
		" 如果你想反向搜索顺序设置为1
		set csto=0
		" 在当前目录中添加任何数据库
		if filereadable("cscope.out") 
			cs add cscope.out
			normal :<CR>
		" 否则添加数据库环境中所指出的 
		elseif $CSCOPE_DB != "" 
			cs add $CSCOPE_DB 
		endif 
		set cscopeverbose 
		" 自定义快捷键设置：针对光标在文件窗口
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
		" 自定义快捷键设置：针对光标在命令输入窗口
		nmap ;fs :cscope find s 
		nmap ;fg :cscope find g 
		nmap ;fc :cscope find c 
		nmap ;ft :cscope find t 
		nmap ;fe :cscope find e 
		nmap ;ff :cscope find f 
		nmap ;fi :cscope find i 
		nmap ;fd :cscope find d 
	endif
	" ---lookupfile设置
	" if filereadable("filenametags")
		let g:LookupFile_TagExpr = '"./filenametags"'
	" endif
endfunction

function!  CscopeSync()
	cs kill -1
       !bash syn.sh
	call Cscope_init()
endfunction

" vundle 环境设置 
set nocompatible              " be iMproved, required 
filetype off  


set rtp+=/usr/share/vim/vim81/bundle/vundle.vim 

" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间  
call vundle#begin('/usr/share/vim/vim81/bundle') 

Plugin 'VundleVim/Vundle.vim'
"Plugin 'taglist.vim'
"Plugin 'nerdtree-ack'
Plugin 'git://github.com/scrooloose/nerdtree.git'
"Plugin 'cscope.vim'
Plugin 'vim-airline/vim-airline'  "状态栏，buffer美化
Plugin 'vim-airline/vim-airline-themes'
Plugin 'git://github.com/kien/ctrlp.vim.git'
"Plugin 'taglist.vim'

Plugin 'vim-scripts/lookupfile'
Plugin 'vim-scripts/genutils'
Plugin 'mbbill/echofunc'
"Plugin 'vim-scripts/tComment'
Plugin 'vim-scripts/taglist.vim'
Plugin 'Yggdroot/indentLine'
  
" 插件列表结束  
call vundle#end()  
filetype plugin indent on 
" 常用命令
":BundleList      - 显示插件列表
":BundleInstall   - 安装插件
":BundleInstall!  - 更新插件
":BundleClean     - 清理无用插件

" ---其它操作
"filetype on
"filetype plugin on
"filetype indent on
"set noerrorbells            " 关闭错误信息响铃
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
nmap <C-f> :CtrlP<CR>
nmap <F1> :call ToggleQf()<CR>
map <BackSpace> <Del>
nmap sy :call CscopeSync()<CR> 

"nmap gre :!find . -name '*.php' -exec grep -i -nH "" {} \;//<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

set nocompatible
set backspace=indent,eol,start				" 使回格键（backspace）正常处理indent, eol, start等

"set whichwrap+=<,>,h,l		" 允许backspace和光标键跨越行边界
"set nowrap 				" 禁止折叠行






" ============================================================================
"							<< 自定义快捷键设置 >>								
" 详细map参考 "http://www.jianshu.com/p/8ae25a680ed7"
" ============================================================================
"
" ---常规模式下 空格键(space)快速进入命令输入(:)
nmap <SPACE> :
" ---常规模式下 连续输入 88 取消搜索高亮
nmap 88 :nohlsearch<CR>
" ---常规模式下 输入 / 后全字匹配搜索
nmap ;/ 	/\<\><Left><Left>
" ---常规模式下 重新映射系统默认窗口切换快捷键
nmap <c-k> <c-w>k
nmap <c-j> <c-w>j
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l

" ---插入模式下 光标上下左右移动
" 副作用：可以令 neocomplcache/lookupfile/ctrlpfunky/ctrlp 插件直接"ctrl + j"和"ctrl + k"上下选择，
"         并解决 neocomplcache "Enter" 键选择补全信息时会多换一行的问题
imap <c-k> <Up>
imap <c-j> <Down>
imap <c-h> <Left>
imap <c-l> <Right>

" ---常规模式下 窗口大小调整
" 使用说明："shift + ="变为"+" Y轴扩大窗口
"			"shift + -"变为"_" Y轴缩小窗口
"			"shift + ."变为">" X轴扩大窗口
"			"shift + ,"变为"<" X轴缩小窗口
nmap + <c-w>+
nmap _ <c-w>-
nmap > <c-w>>
nmap < <c-w><

" ---常规模式下 输入 cS 清除行尾空格，输入 cM 清除行尾 ^M 符号
nmap cS :%s/\s\+$//g<cr>:noh<cr>
nmap cM :%s/\r$//g<cr>:noh<cr>

" ---插入模式下 快捷键
" uart打印快捷键
imap pu<Enter> puts("\n");<Esc>F\i
imap pc<Enter> putchar('');<Esc>F'i
" imap pfx<Enter> printf("=0x%x\n", );<Esc>F=i
" imap pfd<Enter> printf("=%d\n", );<Esc>F=i
imap pff<Enter> printf("\n--func=%s\n", __FUNCTION__);<Esc>
" bit操作快捷键
imap ba<Enter>  &= ~BIT();<Esc>F)i
imap bo<Enter>  \|= BIT();<Esc>F)i
imap or<Enter>  \|= <Esc>i
imap an<Enter>  &= ~<Esc>a
" 大括号自动补齐 输入"{"后按回车键自动补齐"}"并进入插入模式
imap {<Enter> {<Esc>o<tab><Esc>o}<Esc>ka<tab><Esc>lDa
" 小括号自动补齐 输入"("后按回车键自动补齐")"并进入插入模式
" imap (<Enter> ()<Esc>i

" ---常规模式下 quickfix 跳转快捷键
" 使用说明："F9" 上一个要寻找的目标
"			"F10" 下一个要寻找的目标
nmap <F9>   :cp<CR>
nmap <F10>  :cn<CR>

" ---常规模式下 minibufexpl 跳转快捷键
" 使用说明："1" 上一个标签
"			"2" 下一个标签
nmap 1 :bp<CR>
nmap 2 :bn<CR>


map ;e $
map ;h ^

" ---使用复制缓存寄存器进行粘贴
map ;p "0p
map ;P "0P


" ---常规模式下 tab标签页操作
nmap - :tabp<CR>
nmap = :tabn<CR>

" ---常规模式下 定义跳转
nnoremap fo <c-]>

" ---指定数值光标移动
map H 5h
map J 5j
map K 5k
map L 5l

" ---自动跳转到粘贴文本的最后 
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" ---{}/()括号匹配
nmap {	%

" ---高亮光标所在关键字(光标位置不移动)
nmap * *N
" ---黄色高亮visual模式下选中关键字(光标位置不移动)
"  注：/进入命令模式，命令模式不适用<S-Insert>命令，所以要cmap一下
vmap <C-C> 			"+y
cmap <S-Insert> 	<C-R>+
vmap * 				<C-C>/<S-Insert><Enter>N

"显示光标的坐标
set ruler

"高亮整行
set cursorline

"自动缩进
set noautoindent
set cindent
set smartindent

"Tab键的宽度
set shiftwidth=4
set tabstop=4


 
 "设置buffer的主题
  let g:airline_theme='solarized' 

  set laststatus=2  "永远显示状态栏
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1

    if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif 
  
  " unicode symbols
  let g:airline_left_sep = '>>'
  let g:airline_left_sep = '>'
  let g:airline_right_sep = '<<'
  let g:airline_right_sep = '<'


