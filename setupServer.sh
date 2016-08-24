#!/bin/bash
clientName=$1
if [ -z $clientName ] ; then
        echo "Usage: $0 clientName"
        exit 0
fi
mkdir ~/crypt-{keys,scripts}
mkdir ~/.ssh

# Generate a random keyfile for $clientName, but only if it doesn't exist yet.
if [ ! -f ~/crypt-keys/"$clientName".keyfile ] ; then
	dd bs=512 count=4 if=/dev/urandom of=~/crypt-keys/"$clientName".keyfile iflag=fullblock 
fi
# Download the server-keyscript and make it executable
cp server/retrieve_crypto_key ~/crypt-scripts/retrieve_"$clientName"_key
chmod +x ~/crypt-scripts/retrieve_"$clientName"_key

# Adjust variables in key script.
sed -i "s/PLACEHOLDER_FOR_MAC_ADDRESS/$( echo "${clientMac^^}" | sha1sum | awk '{ print $1 }')/g" ~/crypt-scripts/retrieve_"$clientName"_key
sed -i "s/PLACEHOLDER_FOR_KEYFILE/"$clientName"/g" ~/crypt-scripts/retrieve_"$clientName"_key