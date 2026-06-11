#!/bin/bash
echo "Starting Tome Add-on Initialization..."

# Create the persistent directories on the HA /share drive if they don't exist yet. Using -p ensures it creates parent folders without throwing an error if they already exist
mkdir -p /share/tome/books
mkdir -p /share/tome/bindery

# Remove the empty default folders that might exist inside the container image (If we don't delete these, the symlink command will fail)
rm -rf /books
rm -rf /bindery

# Create the symlinks. When Tome writes to /books, it's actually writing to /share/tome/books
ln -s /share/tome/books /books
ln -s /share/tome/bindery /bindery

# Check if the Home Assistant options file exists
if [ -f /data/options.json ]; then
  echo "Reading configuration from Home Assistant..."
  
  # Extract the token using jq. 
  # -r outputs raw text (removes quotes). // empty ensures it doesn't return "null".
  HARDCOVER_TOKEN=$(jq -r '.tome_hardcover_token // empty' /data/options.json)
  
  # If the user actually typed something in, export it!
  if [ -n "$HARDCOVER_TOKEN" ]; then
    export TOME_HARDCOVER_TOKEN="$HARDCOVER_TOKEN"
    echo "TOME_HARDCOVER_TOKEN successfully loaded and exported."
  else
    echo "No Hardcover token provided in add-on configuration. Skipping."
  fi
fi

# --------------------------------------

echo "Symlinks created and environment configured. Handing over to Tome..."

exec uvicorn app.main:app --host 0.0.0.0 --port 8080