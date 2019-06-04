export CREDHUB_URL="https://plane.control.westus.stackpoc.com"
export CLIENT_NAME="credhub_admin_client"
export credhub_password="$(credhub get -n "/p-bosh/control-plane/credhub_admin_client_password" -k password)"
export CA_CERT="$(credhub get -n /p-bosh/control-plane/control-plane-tls -k certificate)"

unset CREDHUB_CLIENT
unset CREDHUB_CA_CERT
unset CREDHUB_PROXY
unset CREDHUB_SERVER
unset CREDHUB_SECRET

credhub login -s "${CREDHUB_URL}" --client-name "${CLIENT_NAME}" --client-secret "${credhub_password}" --ca-cert "${CA_CERT}"


 credhub set \
         --name /concourse/stackpoc-demo/plat-auto-pipes-deploy-key \
         --type ssh \
         --private /Users/bottk/.ssh/git_deploy \
         --public /Users/bottk/.ssh/git_deploy.pub
