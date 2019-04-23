function auto_install_rbenv() {
  if [[ -f .ruby-version ]]; then
    local ruby_version=$(cat .ruby-version)
    local rbenv_root
    [ -n "${RBENV_ROOT}" ] && rbenv_root=${RBENV_ROOT} || rbenv_root=${HOME}/.rbenv
    if [[ ! -d "${rbenv_root}/versions/$ruby_version" ]]; then
      echo "rbenv install $ruby_version"
      rbenv update
      rbenv install "${ruby_version}"
      return $?
    fi
  fi
}

function cd() {
  builtin cd "$@" && auto_install_rbenv
  return $?
}

auto_install_rbenv
