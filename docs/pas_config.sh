#!/bin/bash

# this will be the base for pas customizing


# retrieving uaa password
ENV=${HOME}/workspace/pcfsc2_azurestack_config/pcfsc2/env/env.yml

UAA_ADMIN_CREDENTIALS=$(om --env ${ENV} credentials -p cf -c .uaa.admin_client_credentials -f password)
uaac target https://uaa.sys.pcfsc2.sc2.azurestack-rd.cf-app.com
uaac token client get admin -s ${UAA_ADMIN_CREDENTIALS}


uaac group map --name scim.read "fd570d0b-ae8b-45f8-871e-7e40ef426dd8" --origin labbuildr
uaac group map --name scim.write "fd570d0b-ae8b-45f8-871e-7e40ef426dd8" --origin labbuildr
uaac group map --name cloud_controller.admin "fd570d0b-ae8b-45f8-871e-7e40ef426dd8" --origin labbuildr