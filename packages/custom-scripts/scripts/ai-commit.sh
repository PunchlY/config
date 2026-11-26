#! @runtimeShell@
set -euo pipefail

print_prompt=0

while (($#)); do
  case "$1" in
  --print-prompt)
    print_prompt=1
    shift
    ;;
  -*)
    shift
    ;;
  *)
    break
    ;;
  esac
done

if @git@/bin/git diff --cached --quiet; then
  echo "No staged changes to commit."
  exit 0
fi

IFS= read -r -d '' prompt <<EOF || :
You are an expert software engineer generating a Git commit message. 

## Context: Staged Changes
\`\`\`diff
$(@git@/bin/git diff --cached --no-ext-diff)
\`\`\`

## Context: Recent Commits
\`\`\`
$(@git@/bin/git log --oneline -5)
\`\`\`

## CRITICAL RULE: Commit Message Format
You MUST strictly output the commit message matching the EXACT format below:
<type>(<scope>): <subject>

1. <type> MUST be one of: feat, fix, refactor, perf, docs, test, build, ci, chore, style, revert.
2. (<scope>) is optional. Only use it if a specific module/component is modified.
3. <subject> MUST be in imperative mood, lowercase, no trailing period, max 72 chars.

Example Valid Output:
feat(auth): implement JWT token validation

Example Invalid Output (DO NOT DO THIS):
- Added JWT token validation (Wrong mood, capitalized, missing type)
- Here is your commit: feat: add JWT (Contains conversational text)

## Output Constraints
- OUTPUT ONLY the raw commit message text.
- NO markdown formatting.
- NO code blocks (\`\`\`).
- NO conversational text.
EOF

if [ "$print_prompt" = "1" ]; then
  echo "$prompt"
  exit 0
fi

COMMIT_MSG="$(@opencode@/bin/opencode run --agent plan "$prompt")"

if [ -z "${COMMIT_MSG}" ]; then
  echo "Generated commit message is empty."
  exit 1
fi

EDITED_MSG="$(@gum@/bin/gum write --width "${COLUMNS:-0}" <<<"$COMMIT_MSG")"

if [ -z "$EDITED_MSG" ]; then
  echo "Commit message is empty."
  exit 1
fi

@git@/bin/git commit -F - <<<"$EDITED_MSG"
