        Push-Location $PSScriptRoot
        $DIRECTOR_CONTROL_FILE="$HOME\director_control.json"
        $DIRECTOR_CONTROL = Get-Content $DIRECTOR_CONTROL_FILE | ConvertFrom-Json
        $OM_Target = $DIRECTOR_CONTROL.OM_TARGET
        $domain = $DIRECTOR_CONTROL.domain
        $PCF_DOMAIN_NAME = $domain
        $PCF_SUBDOMAIN_NAME = $DIRECTOR_CONTROL.PCF_SUBDOMAIN_NAME

        $RG = $DIRECTOR_CONTROL.RG
        #some env´s
        $env_vars = Get-Content $HOME/env.json | ConvertFrom-Json
        $OM_Password = $env_vars.OM_Password
        $OM_Username = $env_vars.OM_Username
        $OM_Target = $OM_Target
        $env:Path = "$($env:Path);$HOME/OM;$HOME/bosh;$HOME/credhub"
        $PIVNET_UAA_TOKEN = $env_vars.PIVNET_UAA_TOKEN

        $ssh_public_key = Get-Content $HOME/opsman.pub
        $ssh_private_key = Get-Content $HOME/opsman
        $ssh_private_key = $ssh_private_key -join "\r\n"
        $ca_cert = Get-Content $HOME/root.pem
        $ca_cert = $ca_cert -join "\r\n"

        $fullchain = get-content "$($HOME)/$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME).crt"
        $fullchain = $fullchain -join "`r`n  "
        ## READ OM KEYS and CERT wit `n`r ad passed as dos strings
        $om_cert = Get-Content "$($HOME)/$($OM_Target).crt"
        $om_cert = $om_cert -join "`r`n"

        $om_key = get-content "$($HOME)/$($OM_Target).key"
        $om_key = $om_key -join "`r`n"

        $OM_ENV_FILE = "$HOME/OM_$($RG).env"   

        Invoke-Expression $(om --env $HOME/om_$($RG).env  bosh-env --ssh-private-key $HOME/opsman | Out-String)


        $CREDHUB_URL="https://plane.$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME):8844"
        $FLY_URL="https://plane.$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME)"
        $CREDHUB_PASSWORD=(credhub get /name:'/p-bosh/control-plane/credhub_admin_client_password' /j | ConvertFrom-Json).value
        $CLIENT_NAME="credhub_admin_client"
        $CONTROL_CRED_CA_CERT=credhub get /name:'/p-bosh/control-plane/control-plane-tls' -k certificate
        $env:CREDHUB_CLIENT = ""
        $env:CREDHUB_CA_CERT = ""
        $env:CREDHUB_PROXY = ""
        $env:CREDHUB_SERVER = ""
        $env:CREDHUB_SECRET = ""
        credhub login /server:$CREDHUB_URL /client-name:$CLIENT_NAME /client-secret:$credhub_password /skip-tls-validation

$DIRECTOR_FOUNDATION_FILE="$HOME\director_pcf.json"

$DIRECTOR_FOUNDATION = Get-Content $DIRECTOR_FOUNDATION_FILE | ConvertFrom-Json
$FOUNDATION=$DIRECTOR_FOUNDATION.PCF_SUBDOMAIN_NAME
($CONTROL_CRED_CA_CERT | Out-String) | set-content $HOME\credhub_ca_cert


$S3_ENDPOINT="http://minio.control.sc2.azurestack-rd.cf-app.com:9000"

## vals for pivnet and s3, at the Foundation level ( foundation os the Pipelin Name)
credhub set /name:/concourse/main/$($FOUNDATION)/pivnet-token /type:value --value $($env_vars.EMC_PIVNET_UAA_TOKEN)
credhub set /name:/concourse/main/pivnet-token /type:value --value $($env_vars.EMC_PIVNET_UAA_TOKEN)
credhub set /name:/concourse/main/$($FOUNDATION)/pivnet-token /type:value --value $($env_vars.EMC_PIVNET_UAA_TOKEN)
credhub set /name:/concourse/main/$($FOUNDATION)/s3_access_key_id /type:value --value s3admin
credhub set /name:/concourse/main/$($FOUNDATION)/s3_endpoint /type:value --value "http://minio.$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME):9000"
credhub set /name:/concourse/main/$($FOUNDATION)/s3_region_name /type:value --value region
credhub set /name:/concourse/main/$($FOUNDATION)/s3_secret_access_key /type:value --value $($env_vars.PIVNET_UAA_TOKEN)

# credhub set /name:/concourse/main/s3_endpoint /type:value --value "http://minio.$($PCF_SUBDOMAIN_NAME).$($PCF_DOMAIN_NAME):9000"
# credhub set /name:/concourse/main/s3_region_name /type:value /value:region



credhub set /name:/concourse/main/$($FOUNDATION)/buckets_pivnet_tasks /type:value --value tasks
credhub set /name:/concourse/main/$($FOUNDATION)/buckets_pivnet_image /type:value --value image
credhub set /name:/concourse/main/$($FOUNDATION)/buckets_pivnet_products /type:value --value pivnet.products
credhub set /name:/concourse/main/$($FOUNDATION)/buckets_installation /type:value --value installation


## azs root ca
credhub set /name:/concourse/main/$FOUNDATION/azs_ca /type:certificate /certificate:$HOME/root.pem 



credhub set /name:/concourse/main/$($FOUNDATION)/tenant_id /type:value --value $(Get-AzureRmSubscription).TenantId
credhub set /name:/concourse/main/$($FOUNDATION)/client_id /type:value --value $($env_vars.client_id)
credhub set /name:/concourse/main/$($FOUNDATION)/client_secret /type:value --value $($env_vars.client_secret)
credhub set /name:/concourse/main/$($FOUNDATION)/subscription_id /type:value --value $(Get-AzureRmSubscription).SubscriptionId




credhub set /name:/concourse/main/$($FOUNDATION)/endpoint-resource-manager /type:value --value $(Get-AzureRmContext).Environment.ResourceManagerUrl


credhub set /name:/concourse/main/$FOUNDATION/tenant-endpoint-resource /type:value --value $(Get-AzureRmContext).Environment.ActiveDirectoryServiceEndpointResourceId
credhub set /name:/concourse/main/$FOUNDATION/domain /type:value --value $(Get-AzureRmContext).Environment.StorageEndpointSuffix

#### setup access for credhub interpolate jobs

credhub set /name:/concourse/main/$($FOUNDATION)/credhub-client /type:value --value $CLIENT_NAME
credhub set /name:/concourse/main/$($FOUNDATION)/credhub-secret /type:value --value $CREDHUB_PASSWORD
credhub set /name:/concourse/main/$($FOUNDATION)/credhub-server /type:value --value $CREDHUB_URL
credhub set /name:/concourse/main/$($FOUNDATION)/credhub-ca-cert /type:certificate /certificate:"$HOME\credhub_ca_cert"


credhub set /name:/concourse/main/$($FOUNDATION)/credhub-client /type:value --value $CLIENT_NAME
credhub set /name:/concourse/main/$($FOUNDATION)/credhub-secret /type:value --value $CREDHUB_PASSWORD
credhub set /name:/concourse/main/$($FOUNDATION)/credhub-server /type:value --value $CREDHUB_URL
credhub set /name:/concourse/main/$($FOUNDATION)/credhub-ca-cert /type:certificate /certificate:"$HOME\credhub_ca_cert"


### git resources
# cerate a git repo for variables
# variable.yml
#  --foundation
#               -- cert - root.pem
#               -- config - parameters_opsman.json
#               -- vars - director
## create ssh keys for git resources
$KEY="variable-deploy-key"
ssh-keygen -t rsa -b 4096 -C "$($KEY)@sc2.com" -f $HOME/.ssh/$KEY

credhub set /name:/concourse/main/$FOUNDATION/$($KEY) /type:ssh `
        /private:$HOME\.ssh\$($KEY) `
        /public:$HOME\.ssh\$($KEY).pub



# create a git repo holding your product templates
# --download-product-configs
# --product-configs
## create ssh keys for git resources and add them to the according repo
#
$KEY="template-deploy-key"
ssh-keygen -t rsa -b 4096 -C "$($KEY)@sc2.com" -f $HOME/.ssh/$KEY

credhub set /name:/concourse/main/$FOUNDATION/$($KEY) /type:ssh `
        /private:$HOME\.ssh\$($KEY) `
        /public:$HOME\.ssh\$($KEY).pub
         
         



## optional repo
credhub set /name:/concourse/main/$($FOUNDATION)/azs-resource-key /type:ssh `
         /private:$HOME\.ssh\azs_resource `
         /public:$HOME\.ssh\azs-resource.pub

credhub set /name:/concourse/main/plat-auto-pipes-deploy-key /type:ssh `
         /private:$HOME\.ssh\git_deploy `
         /public:$HOME\.ssh\git_deploy.pub
credhub set /name:/concourse/main/plat-auto-pipes-deploy-key /type:ssh `
         /private:$HOME\.ssh\pcfdemo_asdk_config `
         /public:$HOME\.ssh\pcfdemo_asdk_config.pub 


# credhub set /name:/concourse/main/buckets_pivnet_tasks /type:value --value tasks
# credhub set /name:/concourse/main/buckets_pivnet_image /type:value --value image
# credhub set /name:/concourse/main/buckets_pivnet_products /type:value --value pivnet.products
# credhub set /name:/concourse/main/buckets_installation /type:value --value installation






# s3 connection
credhub set /name:/concourse/main/buckets_pivnet_products /type:value --value pivnet.products
credhub set /name:/concourse/main/secret_access_key /type:value --value $($env_vars.PIVNET_UAA_TOKEN)
credhub set /name:/concourse/main/access_key_id /type:value --value s3admin




# change this to arm deployment outputs
<#
credhub set /name:/concourse/main/$($FOUNDATION)/subnet /type:value --value $(terraform output management_subnet_name)
credhub set /name:/concourse/main/$($FOUNDATION)/vnet /type:value --value $(terraform output network_name)
credhub set /name:/concourse/main/$($FOUNDATION)/ops-manager-private-ip /type:value --value $(terraform output ops_manager_private_ip)
credhub set /name:/concourse/main/$($FOUNDATION)/ops-manager-public-ip /type:value --value $(terraform output ops_manager_public_ip)
credhub set /name:/concourse/main/$($FOUNDATION)/resource-group /type:value --value $($FOUNDATION)
credhub set /name:/concourse/main/$($FOUNDATION)/foundation /type:value --value $($FOUNDATION)
credhub set /name:/concourse/main/$($FOUNDATION)/location /type:value --value ${LOCATION}
credhub set /name:/concourse/main/$($FOUNDATION)/ops-manager-dns /type:value --value $(terraform output ops_manager_dns)
#>

### certs
# ASDK
credhub set /name:/concourse/main/$FOUNDATION/pcf_domain_cert /type:certificate `
 /certificate:$HOME\pcfdemo.local.azurestack.external.crt `
 /private:$HOME\pcfdemo.local.azurestack.external.key 
## pcfsc2
##

credhub set /name:/concourse/main/$FOUNDATION/pcf_domain_cert /type:certificate `
 /certificate:$HOME\pcfsc2.sc2.azurestack-rd.cf-app.com.crt `
 /private:$HOME\pcfsc2.sc2.azurestack-rd.cf-app.com.key 
 

 credhub set /name:/concourse/main/$FOUNDATION/pcf_fullchain_cert /type:certificate `
 /certificate:$HOME\pcfsc2.sc2.azurestack-rd.cf-app.com.crt `
 /private:$HOME\pcfsc2.sc2.azurestack-rd.cf-app.com.key  
 ### opsman
 credhub set /name:/concourse/main/$FOUNDATION/pcf_opsman_cert /type:certificate `
 /certificate:$HOME\pcf.pcfdemo.local.azurestack.external.crt `
 /private:$HOME\pcf.pcfdemo.local.azurestack.external.key


 credhub set /name:/concourse/main/$FOUNDATION/pcf_domain_cert /type:certificate `
 /certificate:C:\Users\kbott\AppData\Local\Posh-ACME\acme-v02.api.letsencrypt.org\55142119\pcfdemo.westus.stackpoc.com\cert.cer `
 /public:C:\Users\kbott\AppData\Local\Posh-ACME\acme-v02.api.letsencrypt.org\55142119\pcfdemo.westus.stackpoc.com\cert.key
