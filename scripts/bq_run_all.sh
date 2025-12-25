#!/usr/bin/env bash
set -euo pipefail

PROJECT_ID="${1:?Usage: $0 <PROJECT_ID> <DATASET> [LOCATION]}"
DATASET="${2:?Usage: $0 <PROJECT_ID> <DATASET> [LOCATION]}"
LOCATION="${3:-US}"

echo "Using PROJECT_ID=$PROJECT_ID DATASET=$DATASET LOCATION=$LOCATION"

command -v bq >/dev/null 2>&1 || { echo "ERROR: bq CLI not found. Install Google Cloud SDK."; exit 1; }

# Ensure dataset exists (idempotent)
if bq --project_id="$PROJECT_ID" --location="$LOCATION" show --format=none "${PROJECT_ID}:${DATASET}" >/dev/null 2>&1; then
  echo "Dataset exists: ${PROJECT_ID}:${DATASET}"
else
  echo "Creating dataset: ${PROJECT_ID}:${DATASET} (location=${LOCATION})"
  bq --project_id="$PROJECT_ID" --location="$LOCATION" mk --dataset "${PROJECT_ID}:${DATASET}"
fi

run_sql_file() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "ERROR: Missing SQL file: $file"
    exit 1
  fi

  if [[ ! -s "$file" ]]; then
    echo "ERROR: Empty SQL file: $file"
    exit 1
  fi

  echo "-> $file"

  # Read SQL safely (prevents 'No query string provided')
  local sql
  sql="$(perl -pe 's/\r$//' "$file")"

  bq --project_id="$PROJECT_ID" --location="$LOCATION" \
    query --use_legacy_sql=false --quiet "$sql"
}

run_dir() {
  local dir="$1"
  echo "Running SQL in: $dir"

  shopt -s nullglob
  local files=("$dir"/*.sql)
  shopt -u nullglob

  if ((${#files[@]} == 0)); then
    echo "(no .sql files found)"
    return 0
  fi

  for f in "${files[@]}"; do
    run_sql_file "$f"
  done
}

run_dir "sql/raw"
run_dir "sql/staging"
run_dir "sql/marts"
run_dir "sql/reporting"

echo "Done. Listing objects in dataset: $DATASET"
bq --project_id="$PROJECT_ID" ls -n 200 "$DATASET"
