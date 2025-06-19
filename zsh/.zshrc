# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.

# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '28'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Start tmux if not already in tmux.
# zstyle ':z4h:' start-tmux command tmux -u new -A -D -t z4h
# zstyle ':z4h:' start-tmux command tmux -u new-session -s "z4h-$$"


zstyle ':z4h:' propagate-cwd yes

# Whether to move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'yes'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'
# Tab will accept the selection and immediately open fzf again if the current word isn't fully specified yet
zstyle ':z4h:fzf-complete' fzf-bindings tab:repeat

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'yes'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
# zstyle ':z4h:ssh:pandora-atlas'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'

# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Start ssh-agent if it's not running yet.
zstyle ':z4h:ssh-agent:' start yes

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

# Export environment variables.
export GPG_TTY=$TTY

# Source additional local files if they exist.
z4h source ~/.env.zsh

# Use additional Git repositories pulled in with `z4h install`.
#
# This is just an example that you should delete. It does nothing useful.
# z4h source ohmyzsh/ohmyzsh/lib/diagnostics.zsh  # source an individual file
# z4h load   ohmyzsh/ohmyzsh/plugins/emoji-clock  # load a plugin

# Define key bindings.
z4h bindkey z4h-backward-kill-word  Ctrl+Backspace     Ctrl+H
z4h bindkey z4h-backward-kill-zword Ctrl+Alt+Backspace

z4h bindkey undo Ctrl+/ Shift+Tab  # undo the last command line change
z4h bindkey redo Alt+/             # redo the last undone command line change

z4h bindkey z4h-cd-back    Ctrl+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Ctrl+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Ctrl+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Ctrl+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
function md() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'
alias ll='ls -al'
alias python='python3'
alias vnv='. .venv/bin/activate'

# Pandora Aliases
if [[ "$(hostname)" == "pandora" ]]; then
    alias appdata='cd /mnt/1tbssd/appdata'
    alias dstats='sudo docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"'
    alias dstats-live='sudo docker stats'
    alias dlimits='sudo docker inspect $(sudo docker ps -q) --format "{{.Name}} - CPU: {{.HostConfig.CpuShares}} shares, Memory: {{.HostConfig.Memory}} bytes"'
    alias dps='sudo docker ps -a'
    alias dps-format='sudo docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"'
    alias dlogs='sudo docker logs --tail=50'
    alias dsystem='sudo docker system df'
    alias dcleanup='sudo docker system prune -af && sudo docker volume prune -f'
    alias dcompose-ps='find /opt/docker_compose -name compose.yml -o -name docker-compose.yml | xargs -I {} dirname {} | xargs -I {} sh -c "echo Stack: {} && cd {} && sudo docker compose ps"'
    alias dcompose-restart='find /opt/docker_compose -name compose.yml -o -name docker-compose.yml | xargs -I {} dirname {} | xargs -I {} sh -c "cd {} && sudo docker compose restart"'
    alias dcompose-down='find /opt/docker_compose -name compose.yml -o -name docker-compose.yml | xargs -I {} dirname {} | xargs -I {} sh -c "cd {} && sudo docker compose down"'
    alias dcompose-up='find /opt/docker_compose -name compose.yml -o -name docker-compose.yml | xargs -I {} dirname {} | xargs -I {} sh -c "cd {} && sudo docker compose up -d"'
    alias dcaddy-logs='sudo docker logs caddy --tail 50'
    alias dcaddy-status='sudo docker ps | grep caddy'
    alias dresources='echo Memory: && free -h && echo && echo CPU: && nproc && echo && echo Disk: && df -h && echo && echo Docker: && sudo docker system df'
    alias dmonitor='watch -n 2 "sudo docker stats --no-stream --format \"table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\""'
fi

# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
