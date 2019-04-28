#!/bin/bash

# Video combiner by tofran

set -e

MAX_SECONDS_BETWEEN_PARTS=5
DATE_FORMAT="%Y-%m-%d_%H-%M"
OUTPUT_FILE_EXTENSION=".avi"

files=( $@ )
start_timestamps=( $(stat -c "%Y" ${files[@]}) )

start_timstamp=99999999999
end_timstamp=0

current_files=()
current_output=""

for i in "${!files[@]}"; do
    file=${files[i]}
    start_timstamp=${start_timestamps[i]}

    lenght=$(ffprobe -loglevel panic -show_format ${file} | sed -n '/duration/s/.*=//p' | sed "s/\..*//")
    interval=$(( ${start_timstamp} - ${end_timstamp} ))

    # echo "-> ${file} (timestamp: ${start_timstamp}; lenght: ${lenght}; interval: ${interval})"

    if [ "${interval}" -gt "${MAX_SECONDS_BETWEEN_PARTS}" ]; then
        if [ ${#current_files[@]} -ne 0 ]; then
            echo "${current_output} will be created from ${current_files[@]}"
            read -p "Press enter to contune...."

            mencoder -oac copy -ovc copy ${current_files[@]} -o ${current_output}
        fi

        current_output=$(date --date="@${start_timstamp}" --utc +"${DATE_FORMAT}")${OUTPUT_FILE_EXTENSION}
        current_files=($file)

    else
        current_files+=($file)
    fi

    end_timstamp=$(( ${start_timstamp} + ${lenght} ))
done

