#! /bin/bash
watch="$HOME/.config/wayvr/theme/gui/watch.xml"
states="$HOME/.config/wayvr/theme/gui/states"
confighome="$HOME/.config/wayvr"
if [[ "$1" == "showsetsorpanels" ]]
then
	if [ -f "${states}/showsetsorpanels" ]
		then

			xmlstarlet ed -L -d "//div[@id='sets_root']/@width" "$watch"
			xmlstarlet ed -L -d "//div[@id='sets_root']/@height" "$watch"
			rm "${states}/showsetsorpanels"
		else
			xmlstarlet ed -L -i "//div[@id='sets_root']" -t attr -n width -v "0" "$watch"
			xmlstarlet ed -L -i "//div[@id='sets_root']" -t attr -n height -v "0" "$watch"
			touch "${states}/showsetsorpanels"

	fi
elif [[ "$1" == "showslimetoggle" ]]
	then
		if [ -f "${states}/showslimetoggle" ]
			then
				xmlstarlet ed -L -d "//div[@id='toggle_slime']/@display" "$watch"
				yq -i -y '.custom_panels += ["slimevr"]' "$confighome/conf.d/panels.yaml"
				rm "${states}/showslimetoggle"
			else
				xmlstarlet ed -L -i "//div[@id='toggle_slime']" -t attr -n display -v "none" "$watch"
				yq -i -y '.custom_panels |= map(select(. != "slimevr"))' "$confighome/conf.d/panels.yaml"
				touch "${states}/showslimetoggle"
		fi
elif [[ "$1" == "showhwmontoggle" ]]
then
	if [ -f "${states}/showhwmontoggle" ]
	then
		xmlstarlet ed -L -d "//div[@id='hwmon_button']/@display" "$watch"
		yq -i -y '.custom_panels += ["hwmon"]' "$confighome/conf.d/panels.yaml"
		rm "${states}/showhwmontoggle"
	else
		xmlstarlet ed -L -i "//div[@id='hwmon_button']" -t attr -n display -v "none" "$watch"
		yq -i -y '.custom_panels |= map(select(. != "hwmon"))' "$confighome/conf.d/panels.yaml"
		touch "${states}/showhwmontoggle"

	fi
fi



