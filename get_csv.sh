#!/bin/bash

# The name of the output CSV file
output_csv="output.csv"

# Write the header to the CSV file
echo "target,retrodock_job_dudez_published_dockfiles,retrodock_job_dudez_published_dockfiles_3.8,beam_search,difference" > "$output_csv"

# Find all the directories that contain the normalized_log_auc.txt files
directories=$(find DOCKING_GRIDS_AND_POSES -maxdepth 2 -type d \( -name 'retrodock_job_dudez_published_dockfiles' -o -name 'retrodock_job_dudez_published_dockfiles_3.8' \))

# Loop through each directory and extract the number from the normalized_log_auc.txt file
for dir in $directories; do
    # Check if the directory ends with retrodock_job_dudez_published_dockfiles
    if [[ $dir == *"/retrodock_job_dudez_published_dockfiles" ]]; then
        # Extract the number from the file
        number1=$(cat "$dir/normalized_log_auc.txt")
        number2=""

        # Extract target name
        target="${dir%/retrodock_job_dudez_published_dockfiles}"
        target="${target##*/}"

        # Check if the corresponding retrodock_job_dudez_published_dockfiles_3.8 directory exists
        dir_3_8="${dir%/*}/retrodock_job_dudez_published_dockfiles_3.8"
        if [ -d "$dir_3_8" ] && [ -f "$dir_3_8/normalized_log_auc.txt" ]; then
            # Extract the number from the file
            number2=$(cat "$dir_3_8/normalized_log_auc.txt")
        fi

        # Extract beam_search
        beam_search=""
        results_csv="${dir%/*}/dockopt_job_beam_search/1_step/results.csv"
        if [ -f "$results_csv" ]; then
            second_line=$(sed -n '2p' "$results_csv")
            beam_search=${second_line##*,}
        fi

        # Calculate difference (Added section)
        difference=""
        if [[ -n "$beam_search" && -n "$number2" ]]; then
            difference=$(echo "$beam_search - $number2" | bc)
        fi

        # Write the numbers to the CSV file (Modified section)
        echo "$target,$number1,$number2,$beam_search,$difference" >> "$output_csv"
    fi
done

