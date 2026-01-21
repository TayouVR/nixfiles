#! /bin/bash
set -e
wayvrctl panel-modify watch top_button set-visible 0
while :
do
wayvrctl panel-modify watch top set-text "$(top -b -n 1 | head -10 | tail -4 | awk '{print $9," | " $10, " | "$11 " | ", $12}')"
sleep 5
done
