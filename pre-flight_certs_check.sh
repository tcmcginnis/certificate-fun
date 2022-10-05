#!/bin/bash

OPENSHIFT_CONFIG="ocp4.10.13/install-config-MIRROR-SAVE.yaml"
REQUIRED_ISSUER="C = US, ST = Ohio, L = Cleveland, O = McLabs.us, OU = lab, CN = bastion.mclabs.us, emailAddress = tom@mcginnis.nu"
REQUIRED_ISSUER="l = US, ST = Ohio, L = Cleveland, O = McLabs.us, OU = lab, CN = bastion.mclabs.us, emailAddress = tom@mcginnis.nu"

BEGIN=$(grep -n "\-\-\-\-\-BEGIN CERTIFICATE\-\-\-\-\-" $OPENSHIFT_CONFIG | awk -F: '{print $1}')
END=$(grep -n "\-\-\-\-\-END CERTIFICATE\-\-\-\-\-" $OPENSHIFT_CONFIG | awk -F: '{print $1}')

CERT_ISSUER=$(sed -n "$BEGIN,$END""p;" ocp4.10.13/install-config-MIRROR-SAVE.yaml|sed 's/  //g'|openssl x509 -text|grep "Issuer:"|awk -F"Issuer: " '{print $2}')

echo "$CERT_ISSUER"

if [ "$CERT_ISSUER" = "$REQUIRED_ISSUER" ]; then
   echo "Certificate in $OPENSHIFT_CONFIG is correct. GOOD!"
else
   echo "Certificate in $OPENSHIFT_CONFIG is not correct."
   echo ""
   echo "Certificate issuer is:"
   echo "   $CERT_ISSUER"
   echo ""
   echo "Expected:"
   echo "   $REQUIRED_ISSUER"
   exit 10
fi

