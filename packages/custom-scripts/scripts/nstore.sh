#! @runtimeShell@
set -euo pipefail

(($# == 0)) && exit 1

url="$(@python314@/bin/python -c 'from pathlib import Path; import sys; print(Path(sys.argv[1]).resolve().as_uri())' "$1")"

name="$(@coreutils@/bin/basename "$1")"

. <(
  @nix@/bin/nix store prefetch-file --json \
    --name "$name" \
    "$url" |
    @yq-go@/bin/yq -o shell
)

@coreutils@/bin/mkdir -p "${NSTORE_DIR:=${XDG_DATA_HOME:-$HOME/.local/share}/nstore}"

@nix@/bin/nix-store --add-root "$NSTORE_DIR/$name" --indirect --realise "$storePath"

echo "requireFile {
  name = \"$name\";
  url = \"...\";
  hash = \"$hash\";
}"
