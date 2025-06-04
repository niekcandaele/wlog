#!/usr/bin/env bats

# Tests for wlog script

setup() {
    # Create temporary directory for test logs
    export TEST_WLOG_DIR="$(mktemp -d)"
    export WLOG_DIR="$TEST_WLOG_DIR"
    
    # Get current date for testing
    export TEST_DATE="$(date +%Y-%m-%d)"
    export LOG_FILE="$WLOG_DIR/$TEST_DATE.json"
}

teardown() {
    # Clean up test directory
    rm -rf "$TEST_WLOG_DIR"
}

@test "wlog shows usage when no arguments provided" {
    run ./wlog
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage: wlog" ]]
}

@test "wlog creates log directory if it doesn't exist" {
    # Remove the directory created in setup
    rm -rf "$WLOG_DIR"
    [ ! -d "$WLOG_DIR" ]
    run ./wlog "Test message"
    [ "$status" -eq 0 ]
    [ -d "$WLOG_DIR" ]
}

@test "wlog creates new log file with proper JSON structure" {
    run ./wlog "Test entry"
    [ "$status" -eq 0 ]
    [ -f "$LOG_FILE" ]
    
    # Check JSON structure
    run jq -e '.date' "$LOG_FILE"
    [ "$status" -eq 0 ]
    
    run jq -e '.entries[0].timestamp' "$LOG_FILE"
    [ "$status" -eq 0 ]
    
    run jq -e '.entries[0].message' "$LOG_FILE"
    [ "$status" -eq 0 ]
    [[ "$(jq -r '.entries[0].message' "$LOG_FILE")" == "Test entry" ]]
}

@test "wlog appends to existing log file" {
    # Create first entry
    run ./wlog "First entry"
    [ "$status" -eq 0 ]
    
    # Add second entry
    run ./wlog "Second entry"
    [ "$status" -eq 0 ]
    
    # Check both entries exist
    entries_count=$(jq '.entries | length' "$LOG_FILE")
    [ "$entries_count" -eq 2 ]
    
    first_message=$(jq -r '.entries[0].message' "$LOG_FILE")
    second_message=$(jq -r '.entries[1].message' "$LOG_FILE")
    
    [ "$first_message" = "First entry" ]
    [ "$second_message" = "Second entry" ]
}

@test "wlog outputs confirmation message" {
    run ./wlog "Test message"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Logged: Test message" ]]
}