
cat /var/version && echo ""
set -eux
om --env env/"${ENV_FILE}" apply-changes \
  ----product-name ${PRODUCT_NAME}
  --reattach