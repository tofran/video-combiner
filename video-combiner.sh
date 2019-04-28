#!/bin/bash

# Automatically combine multipart videos 
# https://github.com/tofran/video-combiner
# usage:
#   $ video-combiner.sh video1.avi video2.avi video3.avi

MAX_SECONDS_BETWEEN_PARTS=5
DATE_FORMAT="%Y-%m-%d_%H-%M"
OUTPUT_FILE_EXTENSION=".avi"

set -e

files=( $@ )
end_timestamps=( $(stat -c "%Y" ${files[@]}) )

previous_end_timestamp=0
current_files=()
current_output=""

for i in "${!files[@]}"; do
    file=${files[i]}
    end_timestamp=${end_timestamps[i]}

    lenght=$(ffprobe -loglevel panic -show_format ${file} | sed -n '/duration/s/.*=//p' | sed "s/\..*//")

    start_timstamp=$(( ${end_timestamp} - ${lenght} ))
    interval=$(( ${start_timstamp} - ${previous_end_timestamp} ))

    echo "-> ${file} (timestamp: ${start_timstamp}; lenght: ${lenght}; interval: ${interval})"

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

    previous_end_timestamp=${end_timestamp}
done

