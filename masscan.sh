sudo masscan -p1-65535,U:1-65535 --exclude-ports 80,443 --rate 10000 -iL $1 -oJ $1-output.json
