#!/bin/bash

# this script should run in a container, i.e. with
# PID 1; otherwise it might damage your system
[[ $$ -eq 1 ]] || exit 1

set -m

# define the initlog function for the init process
source /services/initlog


initlog -- '\n--------------------------------------------------------------------------------\n'
initlog 'Init started with PID %s\n' $$
initlog -- '--------------------------------------------------------------------------------\n\n'


# kill the keep-alive process when SIGTERM is catched
function on_sigterm() {
    [[ $KEEPALIVE -ne 0 ]] && kill $KEEPALIVE && KEEPALIVE=0
}

trap 'on_sigterm' SIGTERM

# kill all child processes when this script exits
function on_exit() {
    kill -- -$$
}

trap 'on_exit' EXIT


# run child processes
for SVC in $(find /services/svc -mindepth 1 -maxdepth 1 -type d | sort) ; do
    SVCNAME=$(basename $SVC)

    initlog -- '--------------------------------------------------------------------------------\n'
    initlog 'Service %s\n' $SVCNAME

    BEFORE="$SVC/before_start.sh"
    START="$SVC/start.sh"
    AFTER="$SVC/after_start.sh"
    LOG="/services/log/${SVCNAME}.log"

    touch $LOG && chmod 666 $LOG

    if [[ -x $BEFORE ]] ; then
        $BEFORE $LOG &>> $LOG
    elif [[ -f $BEFORE ]] ; then
        initlog '  Script %s is not executable: SKIPPED\n' $BEFORE
    fi

    if [[ -x $START ]] ; then
        $START $LOG &>> $LOG &
        initlog '  Started %s PID: %s\n' $START $!
        initlog '  log file:       %s\n' $LOG
    elif [[ -f $START ]] ; then
        initlog '  Script %s is not executable: SKIPPED\n' $START
    fi

    if [[ -x $AFTER ]] ; then
        $AFTER $LOG
    elif [[ -f $AFTER ]] ; then
        initlog '  Script %s is not executable: SKIPPED\n' $AFTER
    fi
done

initlog -- '--------------------------------------------------------------------------------\n\n'

# keep the container alive until SIGTERM is received
ln -snf /bin/sleep /usr/local/bin/keepalive
keepalive infinity &
KEEPALIVE=$!
wait $KEEPALIVE
