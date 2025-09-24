# ASFCP - Assault-Style Firearms Compensation Program Data

This project provides data representations of information published by the Canadian Government for their Assault-Style Firearms Compensation Program (ASFCP).

## Overview

The ASFCP was established by the Canadian Government to provide compensation to firearm owners for certain assault-style firearms that were prohibited under federal regulations. This repository contains structured data representations of the official government information to make it more accessible and usable for analysis.

## Directory Structure

```
asfcp/
├── bin/                                         # Executable scripts
│   ├── fetch.sh                                 # Downloads HTML data from government website
│   └── parse.sh                                 # Parses HTML table to CSV and JSON
├── data/                                        # Processed data files
└── ref/                                         # Raw reference files
```

## Usage

### Getting Started

1. **Download the latest data:**
   ```bash
   ./bin/fetch.sh
   ```
   This downloads the current firearms list from the Canadian Government website and saves it to the `ref/` directory with a timestamp.

2. **Parse the data to structured formats:**
   ```bash
   ./bin/parse.sh
   ```
   This processes the latest HTML file and generates both CSV and JSON versions in the `data/` directory.

### Data Formats

The parsed data includes the following fields for each firearm:
- **Firearm Reference Number (FRN)**: Official government reference number
- **Make**: Manufacturer name
- **Model**: Firearm model designation
- **Individual Amount**: Compensation value in Canadian dollars

#### CSV Format
```csv
Firearm Reference Number,Make,Model,Individual Amount
125981,Steele, G M,GM16,$150
133396,Mossberg,702 Plinkster Tactical 22,$190
```

#### JSON Format
```json
[
  {
    "firearm_reference_number": "125981",
    "make": "Steele, G M",
    "model": "GM16",
    "individual_amount": "$150"
  }
]
```

## Data Sources

All data in this repository is derived from official Canadian Government publications and regulations related to the Assault-Style Firearms Compensation Program. Users should refer to official government sources for authoritative information.

**Source URL:** https://www.canada.ca/en/public-safety-canada/campaigns/firearms-buyback/individual-lists-firearms-lower-upper-receivers/list-firearms-individuals.html

## Contributing

Contributions to improve data accuracy, add new data representations, or enhance usability are welcome. Please ensure all contributions maintain accuracy to official government sources.

## License

This project is provided for informational and research purposes. Users should verify all information against official government sources.

## Disclaimer

This repository contains data representations of government information for research and analysis purposes. It is not an official government resource. For authoritative information about the Assault-Style Firearms Compensation Program, please refer to official Canadian Government sources.
