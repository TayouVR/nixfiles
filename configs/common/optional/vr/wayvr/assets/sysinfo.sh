#!/bin/bash
set -e
wayvrctl panel-modify hwmon startbutton set-visible 0
wayvrctl panel-modify hwmon rootrect set-visible 1

while :
do
	wayvrctl panel-modify hwmon top set-text "$(top -b -n 1 | head -20 | tail -14 | awk '{print $9," | " $10, " | "$11 " | ", $12}')"
	sleep 5;
done
