if status is-interactive
end

function fish_greeting
    echo \nThis is the fish shell!\n
    fish_logo
end

set -gx EDITOR nvim
set -gx NVIM_APPNAME nvim-kickstart
set -gx RUSTUP_HOME $HOME/.local/share/rustup
set -gx CARGO_HOME $HOME/.local/share/cargo
set -gx PATH $HOME/.local/bin $HOME/.local/share/cargo/bin $PATH
set -gx FZF_DEFAULT_OPTS "
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

fzf --fish | source
zoxide init fish | source
mise activate fish | source

function l
    eza -lah $argv
end

function lt
    if contains -- -L $argv != 0
        eza -T -h -L 4 $argv
    else
        eza -T -h $argv
    end
end

function vi --description 'neovide passing -g or terminal nvim'
    set idx_gui_arg $(contains -i -- -g $argv)
    if test -n "$idx_gui_arg"
        echo Launching Neovide.
        set -e argv[$idx_gui_arg]
        neovide --fork $argv
    else
        nvim $argv
    end
end

function g
    if test "$(count $argv)" -gt 0
        git $argv
    else
        git status
    end
end

function dotfiles
    set -l base_comm git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"
    if test "$(count $argv)" -gt 0
        $base_comm $argv
    else
        $base_comm status
    end
end

function senv
    set -l env_path .venv/bin/activate.fish
    if test -e $env_path
        source $env_path
        echo "Activating env!"
    else
        echo "`$env_path` not found!"
    end
end
