# jq based 
alias jp.py="/usr/local/Cellar/azure-cli/2.0.70/libexec/bin/jp.py"
alias jp.py=/opt/az/bin/jp.py
update=true
GOALSTATE=2.2.38
DEPLOYMENTS=$(bosh deployments --json | jp.py 'Tables[].Rows[].name[]' | tr -d '[]"\n ')
while IFS=',' read -r DEPLOYMENT
do
 echo "deployment $DEPLOYMENT"

if [[ ${DEPLOYMENT} != *"pas-windows"* ]];then
        echo "\e[1mChecking WAAGENT for deployment \e[35m$DEPLOYMENT \e[0m"
        VMS=$(bosh -d $DEPLOYMENT vms --json | jp.py 'Tables[].Rows[].instance' | tr -d '[]" \n')
        while IFS=',' read -r VM
        do
            printf "==>Checking current WAAGENT Version for \e[1m$VM:  \e[32m"
            WAAGENTVER=$(bosh -d $DEPLOYMENT ssh $VM "sudo waagent -version" --json | jq -r '.Blocks[] | select(. | contains("Goal state agent"))')
            printf "${WAAGENTVER}\e[0m\n"
            sem=$(echo $WAAGENTVER | egrep -o '[0-9].[0-9].[0-9][0-9]')
    #        if [[ $sem < "$GOALSTATE" && $update = "true" ]]; then
    #            printf  "==>\e[33magent on $VM is behind $GOALSTATE, setting update\e[0m "
    #            printf "$(bosh -d $DEPLOYMENT ssh $VM "sudo sed -i 's/AutoUpdate.Enabled=n/AutoUpdate.Enabled=y/g' /etc/waagent.conf" --json | tr '\r\n' ' ' | jq -r '.Lines[] | select(.|test("Succeeded"))') \n"
                # success=$(echo $result  | tr '\r\n' ' ' | jq -r '.Lines[] | select(.|test("Succeeded"))')
    #            printf "==>\e[33mrestarting agent on $VM\e[0m "
    #            printf "$(bosh -d $DEPLOYMENT ssh $VM "sudo service walinuxagent restart" --json | tr '\r\n' ' ' | jq -r '.Lines[] | select( .|test("Succeeded"))') \n"
    #       fi
        done <<< "$VMS"
    fi   
done <<< "$DEPLOYMENTS"
    


