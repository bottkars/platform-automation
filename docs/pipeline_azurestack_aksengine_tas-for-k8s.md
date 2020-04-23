# Readme for pipeline_azurestack_aksengine_tas-for-k8s.yml

## getting started


### setting the pipeline
```bash
flyme set-pipeline -c ${AKS_PIPELINE}  -l ${PLATFORM_VARS} -l ${AKS_VARS} -p ${AKS_CLUSTER} -v tas_k8s_domain=tas.local.azurestack.external
```

### what aks engine does


https://github.com/bottkars/azs-concourse/blob/cb255d5812b59da3115cc218d71b7ed9232e5b0a/ci/scripts/deploy-aks.sh#L10-L31

