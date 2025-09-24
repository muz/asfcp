#!/bin/bash

# Script to parse the firearms HTML table and convert to CSV
# Usage: ./parse_to_csv.sh

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the project root (parent directory of bin)
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Find the latest HTML file in ref directory
LATEST_HTML=$(ls -t "$PROJECT_ROOT/ref"/list_of_firearms_for_individuals_*.html 2>/dev/null | head -n1)

if [ -z "$LATEST_HTML" ]; then
    echo "Error: No firearms HTML files found in ref directory"
    echo "Please run fetch.sh first to download the data"
    exit 1
fi

echo "Using HTML file: $(basename "$LATEST_HTML")"

# Extract timestamp from HTML filename
TIMESTAMP=$(basename "$LATEST_HTML" | sed 's/list_of_firearms_for_individuals_\([0-9]*\)\.html/\1/')

# Create data directory if it doesn't exist
mkdir -p "$PROJECT_ROOT/data"

OUTPUT_CSV="$PROJECT_ROOT/data/firearms_data_${TIMESTAMP}.csv"
OUTPUT_JSON="$PROJECT_ROOT/data/firearms_data_${TIMESTAMP}.json"

# Create CSV header
echo "Firearm Reference Number,Make,Model,Individual Amount" > "$OUTPUT_CSV"

# Extract table data using Python to generate both CSV and JSON
python3 -c "
import re
import json
import sys

# Read the HTML file
with open('$LATEST_HTML', 'r', encoding='utf-8') as f:
    content = f.read()

# Find the table section
table_match = re.search(r'<table[^>]*class=\"wb-tables[^\"]*\"[^>]*>.*?</table>', content, re.DOTALL)
if not table_match:
    print('Table not found', file=sys.stderr)
    sys.exit(1)

table_html = table_match.group(0)

# Extract all table rows
rows = re.findall(r'<tr>.*?</tr>', table_html, re.DOTALL)

csv_data = []
json_data = []

for row in rows:
    # Extract table cells
    cells = re.findall(r'<td[^>]*>(.*?)</td>', row, re.DOTALL)

    if len(cells) >= 4:
        # Clean up HTML entities and whitespace
        cleaned_cells = []
        for cell in cells[:4]:
            # Remove HTML tags
            cell = re.sub(r'<[^>]*>', '', cell)
            # Decode HTML entities
            cell = cell.replace('&amp;', '&')
            cell = cell.replace('&lt;', '<')
            cell = cell.replace('&gt;', '>')
            cell = cell.replace('&quot;', '\"')
            cell = cell.replace('&#39;', \"'\")
            # Clean whitespace
            cell = cell.strip()
            cleaned_cells.append(cell)

        # Add to CSV data
        csv_data.append(','.join(cleaned_cells))

        # Add to JSON data
        json_data.append({
            'firearm_reference_number': cleaned_cells[0],
            'make': cleaned_cells[1],
            'model': cleaned_cells[2],
            'individual_amount': cleaned_cells[3]
        })

# Write CSV data
with open('$OUTPUT_CSV', 'a', encoding='utf-8') as f:
    for line in csv_data:
        f.write(line + '\n')

# Write JSON data
with open('$OUTPUT_JSON', 'w', encoding='utf-8') as f:
    json.dump(json_data, f, indent=2, ensure_ascii=False)
"

# Check if both files were created successfully
if [ -f "$OUTPUT_CSV" ] && [ -s "$OUTPUT_CSV" ] && [ -f "$OUTPUT_JSON" ] && [ -s "$OUTPUT_JSON" ]; then
    echo "Successfully created both files:"
    echo "  CSV: $(basename "$OUTPUT_CSV") ($(wc -c < "$OUTPUT_CSV") bytes)"
    echo "  JSON: $(basename "$OUTPUT_JSON") ($(wc -c < "$OUTPUT_JSON") bytes)"
    echo "Total records: $(($(wc -l < "$OUTPUT_CSV") - 1))"

    # Show first few lines as preview
    echo ""
    echo "Preview of first 5 records (CSV):"
    head -n 6 "$OUTPUT_CSV"

    echo ""
    echo "Preview of first 3 records (JSON):"
    head -n 20 "$OUTPUT_JSON"
else
    echo "Error: Failed to create output files"
    exit 1
fi