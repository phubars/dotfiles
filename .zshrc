# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/phuhuynh/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colorize)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

# Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'
alias vim='mvim -v'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# set terraform role for bastion account
export TERRAFORM_EXEC_ROLE=Operations
export TF_VAR_terraform_exec_role=Operations

# export TERRAFORM_EXEC_ROLE=PowerUser
# export TF_VAR_terraform_exec_role=PowerUser

# export TERRAFORM_EXEC_ROLE=Administrator
# export TF_VAR_terraform_exec_role=Administrator

# set go path
export PATH=$PATH:$(go env GOPATH)/bin

# set npm token
# .zshrc or .zshenv or .bashrc
npm-token() {
	echo `awk -F\= '{gsub(/"/,"",$2);print $2}' ~/.npmrc`
}
export NPM_TOKEN="$(npm-token)"

# java env
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# python env
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"

# jwts
function jwt-decode() {
  sed 's/\./\n/g' <<< $(cut -d. -f1,2 <<< $1) | base64 --decode | jq
}

# hs-ops-tools
export PATH=$PATH:$(python -c 'import site; print(site.USER_BASE + "/bin")')

# color output
red=`tput setaf 1`
green=`tput setaf 2`
blue=`tput setaf 4`
yellow=`tput setaf 3`
reset=`tput sgr0`

##### CHANGE DIRECTORY HOOKS #####
autoload -U add-zsh-hook
# set node version
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
# set personal AWS_PROFILE
load-personal-aws() {
  local personal_profile='personal'
  local workspace_dir='personal_workspace'
  local cur_dir=$(pwd)

  if [[ $cur_dir =~ .*$workspace_dir.* && $AWS_PROFILE != $personal_profile ]]; then
    echo "${yellow}setting AWS_PROFILE=$personal_profile${reset}"
    export AWS_PROFILE=$personal_profile
  elif [[ ! $cur_dir =~ .*$workspace_dir.* && ! -z $AWS_PROFILE ]]; then
    echo "${yellow}unsetting AWS_PROFILE${reset}"
    unset AWS_PROFILE
  else
    # do nothing
  fi
}

# set terraform version
tfenv_find_terraform_version() {
  local version="$(pwd)/.terraform-version"
  if [ -e $version ]; then
    head -n1 $version
  fi
}

load-terraform-version() {
  local terraform_version=$(tfenv_find_terraform_version)
  if [ ! -z $terraform_version ]; then
    tfenv use $terraform_version
  fi
}


# load venv
load-venv() {
  local green=`tput setaf 2`
  local yellow=`tput setaf 3`
  local magenta=`tput setaf 5`
  local reset=`tput sgr0`
  local cur_dir=$(pwd)
  local venv_activate="$(pwd)/venv/bin/activate"
  if [ -e $venv_activate ]; then
    echo "${yellow}Found a python virtual environment${reset}"
    source venv/bin/activate
    echo "${green}Loaded python venv for ${magenta}$cur_dir/venv${reset}"
  fi
}

add-zsh-hook chpwd load-venv
add-zsh-hook chpwd load-nvmrc
# add-zsh-hook chpwd load-personal-aws
add-zsh-hook chpwd load-terraform-version

load-nvmrc
load-personal-aws

#key bindings
bindkey '^h' kill-word
bindkey '^w' backward-kill-word
bindkey '^f' forward-word
bindkey '^b' backward-word


export TF_VAR_pagerduty_user_token="u+fknQd1Dsfm8VoLHAZQ"
