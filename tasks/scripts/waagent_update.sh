# jq based 
update=true
GOALSTATE=2.2.38
printf  "\e[1mReading BoSH deployments for \e[35m$BOSH_ENVIRONMENT \e[0m\e[1mas client \e[35m$BOSH_CLIENT\e[0m\n"

DEPLOYMENTS=$(bosh deployments --json | jq -r ".Tables[].Rows[].name")
while IFS= read -r DEPLOYMENT
do
    if [[ ${DEPLOYMENT} != *"pas-windows"* ]]
    then
        printf  "\e[1mChecking WAAGENT for deployment \e[35m$DEPLOYMENT \e[0m\n"
        VMS=$(bosh -d $DEPLOYMENT vms --json | jq -r ".Tables[].Rows[].instance")
        while IFS= read -r VM
            do
            printf "==>Checking current WAAGENT Version for \e[1m$VM:  \e[32m"
            WAAGENTVER=$(bosh -d $DEPLOYMENT ssh $VM "sudo waagent -version" --json | jq -r '.Blocks[] | select(. | contains("Goal state agent"))')
            printf "${WAAGENTVER}\e[0m\n"
            sem=$(echo $WAAGENTVER | egrep -o '[0-9].[0-9].[0-9][0-9]')
            if [[ $sem < "$GOALSTATE" && $update = "true" ]]; then
                printf  "==>\e[33magent on $VM is behind $GOALSTATE, setting update\e[0m "
                printf "$(bosh -d $DEPLOYMENT ssh $VM "sudo sed -i 's/AutoUpdate.Enabled=n/AutoUpdate.Enabled=y/g' /etc/waagent.conf" --json | tr '\r\n' ' ' | jq -r '.Lines[] | select(.|test("Succeeded"))') \n"
                # success=$(echo $result  | tr '\r\n' ' ' | jq -r '.Lines[] | select(.|test("Succeeded"))')
                printf "==>\e[33mrestarting agent on $VM\e[0m "
                printf "$(bosh -d $DEPLOYMENT ssh $VM "sudo service walinuxagent restart" --json | tr '\r\n' ' ' | jq -r '.Lines[] | select( .|test("Succeeded"))') \n"
            fi
        done <<< "$VMS"
     fi   
done <<< "$DEPLOYMENTS"
    


