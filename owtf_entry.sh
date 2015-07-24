#! /bin/bash
# @param : --help (-h) echos the usage of running the dockerfile
# @param : --update (-u) installs the optional dependencies

function parse_arg {
  if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage : $0 [OPTIONS]" >&2
    echo "-h, --help\n\tDisplay help and exit" >&2
    echo "-u, --update\n\tInstall optional dependencies" >&2
    return
  fi

  if [[ "$1" == "--update" ]] || [[ "$1" == "-u" ]]; then
    echo "Installing optional dependencies ..." >$2
    exec /usr/local/bin/optional_tools.sh
    echo "OWTF optional dependencies were successfully installed" >$2
  fi

}

if [ $# -gt 0 ]; then
  for arg in "$@"
  do
    if [ "$arg" == "-"* ]; then
      parse_arg $arg
    fi
  done
fi

python /usr/local/bin/owtf.py
