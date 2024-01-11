#!/bin/bash

# Define the directory where you want to save the .yml files
output_dir="$HOME/conda-envs"
mkdir -p $output_dir

# Get a list of all conda environments
conda_env_list=$(conda env list --json)

# Parse the JSON output and iterate through the environments
env_names=($(echo "$conda_env_list" | jq -r '.envs[]'))
for env_path in "${env_names[@]}"; do
    env_name=$(basename "$env_path")
    echo Saving $env_name ..
    # Construct the export command
    export_command="conda env export --from-history -n $env_name > $output_dir/$env_name.yml"
    echo Saved

    # Run the export command
    eval "$export_command"
done

echo "All conda environments exported as .yml files."

