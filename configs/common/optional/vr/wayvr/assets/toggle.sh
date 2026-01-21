
#! /bin/bash
set -e
FILE="${1}status"

if [ -f $HOME/.config/wayvr/theme/gui/states/$FILE ]; then
		wayvrctl panel-modify watch $1 set-visible 1;			
		rm $HOME/.config/wayvr/theme/gui/states/$FILE;
else
	wayvrctl panel-modify watch $1 set-visible 0;
	touch $HOME/.config/wayvr/theme/gui/states/$FILE;
fi

