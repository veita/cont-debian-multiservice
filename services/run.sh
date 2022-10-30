#!/bin/bash

printf 'Runner started with PID %s\n' $$

#set -ex

# kill the keep-alive process when SIGTERM is catched
on_sigterm() {
    [[ $KEEPALIVE -ne 0 ]] && kill $KEEPALIVE && KEEPALIVE=0
}

trap 'on_sigterm' SIGTERM

# kill all child processes when this script exits
on_exit() {
    kill -- -$$
}

trap 'on_exit' EXIT

# run child processes
for SVC in $(find services/service -mindepth 1 -maxdepth 1 -type d | sort) ; do
    printf -- '----------------------------------------\n'
    printf 'Service %s\n' $SVC

    BEFORE=$SVC/before_start.sh
    START=$SVC/start.sh
    AFTER=$SVC/after_start.sh

    if [[ -x $BEFORE ]] ; then
        $BEFORE
    elif [[ -f $BEFORE ]] ; then
        printf '  Script %s not executable: SKIPPED\n' $BEFORE
    fi

    if [[ -x $START ]] ; then
        $START >/dev/null 2>&1 &
        printf '  Started %s PID: %s\n' $START $!
    elif [[ -f $START ]] ; then
        printf '  Script %s not executable: SKIPPED\n' $START
    fi

    if [[ -x $AFTER ]] ; then
        $AFTER
    elif [[ -f $AFTER ]] ; then
        printf '  Script %s not executable: SKIPPED\n' $AFTER
    fi
done

printf -- '----------------------------------------\n'

# keep the container alive until SIGTERM is received
sleep infinity &
KEEPALIVE=$!
wait $KEEPALIVE
