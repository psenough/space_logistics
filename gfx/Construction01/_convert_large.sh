!/bin/bash

# Get the directory where the script is located (equivalent to %~dp0)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Loop through all .png files in the script's directory
for f in "$SCRIPT_DIR"/*.png; do
    # Check if file exists (handles case where no .png files are found)
    [ -e "$f" ] || continue

    echo "Converting: $f"
    python "./ticpanel.py" "$f"
done
