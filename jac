#!/usr/bin/env bash

help() {
  echo "Usage : $(basename "$0") <COMMAND> [ARGS]"
  echo "Commands:"
  echo "  yadm-force-add  Force add files to yadm that are already in another git repo"
  exit 0
}

version() {
  echo "jac version 0.1 - 2024/08/20"

  exit 0
}

yadm_force_add() {
  # A workaround for a bug where yadm won't add files
  # already in another git repo (probably a git issue).
  #
  # https://github.com/TheLocehiliosan/yadm/issues/361
  #
  # Run this from the base dir with the conflicting .git/ in it.
  # Example:
  #
  #     ~/.oh-my-zsh $ myscript yadm-force-add custom/plugins/install.sh

  # Must be in the root git dir.
  if [[ ! -d ".git" ]]; then
      echo
      echo "Run from the conflicted .git repo base dir."
      echo "(I'm looking for a .git/ dir.)"
      echo
      exit 1
  fi

  tmpdir=/tmp/tmp.git

  if [[ -d $tmpdir ]]; then
      echo
      echo "Yo the temp dir already exists. Did I crash?"
      echo "Please reconcile: $tmpdir"
      echo
      exit 1
  fi

  # Git is just files.
  # So just move the .git dir away for a second.
  mv .git $tmpdir

  # yadm will respect the other repo's .gitignore file
  # so be sure to move that too.
  tmpignore=/tmp/tmp.gitignore

  if [[ -e ".gitignore" ]]; then
      mv .gitignore $tmpignore
  fi

  # Should work now.
  yadm add "$1"

  # Put the .git dir back.
  mv $tmpdir .git

  # Put the .gitignore back (if it existed).
  if [[ -e $tmpignore ]]; then
      mv $tmpignore .gitignore
  fi

  # Show the yadm status, hopefully with a successfully added file.
  yadm status
}

# Main logic to handle commands
if [ -z "$1" ]; then
  help
fi

case "$1" in
  -h|--help)
    help
    ;;
  -v|--version)
    version
    ;;
  yadm-force-add)
    shift
    yadm_force_add "$@"
    ;;
  *)
    echo "Unknown command: $1"
    help
    exit 1
    ;;
esac
