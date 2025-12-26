# ZINIT--------------------------------------------------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# zinit ice  depth=1
zinit ice lucid wait atload'unalias zi' depth=1
zinit light zsh-users/zsh-syntax-highlighting
zinit light jeffreytse/zsh-vi-mode
zinit snippet OMZP::fzf

# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab

# if which atuin &> /dev/null; then
#     eval "$(atuin init zsh)"
#     echo 123
# fi
#

# if which fzf &> /dev/null; then
#     source <(fzf --zsh)
# fi

if which zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]=none
ZSH_HIGHLIGHT_STYLES[alias]=fg=blue
ZSH_HIGHLIGHT_STYLES[command]=fg=blue

# -------------------------------------------------------------------------------------------------------------------------

autoload -U colors && colors

setopt autocd
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_resume
setopt nobeep

setopt extendedglob
setopt append_history
setopt share_history
setopt histignorealldups

# Needs to be enabled for the prompt to change
setopt prompt_subst

if [[ "$CODER" == "true" ]]; then
    HISTFILE=/workspaces/.zsh-histfile
else
    HISTFILE=~/.zsh-histfile
fi
HISTSIZE=10000
SAVEHIST=10000

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

# completion __------------------------------------------------------------------------------------------------------------
fpath[1,0]=~/.zsh/completion/
autoload -U compinit && compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# -------------------------------------------------------------------------------------------------------------------------

# key bindings ------------------------------------------------------------------------------------------------------------
# bindkey -v

bindkey '^R' history-incremental-search-backward
bindkey '^T' history-incremental-search-forward

bindkey '\e.' insert-last-word

bindkey '^[[H'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey "\e[3~" delete-char

# under TMUX
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line

insert-last-command-output() {
    LBUFFER+="$(eval $history[$((HISTCMD-1))] | head -1)"
}

zle -N insert-last-command-output
bindkey "^K" insert-last-command-output
# -------------------------------------------------------------------------------------------------------------------------

# aliases -----------------------------------------------------------------------------------------------------------------
# if [ "$(uname)" = "Darwin" -o "$(uname)" = "FreeBSD" ]; then
#     alias ls='ls -G'
# else
#     alias ls='ls --color'
# fi
alias less='less -R'
alias grep='grep --color'
alias bc='bc -lq'
# alias vi='nvim'
alias v='nvim'

alias .='cd ../'
alias ..='cd ../../'
alias ...='cd ../../../'
alias ....='cd ../../../../'

alias -g L="| less"
alias -g DD='>/dev/null'

mkcd () {
    mkdir -p "$@" && cd "$@";
}

if which eza &> /dev/null; then
  export EZA_COLORS="xx=0:uu=0:uR=0;31:un=0;34:sn=0:ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0:da=0:BUILD=32"
  alias l='eza --git -l -a'
  alias lt='eza --tree --level=2 --long --git'
else
  export LSCOLORS=exfxcxdxcxegedabagacad
  alias l='ls -laFh'
fi

alias coder_dotfiles='coder dotfiles https://github.com/ferrr/dotfiles.git'

ssh_tmux() {
  ssh -A -t "$@" 'bash --login -i -c "exec tmux -- new -A -s main"'
}
alias ssh-tmux='ssh_tmux'
# -------------------------------------------------------------------------------------------------------------------------

# bazel -------------------------------------------------------------------------------------------------------------------
alias bz='bazelisk'

bzq() {
    bz query  --noimplicit_deps --output location --xml:line_numbers //... | \
       fzf --delimiter=" " --with-nth=4 --preview="~/.fzf_bz_preview.sh {}" --border=none --preview-window noborder | \
       awk -F' ' '{print $4}'
}

# -------------------------------------------------------------------------------------------------------------------------

# git ---------------------------------------------------------------------------------------------------------------------

function chpwd_update_git_vars() {
    update_current_git_vars
}

function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook precmd precmd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    local gitstatus="$HOME/.gitstatus.py"
    _GIT_STATUS=$(python3 ${gitstatus} 2>/dev/null)
     __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
    GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
    GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
    GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
    GIT_STAGED=$__CURRENT_GIT_STATUS[4]
    GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
    GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
    GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
    GIT_STASHED=$__CURRENT_GIT_STATUS[8]
    GIT_CLEAN=$__CURRENT_GIT_STATUS[9]
    GIT_DELETED=$__CURRENT_GIT_STATUS[10]

    # if [ -z ${ZSH_THEME_GIT_SHOW_UPSTREAM+x} ]; then
    #     GIT_UPSTREAM=
    # else
    #     GIT_UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) && GIT_UPSTREAM="${ZSH_THEME_GIT_PROMPT_UPSTREAM_SEPARATOR}${GIT_UPSTREAM}"
    # fi
}

git_super_status() {
    precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH$GIT_UPSTREAM%{${reset_color}%}"
      if [ "$GIT_BEHIND" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND%{${reset_color}%}"
      fi
      if [ "$GIT_AHEAD" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD%{${reset_color}%}"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
      if [ "$GIT_STAGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED%{${reset_color}%}"
      fi
      if [ "$GIT_CONFLICTS" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS%{${reset_color}%}"
      fi
      if [ "$GIT_CHANGED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED%{${reset_color}%}"
      fi
      if [ "$GIT_DELETED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_DELETED$GIT_DELETED%{${reset_color}%}"
      fi
      if [ "$GIT_UNTRACKED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED$GIT_UNTRACKED%{${reset_color}%}"
      fi
      if [ "$GIT_STASHED" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STASHED$GIT_STASHED%{${reset_color}%}"
      fi
      if [ "$GIT_CLEAN" -eq "1" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
      fi
      STATUS="$STATUS%{${reset_color}%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
      echo "$STATUS"
    fi
}

# Default values for the appearance of the prompt.
ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[blue]%}%{+%G%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[blue]%}%{-%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}%{…%G%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg_bold[blue]%}%{⚑%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}%{✔%G%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SEPARATOR="->"
# -------------------------------------------------------------------------------------------------------------------------

# PROMPT ------------------------------------------------------------------------------------------------------------------
function get_hostname_abbr {
    local hname=$(hostname | cut -d. -f1)

    # fix for coder long hostname
    if [[ "$CODER" == "true" ]]; then
        local parts=("${(@s/-/)hname}")
        echo "coder[${parts[-1]}]"
    else
        echo "$hname"
    fi
}

local hostname_abbr=$(get_hostname_abbr)
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)%{$reset_color%}"
local hostname="%(!.%F{red}.%F{default})${hostname_abbr}%{$reset_color%}"
local curdir="%{$fg_bold[default]%}%c%{$reset_color%}"
PROMPT='${ret_status}${hostname}:${curdir}$(git_super_status)%{$reset_color%} '
RPROMPT=$'%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})'

# set up tab title
precmd () {
    local hostname_abbr=$(get_hostname_abbr)
    print -Pn "\e]0;$hostname_abbr:%c\a"
}
# -------------------------------------------------------------------------------------------------------------------------
