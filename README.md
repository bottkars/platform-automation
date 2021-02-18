# readme for Platform Pipeline´s 






# DELL DPS Pipelines


## DPC on vSphere

```bash
fly -t asdk set-pipeline -p vSphere-DPC -c ../platform-automation/pipeline_dps_dpc_vsphere.yml -l ../dpslab_labbuildr_local/vars_powerprotect.yml
```


```bash
flyme set-pipeline -c ${AKS_PIPELINE}  -l ${PLATFORM_VARS} -l ${AKS_VARS} -p ${AKS_CLUSTER}
```
