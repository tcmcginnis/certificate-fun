#!/bin/bash
#set -x

REQUIRED_ISSUER="C = US, ST = Ohio, L = Cleveland, O = McLabs.us, OU = lab, CN = bastion.mclabs.us, emailAddress = tom@mcginnis.nu"
REQUIRED_ISSUER="l = US, ST = Ohio, L = Cleveland, O = McLabs.us, OU = lab, CN = bastion.mclabs.us, emailAddress = tom@mcginnis.nu"

DEFAULT="NOTSET"
CLUSTER="${1:-$DEFAULT}"

if [ -f "$CLUSTER" ]; then
   OPENSHIFT_CONFIG="$CLUSTER"
else
   OPENSHIFT_CONFIG="/root/ocp4.10.13/install-config-MIRROR-SAVE.yaml"
fi

CERT_ISSUER=$(sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' $OPENSHIFT_CONFIG|sed 's/  //g'|openssl x509 -text|grep "Issuer:"|awk -F"Issuer: " '{print $2}')

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

