#!/usr/bin/env fish

function download
  argparse -n download 'h/help' 't/target=' -- $argv
  or return 1

  if set -lq _flag_help
    echo "download-istio.fish -t/--target <TARGET_URL>"
    return
  end

  set -lq _flag_target
  or set -l _flag_target "https://istio.io/downloadIstio"

  curl -L $_flag_target | sh -
end

download $argv
