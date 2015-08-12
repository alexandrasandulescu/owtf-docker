#! /bin/bash
# @param : --help (-h) echos the usage of running the dockerfile
# @param : --update (-u) installs the optional dependencies

function parse_arg {
  if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage : $0 [OPTIONS]" >&2
    echo -e "-h, --help\n\tDisplay help and exit" >&2
    echo -e "-u, --update\n\tInstall optional dependencies" >&2
    return
  fi

  if [[ "$1" == "--update" ]] || [[ "$1" == "-u" ]]; then
    echo "Installing optional dependencies ..." >&2
    /bin/bash $OWTF_OPTIONAL_TOOLS
    echo "OWTF optional dependencies were successfully installed" >&2
  fi

}
if [ $# -gt 0 ]; then
  for arg in "$@"
  do
    parse_arg $arg
    if [[ "$arg" == "--help" ]] || [[ "$arg" == "-h" ]]; then
        exit 0
    fi
  done
fi

# Start postgres server and configure db.
/bin/bash $POSTGRES_ENTRY owtf

# Run owtf.
python owtf/owtf.py
