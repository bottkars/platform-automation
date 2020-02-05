#!/bin/bash
set -eu
#set -ueo pipefail
VERSIONS_FILE="${HOME}/workspace/pcf-controlplane-azurestack/templates/versions.yml"
echo ${VERSIONS_FILE}
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
    OLD_VERSION=$(grep -A0 ${RELEASE} $VERSIONS_FILE | cut -d ':' -f2 | tr -d ' "')
    VERSION=$(get_latest_release "${REPO}/${RELEASE}")
    if [[ ${VERSION//v} != $OLD_VERSION ]]
    then
        echo "Replacing ${RELEASE} version ${OLD_VERSION} with ${VERSION//v} in $VERSIONS_FILE"
        sed -i.bu "/${RELEASE}/s/.*/${RELEASE}: \"${VERSION//v}\"/" $VERSIONS_FILE 
    else    
        echo "$RELEASE already at version ${VERSION//v}"
    fi
done <<< "${RELEASES}"    

VERSION=$(curl -u "${GIT_USERNAME}:${GIT_TOKEN}" --silent "https://api.github.com/repos/cloudfoundry/bosh-linux-stemcell-builder/tags"  | jq -r '[.[] | select(.name | contains("621."))] | .[0].name')
RELEASE=stemcell-release
    echo "Checking Stemcell Releases"
    OLD_VERSION=$(grep -A0 ${RELEASE} $VERSIONS_FILE | cut -d ':' -f2 | tr -d ' "')
    if [[ ${VERSION//ubuntu-xenial\/v} != ${OLD_VERSION} ]]
        then
        echo "testing if new stemcell exists from Stemcell Builder ${VERSION//ubuntu-xenial\/v}"
        return=$(curl --write-out %{http_code} --silent --head --output /dev/null  "https://bosh.io/d/stemcells//bosh-stemcell-${VERSION//ubuntu-xenial\/v}-azure-hyperv-ubuntu-xenial-go_agent.tgz")
        echo "getting return $return for Stemcell $VERSION"
        if [[ $return != *"40"* ]]
        then
            echo "we found Stemcell $VERSION"
            echo "Replacing ${RELEASE} version ${OLD_VERSION} with \"${VERSION//ubuntu-xenial\/v}\" in $VERSIONS_FILE"
            sed -i "/${RELEASE}/s/.*/${RELEASE}: \"${VERSION//ubuntu-xenial\/v}\"/" $VERSIONS_FILE
        else
            echo "Stemcell for $VERSION not yet published"        
        fi    
    else
        echo "Already at Stemcell version ${VERSION//ubuntu-xenial\/v}"
    fi


# https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.19.10
# https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.19.10
