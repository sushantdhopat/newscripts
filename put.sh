#!/bin/bash

cat $1 | nuclei -t /root/nuclei-templates/http/misconfiguration/put-method-enabled.yaml | tee put.txt
