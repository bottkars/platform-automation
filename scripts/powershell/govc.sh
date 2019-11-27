######################################
# Description: retryop
#
# Arguments:
#
#######################################
function retryop()
{
  retry=0
  max_retries=$2
  interval=$3
  while [ ${retry} -lt ${max_retries} ]; do
    echo "Operation: $1, Retry #${retry}"
    eval $1
    if [ $? -eq 0 ]; then
      echo "Successful"
      break
    else
      let retry=retry+1
      echo "Sleep $interval seconds, then retry..."
      sleep $interval
    fi
  done
  if [ ${retry} -eq ${max_retries} ]; then
    echo "Operation failed: $1"
    exit 1
  fi
}



######################################
# Description:
#
# Arguments:
# | jq -r '.VirtualMachines[].Guest.ToolsStatus'
#######################################
function getToolsStatus() {
	local vm_ipath="${1}"

	if ! info=$(getInfo "${vm_ipath}"); then
		echo "${info}"
		return 1
	fi # 2>&1

	if ! toolsStatus=$(echo ${info} | jq'.VirtualMachines[].Guest.ToolsStatus'); then
		writeErr "Could not parse vm info at ${vm_ipath}"
		return 1
	elif [[ -z "${toolsStatus}" ]]; then
		writeErr "Tools state could not be parsed for VM at ${vm_ipath}"
		return 1
	fi

	echo "${toolsStatus}"
	return 0
}


## in update base:


echo "--------------------------------------------------------"
echo "waiting for tools offline on VM ${base_vm_name}"
echo "--------------------------------------------------------"

while [[ $(getToolsStatus "${baseVMIPath}" ) != 'toolsNotRunning' ]]
do	
	printf .
	sleep 2
done
echo 
echo "--------------------------------------------------------"
echo "Tools stopped on ${base_vm_name}"
echo "--------------------------------------------------------"



echo "--------------------------------------------------------"
echo "waiting for tools online on VM ${base_vm_name}"
echo "--------------------------------------------------------"

while [[ $(getToolsStatus "${baseVMIPath}" ) != 'toolsOk' ]]
do	
	printf .
	sleep 10
done
echo 
echo "--------------------------------------------------------"
echo "Tools Running on VM ${base_vm_name}"
echo "--------------------------------------------------------"



echo "|"

if ! retryop "shutdownVM '${baseVMIPath}'" 6 10; then
	writeErr "shudown vm"
	exit 1
else

###
clone_base
# mutually destroy vm upon cloning
stembuildVMIPath=$(buildIpath "${vcenter_datacenter}" "${vm_folder}" "${stembuild_vm_name}")
echo "--------------------------------------------------------"
echo "Destroy Base VM"
echo "--------------------------------------------------------"
destroyVM "${stembuildVMIPath}"

#
if  vmExists "${baseVMIPath}"; then
	writeErr "base VM found not found for clone at path ${iPath}"
	exit 1
fi

