#! /bin/bash


wayvrctl panel-modify watch listenforsong set-visible 0
while :
do
	name="$(playerctl metadata title)"
	name="${name:0:20}"
	wayvrctl panel-modify watch songname set-text "$name"
	sleep 3;
done
