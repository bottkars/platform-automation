#!/bin/bash

function get_latest_release() {
curl -u ${GITUSER} --silent "https://api.github.com/repos/$1/tags"  | jq -r '[.[] | select(.name!="v1")] | .[0].name'
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
echo $RELEASES
unset REPO RELEASE VERSIONS
set -u
while IFS=", " read -r REPO RELEASE; do
    VERSION=$(get_latest_release "${REPO}/${RELEASE}")
    echo "${RELEASE}: \"${VERSION//v}\""
done <<< "${RELEASES}"            