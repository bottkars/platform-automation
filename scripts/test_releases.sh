#!/bin/bash
VERSIONS_FILE="${HOME}/workspace/pcf-controlplane-azurestack/templates/versions.yml"
function get_latest_release() {
curl -u "${GIT_USERNAME}:${GIT_TOKEN}" --silent "https://api.github.com/repos/$1/tags"  | jq -r '[.[] | select(.name!="v1")] | .[0].name'
}

RELEASES="cloudfoundry, garden-runc-release, 
            cloudfoundry, uaa-release, 
            cloudfoundry, bpm-release, 
            cloudfoundry, bosh-dns-aliases-release, 
            cloudfoundry, postgres-release, 
            cloudfoundry, garden-runc-release, 
            cloudfoundry-incubator, windows-utilities-release, 
            cloudfoundry-incubator, garden-windows-bosh-release, 
            cloudfoundry, windows-tools-release, 
            cloudfoundry, winc-release, 
            vito, grafana-boshrelease, 
            concourse, concourse-bosh-release, 
            pivotal, credhub-release,
            minio, minio-boshrelease"
unset REPO RELEASE VERSION
set -u
while IFS=", " read -r REPO RELEASE; do
    VERSION=$(get_latest_release "${REPO}/${RELEASE}")
    echo "Replacing ${RELEASE} version with \"${VERSION//v}\" in $VERSIONS_FILE"
    sed -i "/${RELEASE}/s/.*/${RELEASE}: \"${VERSION//v}\"/" $VERSIONS_FILE
done <<< "${RELEASES}"    

VERSION=$(curl -u "${GIT_USERNAME}:${GIT_TOKEN}" --silent "https://api.github.com/repos/cloudfoundry/bosh-linux-stemcell-builder/tags"  | jq -r '[.[] | select(.name | contains("621."))] | .[0].name')
RELEASE=stemcell-release
echo "Replacing ${RELEASE} version with \"${VERSION//ubuntu-xenial\/v}\" in $VERSIONS_FILE"
sed -i "/${RELEASE}/s/.*/${RELEASE}: \"${VERSION//ubuntu-xenial\/v}\"/" $VERSIONS_FILE

# https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.19.10
# https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.19.10
