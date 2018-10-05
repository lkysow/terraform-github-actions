#!/bin/sh -l
set -eu

# todo: use random name for plan.out
# todo: use the TF_INAUTOMATION env var
terraform plan -no-color | tee /tmp/plan.out

COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
FMT_PLAN=$(cat /tmp/plan.out | sed -r -e 's/^  \+/\+/g' | sed -r -e 's/^  ~/~/g' | sed -r -e 's/^  -/-/g')
COMMENT="\`\`\`diff
$FMT_PLAN
\`\`\`"
PAYLOAD=$(echo '{}' | jq --arg body "$COMMENT" '.body = $body')
curl -v -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL"
