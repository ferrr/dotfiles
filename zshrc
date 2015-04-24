# key bindings
bindkey -v

bindkey '^R' history-incremental-search-backward
bindkey '^T' history-incremental-search-forward

bindkey '\e.' insert-last-word

bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey "\e[3~" delete-char

insert-last-command-output() {
    LBUFFER+="$(eval $history[$((HISTCMD-1))] | head -1)"
}

zle -N insert-last-command-output
bindkey "^K" insert-last-command-output

# -------------------------------------------------------------------------------------------------------------------------
autoload -U compinit
compinit

autoload -U colors && colors

#setopt correctall
setopt autocd
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_resume
setopt nobeep

setopt extendedglob
setopt append_history share_history histignorealldups

zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}


autoload -Uz vcs_info

# Needs to be enabled for the prompt to change
setopt prompt_subst

# Formats
VCS_FORMAT="%{$fg[yellow]%}%b%{$reset_color%} "

zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*' formats $VCS_FORMAT

precmd () {
    vcs_info 2>/dev/null

    PS1_STR=""
    PS1_STR="${PS1_STR}%{$fg[blue]%}%n%{$reset_color%}@"  #user
    PS1_STR="${PS1_STR}%{$fg[green]%}%m%{$reset_color%}" #hostname
    PS1_STR="${PS1_STR}[%{$reset_color%}%{$fg[blue]%}%~%{$reset_color%}]" #folder
    PS1_STR="${PS1_STR}${vcs_info_msg_0_} "

    TITLE="%m:%~"
    print -Pn "\033];$TITLE\007"
}

#export PS1='${PS1_STR}'
PROMPT='%{$fg_bold[green]%}%%%{$reset_color%} %{$fg[gray]%}%m%{$fg_bold[green]%}%p %{$fg_bold[white]%}%c %{$fg_bold[blue]%}%{$fg_bold[blue]%}%{$reset_color%}${vcs_info_msg_0_}'
RPROMPT=$'%(?..%{$fg_bold[red]%}[ %? ]%{$reset_color%})'

HISTFILE=~/.zsh-histfile
HISTSIZE=10000
SAVEHIST=10000

# -------------------------------------------------------------------------------------------------------------------------
if [ "$(uname)" = "Darwin" -o "$(uname)" = "FreeBSD" ]; then
    alias ls='ls -G'
else
    alias ls='ls --color'
fi
alias l='ls -lFh'
alias less='less -R'
export LSCOLORS=exfxcxdxcxegedabagacad
alias grep='grep --color'
alias bc='bc -lq'

alias .='cd ../'
alias ..='cd ../../'
alias ...='cd ../../../'
alias ....='cd ../../../../'

alias ccat='pygmentize -g -f console256 -O style=native'
alias json='python -mjson.tool'
alias xml='xmllint --format --encode utf8 --nonet -'
alias -g L="| less"
alias -g DD='>/dev/null'

alias -g math="rlwrap /Applications/Mathematica.app/Contents/MacOS/MathKernel"
alias -g diffs="hg st | sed -nE 's/^[MARC] //p' | xargs -I {} hg di {}"

# -------------------------------------------------------------------------------------------------------------------------
mkcd () {
    mkdir -p "$@" && cd "$@";
}

gs() {
    ext="*.$1"
    str="$2"
    shift 2

    grep --color -Rn --include=$ext $str $@ .
}

scr() {
    if screen -ls | grep -q Main; then
        screen -xr Main
    else
        screen -S Main
    fi
}

drop() {
    # create dropbox public url for recent files
    n=${1:-1}
    ~/.config/generate-dropbox-pub-url.py -i 1591107 -f "$(ls -1t ~/Dropbox/Public/temp/ | head -$n | tail -1)"
}

# -------------------------------------------------------------------------------------------------------------------------
export EDITOR=/usr/bin/vim
export DEBEMAIL=rnefyodov@yandex-team.ru
export DEBFULLNAME="Roman Nefyodov"
export YANDEX_BUILD=~/yandex-build

export MANPAGER='bash -c "vim -MRn -c \"set ft=man nomod nolist nospell nonu\" \
    -c \"nm q :qa!<CR>\" -c \"nm <end> G\" -c \"nm <home> gg\"</dev/tty <(col -b)"'

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# -------------------------------------------------------------------------------------------------------------------------
# section for ssh key forwarding
#

if [ $(uname) = "Darwin" ]; then
    ssh_env="$HOME/.ssh/environment"

    start_agent() {
         echo "Initialising new SSH agent..."
         ssh-agent | sed 's/^echo/#echo/' >"${ssh_env}"
         source "${ssh_env}"
         ssh-add
    }

    if [ -f "${ssh_env}" ]; then
         source "${ssh_env}"
         [ -n "$SSH_AGENT_PID" ] && ps -p "$SSH_AGENT_PID" >/dev/null || start_agent
    else
         start_agent
    fi
fi
# -------------------------------------------------------------------------------------------------------------------------
