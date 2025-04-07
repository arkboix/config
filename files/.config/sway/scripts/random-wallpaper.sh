#!/bin/bash

# Script to randomly change wallpaper using swww
# Wallpapers are selected from ~/wallpapers-dt
# Changes every 30 seconds with fade transition


# Check if swww is installed
if ! command -v swww &> /dev/null; then
    echo "Error: swww is not installed. Please install it first."
    exit 1
fi

# Initialize swww if it's not already running
if ! pgrep -x swww-daemon > /dev/null; then
    echo "Initializing swww daemon..."
    swww init
    # Give it a moment to start up
    sleep 1
fi

# Path to wallpapers
WALLPAPER_DIR="$HOME/wallpapers-dt"

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
    exit 1
fi

# Function to change wallpaper
change_wallpaper() {
    # Get a random wallpaper file
    WALLPAPERS=("$WALLPAPER_DIR"/*)
    VALID_EXTENSIONS=("jpg" "jpeg" "png" "gif")
    
    # Filter for valid image files
    VALID_WALLPAPERS=()
    for FILE in "${WALLPAPERS[@]}"; do
        if [ -f "$FILE" ]; then
            EXTENSION=$(echo "${FILE##*.}" | tr '[:upper:]' '[:lower:]')
            for VALID_EXT in "${VALID_EXTENSIONS[@]}"; do
                if [ "$EXTENSION" = "$VALID_EXT" ]; then
                    VALID_WALLPAPERS+=("$FILE")
                    break
                fi
            done
        fi
    done
    
    # Check if we have any valid wallpapers
    if [ ${#VALID_WALLPAPERS[@]} -eq 0 ]; then
        echo "Error: No valid image files found in $WALLPAPER_DIR"
        exit 1
    fi
    
    # Select a random wallpaper
    RANDOM_INDEX=$((RANDOM % ${#VALID_WALLPAPERS[@]}))
    SELECTED_WALLPAPER="${VALID_WALLPAPERS[$RANDOM_INDEX]}"
    
    # Set the wallpaper with fade transition
    echo "Changing wallpaper to: $(basename "$SELECTED_WALLPAPER")"
    swww img "$SELECTED_WALLPAPER" --transition-type fade --transition-duration 1
}

# Main loop
echo "Starting wallpaper rotation every 30 seconds with fade transition. Press Ctrl+C to stop."
while true; do
    change_wallpaper
    sleep 60
done
