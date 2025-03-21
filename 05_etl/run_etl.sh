#!/bin/bash

# Exit on any error
set -e

# Directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Activate the virtual environment
echo "Activating virtual environment..."
source ../venv/bin/activate

# Set up Spark environment
echo "Setting up Spark environment..."
source ~/.spark_env

# Check if prefect is installed
if ! pip show prefect &>/dev/null; then
    echo "Installing Prefect..."
    pip install prefect
fi

# Run the ETL flow
echo "Running ETL flow..."
python dag.py

echo "ETL flow completed successfully!" 