# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
# ZSH_THEME="dstufft"
ZSH_THEME="half-life"
# ZSH_THEME="jonathan"
# ZSH_THEME="mikeh"
# ZSH_THEME="apple"
# ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git tmux zsh-autosuggestions svn autojump)
#plugins=(svn)
#plugins=(zsh-syntax-highlighting)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/bin:/usr/bin:/usr/local/bin:"${PATH}"
# export MANPATH="/usr/local/man:$MANPATH"
# export NFS_DIR="~/code/fs_mini"
export NFS_DIR="/home/liuxing/code/fs_mini_mdev"
export KERNEL_DIR="~/code/linux-2.6.22.6"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
 
# huayue add
#命令关键字高亮(导致svn 快捷路径^不能用)
setopt extended_glob
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')

recolor-cmd() 
{
    region_highlight=()
    colorize=true
    start_pos=0
    for arg in ${(z)BUFFER}; do
        ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
        ((end_pos=$start_pos+${#arg}))
        if $colorize; then
            colorize=false
            res=$(LC_ALL=C builtin type $arg 2>/dev/null)
            case $res in
                *'reserved word'*)   style="fg=magenta,bold";;
                *'alias for'*)       style="fg=red,bold";;
                *'shell builtin'*)   style="fg=yellow,bold";;
                *'shell function'*)  style='fg=green,bold';;
                *"$arg is"*)
                    [[ $arg = 'sudo' ]] && style="fg=red,bold" || style="fg=cyan,bold";;
                *)                   style='none,bold';;
            esac
            region_highlight+=("$start_pos $end_pos $style")
        fi
        [[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
        start_pos=$end_pos
    done
}
check-cmd-self-insert() { zle .self-insert && recolor-cmd }
check-cmd-backward-delete-char() { zle .backward-delete-char && recolor-cmd }
zle -N self-insert check-cmd-self-insert
zle -N backward-delete-char check-cmd-backward-delete-char

# ---cd目录后自动ls
function cd {
	    builtin cd "$@" && ls -lta
		}	

# ---相对路径快捷命令(进入相应路径时只要 cd ~xxx)
# hash -d br17_br="/home/huayue/jl_svn/br17/branches/FPGA/dual_single_thread/code"
# hash -d br17_tr="/home/huayue/jl_svn/br17/trunk/FPGA"
# # for svn
# hash -d svn_addr="https://192.168.8.211:9001/svn"
# hash -d svn_addr_br17_branches="https://192.168.8.211:9001/svn/BR17/branches/FPGA/dual_single_thread/code"
# hash -d svn_addr_br17_trunk="https://192.168.8.211:9001/svn/BR17/trunk/FPGA/dual_single_thread/code"
# hash -d svn_addr_br16="https://192.168.8.211:9001/svn/br16_verify"
# # for my git
hash -d git_tool_addr="git@github.com:hhy-ccj/LINUX_TOOL"
# ---快捷命令
alias s="source ~/.zshrc"
alias ll="ls -l"
alias la="ls -al"
alias lt="ls -lat"
alias cp="cp -rf"
alias rm="rm -rf"
alias cls="clear"
alias chsh="chsh -s" #改变当前shell
alias e_sh="echo $SHELL" #显示当前shell
# alias open_destop="startxfce4" #打开linux destop图形界面
alias open_destop="nautilus --no-desktop" #打开linux destop图形界面
alias dswp="find -name \"*.swp\" | xargs rm -rf" #删除当前目录下所有*.swp文件
alias dgit="find -name \".git\" | xargs rm -rf" #删除当前目录下所有.git文件
alias dsync="find -name \"tags\" -o -name \"filenametags\" -o -name \"cscope.out\" -o -name \"cscope.input\" | xargs rm -rf" #删除当前目录下所有同步文件
# alias dsvn="find -name \"tags\" -o -name \"filenametags\" -o -name \"cscope.out\" -o -name \"*.layout\" -o -name \"*.depend\" -o -name \"obj\" -o -name \"*.or32\" -o -name \"*.o\" -o -name \"*.d\" -o -name \"*.swp\" -o -name \"*.lst\" -o -name \"map.txt\" -o -name \"*.lit\" | xargs rm -rf" 
alias dsvn="find -regex '.*\(\.o\|\.d\|\.swp\|\.lit\|\.lst\|\.or32\|\.depend\|\.layout\|tags\|filenametags\|cscope\.out\|cscope.input\|obj\|map\.txt\|output\)' | xargs rm -rf" #删除当前目录下所有临时文件
alias dln="rm -rf .vimrc .vim .oh-my-zsh .zshrc .tmux .tmux.conf"
alias ln="ln -s" #创建快捷方式
# for svn
# alias sll="svn log -l"
# alias slv="svn log -l 1 -v"
# alias si="svn info"
# alias st="svn status"
# alias sh="svn log -r HEAD"
# alias su="svn update"
# alias sr="svn revert -R"
# alias sm="svn merge"
# alias sci="svn ci"
# alias svn_br17="svn co https://192.168.8.211:9001/svn/BR17 ./BR17"
# alias svn_br16="svn co https://192.168.8.211:9001/svn/br16_verify ./BR16"
# alias svn_bt15="svn co https://192.168.8.211:9001/svn/AC4600_SDK ./BT15"
# alias svn_bc51="svn co https://192.168.8.211:9001/svn/BC51 ./BC51"
# # for my git
# alias mgkey="ssh-keygen -t rsa -C \"772958417@qq.com\"" #创建rsa公钥
# alias mg_name="git config --global user.name \"hhy-ccj\"" #设置账户名
# alias mg_mail="git config --global user.email \"772958417@qq.com\"" #设置账户邮箱
# alias mgra="git remote add origin" #定义远程服务器别名origin
# alias mga="git add" #加入本地缓存
# alias mgci="git commit -m" #填写commit信息
# alias mgpush="git push origin master -f" #上传到远程仓库master主线上
# alias mgpull="git pull" #从远程仓库获取最新版本并merge到本地
# alias mgr="git revert HEAD" #取消上次commit
# alias mgd="git diff" #比较本地跟远程的差别
# # 命令备忘
# tree #目录结构查看
# cp -rf ./. xxx/xxx #复制当前文件夹所有文件(包括隐藏)及其向下递归子目录文件(包括隐藏)到xxx/xxx下
# cp -rf ./* xxx/xxx #复制当前文件夹所有文件(包括隐藏)及其向下递归子目录文件(不包括隐藏)到xxx/xxx下
# rm -rf * #删除当前文件夹下所有文件及目录
# find -name "*.h" | xargs -I {} cp {} ./xxx #将当前目录及其子目录下所有*.h文件复制到./xxx文件夹下
# find -type d | xargs rm -rf #删除当前目录下所有文件夹
# find -type d -empty | xargs rm -rf #删除当前目录下所有空文件夹
# hexdump xx #十六进制查看器
# hexdump -C xx #十六进制查看器:显示对应ASCII，类似winhex界面
# linux下使用 du查看某个文件或目录占用磁盘空间的大小
	# du -ah --max-depth=1 	#显示当前目录下所有文件和文件夹(不含子目录)大小，另外：max-depth表示目录的深度
	# du -sh 			   	#显示当前目录所占大小
	# du -sh xxx			#显示xxx文件或者文件夹所占大小

# 环境变量添加
# export PI32V2_TOOLCHAINS="opt/pi32v2/pi32v2-uclinux-toolchains"
# export PI32="/opt/pi32/bin"
# export UBOOT_TOOL="/opt/tools"
export TOOLS="~/.vim/tools"
# export PATH="$PATH:$PI32V2_TOOLCHAINS:$TOOLS:$PI32:$UBOOT_TOOL:/usr/local/arm/4.4.3/bin/"
# export CLANG_COMPILER_RT="$PI32V2_TOOLCHAINS/compiler-rt.a"
# export CLANG="$PI32V2_TOOLCHAINS/pi32v2-uclinux-clang"
# export COMPILER=clang
# export BUILD_DIR=../build_uboot
export PATH=$PATH:/usr/local/arm/gcc-3.4.5-glibc-2.3.6/bin
export PATH=$PATH:~/local/bin
# 终端颜色
if [ "$TERM"=="xterm" ]; then
    export TERM=xterm-256color
fi

# export LANGUAGE=en_US.UTF-8

# tmux工作区间临时文件定位到~/.tmux_workspace_save
export TMPDIR=~/.tmux_workspace_save
#alias tmux_fix='TMPDIR=~/.tmux_workspace_save tmux'

# autojump 配置
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u
