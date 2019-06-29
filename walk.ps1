$PIPELINE="azurestack_asdk"
$FLY_URL="https://plane.control.local.azurestack.external"
fly --target plane login --concourse-url $FLY_URL -k

fly -t plane set-pipeline -c .\pipeline_azurestack.yml -l vars_$($PIPELINE).yml -p $PIPELINE
fly -t plane up -p $PIPELINE

fly -t plane dp -p $PIPELINE

$PIPELINE="stackpoc"
$FLY_URL="https://plane.control.westus.stackpoc.com"
fly --target plane login --concourse-url $FLY_URL -k

fly -t plane set-pipeline -c pipeline_$($PIPELINE).yml -l vars_$($PIPELINE).yml -p $PIPELINE
fly -t plane up -p $PIPELINE

fly -t plane dp -p $PIPELINE




fly -t plane set-pipeline -c .\azcli_test\azcli_pipeline.yml -p azcli_test