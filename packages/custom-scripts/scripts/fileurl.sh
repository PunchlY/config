#! @runtimeShell@
set -euo pipefail

LC_ALL=C

printf "file://"

realpath="$(@coreutils@/bin/realpath -- "$1")"

for ((i = 0; i < ${#realpath}; i++)); do
  : "${realpath:i:1}"
  case "$_" in
  [._~0-9A-Za-z/-])
    printf '%s' "$_"
    ;;
  *)
    printf '%%%02X' "'$_"
    ;;
  esac
done
