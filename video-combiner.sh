#!/bin/bash

# Automatically combine multipart videos 
# https://github.com/tofran/video-combiner
# usage:
#   $ video-combiner.sh video1.avi video2.avi video3.avi

MAX_SECONDS_BETWEEN_PARTS=5
OUTPUT_FILE_EXTENSION=".avi"
OUTPUT_DATE_FORMAT="%Y-%m-%d_%H-%M_%Z"
TOUCH_DATE_FORMAT="%Y%m%d%H%M.%S"

set -e

generate_video () {
    local start_timstamp=$1; shift;
    local files=( $@ )

    if [ ${#files[@]} -ne 0 ]; then

        output_file=$(date --date="@${start_timstamp}" +"${OUTPUT_DATE_FORMAT}")${OUTPUT_FILE_EXTENSION}
        touch_date=$(date --date="@${start_timstamp}" +"${TOUCH_DATE_FORMAT}")

        echo "${output_file} will be created from ${files[@]}"
        read -p "Press enter to contune..."

        mencoder -oac copy -ovc copy ${files[@]} -o ${output_file}
        touch -camt ${touch_date} ${output_file}

    fi
}

files=( $@ )
end_timestamps=( $(stat -c "%Y" ${files[@]}) )

previous_end_timestamp=0
current_video_files=()
current_output=""

for i in "${!files[@]}"; do
    file=${files[i]}
    end_timestamp=${end_timestamps[i]}

    lenght=$(ffprobe -loglevel panic -show_format ${file} | sed -n '/duration/s/.*=//p' | sed "s/\..*//")

    start_timstamp=$(( ${end_timestamp} - ${lenght} ))
    interval=$(( ${start_timstamp} - ${previous_end_timestamp} ))

    # echo "-> ${file} (timestamp: ${start_timstamp}; lenght: ${lenght}; interval: ${interval})"

    if [ "${interval}" -gt "${MAX_SECONDS_BETWEEN_PARTS}" ]; then

        generate_video "${current_video_start_timstamp}" "${current_video_files[@]}" 

        current_video_start_timstamp=${start_timstamp}
        current_video_files=($file)

    else
        current_video_files+=($file)
    fi

    previous_end_timestamp=${end_timestamp}
done

generate_video "${current_video_start_timstamp}" "${current_video_files[@]}" 
