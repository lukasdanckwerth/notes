#!/usr/bin/env bash
# set -o xtrace

# ===------------------------------------------------------------------------===
#
#
# Prints Usage
# ===------------------------------------------------------------------------===

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

__pwd="$(pwd)"
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"


# ===------------------------------------------------------------------------===
#
#
# Prints Usage
# ===------------------------------------------------------------------------===
print_usage() {
    echo -e "
usage: NAME <argument> [--help] [--EXAMPLE]

flags:

  \033[1m -h, --help\033[0m   Print this help text and exit
  \033[1m --EXAMPLE\033[0m    DOES SOME EXAMPLE STUFF

"
}

die() {
	echo "${*}"
	exit 0
}



# ===------------------------------------------------------------------------===
#
#
# Parse Command Line
# ===------------------------------------------------------------------------===

while (( $# > 0 ))
do
    case ${1} in
    -h  | --help        ) print_usage;                      exit 0 ;;
          --EXAMPLE     ) EXAMPLE+TAG=1;                     shift ;;
    *                   ) MESSAGE="$MESSAGE ${1}";           shift ;;
   esac
done



# ===------------------------------------------------------------------------===
# 
#
# Precoditions
# ===------------------------------------------------------------------------===

# guard message existene
[ -n "${MESSAGE-}}" ] || die "No mesage."


# exit clean
exit 0
