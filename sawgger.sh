run:
  path: bash
  args:
  - "-c"
  - |
    cat /var/version && echo ""
    set -eu
    eval "$(om --env ./env/${ENV_FILE} \
        --skip-ssl-validation bosh-env --ssh-private-key ./env/${KEY_FILE})"
    deployments=$(bosh deployments --column=Name --json)
    PKS_DEPLOYMENT=$(echo $deployments | \
        jp.py "Tables[0].Rows[?contains(name,'pivotal-container-service')].name |[0]")
    PKS_DEPLOYMENT=$(echo "${PKS_DEPLOYMENT//\"}")
    ADMIN_CLIENT_SECRET=$(credhub get -n /opsmgr/${PKS_DEPLOYMENT}/pks_uaa_management_admin_client -k=value )
    echo "-->getting UAA Token"
    TOKEN=$(curl -k -s "https://${PKS_API_ENDPOINT}:8443/oauth/token" -i -X POST \
    -H "Accept: application/json" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "client_id=admin&client_secret=${ADMIN_CLIENT_SECRET}&grant_type=client_credentials&token_format=opaque" \
     | awk -F\" '/access_token/{printf $4}')
DATA=$(cat << EOF
{"name": "swagger","parameters": {"kubernetes_master_host": "swagger.pks.labbuildr.local"},"plan_name": "small"}
EOF
)

curl -k -s "https://${PKS_API_ENDPOINT}:9021/v1/clusters" -i -X POST \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "${DATA}"

curl -k -s "https://${PKS_API_ENDPOINT}:9021/v1/clusters" -i -X GET \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "${DATA}"

