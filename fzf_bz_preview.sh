#!/bin/sh -e

text="$1"
file=${text%%:*}
remaining=${text#*:}
line=${remaining%%:*}
left=$(( line - 5 > 0 ? line - 5 : 0 ))
right=$(( line + 10 ))

bat "$file" -H "$line" -r $left:$right -l bazel -f --theme=ansi --style=numbers,header
