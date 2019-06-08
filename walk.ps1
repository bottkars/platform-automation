$PIPELINE="azurestack_asdk"

fly --target plane login --concourse-url $FLY_URL -k

fly -t plane set-pipeline -c pipeline_s3.yml -l vars_pcfdemo.yml -p $PIPELINE
fly -t plane up -p $PIPELINE