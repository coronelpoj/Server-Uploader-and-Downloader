#!/bin/bash

usage() {
    echo "Usage: sh run_file_transfer.sh [ local-to-server | server-to-local | all ]"
    echo "local-to-server: Transfers file from local pc to the end server"
    echo "server-to-local: Gets the file from server to local pc"
    echo "all: does both actions"
    echo "Sample Execution:$  sh run_file_transfer.sh local-to-server"
}

if [ -z "$2" ]; then
    if [ $1 == "local-to-server" ]; then
        robot -t 'Transfer file from local to environment' execute.robot
    elif [ $1 == "server-to-local" ]; then
        robot -t 'Transfer file from environment to local' execute.robot
    elif [ $1 == "all" ]; then
        robot execute.robot
    else
        usage
    fi    
else 
    echo "Invalid Option Selection!!"
    echo 
    usage
fi

