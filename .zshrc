ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search pyenv)

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
source /usr/local/bin/virtualenvwrapper.sh

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# chainin pip to pip3
alias pip=pip3

# Load rbenv if installed (to manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}" # Needed for Linux/WSL
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Load pyenv (to manage your Python versions)
#export PYENV_VIRTUALENV_DISABLE_PROMPT=1
#type -a pyenv > /dev/null && eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)" && RPROMPT+='[🦑 $(pyenv_prompt_info)]'

# Load nvm (to manage your node versions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Call `nvm use` automatically in a directory with a `.nvmrc` file
autoload -U add-zsh-hook
load-nvmrc() {
  if nvm -v &> /dev/null; then
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use --silent
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  fi
}
type -a nvm > /dev/null && add-zsh-hook chpwd load-nvmrc
type -a nvm > /dev/null && load-nvmrc

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export BUNDLER_EDITOR=code
export EDITOR=code

# Set ipdb as the default Python debugger
export PYTHONBREAKPOINT=ipdb.set_trace
export PATH=/opt/homebrew/bin:./bin:./node_modules/.bin:/Users/alfredosuarez/.pyenv/plugins/pyenv-virtualenv/shims:/Users/alfredosuarez/.pyenv/shims:/Users/alfredosuarez/.rbenv/bin:/Users/alfredosuarez/.pyenv/plugins/pyenv-virtualenv/shims:/Library/Frameworks/Python.framework/Versions/3.11/bin:/Library/Frameworks/Python.framework/Versions/3.10/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Users/alfredosuarez/.pyenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Users/alfredosuarez/.cargo/bin:/usr/local/sbin

# Created by `userpath` on 2022-12-20 09:16:35
export PATH="$PATH:/Users/alfredosuarez/.local/bin"

# Created by `pipx` on 2022-12-20 09:17:24
export PATH="$PATH:/Users/alfredosuarez/Library/Python/3.10/bin"

# python3 Alias
alias python="python3"

export SDKROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"

# pipx
export PATH="~/.local/bin:$PATH"

### Add these next lines to protect your system python from
### pollution from 3rd-party packages

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=false

# commands to override pip restriction above.
# use `gpip` or `gpip3` to force installation of
# a package in the global python environment
# Never do this! It is just an escape hatch.
gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
gpip3(){
   PIP_REQUIRE_VIRTUALENV="" pip3 "$@"
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

function venv() {
    create_project=$1
    if [ -z "$create_project" ]; then
        create_project=false
    fi

    if [ -d "./.venv" ]; then
        echo "Activating existing virtual environment..."
        source .venv/bin/activate
    else
        echo "Creating virtual environment..."
        python3 -m venv .venv
        source .venv/bin/activate
    fi

    if [ "$create_project" = true ]; then
        echo "Creating project directory structure..."
        mkdir -p src tests .github/workflows
        touch src/__init__.py tests/__init__.py src/main.py tests/test_main.py pyproject.toml .gitignore

        echo "Creating GitHub Actions workflow..."
        echo "name: Python CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Set up Python \${{ matrix.python-version }}
      uses: actions/setup-python@v2
      with:
        python-version: \${{ matrix.python-version }}
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install poetry
        poetry install
    - name: Run tests
      run: pytest" > .github/workflows/main.yml

    fi

    if [ -f "./pyproject.toml" ]; then
        echo "Installing dependencies with Poetry..."
        poetry install
    else
        echo "Creating pyproject.toml..."
        poetry init -n
    fi
}
