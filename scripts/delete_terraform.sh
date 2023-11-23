#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Deleting .terraform folders in terraform/core..."
for dir in ../terraform/core/*; do
  if [[ -d "$dir" ]]; then
    echo "Deleting .terraform folder in $dir"
    find "$dir" -type d -name ".terraform" -exec rm -rf {} +
  fi
done

echo "Cleanup completed."
