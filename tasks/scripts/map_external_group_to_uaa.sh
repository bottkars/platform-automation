#!/bin/bash
ADMIN_CLIENT_SECRET=$(om --env env/${ENV_FILE} credentials --product-name cf \
    --credential-reference .uaa.admin_client_credentials \
    --credential-field password) 

TOKEN=$(curl -k -s "https://${UAA_ENDPOINT}:443/oauth/token" -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "client_id=admin&client_secret=${ADMIN_CLIENT_SECRET}&grant_type=client_credentials&token_format=opaque" \
    | awk -F\" '/access_token/{printf $4}')

IFS=', ' read -r -a array <<< "${GROUP_NAMES}"
for GROUP_NAME in "${array[@]}"
do
echo
echo "Getting ID for $GROUP_NAME"
QUERY_GROUP_NAME="'${GROUP_NAME}'"
GROUP_ID=$(curl -k -s "https://${UAA_ENDPOINT}:443/Groups?scheme=openid&filter=displayName+eq+%${GROUP_NAME}" -X GET \
-H "Accept: application/json" \
-H "Authorization: Bearer ${TOKEN}" | jp.py "resources[?displayName==${QUERY_GROUP_NAME}].id | [0]")

GROUP_ID=$(echo "${GROUP_ID//\"}")

DATA=$(cat <<EOF 
{
    "displayName": "${GROUP_NAME}",
    "externalGroup": "${EXTERNAL_GROUP}",
    "schemas":["urn:scim:schemas:core:1.0"],
    "origin": "${ORIGIN}"
}
EOF
)
echo      
echo "--> mapping ${EXTERNAL_GROUP} with origin ${ORIGIN} to ${GROUP_NAME}/${GROUP_ID}"


curl -k  "https://${UAA_ENDPOINT}:443/Groups/External" -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${TOKEN}" \
    -d "${DATA}"
echo    
done