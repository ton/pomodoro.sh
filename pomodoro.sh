#!/bin/sh

# Hide cursor and make sure to show the cursor again on exit.
trap "tput cnorm" EXIT
tput civis

# Constants; modify at will.
short_break_mins=5
long_break_mins=15
work_mins=25

# For convenience...
short_break_secs=$((60 * short_break_mins))
long_break_secs=$((60 * long_break_mins))
work_secs=$((60 * work_mins))

# Count down the number of seconds to work.
do_work() {
    n=$1 # number of seconds to work
    while [ "$n" -gt "0" ]; do
        printf "%d seconds until next break...   \r" "$n"
        sleep 1
        n=$((n - 1))
    done
}

# Count down the number of seconds to break, send a notification that announces
# the start of the break.
do_break() {
    n=$1 # number of seconds to break

    if [ "$n" -eq "$short_break_secs" ]; then
        notify-send 'Time for a short break.' -t $((1000 * n))
    else
        notify-send 'Time for a long break.' -t $((1000 * n))
    fi

    while [ "$n" -gt "0" ]; do
        printf "On break, %d seconds to go...   \r" "$n"
        sleep 1
        n=$((n - 1))
    done
}

# Four short breaks followed by a longer one, Pomodoro style.
while true ; do
    do_work $work_secs
    do_break $short_break_secs

    do_work $work_secs
    do_break $short_break_secs

    do_work $work_secs
    do_break $short_break_secs

    do_work $work_secs
    do_break $short_break_secs

    do_work $work_secs
    do_break $long_break_secs
done
