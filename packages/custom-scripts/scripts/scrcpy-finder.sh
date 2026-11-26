#! @runtimeShell@
set -euo pipefail

tcpip="$(
  @net-tools@/bin/arp -a |
    @fzy@/bin/fzy |
    @jc@/bin/jc --arp |
    @jq@/bin/jq -r '.[0].address'
)"

exec @scrcpy@/bin/scrcpy --tcpip="$tcpip" "$@"
