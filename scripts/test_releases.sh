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
    VERSION=${VERSION//RELEASE.}
    if [[ ${VERSION//v} != $OLD_VERSION ]]
    then
        echo "Replacing ${RELEASE} version ${OLD_VERSION} with ${VERSION//v} in $VERSIONS_FILE"
        sed -i.bu "/${RELEASE}/s/.*/${RELEASE}: \"${VERSION//v}\"/" $VERSIONS_FILE 
    else    
        echo "$RELEASE already at version ${VERSION//v}"
    fi
done <<< "${RELEASES}"    


stemcells=$(curl -s https://bosh.io/api/v1/stemcells/bosh-azure-hyperv-ubuntu-xenial-go_agent)

VERSION=$(echo $stemcells |jq -r '[.[] | select(.version|test("621."))][0].version')
RELEASE=stemcell-release
    echo "Checking Stemcell Releases"
    OLD_VERSION=$(grep -A0 ${RELEASE} $VERSIONS_FILE | cut -d ':' -f2 | tr -d ' "')
    if [[ ${VERSION} != ${OLD_VERSION} ]]
        then
        echo "new stemcell ${VERSION} found at bosh.io"
            echo "Replacing ${RELEASE} version ${OLD_VERSION} with \"${VERSION}\" in $VERSIONS_FILE"
            sed -i'.bak' "/${RELEASE}/s/.*/${RELEASE}: \"${VERSION}\"/" ${VERSIONS_FILE}
    else
        echo "Already at Stemcell version ${VERSION}"
    fi


# https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.19.10
# https://bosh.io/d/github.com/cloudfoundry/garden-runc-release?v=1.19.10
