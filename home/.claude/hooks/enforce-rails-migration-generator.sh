#!/usr/bin/env bash
# PreToolUse hook (Write): block creating NEW files in a Rails db/migrate folder.
# Editing an existing migration is still allowed.

file_path=$(jq -r '.tool_input.file_path // empty')

case "$file_path" in
  */db/migrate/*) ;;
  *) exit 0 ;;
esac

[ -e "$file_path" ] && exit 0

reason=$(cat <<'EOF'
Do not create migration files directly. Run `bin/rails generate migration <MigrationName>` to generate the file (with the correct timestamp), then edit its body.

Usage: bin/rails generate migration NAME [field[:type][:index] ...] [options]

Name conventions that pre-fill the body:
  add_{columns}_to_{table} title:string body:text  -> add_column lines
  remove_{columns}_from_{table} title:string       -> remove_column lines
  create_{table} email:string                      -> create_table with columns + timestamps
  create_media_join_table artists musics:uniq      -> create_join_table (name contains JoinTable)
  anything else (e.g. backfill_user_roles)         -> empty change method

Field syntax: name:type[:index|:uniq], e.g. user:references, email:string:uniq
Useful options: --pretend (dry run), --database=NAME, --no-timestamps
EOF
)

jq -n --arg reason "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $reason
  }
}'
