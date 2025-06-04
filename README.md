# Work Logger

A terminal-based productivity tool for tracking daily work activities and generating reports for standups and retrospectives.

## Overview

Work Logger eliminates the common problem of forgetting accomplishments during daily standups or weekly reviews. The tool provides a frictionless command-line interface for logging work items throughout the day and retrieving organized reports on demand.

## Features

- **Rapid logging**: Capture work items with simple terminal commands
- **Persistent storage**: Daily JSON files maintain historical records
- **Flexible reporting**: Generate reports for arbitrary time periods
- **Configurable storage**: Customize log file location
- **Lightweight operation**: Minimal system resource usage

## Installation

```bash
# Installation method will be added once implementation is complete
```

## Usage

### Logging Work Items

Log significant work activities throughout your day:

```bash
wlog "Helped Joe with cluster configuration"
wlog "Tested HA failover for onprem cluster"
wlog "Client call with customer-x regarding SSO integration"
wlog "Reviewed pull request #247 for authentication module"
wlog "Deployed hotfix to production environment"
```

### Generating Reports

Retrieve work summaries for different time periods:

```bash
# Last 24 hours
wreport day

# Last 7 days
wreport week
```

## Configuration

The application stores daily JSON files in a configurable directory. Default configuration and customization options will be documented upon implementation.

## Data Format

Work items are stored in daily JSON files with the following structure:

```json
{
  "date": "2024-06-04",
  "entries": [
    {
      "timestamp": "2024-06-04T09:15:30Z",
      "message": "Helped Joe with cluster configuration"
    },
    {
      "timestamp": "2024-06-04T11:42:18Z",
      "message": "Tested HA failover for onprem cluster"
    }
  ]
}
```

## Report Output

Reports display chronologically ordered work items with timestamps:

```
Work Report - Last 24 Hours
============================

2024-06-04 09:15 - Helped Joe with cluster configuration
2024-06-04 11:42 - Tested HA failover for onprem cluster
2024-06-04 14:30 - Client call with customer-x regarding SSO integration
```

## Roadmap

- [ ] Core logging functionality
- [ ] Report generation engine
- [ ] Export capabilities (markdown, CSV)

## Contributing

Contributions are welcome. Please submit issues and pull requests to improve functionality and documentation.

## License

License will be specified upon initial release.
