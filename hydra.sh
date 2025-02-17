#!/bin/bash

target=$1
port=$2

hydra -L /Users/sushantdhopat/desktop/default-cred/username.txt -P /Users/sushantdhopat/desktop/default-cred/password.txt -s $port -f $target http-get

if ($port ==== ''){
    then
    hydra -L /Users/sushantdhopat/desktop/default-cred/username.txt -P /Users/sushantdhopat/desktop/default-cred/password.txt -f $target http-get
}
fi