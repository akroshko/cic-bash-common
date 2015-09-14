#!/bin/bash
# script from stack overflow but do not have link to attribute it
# TODO: my current config no longer supports all these ciphers
#       test better for existing cipher and have override for experimental purposes
# TODO: maybe try to read data from a random file or memory too?
user=akroshko
# password=<his password>
port=22
MB=4096

export LC_ALL=C

ciphers="3des-cbc aes128-cbc aes192-cbc aes256-cbc aes128-ctr aes192-ctr \
         aes256-ctr aes128-gcm@openssh.com aes256-gcm@openssh.com arcfour \
         arcfour128 arcfour256 blowfish-cbc cast128-cbc chacha20-poly1305@openssh.com"

#ciphers=$(ssh -Q cipher)

for cipher in $ciphers; do
    echo "================================================================================"
    echo cipher: "$cipher"
    # dd if=/dev/zero bs=1M count=$MB conv=sync  | \
    #     sshpass -p $password ssh -c $cipher -o Compression=no -o Port=$port $user@127.0.0.1 "cat - >/dev/null"
    dd if=/dev/zero bs=1M count=$MB conv=sync  | \
    ssh -c $cipher -o Compression=no -o Port=$port $user@127.0.0.1 "cat - >/dev/null"
done
