#!/bin/bash

after_create() {
  echo 'after_create'
  bundle install
}

after_start() {
  echo 'after_start'
}

after_attach() {
  echo 'after_attach'
  ssh -T 'git@github.com' 2>&1 | grep "^Hi [-_A-Za-z0-9]*! You've successfully authenticated, but GitHub does not provide shell access.$" -
}

run() {
  echo 'run' 
  local -r stage="$1"

  case "$stage" in
    'CREATE')
      after_create
      ;;
    'START')
      after_start
      ;;
    'ATTACH')
      after_attach
      ;;
  esac
}

run "$@"
