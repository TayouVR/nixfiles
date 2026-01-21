#! /bin/bash
set -e

while [ ! -f $HOME/.config/wayvr/theme/gui/states/sysstatsrootrectstatus ]
do
	junctiontemp=$(sensors amdgpu-pci-0300 | grep 'junction:' | awk '{print $2}')
	memtemp=$(sensors amdgpu-pci-0300 | grep 'mem:' | awk '{print $2}')
	tctltemp=$(sensors k10temp-pci-00c3 | grep "Tctl:" | awk '{print $2}')
	gpuusage=$(amd-smi monitor -u | awk '{print $5," %"}' | head -2 | tail -1)
{
  echo "panel-modify watch junction set-text \"Junction ${junctiontemp}\""
  echo "panel-modify watch mem set-text \"Mem: ${memtemp}\""
  echo "panel-modify watch tctl set-text \"Tctl: ${tctltemp}\""
	echo "panel-modify watch gpuusage set-text \"GPU: ${gpuusage}\""
} | wayvrctl batch

	sleep 1
done
