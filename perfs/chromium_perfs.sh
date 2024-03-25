#!/bin/bash
folder=/etc/chromium.d
flags="--ignore-gpu-blacklist --enable-checker-imaging --cc-scroll-animation-duration-in-seconds=0.6 --disable-quic --enable-tcp-fast-open --enable-experimental-canvas-features --enable-scroll-prediction --enable-simple-cache-backend --max-tiles-for-interest-area=512 --num-raster-threads=4 --default-tile-height=512 --enable-features=VaapiVideoDecoder,VaapiVideoEncoder,ParallelDownloading --disable-features=UseChromeOSDirectVideoDecoder --enable-accelerated-video-decode --enable-low-res-tiling --process-per-site"
  #The --process-per-site flag significantly decreases RAM usage and number of chromium processes, without any noticeable disadvantages.
  #Not using --enable-low-end-device-mode even though it helps, because scrolling image-heavy pages would crash with "background allocation failure" error.
  
  echo "Adding $flags to ${folder}/performance_improvements"
  cat << EOF | sudo tee "${folder}/performance_improvements" >/dev/null
export CHROMIUM_FLAGS="\$CHROMIUM_FLAGS $flags"
EOF