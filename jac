#!/usr/bin/env bash

VERSION=0.2

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
  echo "  scr|script                 $(_jac_describe_script)"
  echo "  yfa|yadm-force-add         $(_jac_describe_yadm-force-add)"
  echo "  ign|ignore                 $(_jac_describe_ignore)"
  echo "  fad|for-all-directories    $(_jac_describe_for-all-directories)"
  echo "  hrs|human-readable-size    $(_jac_describe_human-readable-size)"
  echo "  -v, --version              Print jac version"
  echo "  -h, --help                 Show this help message"
  exit 0
}

version() {
  echo "jac version $VERSION"
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
  yfa|yadm-force-add)
    shift
    yadm-force-add "$@"
    ;;
  scr|script)
    shift
    script "$@"
    ;;
  ign|ignore)
    shift
    ignore "$@"
    ;;
  fad|for-all-directories)
    shift
    for-all-directories "$@"
    ;;
  hrs|human-readable-size)
    shift
    human-readable-size "$@"
    ;;
  *)
    echo "Unknown command: $1"
    help
    ;;
esac
