#!/bin/bash

function wait_for_process () {
    local max_time_wait=30
    local process_name="$1"
    local waited_sec=0
    while ! pgrep "$process_name" >/dev/null && ((waited_sec < max_time_wait)); do
        sleep 1
        ((waited_sec=waited_sec+1))
        if ((waited_sec >= max_time_wait)); then
            return 1
        fi
    done
    return 0
}

/usr/bin/supervisord -n >> /dev/null 2>&1 &

processes=(dockerd)

for process in "${processes[@]}"; do
    wait_for_process "$process"
    if [ $? -ne 0 ]; then
        exit 1
    fi
done

# Wait processes to be running
/bin/bash
