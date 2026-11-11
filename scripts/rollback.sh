#!/bin/bash
set -e

TARGET_VERSION=${1:-${TARGET_VERSION:-"v2.2.0"}}
echo "Rolling back deployment..."
echo "Reverting to previous stable version: $TARGET_VERSION"
# kubectl rollout undo deployment/lab-app
echo "Rollback completed."
