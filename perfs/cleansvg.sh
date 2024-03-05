#!/bin/bash
optimize_svg_files() {
local directory="$1"
echo "$directory"
find "$directory" -type f -name "*.svg" -exec du -b {} + | awk '{s+=$1; count++} END {print ".svg files count:", count, "/ Size before optimisation:", s/1024, "Kb"}'
find "$directory" -type f -name "*.svg" -exec ./svgcleaner {} {} \; > /dev/null 2>&1
find "$directory" -type f -name "*.svg" -exec du -b {} + | awk '{s+=$1} END {print "Size after optimisation:", s/1024, "Kb"}'
}

optimize_svg_files "/usr/share"
optimize_svg_files "/usr/lib"
optimize_svg_files "/opt/trinity"




