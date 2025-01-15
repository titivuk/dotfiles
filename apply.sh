#!/bin/bash

set -e # exit as soon as any command returns non-zero code

SCRIPT_DIR="$( cd "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

main() {
    # additional OR required for files missing last empty line
    # if empty line is missing, last value is written into $row
    # but loop exited
    # 'test -n' checks if length is non-zero
    while read -r row || [[ -n "$row" ]]; do
        if [[ ${row::1} == '#' ]]; then
            continue
        fi

        source=$(echo $row | cut -d '|' -f 1)
        dest=$(echo $row | cut -d '|' -f 2)

        symlink $source $dest
    done < $1
}

symlink() {
    source="$SCRIPT_DIR/$1"
    dest="$HOME/$2"
    
    mkdir -p $(dirname $dest)

    # 'man test' to see all available flags

    # check if dest is a symlink
    if [ -L $dest ]; then
        echo "[WARN] Skip. \"$dest\" is a symlink"
        return
    fi

    # check if dest exists
    if [ -e "$dest" ]; then
        echo "[WARN] Skip. \"$dest\" already exists"
        return
    fi

    ln -s $source $dest
    echo "[INFO] symlink \"$dest\" created for \"$source\""
}

main $1