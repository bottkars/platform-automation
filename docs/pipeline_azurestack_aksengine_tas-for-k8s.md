# Readme for pipeline_azurestack_aksengine_tas-for-k8s.yml

## getting started
assuming to set variables for pipeline:
tbd

### setting the pipeline
```bash
flyme set-pipeline -c ${AKS_PIPELINE}  -l ${PLATFORM_VARS} -l ${AKS_VARS} -p ${AKS_CLUSTER} -v tas_k8s_domain=tas.local.azurestack.external
```

### what aks engine does


https://github.com/bottkars/azs-concourse/blob/cb255d5812b59da3115cc218d71b7ed9232e5b0a/ci/scripts/deploy-aks.sh#L10-L31

### login
```bash
get-cfvalues # command from my direnv aliases
cf api api.tas.local.azurestack.external --skip-ssl-validation
cf auth admin $(get-cfadmin)
```

### enable diego-docker

```bash
cf enable-feature-flag diego_docker
```

### create orgs and spaces
```bash
cf create-org demo
cf create-space test -o demo
cf target -o demo -s test
```

### clone source app

```bash
git clone https://github.com/cloudfoundry-samples/cf-sample-app-nodejs
```


### Push the app
```bash
cf enable-feature-flag diego_docker
```
