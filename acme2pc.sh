#######################
# Automatic Renewal Script for LetsEncrypt Certs in PrismCentral
# wolfgang.huse@nutanix.com
# 12/27/2021 0.1 Initial Release
#######################

#######################
# Usage: acme2pc.sh -u pc_user -p pc_pass -h IP/Hostname of PrismCentral -d Domain used for LE
# Parameters could also exist as EXPORT (USERNAME PASSWORD PRISM_CENTRAL DOMAIN)
#######################

# Load Secrets from Local .secret/acme2pc.env
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -f $SCRIPT_DIR/.secret/acme2pc.env ]; then
    # Load Environment Variables
    export $(cat $SCRIPT_DIR/.secret/acme2pc.env | grep -v '#' | awk '/=/ {print $1}')
fi

# Command-Line-Options will override Settings
while getopts u:p:h:d: flag
do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
        p) PASSWORD=${OPTARG};;
        h) PRISM_CENTRAL=${OPTARG};;
        d) DOMAIN=${OPTARG};;
    esac
done
curl --user $USERNAME:$PASSWORD \
--silent \
--show-error \
--fail \
-F caChain=@$LE_WORKING_DIR/$DOMAIN/ca.cer \
-F cert=@$LE_WORKING_DIR/$DOMAIN/$DOMAIN.cer \
-F key=@$LE_WORKING_DIR/$DOMAIN/$DOMAIN.key \
-F keyType=RSA_2048 \
-k https://$PRISM_CENTRAL:9440/PrismGateway/services/rest/v1/keys/pem/import

# Checking CURL return value

res=$?
if test "$res" != "0"; then
   echo "the curl command failed with: $res"
   exit 1
fi
