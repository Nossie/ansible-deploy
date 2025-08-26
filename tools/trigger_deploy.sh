#!/bin/bash
# Helper to queue deploy pipeline

if [ -z "$AZDO_PAT" ] || [ -z "$AZDO_ORG" ] || [ -z "$AZDO_PROJECT" ] || [ -z "$DEPLOY_PIPELINE_ID" ]; then
  echo "Please set AZDO_PAT, AZDO_ORG, AZDO_PROJECT, DEPLOY_PIPELINE_ID"
  exit 1
fi

curl -u :$AZDO_PAT \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"resources": {}}' \
  "https://dev.azure.com/$AZDO_ORG/$AZDO_PROJECT/_apis/pipelines/$DEPLOY_PIPELINE_ID/runs?api-version=7.1-preview.1"

