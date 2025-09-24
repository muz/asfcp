#!/bin/bash

# Script to fetch the list of firearms for individuals from the Canadian Government website
# Usage: ./fetch.sh

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the project root (parent directory of bin)
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Create ref directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/ref"

# Get current UNIX timestamp
TIMESTAMP=$(date +%s)

# Define the URL and output filename
URL="https://www.canada.ca/en/public-safety-canada/campaigns/firearms-buyback/individual-lists-firearms-lower-upper-receivers/list-firearms-individuals.html"
OUTPUT_FILE="$PROJECT_ROOT/ref/list_of_firearms_for_individuals_${TIMESTAMP}.html"

# Fetch the webpage using curl
echo "Fetching firearms list from Canadian Government website..."
curl -L -o "$OUTPUT_FILE" "$URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Successfully downloaded: $OUTPUT_FILE"
    echo "File size: $(wc -c < "$OUTPUT_FILE") bytes"
else
    echo "Error: Failed to download the webpage"
    exit 1
fi
