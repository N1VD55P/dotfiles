# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"
export PATH="/snap/bin:$PATH"
# Enable command auto-correction
ENABLE_CORRECTION="true"

# Plugins - ONLY ONE plugins=() declaration!
# Remove duplicates and combine all plugins here
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    fzf-tab
)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# FZF integration (if installed)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# User configuration
# Preferred editor
export EDITOR='nvim'

# Custom aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias vim="nvim"
alias vi="nvim"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
