$PIPELINE="azurestack_asdk"
$FLY_URL="https://plane.control.local.azurestack.external"
fly --target plane login --concourse-url $FLY_URL -k

fly -t plane set-pipeline -c pipeline_pcfdemo.yml -l vars_pcfdemo.yml -p $PIPELINE
fly -t plane up -p $PIPELINE

fly -t plane dp -p $PIPELINE
