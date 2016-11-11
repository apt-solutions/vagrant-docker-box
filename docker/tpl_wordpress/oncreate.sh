#!/usr/bin/env bash

# How often will we increase the port to find a free one?
retryPortsCount=200

# Try to find ports in this range only
minPortNum=31700
maxPortNum=34000

# read last used port from file
port=$(<./../lastusedport)

if [ -z "$port" ]; then
  # begin if .lastusedport does not exist
  port="$minPortNum"
fi

i=0
while
  # i++
  i="$((i+1))"
  # port++
  port="$((port+1))"

  # roundtrip ports
  if [ "$port" -ge "$maxPortNum" ]; then
    port="$maxPortNum"
  fi

  # return process id for the given port if exists
  portpid=`lsof -t -P -i :$port;`

  if [ -z "$portpid" ]; then
    # no process occupying the port

    # persist new port
    echo "$port" > ./../lastusedport

    # and use this very port
    break;
  fi

  # prevent endless loops!
  if [ "$i" -ge "$retryPortsCount" ]; then
    # reset port to empty string indicating error (no usable open port found)
    port=""
    break
  fi
do :; done


if [ -n "$port" ]; then
  # We found an open port

  # update docker-compose.yaml. set this very port
  sudo sed -i "s#{{{publicport}}}#$port#g" ./docker-compose.yaml

  # set up docker containers with docker compose, redirect outputs to "bash.log"
  docker-compose up -d --no-recreate > ./bash.log 2>&1

  # docker-compose outputs lines with "ERROR:" in case of something went wrong
  # search for this in the bash.log file.
  # if exists output the log file to "throw" the error
  errors=$(cat ./bash.log | grep ERROR:)
  if [ -n "$errors" ]; then
    cat ./bash.log
  fi
fi

# echo port as result
echo "$port"
