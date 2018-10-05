#!/bin/sh
set -eu

# todo: clean up path
DIR=${TF_ACTION_WORKING_DIR:-.}

# todo: support args to terraform plan
PLAN_OUTPUT_FILE=$(mktemp)
sh -c "TF_IN_AUTOMATION=true terraform plan -no-color $* | tee $PLAN_OUTPUT_FILE"

COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
FMT_PLAN=$(cat "$PLAN_OUTPUT_FILE" | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')
COMMENT="\`\`\`diff
$FMT_PLAN
\`\`\`"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
curl -v -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL"
