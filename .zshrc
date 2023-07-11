ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(git gitfast last-working-dir common-aliases zsh-syntax-highlighting history-substring-search pyenv)
export HOMEBREW_NO_ANALYTICS=1
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
ZSH_DISABLE_COMPFIX=true
source "${ZSH}/oh-my-zsh.sh"
unalias rm
alias pip=pip3
export PATH="${HOME}/.rbenv/bin:${PATH}"
type -a rbenv > /dev/null && eval "$(rbenv init -)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
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
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BUNDLER_EDITOR=code
export EDITOR=code
export PYTHONBREAKPOINT=ipdb.set_trace
export PATH="$PATH:/Users/alfredosuarez/.local/bin"
export PATH="$PATH:/Users/alfredosuarez/Library/Python/3.10/bin"
alias python="python3"
export SDKROOT="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk"
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
        source .venv/bin/activate
    else
        python3 -m venv .venv
        source .venv/bin/activate
    fi
    if [ "$create_project" = true ]; then
        mkdir -p src tests .github/workflows
        touch src/__init__.py tests/__init__.py src/main.py tests/test_main.py pyproject.toml .gitignore
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
        poetry install
    else
        poetry init -n
    fi
}

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"