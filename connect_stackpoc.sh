export CREDHUB_URL="https://plane.control.westus.stackpoc.com"
export CLIENT_NAME="credhub_admin_client"
export credhub_password="$(credhub get -n "/p-bosh/control-plane/credhub_admin_client_password" -k password)"
export CA_CERT="$(credhub get -n /p-bosh/control-plane/control-plane-tls -k certificate)"

credhub login -s "${CREDHUB_URL}" --client-name "${CLIENT_NAME}" --client-secret "${credhub_password}" --ca-cert "${CA_CERT}"
