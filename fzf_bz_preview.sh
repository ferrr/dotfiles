#!/bin/sh -e

text="$1"
file=${text%%:*}
remaining=${text#*:}
line=${remaining%%:*}
left=$(( line - 5 > 0 ? line - 5 : 0 ))
right=$(( line + 10 ))

if which bat &> /dev/null; then
  bat "$file" -H "$line" -r $left:$right -l bazel -f --theme=ansi --style=numbers,header
else
  nl -ba "$file" | sed -n "$left,${right}p"
fi
