#!/bin/bash
# Enhanced script to perform thorough cleanup of system data on macOS with safety features

# Function to clear Time Machine local snapshots
clear_time_machine_snapshots() {
    echo "Checking for Time Machine local snapshots..."
    local snapshots=$(tmutil listlocalsnapshots / | wc -l)
    if [ $snapshots -gt 0 ]; then
        echo "Found $snapshots snapshots. Removing..."
        for snapshot in $(tmutil listlocalsnapshots / | cut -d. -f4); do
            sudo tmutil deletelocalsnapshots $snapshot
            echo "Deleted snapshot: $snapshot"
        done
    else
        echo "No Time Machine local snapshots found."
    fi
}

# Function to clear system cache
clear_system_cache() {
    echo "Clearing system caches..."
    sudo find /Library/Caches -type f -delete 2>/dev/null
    sudo find ~/Library/Caches -type f -delete 2>/dev/null
}

# Function to clear user logs older than 7 days
clear_user_logs() {
    echo "Clearing user logs older than 7 days..."
    sudo find /var/log -type f -mtime +7 -name "*.log" -delete 2>/dev/null
    sudo find ~/Library/Logs -type f -mtime +7 -delete 2>/dev/null
}

# Function to remove temp files older than 2 days
remove_temp_files() {
    echo "Removing temporary files older than 2 days..."
    sudo find /tmp -type f -mtime +2 -delete 2>/dev/null
    sudo find /private/tmp -type f -mtime +2 -delete 2>/dev/null
}

# Function to clear application support cache
clear_app_cache() {
    echo "Clearing application support caches..."
    sudo find ~/Library/Application\ Support/Caches -type f -delete 2>/dev/null
}

# Function to clean Xcode derived data and archives
clean_xcode_data() {
    echo "Cleaning Xcode derived data and archives..."
    
    # Clear derived data
    if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
        echo "Clearing Xcode derived data..."
        rm -rf ~/Library/Developer/Xcode/DerivedData/* 2>/dev/null
    fi
    
    # Clear archives
    if [ -d ~/Library/Developer/Xcode/Archives ]; then
        echo "Clearing Xcode archives..."
        rm -rf ~/Library/Developer/Xcode/Archives/* 2>/dev/null
    fi
    
    # Clear iOS device support files (optional - uncommment if needed)
    # echo "Clearing iOS device support files..."
    # rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/* 2>/dev/null
}

# Function to clean Snap Lens Studio autosaves
clean_snap_autosaves() {
    local autosaves_dir="$HOME/Library/Application Support/Snap/Lens Studio/Autosaves"
    local keep_latest=3  # Number of most recent autosaves to keep
    
    if [ -d "$autosaves_dir" ]; then
        echo "Cleaning Snap Lens Studio autosaves..."
        
        # Count total autosaves
        local total_autosaves=$(ls -1 "$autosaves_dir" | wc -l)
        
        if [ $total_autosaves -gt $keep_latest ]; then
            # List files by modification time, keep the latest 3
            ls -t "$autosaves_dir" | tail -n +$((keep_latest + 1)) | while read -r file; do
                echo "Removing old autosave: $file"
                rm -rf "$autosaves_dir/$file"
            done
            echo "Kept the $keep_latest most recent autosaves."
        else
            echo "Found $total_autosaves autosaves. No cleanup needed (keeping $keep_latest latest)."
        fi
    else
        echo "Snap Lens Studio autosaves directory not found."
    fi
}

# Function to clean Stremio cache
clean_stremio_cache() {
    local stremio_dir="$HOME/Library/Application Support/stremio-server"
    local cache_dir="$stremio_dir/stremio-cache"
    
    if [ -d "$cache_dir" ]; then
        echo "Cleaning Stremio cache..."
        local cache_size=$(du -sh "$cache_dir" | cut -f1)
        echo "Current cache size: $cache_size"
        
        # Stop Stremio if it's running
        if pgrep -x "Stremio" > /dev/null; then
            echo "Stopping Stremio..."
            osascript -e 'tell application "Stremio" to quit'
            sleep 2
        fi
        
        # Remove cache while preserving settings
        rm -rf "$cache_dir"/*
        echo "Stremio cache cleared."
    else
        echo "Stremio cache directory not found."
    fi
}

# Function to clean iOS Simulators
clean_ios_simulators() {
    echo "Cleaning iOS Simulators..."
    xcrun simctl shutdown all 2>/dev/null
    xcrun simctl erase all 2>/dev/null
}

# Function to delete trash after confirmation
empty_trash() {
    read -p "Are you sure you want to empty the trash? (y/n): " confirm
    if [[ $confirm = y ]]; then
        echo "Emptying Trash..."
        sudo rm -rf ~/.Trash/* 2>/dev/null
    else
        echo "Trash not emptied."
    fi
}

# Function to display system storage information
show_storage_info() {
    echo "Current storage information:"
    system_profiler SPStorageDataType | grep -A 4 "Free\|Capacity"
}

# Main function to run cleanup tasks with logging
run_cleanup() {
    echo "Starting system cleanup..."
    echo "==============================================="
    
    # Show initial storage
    echo "Initial storage status:"
    show_storage_info
    echo "==============================================="
    
    # Run cleanup tasks
    clear_time_machine_snapshots
    clear_system_cache
    clear_user_logs
    remove_temp_files
    clear_app_cache
    clean_xcode_data
    clean_snap_autosaves
    clean_stremio_cache
    clean_ios_simulators
    empty_trash
    
    echo "==============================================="
    # Show final storage
    echo "Final storage status:"
    show_storage_info
    
    echo "==============================================="
    echo "Cleanup completed successfully!"
    echo "$(date): Cleanup performed" >> ~/cleanup_log.txt
}

# Execute cleanup
run_cleanup
