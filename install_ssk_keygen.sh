#!/bin/bash 

set -eu 

username=$(whoami}

ssh-keygen -q -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1

yes| ssh-copy-id $username@$IP

echo "Setting keygen ==> "
cat ~/.ssh/id_rsa.pub | ssh $username@$IP "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
