#!/bin/sh
# Usage = sh rsync.sh ./downloads/ user@x.x.x.x:remote_directory
# "./downloads/" = the directory to be synced
# "user@x.x.x.x" = the username and server where files should be synced
# "remote_directory" = the remote directory to which files should be synced

show_header () {
  echo
  echo
  echo "-----------------------------------------------------"
  echo "Periodic rsync v$VERSION"
  echo
  echo "$(date +%H:%M:%S): Syncing files with rsync..."
  echo
}

show_footer () {
  echo
  echo "$(date +%H:%M:%S): Rsync complete"
  echo "------------------------------------------------------"
  echo
}

set_arguments () {
  if [ -z "$1" ] || [ ! -e "$1" ] || [ ! -d "$1" ] || [ -z "$2" ]
  then
    echo "Usage: $0 <local_directory> <remote>:<remote_directory>"
    echo
    echo "Example: $0 ./downloads/ user@x.x.x.x:remote_directory"
    echo
    echo "Wrong command line arguments or another error:"
    echo
    echo "- Directory not provided as argument or"
    echo "- Directory does not exist or"
    echo "- Argument is not a directory or"
    echo "- server was not provided."
    echo
    exit 1
  fi

  LOCAL=$1
  echo "Directory to sync="$LOCAL

  REMOTE=$2
  echo "Remote target="$REMOTE
}

do_rsync () {
  rsync -Pav $LOCAL $REMOTE
}

set_arguments $1 $2
show_header
rsync -Pav $LOCAL $REMOTE
show_footer
