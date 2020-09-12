#!/usr/bin/env zsh

root=${0:A:h}

function self-update {
  local output exit_code

  output=$(cd $root && git pull --ff-only 2>&1)
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo '$ git pull --ff-only'
    echo "$output"
    echo "Updating $root failed with status code $exit_code."
    exit $exit_code
  fi

  if ! [[ $output =~ '^Already up[ -]to[ -]date.$' ]]; then
    echo "$output"
  else
    return 1
  fi

  output=$(cd $root && git submodule update --init --recursive 2>&1)
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    echo '$ git submodule update --init --recursive'
    echo "$output"
    echo "Updating $root failed with status code $exit_code."
    exit $exit_code
  fi

  if [[ -n $output ]]; then
    echo "$output"
  fi
}

if self-update; then
  echo "Updated $root. Restarting..."
  echo
  exec $ZSH_ARGZERO $argv
fi
