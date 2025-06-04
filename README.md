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

### Quick Install (One-liner)

```bash
mkdir -p ~/.local/bin && curl -sSL https://raw.githubusercontent.com/niekcandaele/wlog/main/wlog -o ~/.local/bin/wlog && curl -sSL https://raw.githubusercontent.com/niekcandaele/wlog/main/wreport -o ~/.local/bin/wreport && chmod +x ~/.local/bin/{wlog,wreport} && echo "wlog installed to ~/.local/bin"
```

Make sure `~/.local/bin` is in your PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

### Manual Installation

1. Clone the repository:

```bash
git clone https://github.com/niekcandaele/wlog
cd wlog
```

2. Make the scripts executable (if not already):

```bash
chmod +x wlog wreport
```

3. Add to your PATH by copying to a directory in your PATH or creating symlinks:

```bash
# Option 1: Copy to /usr/local/bin (requires sudo)
sudo cp wlog wreport /usr/local/bin/

# Option 2: Copy to ~/.local/bin (user-specific)
mkdir -p ~/.local/bin
cp wlog wreport ~/.local/bin/
# Ensure ~/.local/bin is in your PATH

# Option 3: Create symlinks (replace /path/to/wlog with actual path)
ln -s /path/to/wlog/wlog ~/.local/bin/wlog
ln -s /path/to/wlog/wreport ~/.local/bin/wreport
```

4. Verify installation:

```bash
wlog Test message
wreport day
```

## Usage

### Logging Work Items

Log significant work activities throughout your day:

```bash
wlog Helped Joe with cluster configuration
wlog Tested HA failover for onprem cluster
wlog Client call with customer-x regarding SSO integration
wlog Reviewed pull request #247 for authentication module
wlog Deployed hotfix to production environment
```

### Generating Reports

Retrieve work summaries for different time periods:

```bash
# Last 24 hours
wreport day

# Last 7 days
wreport week
```

## Testing

The project includes a comprehensive test suite using the bats testing framework.

### Running Tests

1. Set up the testing framework (one-time setup):

```bash
./test_setup.sh
```

2. Run all tests:

```bash
./run_tests.sh
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

## Contributing

Contributions are welcome. Please submit issues and pull requests to improve functionality and documentation.
