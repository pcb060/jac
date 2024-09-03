#!/usr/bin/env bash

script_dir=$(dirname "$(realpath "$0")")
funcs_dir="$script_dir/funcs"

# SC1090 - https://www.shellcheck.net/wiki/SC1090
# shellcheck source=/dev/null
for file in "$funcs_dir"/*; do
  if [[ -f "$file" && -r "$file" ]]; then
    source "$file"
  fi
done

help() {
  echo "Usage : $(basename "$0") <COMMAND> [ARGS]"
  echo "Commands:"
  echo "  script          Create template script file fitting bash best practices"
  echo "  yadm-force-add  Force add files to yadm that are already in another git repo"
  echo "  ignore          Download template gitignore file for specified language"
  exit 0
}

version() {
  echo "jac version 0.1 - 2024/08/20"

  exit 0
}

# Main logic to handle commands
if [ -z "${1-}" ]; then
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
  script)
    shift
    script "$@"
    ;;
  ignore)
    shift
    ignore "$@"
    ;;
  *)
    echo "Unknown command: $1"
    help
    ;;
esac
