#!/bin/bash
cat /var/version && echo ""
    set -eux
    eval "$(om --env ./env/${ENV_FILE} \
        --skip-ssl-validation bosh-env --ssh-private-key ./env/${KEY_FILE})"
    deployments=$(bosh deployments --column=Name --json)
    PKS_DEPLOYMENT=$(echo $deployments | \
        jp.py "Tables[0].Rows[?contains(name,'pivotal-container-service')].name |[0]")
    PKS_DEPLOYMENT=$(echo "${PKS_DEPLOYMENT//\"}")
    ADMIN_CLIENT_SECRET=$(credhub get -n /opsmgr/${PKS_DEPLOYMENT}/pks_uaa_management_admin_client -k=value )
    TOKEN=$(curl -k -s "https://${PKS_API_ENDPOINT}:8443/oauth/token" -i -X POST \
    -H "Accept: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=admin&client_secret=${ADMIN_CLIENT_SECRET}&grant_type=client_credentials&token_format=opaque" \
     | awk -F\" '/access_token/{printf $4}')

    DATA=$(cat <<EOF
    {
        "userName" : "${PKS_USERNAME}",
        "name" : {
            "familyName" : "PKS",
            "givenName" : "ADMIN"
        },
        "emails" : [ {
            "value" : "${PKS_USERNAME}@test.org",
            "primary" : true
        } ],
        "password" : "${PKS_PASSWORD}"
    }
EOF
    )
    curl -k -s "https://${PKS_API_ENDPOINT}:8443/Users" -i -X POST \
    -H "Accept: application/json" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H "Content-Type: application/json" \
    -d "${DATA}"

    USER_ID=$(curl -k -s "https://${PKS_API_ENDPOINT}:8443/Users?attributes=id&filter=username+eq+%${PKS_USERNAME}%22&count=1" -i -X GET \
    -H "Accept: application/json" \
    -H "Authorization: Bearer ${TOKEN}" | awk -F\" '/id/{printf $6}')


    GROUP_ID=$(curl -k -s "https://${PKS_API_ENDPOINT}:8443/Groups?scheme=openid&filter=displayName+eq+%pks.clusters.admin" -i -X GET \
    -H "Accept: application/json" \
    -H "Authorization: Bearer ${TOKEN}" | tail -n +13 | jp.py "resources[?displayName=='pks.clusters.admin'].id | [0]")

    GROUP_ID=$(echo "${GROUP_ID//\"}")

    DATA=$(cat <<EOF 
    {
        "origin" : "uaa",
        "type" : "USER",
        "value" : "${USER_ID}"
    }
EOF
    )      
    
    curl -k  "https://${PKS_API_ENDPOINT}:8443/Groups/${GROUP_ID}/members" -i -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${TOKEN}" \
        -d "${DATA}"


