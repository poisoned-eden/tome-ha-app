#!/bin/bash
echo "--- BOOTING NEW SCRIPT V0.1.6 ---"

export TOME_LIBRARY_DIR="/share/tome/books"
export TOME_INCOMING_DIR="/share/tome/bindery"

mkdir -p /share/tome/books
mkdir -p /share/tome/bindery

if [ -f /data/options.json ]; then
  echo "Reading configuration from Home Assistant..."
  
  HARDCOVER_TOKEN=$(jq -r '.tome_hardcover_token // empty' /data/options.json)
  
  if [ -n "$HARDCOVER_TOKEN" ]; then
    export TOME_HARDCOVER_TOKEN="$HARDCOVER_TOKEN"
    echo "TOME_HARDCOVER_TOKEN successfully loaded and exported."
  else
    echo "No Hardcover token provided in add-on configuration. Skipping."
  fi
fi

# --------------------------------------

echo "Environment configured. Handing over to Tome..."

cd /app

exec uvicorn backend.main:app --host 0.0.0.0 --port 8080