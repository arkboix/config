###
# https://fishshell.com/docs/current/index.html
# https://github.com/jorgebucaran/cookbook.fish

set fish_greeting

# themes

# colors to set or unset
set fish_color_autosuggestion "#5c6370"
set fish_color_cancel -r
set fish_color_command "#61afef"
set fish_color_comment "#7f848e"
set fish_color_cwd "#98c379"
set fish_color_cwd_root "#e06c75"
set fish_color_end "#c678dd"
set fish_color_error "#e06c75"
set fish_color_escape "#d19a66"
set fish_color_history_current --bold
set fish_color_host "#98c379"
set fish_color_host_remote "#d19a66"
set fish_color_match --background="#61afef"
set fish_color_normal normal
set fish_color_operator "#d19a66"
set fish_color_param "#61afef"
set fish_color_quote "#98c379"
set fish_color_redirection "#c678dd"
set fish_color_search_match "#e5c07b" --background="#282c34"
set fish_color_selection "#ffffff" --bold --background="#3e4451"
set fish_color_status "#e06c75"
set fish_color_user "#98c379"
set fish_color_valid_path --underline
set fish_pager_color_completion normal
set fish_pager_color_description "#e5c07b" "#d19a66"
set fish_pager_color_prefix normal --bold --underline
set fish_pager_color_progress "#ffffff" --background="#61afef"
set fish_color_search_match --background="#61afef"



# Set XDG variables for Fish shell in Sway
set -Ux QT_QPA_PLATFORM wayland
set -Ux XDG_CURRENT_DESKTOP sway
set -Ux XDG_SESSION_DESKTOP sway
set -Ux XDG_CURRENT_SESSION sway
set -Ux XDG_SESSION_TYPE wayland
set -Ux GDK_BACKEND wayland,x11
set -Ux MOZ_ENABLE_WAYLAND 1
set LC_CTYPE en_US.utf8
set -e GDK_BACKEND


# Starship
#starship init fish | source

# Fastfetch

function random_positive_message
    set quotes \
        "Every day is a fresh start." \
        "You're stronger than you think." \
        "The best way out is always through." \
        "Do what you can, with what you have, where you are." \
        "Small steps every day lead to big changes." \
        "You are enough, just as you are." \
        "Difficult roads often lead to beautiful destinations." \
        "Failure is just another step towards success." \
        "You have survived 100% of your bad days." \
        "Growth begins at the end of your comfort zone." \
        "Your potential is limitless." \
        "Be the reason someone smiles today." \
        "It always seems impossible until it's done." \
        "Your mindset is your superpower." \
        "The only time you fail is when you stop trying." \
        "Focus on progress, not perfection." \
        "Storms make trees take deeper roots." \
        "Believe you can, and you're halfway there." \
        "You are the artist of your own life." \
        "Every challenge is an opportunity to grow." \
        "No rain, no flowers." \
        "Nothing worth having comes easy." \
        "Make today count." \
        "Keep going. You’re getting there." \
        "You can do hard things." \
        "Happiness is a choice you make every day." \
        "Your only limit is you." \
        "One day at a time." \
        "The sun will rise, and we will try again." \
        "Even the darkest night will end and the sun will rise." \
        "Strength grows in the moments you think you can't go on." \
        "You are capable of amazing things." \
        "No pressure, no diamonds." \
        "Dream big, start small, act now." \
        "You are someone’s reason to smile." \
        "Great things never come from comfort zones." \
        "Doubt kills more dreams than failure ever will." \
        "Act as if what you do makes a difference. It does." \
        "Mistakes are proof that you are trying." \
        "Your vibe attracts your tribe." \
        "Just keep swimming." \
        "Don't be afraid to shine." \
        "Nothing can dim the light that shines from within." \
        "Keep moving forward." \
        "Don't watch the clock; do what it does. Keep going." \
        "Be yourself; everyone else is already taken." \
        "Take the risk or lose the chance." \
        "Success is the sum of small efforts, repeated daily." \
        "Your future is created by what you do today." \
        "The only way to do great work is to love what you do."

    # Pick a random quote
    set choice (random 1 (count $quotes))
    echo $quotes[$choice]
end

# Call it on shell startup
echo
#random_positive_message
bash ~/Projects/ColorScripts/run.sh



## Aliases


# Update
alias update='sudo pacman -Syu'
alias up='update'


# List
alias ls='exa --icons -a --group-directories-first'
alias ll='exa -l --icons'
alias la='exa -la --icons'
alias l='ls'


# Random Wallpapers
alias rwall='swww img ~/wallpapers-dt/$(ls ~/wallpapers-dt | shuf -n 1)'

# Navigation

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias mkdir='mkdir -p'
alias rmd='rm -r'
alias mv='mv -i'
alias cp='cp -i'
alias df='df -h'
alias du='du -ch'
alias findbig='du -ahx . | sort -rh | head -20'
alias f='fd' # `fd` is a better `find`
alias searchf='fd -H'
alias grep='grep --color=auto'


# Safety

alias rm='rm -i'
alias trs='trash'
alias mv='mv -i'
alias cp='cp -i'


# Git

alias g='git'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gs='git status'
alias gd='git diff'
alias gr='git restore'
alias gco='git checkout'
alias gb='git branch'
alias gf='git fetch'
alias grh='git reset --hard'
alias gclean='git clean -fd'


# Fun

alias cow='cowsay "Use Fish, not Bash!"'
alias weather='curl wttr.in'
alias fuck="sudo"
alias shrug="echo '¯\_(ツ)_/¯'"
alias flip="echo '(╯°□°）╯︵ ┻━┻'"
alias unflip="echo '┬─┬ノ( º _ ºノ)'"
alias groot="echo 'I am Groot'"
alias insult="curl -s https://evilinsult.com/generate_insult.php?lang=en"
alias matrix='cmatrix -C green'

# More Package Manager

alias p='sudo pacman'
alias a='paru'
alias n='--needed'
echo










function fish_prompt
    set user (whoami)
    set host (hostname -s)
    set dir (prompt_pwd)

    set_color normal
    echo -n '['
    set_color green
    echo -n "$user@$host"
    set_color normal
    echo -n ' '
    set_color cyan
    echo -n "$dir"
    set_color normal
    echo -n ']$ '
end













function !!
    eval (history --max=1)
end
