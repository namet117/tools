#!/bin/bash


doFunc ()
{
    release_info_file=/etc/os-release;
    test -f $release_info_file;

    if [ $? == '0' ]; then
        source $release_info_file;
    fi
}


doFunc;

exit 0;
