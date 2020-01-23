
```
PIPELINE=stackpoc
TARGET=plane

PIPELINE=pcfdemo
TARGET=asdk
```
```bash
TILES=( "srt" "pas-windows" "pivotal-mysql" "p-healthwatch" "wavefront-nozzle" "p-event-alerts" "p-spring-cloud-services" "p-spring-cloud-services-3" "p-rabbitmq" )  

for TILE in "${TILES[@]}"
do
   fly -t ${TARGET} tj -j ${PIPELINE}/get-${TILE}
done
```

# "srt" "pivotal-mysql" "p-healthwatch" "wavefront-nozzle" "p-event-alerts" "p-spring-cloud-services-3" "p-rabbitmq" "apm"

```bash
PIPELINE=pcfazurestack
TARGET=control
TILES=(  "reliability-view-pas-exporter" "reliability-view-pcf" "p-compliance-scanner" "azure-service-broker" )  

for TILE in "${TILES[@]}"
do
   fly -t ${TARGET} tj -j ${PIPELINE}/upload-and-stage-${TILE}
done


for TILE in "${TILES[@]}"
do
   fly -t ${TARGET} tj -j ${PIPELINE}/configure-${TILE}
done
```


upload-and-stage-pivotal-mysql                  no      n/a        pending
upload-and-stage-p-healthwatch                  no      n/a        pending
upload-and-stage-wavefront-nozzle               no      n/a        pending
upload-and-stage-p-event-alerts                 no      n/a        pending
upload-and-stage-apm                            no      succeeded  pending
upload-and-stage-p-compliance-scanner           no      n/a        n/a
upload-and-stage-reliability-view-pcf           no      n/a        n/a
upload-and-stage-reliability-view-pas-exporter  no      n/a        n/a
upload-and-stage-p-spring-cloud-services        no      n/a        n/a
upload-and-stage-p-spring-cloud-services-3      no      n/a        pending
upload-and-stage-p-rabbitmq



get-p-spring-cloud-services                     no      succeeded  n/a
get-p-spring-cloud-services-3                   no      succeeded  n/a
get-pivotal-mysql                               no      succeeded  n/a
get-p-healthwatch                               no      succeeded  n/a
get-wavefront-nozzle                            no      succeeded  n/a
get-p-event-alerts                              no      succeeded  n/a
get-p-rabbitmq                                  no      succeeded  n/a
get-pas-windows                                 no      failed     n/a
upload-and-stage-pas                            no      n/a        n/a
upload-and-stage-srt                            no      succeeded  n/a
upload-and-stage-pas-windows                    no      n/a        n/a
upload-and-stage-pivotal-mysql                  no      succeeded  n/a
upload-and-stage-p-healthwatch                  no      succeeded  n/a
upload-and-stage-wavefront-nozzle               no      n/a        n/a
upload-and-stage-p-event-alerts                 no      succeeded  n/a
upload-and-stage-p-spring-cloud-services        no      succeeded  n/a
upload-and-stage-p-spring-cloud-services-3      no      succeeded  n/a
upload-and-stage-p-rabbitmq                     no      succeeded  n/a
configure-pas                                   no      n/a        n/a
configure-pas-windows                           no      n/a        n/a
configure-p-rabbitmq                            no      succeeded  n/a
configure-pivotal-mysql                         no      succeeded  n/a
configure-p-healthwatch                         no      succeeded  n/a
configure-wavefront-nozzle                      no      n/a        n/a
configure-p-event-alerts                        no      succeeded  n/a
configure-p-spring-cloud-services               no      succeeded  n/a
configure-p-spring-cloud-services-3             no      succeeded  n/a
configure-srt                                   no      succeeded  n/a
deploy-asdk                                     no      succeeded  n/a
staged-pas-config                               no      succeeded  n/a
apply-product-changes                           no      succeeded  n/a
staged-pivotal-mysql-config                     no      succeeded  n/a
staged-p-spring-cloud-services-config           no      succeeded  n/a
staged-p-spring-cloud-services-3-config         no      succeeded  n/a
staged-p-rabbitmq-config                        no      succeeded  n/a
get-p-compliance-scanner                        no      succeeded  n/a
upload-and-stage-p-compliance-scanner           no      succeeded  n/a
configure-p-compliance-scanner                  no      succeeded  n/a




export BOSH_CLIENT=ops_manager \
BOSH_CLIENT_SECRET=QMzbL_OvZTuGBbokKSOKwh6cyDTgfmKj \
BOSH_ENVIRONMENT=172.16.1.11 \
BOSH_CA_CERT=/var/tempest/workspaces/default/root_ca_certificate \
CREDHUB_CLIENT=ops_manager \
CREDHUB_SERVER=https://172.16.1.11:8844 \
CREDHUB_SECRET=QMzbL_OvZTuGBbokKSOKwh6cyDTgfmKj \
CREDHUB_CA_CERT=/var/tempest/workspaces/default/root_ca_certificate



*.istio-apps.run.haas-259.pez.pivotal.io,*.sys.run.haas-259.pez.pivotal.io,*.login.sys.run.haas-259.pez.pivotal.io,*.apps.run.haas-259.pez.pivotal.io,*.uaa.sys.run.haas-259.pez.pivotal.io,*.run.haas-259.pez.pivotal.io