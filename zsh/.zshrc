DISABLE_UPDATE_PROMPT=true
autoload bashcompinit
bashcompinit
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
source ~/.bash_profile
source ~/.zprofile
eval "$(zoxide init zsh)"
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git poetry python pip pep8 autopep8 virtualenv zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

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

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias rc="code ~/.zshrc"
alias src="source ~/.zshrc"
# Add poetry(~/.local/bin/poetry) to path
path+=~/.local/bin

export DOCKER_DEFAULT_PLATFORM=linux/amd64
eval "$(starship init zsh)"
alias coa='conda activate'
alias cod='conda deactivate'

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
# Define a function instead of an alias
# Source the gpr.sh script to make the gpr function available
if [ -f ~/Projects/dotfiles/zsh/gh-cherry-pick.sh ]; then
  source ~/Projects/dotfiles/zsh/gh-cherry-pick.sh

# Define a function to update the main branch and rebase or merge it into the current feature branch
# Function to update the main branch and optionally rebase or merge it into the current feature branch
gcop() {
    local main_branch="$1"
    local action="${2:-prompt}"  # Default to prompt if no action specified
    local feature_branch="$(git rev-parse --abbrev-ref HEAD)"  # Store the current branch name

    if [[ "$feature_branch" == "$main_branch" ]]; then
        echo "You are already on the '$main_branch' branch."
        return 0
    fi

    # Check for and stash any uncommitted changes
    local stash_needed=false
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Stashing local changes..."
        git stash push --include-untracked -m "Stash before updating $main_branch"
        stash_needed=true
    fi

    # Checkout the main branch and pull the latest changes
    if git checkout "$main_branch" && git pull; then
        echo "Updated '$main_branch' successfully."
    else
        echo "Failed to update '$main_branch'."
        # Restore stashed changes if there was a failure
        if $stash_needed; then
            git stash pop
        fi
        return 1
    fi

    # Switch back to the feature branch
    if git checkout "$feature_branch"; then
        echo "Switched back to '$feature_branch'."
    else
        echo "Failed to switch back to '$feature_branch'."
        # Restore stashed changes if there was a failure
        if $stash_needed; then
            git stash pop
        fi
        return 1
    fi

    # Decide on action based on input or prompt
    if [[ "$action" == "prompt" ]]; then
        echo "Would you like to rebase ('r'), merge ('m'), or skip ('s')?"
        read action
    fi

    case "$action" in
        r | rebase)
            if git rebase "$main_branch"; then
                echo "Rebased '$feature_branch' onto '$main_branch' successfully."
            else
                echo "Failed to rebase. Please resolve conflicts if any and complete the rebase."
                # Note: Don't restore stash here as it could interfere with rebase conflict resolution
                return 1
            fi
            ;;
        m | merge)
            if git merge "$main_branch"; then
                echo "Merged '$main_branch' into '$feature_branch' successfully."
            else
                echo "Failed to merge. Please resolve conflicts if any."
                # Note: Don't restore stash here as it could interfere with merge conflict resolution
                return 1
            fi
            ;;
        s | skip)
            echo "No action taken."
            ;;
        *)
            echo "Invalid action. No action taken."
            ;;
    esac

    # Restore stashed changes if everything succeeded
    if $stash_needed; then
        echo "Restoring stashed changes..."
        git stash pop
    fi
}
# Safely checkout a GitHub pull request while preserving any local changes
# This function will:
# 1. Stash any uncommitted changes
# 2. Checkout the specified PR using GitHub CLI (supports PR number or full URL)
# 3. Restore the stashed changes if any were saved
#
# Usage: ghpr <PR_NUMBER_OR_URL>
# Examples:
#   ghpr 123 - Checks out PR #123, stashing any local changes first
#   ghpr https://github.com/langflow-ai/langflow/pull/8714 - Checks out PR from URL
#   ghpr https://github.com/langflow-ai/langflow/pull/8728/files - Checks out PR from files URL
ghpr() {
    if [ -z "$1" ]; then
        echo "Safely checkout a GitHub PR, stashing and restoring any local changes"
        echo "Usage: ghpr <PR_NUMBER_OR_URL>"
        echo "Examples:"
        echo "  ghpr 123"
        echo "  ghpr https://github.com/langflow-ai/langflow/pull/8714"
        echo "  ghpr https://github.com/langflow-ai/langflow/pull/8728/files"
        return 1
    fi

    local pr_input="$1"
    local pr_number
    local stash_created=false

    # Check if input is a URL and extract PR number (supports /files suffix)
    if [[ "$pr_input" =~ ^https://github\.com/[^/]+/[^/]+/pull/([0-9]+)(/.*)?$ ]]; then
        pr_number="${match[1]}"
        echo "Extracted PR number: $pr_number from URL: $pr_input"
    elif [[ "$pr_input" =~ ^[0-9]+$ ]]; then
        pr_number="$pr_input"
    else
        echo "Error: Invalid input. Please provide a PR number or a valid GitHub PR URL."
        echo "Examples:"
        echo "  ghpr 123"
        echo "  ghpr https://github.com/langflow-ai/langflow/pull/8714"
        echo "  ghpr https://github.com/langflow-ai/langflow/pull/8728/files"
        return 1
    fi

    # Check if there are any changes
    if ! git diff --quiet || ! git diff --cached --quiet; then
        echo "Stashing local changes..."
        git stash push --include-untracked -m "Stash before checking out PR #$pr_number"
        stash_created=true
    fi

    # Get and display PR title
    echo "PR Title: $(gh pr view "$pr_number" --json title --jq '.title')"

    # Checkout the PR
    echo "Checking out PR #${pr_number}..."
    gh pr checkout "${pr_number}"

    # Check if there's anything in the stash and apply it back
    if $stash_created && git stash list | grep "Stash before checking out PR #${pr_number}"; then
        echo "Applying stashed changes..."
        git stash pop
    fi
}

# Auto-handle GitHub PR URLs - just paste the URL directly and it will checkout the PR
# Uses zshaddhistory hook to intercept URLs before they're executed
zshaddhistory() {
    local line="$1"
    # Remove trailing newline and check if it's a GitHub PR URL
    local clean_line="${line%$'\n'}"
    if [[ "$clean_line" =~ ^https://github\.com/[^/]+/[^/]+/pull/([0-9]+)(/.*)?$ ]]; then
        echo "🔄 Detected GitHub PR URL, checking out PR #${match[1]}..."
        # Execute ghpr in a subshell to prevent command leakage
        ghpr "$clean_line"
        return 1  # Prevent the original command from executing
    else
        return 0  # Allow normal processing for other commands
    fi
}

show_diff() {
    # Validate that we have 1 or 2 arguments.
    if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Usage: show_diff [--backend|--frontend|--docs] [--all|--A|--M]"
        return 1
    fi

    local option="$1"
    # Default diff filter is --all if not provided.
    local diff_filter="${2:---all}"

    # Validate the provided component option.
    case "$option" in
        --backend|--frontend|--docs)
            ;;
        *)
            echo "Error: Invalid option '$option'"
            echo "Usage: show_diff [--backend|--frontend|--docs] [--all|--A|--M]"
            return 1
            ;;
    esac

    # Validate the diff_filter option.
    case "$diff_filter" in
        --all|--A|--M)
            ;;
        *)
            echo "Error: Invalid diff filter option '$diff_filter'"
            echo "Usage: show_diff [--backend|--frontend|--docs] [--all|--A|--M]"
            return 1
            ;;
    esac

    # Update tags.
    git fetch --tags

    # Determine the latest stable tag (ignoring any tag containing 'dev').
    local stable_tag
    stable_tag=$(git for-each-ref --sort=creatordate --format '%(refname:short)' refs/tags \
                  | grep -v 'dev' | tail -n1)
    if [ -z "$stable_tag" ]; then
        echo "Error: Unable to determine a stable (non-dev) tag."
        return 1
    fi

    echo "Using stable tag: $stable_tag"

    # Create a new branch from the stable tag.
    local branch_name="diff${option//--/-}"
    if git show-ref --verify "refs/heads/${branch_name}" > /dev/null 2>&1; then
        echo "Branch '$branch_name' already exists. Removing it..."
        git checkout main
        git branch -D "$branch_name"
    fi

    if ! git checkout -b "$branch_name" "$stable_tag"; then
        echo "Error: Could not create branch '$branch_name' from tag '$stable_tag'."
        return 1
    fi

    echo "Overlaying changes from main for $option with diff filter $diff_filter..."

    # Determine file patterns based on the option.
    local -a patterns
    case "$option" in
        --backend)
            patterns=("*.py")
            ;;
        --frontend)
            patterns=("*.js" "*.ts" "*.tsx")
            ;;
        --docs)
            patterns=("docs/")
            ;;
    esac

    # If diff_filter is --all, just checkout all matching files.
    if [ "$diff_filter" = "--all" ]; then
        git checkout main -- "${patterns[@]}"
    else
        # Remove any leading dashes (so '--A' becomes 'A').
        local filter_chars
        filter_chars=$(echo "$diff_filter" | sed 's/^-*//')

        # Get list of files (one per line) matching the filter between stable_tag and main.
        # Using IFS and read to safely capture filenames even if they contain spaces.
        local files=()
        while IFS= read -r file; do
            files+=("$file")
        done < <(git diff --name-only --diff-filter="$filter_chars" "$stable_tag" main -- "${patterns[@]}")

        if [ "${#files[@]}" -eq 0 ]; then
            echo "No files match the filter $diff_filter for $option."
        else
            git checkout main -- "${files[@]}"
        fi
    fi

    echo "Files from main have been staged on branch '$branch_name'."
    echo "Run 'git status' to review the staged changes and inspect them (e.g., with VSCode and GitLens)."
}
function gnew() {
    if [ -z "$1" ]; then
        echo "Usage: gnew <branch_name> [base_branch]"
        return 1
    fi

    # Set base branch - default to main if not provided
    local base_branch=${2:-main}

    # Stash all changes if present
    local changes=$(git status --porcelain)
    if [ -n "$changes" ]; then
        echo "Stashing uncommitted changes..."
        git stash push -m "Auto stash for $1"
    fi

    # Checkout base branch and update
    git checkout "$base_branch"
    git fetch origin
    git pull origin "$base_branch"

    # Create and switch to the new branch
    git checkout -b "$1"

    # Reapply stashed changes if we created a stash
    if git stash list | grep -q "Auto stash for $1"; then
        echo "Reapplying stashed changes..."
        git stash pop
    fi
}

# Function to stash what is currently in the staging area and checkout a branch or tag and then apply the stash
function gcos() {
    # Stash changes
    git stash

    # Check if the argument is a valid branch or tag
    if git rev-parse --verify --quiet "$1" >/dev/null; then
        # Checkout the branch or tag
        git checkout "$1"

        # Apply the stashed changes
        git stash apply
    else
        echo "Error: '$1' is not a valid branch or tag"
        # Pop the stash to restore changes if checkout failed
        git stash pop
        return 1
    fi
}

alias gpl='git push --force-with-lease'

# Kill processes on port(s) - supports multiple ports
kp() {
    if [ $# -eq 0 ]; then
        echo "Usage: kp <port1> [port2] [port3] ..."
        echo "Example: kp 3000 7860 8080"
        return 1
    fi

    for port in "$@"; do
        echo "🔪 Killing processes on port $port..."
        local pids=$(lsof -i tcp:"$port" | awk 'NR!=1 {print $2}')
        if [ -n "$pids" ]; then
            echo "$pids" | xargs kill -9
            echo "✅ Killed processes on port $port"
        else
            echo "❌ No processes found on port $port"
        fi
    done
}

# Kill langflow ports (frontend 3000, backend 7860)
kplf() {
    echo "🚀 Killing Langflow processes..."
    kp 3000 7860
}

# Legacy alias for backwards compatibility
alias kpl='kp 7860 & kp 3000'

autoload -Uz compinit
zstyle ':completion:*' menu select
fpath+=~/.zfunc
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
alias gpp='git pull --rebase && git push'
alias ls='exa --icons -F -H --group-directories-first --git -1'



autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
export PATH="$HOME/istio-1.18.2/bin:$PATH"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export PNPM_HOME="/Users/ogabrielluiz/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Python
PYTHONDONTWRITEBYTECODE=1

# alias for cd into ~/Projects/langflow
alias cdl='cd ~/Projects/langflow'
alias cdl2='cd ~/Projects/langflow2'
alias cdp='cd ~/Projects'
alias cdlf='cd ~/Projects/langflow/src/frontend'
alias cdlb='cd ~/Projects/langflow/src/backend'
alias cdlbb='cd ~/Projects/langflow/src/backend/base'

# ZSH has a quirk where `preexec` is only run if a command is actually run (i.e
# pressing ENTER at an empty command line will not cause preexec to fire). This
# can cause timing issues, as a user who presses "ENTER" without running a command
# will see the time to the start of the last command, which may be very large.

# To fix this, we create STARSHIP_START_TIME upon preexec() firing, and destroy it
# after drawing the prompt. This ensures that the timing for one command is only
# ever drawn once (for the prompt immediately after it is run).

zmodload zsh/parameter  # Needed to access jobstates variable for STARSHIP_JOBS_COUNT

# Defines a function `__starship_get_time` that sets the time since epoch in millis in STARSHIP_CAPTURED_TIME.
if [[ $ZSH_VERSION == ([1-4]*) ]]; then
    # ZSH <= 5; Does not have a built-in variable so we will rely on Starship's inbuilt time function.
    __starship_get_time() {
        STARSHIP_CAPTURED_TIME=$(/opt/homebrew/bin/starship time)
    }
else
    zmodload zsh/datetime
    zmodload zsh/mathfunc
    __starship_get_time() {
        (( STARSHIP_CAPTURED_TIME = int(rint(EPOCHREALTIME * 1000)) ))
    }
fi

# The two functions below follow the naming convention `prompt_<theme>_<hook>`
# for compatibility with Zsh's prompt system. See
# https://github.com/zsh-users/zsh/blob/2876c25a28b8052d6683027998cc118fc9b50157/Functions/Prompts/promptinit#L155

# Runs before each new command line.
prompt_starship_precmd() {
    # Save the status, because subsequent commands in this function will change $?
    STARSHIP_CMD_STATUS=$? STARSHIP_PIPE_STATUS=(${pipestatus[@]})

    # Calculate duration if a command was executed
    if (( ${+STARSHIP_START_TIME} )); then
        __starship_get_time && (( STARSHIP_DURATION = STARSHIP_CAPTURED_TIME - STARSHIP_START_TIME ))
        unset STARSHIP_START_TIME
    # Drop status and duration otherwise
    else
        unset STARSHIP_DURATION STARSHIP_CMD_STATUS STARSHIP_PIPE_STATUS
    fi

    # Use length of jobstates array as number of jobs. Expansion fails inside
    # quotes so we set it here and then use the value later on.
    STARSHIP_JOBS_COUNT=${#jobstates}
}

# Runs after the user submits the command line, but before it is executed and
# only if there's an actual command to run
prompt_starship_preexec() {
    __starship_get_time && STARSHIP_START_TIME=$STARSHIP_CAPTURED_TIME
}

# Add hook functions
autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_starship_precmd
add-zsh-hook preexec prompt_starship_preexec

# Set up a function to redraw the prompt if the user switches vi modes
starship_zle-keymap-select() {
    zle reset-prompt
}

## Check for existing keymap-select widget.
# zle-keymap-select is a special widget so it'll be "user:fnName" or nothing. Let's get fnName only.
__starship_preserved_zle_keymap_select=${widgets[zle-keymap-select]#user:}
if [[ -z $__starship_preserved_zle_keymap_select ]]; then
    zle -N zle-keymap-select starship_zle-keymap-select;
else
    # Define a wrapper fn to call the original widget fn and then Starship's.
    starship_zle-keymap-select-wrapped() {
        $__starship_preserved_zle_keymap_select "$@";
        starship_zle-keymap-select "$@";
    }
    zle -N zle-keymap-select starship_zle-keymap-select-wrapped;
fi

export STARSHIP_SHELL="zsh"

# Set up the session key that will be used to store logs
STARSHIP_SESSION_KEY="$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM"; # Random generates a number b/w 0 - 32767
STARSHIP_SESSION_KEY="${STARSHIP_SESSION_KEY}0000000000000000" # Pad it to 16+ chars.
export STARSHIP_SESSION_KEY=${STARSHIP_SESSION_KEY:0:16}; # Trim to 16-digits if excess.

VIRTUAL_ENV_DISABLE_PROMPT=1

setopt promptsubst

PROMPT='$('/opt/homebrew/bin/starship' prompt --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
RPROMPT='$('/opt/homebrew/bin/starship' prompt --right --terminal-width="$COLUMNS" --keymap="${KEYMAP:-}" --status="$STARSHIP_CMD_STATUS" --pipestatus="${STARSHIP_PIPE_STATUS[*]}" --cmd-duration="${STARSHIP_DURATION:-}" --jobs="$STARSHIP_JOBS_COUNT")'
PROMPT2="$(/opt/homebrew/bin/starship prompt --continuation)"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ogabrielluiz/.cache/lm-studio/bin"

# Added by Windsurf
export PATH="/Users/ogabrielluiz/.codeium/windsurf/bin:$PATH"


# Source API keys if the file exists (create this file separately for sensitive information)
if [ -f "$HOME/.api_keys" ]; then
    source "$HOME/.api_keys"
fi

. "$HOME/.langflow/uv/env"
alias claude="/Users/ogabrielluiz/.claude/local/claude"
