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

@test "wlog handles messages with spaces correctly" {
    run ./wlog "message with multiple spaces"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Logged: message with multiple spaces" ]]
    
    # Check that the full message is stored in the log file
    message=$(jq -r '.entries[0].message' "$LOG_FILE")
    [ "$message" = "message with multiple spaces" ]
}

@test "wlog handles unquoted multi-word arguments" {
    run ./wlog testing multiple words
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Logged: testing multiple words" ]]
    
    # Check that all words are captured
    message=$(jq -r '.entries[0].message' "$LOG_FILE")
    [ "$message" = "testing multiple words" ]
}

@test "wlog pop shows error when no log file exists" {
    run ./wlog pop
    [ "$status" -eq 1 ]
    [[ "$output" =~ "No entries found for today to remove." ]]
}

@test "wlog pop shows error when log file has no entries" {
    # Create empty log file
    cat > "$LOG_FILE" << EOF
{
  "date": "$TEST_DATE",
  "entries": []
}
EOF
    
    run ./wlog pop
    [ "$status" -eq 1 ]
    [[ "$output" =~ "No entries found for today to remove." ]]
}

@test "wlog pop removes the latest entry" {
    # Create multiple entries
    run ./wlog "First entry"
    run ./wlog "Second entry"
    run ./wlog "Third entry"
    
    # Verify we have 3 entries
    entries_count=$(jq '.entries | length' "$LOG_FILE")
    [ "$entries_count" -eq 3 ]
    
    # Pop the latest entry
    run ./wlog pop
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Removed:" ]]
    [[ "$output" =~ "Third entry" ]]
    
    # Verify we now have 2 entries
    entries_count=$(jq '.entries | length' "$LOG_FILE")
    [ "$entries_count" -eq 2 ]
    
    # Verify the remaining entries are correct
    first_message=$(jq -r '.entries[0].message' "$LOG_FILE")
    second_message=$(jq -r '.entries[1].message' "$LOG_FILE")
    
    [ "$first_message" = "First entry" ]
    [ "$second_message" = "Second entry" ]
}

@test "wlog pop shows removed entry with timestamp" {
    # Create an entry
    run ./wlog "Test entry for removal"
    
    # Get the timestamp that was created
    timestamp=$(jq -r '.entries[0].timestamp' "$LOG_FILE")
    
    # Pop the entry
    run ./wlog pop
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Removed: $timestamp - Test entry for removal" ]]
}

@test "wlog pop can remove all entries one by one" {
    # Create multiple entries
    run ./wlog "Entry 1"
    run ./wlog "Entry 2"
    run ./wlog "Entry 3"
    
    # Pop all entries
    run ./wlog pop
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Entry 3" ]]
    
    run ./wlog pop
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Entry 2" ]]
    
    run ./wlog pop
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Entry 1" ]]
    
    # Verify no entries left
    entries_count=$(jq '.entries | length' "$LOG_FILE")
    [ "$entries_count" -eq 0 ]
    
    # Try to pop again - should fail
    run ./wlog pop
    [ "$status" -eq 1 ]
    [[ "$output" =~ "No entries found for today to remove." ]]
}

@test "wlog pop updates usage message" {
    run ./wlog
    [ "$status" -eq 1 ]
    [[ "$output" =~ "Usage: wlog \"message\" or wlog pop" ]]
    [[ "$output" =~ "wlog pop" ]]
}