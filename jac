#!/bin/bash

help() {
  echo "Usage : $(basename "$0") [OPTIONS]"
  echo "Options:"
  echo "  -h, --help      Display this help message"
  echo "  -v, --version   Display version information"

  exit 0
}

version() {
  echo "jac v0.1 - 2024/08/13"

  exit 0
}

if [ -z "$1" ]; then
  help
fi

while getopts ":hv" opt; do
  case ${opt} in
    h) help ;;
    v) version ;;
    \?) echo "Invalid option -$OPTARG" >&2; exit 1 ;;
  esac
done