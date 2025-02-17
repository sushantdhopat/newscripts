color(){
  RED="\e[31m"
  CYAN="\e[36m"
  ENDCOLOR="\e[0m"
  BLINK="\e[5m"
  BOLD="\e[1m"
  GREEN="\e[32m"
  YELLOW="\e[33m"

}

color
echo -e "            recon"
echo -e "            Twitter: ${CYAN}@sushantdhopat${ENDCOLOR}"

#############Create Files###########


file(){
  echo -e "\e[94mCreating files \e[0m"
  mkdir  -p Subdomains/ 
  cd Subdomains
  mkdir  -p Subdomains/ Nuclei/ nabuu/ Trash/
  cd ../
}

subdomain() {
  echo -e "${GREEN} Starting Subdomain-Enumeration: ${ENDCOLOR}"  
  amass enum -passive -norecursive -noalts -df $domain -o  Subdomains/Trash/amass.txt &>/dev/null
  echo -e "\e[36m     \_amass count: \e[32m$(cat Subdomains/Trash/amass.txt | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"  
  #subfinder -dL $domain -o Subdomains/Trash/subfinder.txt &>/dev/null
  #echo -e "\e[36m      \_subfinder count: \e[32m$(cat  Subdomains/Trash/subfinder.txt | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"
  #cat $domain | assetfinder --subs-only >> Subdomains/Trash/assetfinder.txt &>/dev/null
  #echo -e "\e[36m       \_assetfinder count: \e[32m$(cat  Subdomains/Trash/assetfinder.txt | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"
  #for x in $(cat $domain)
  #do
  #python3 /root/Sublist3r/sublist3r.py -d $x | grep -oP  "(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]" >> Subdomains/Trash/sublist3r.txt &>/dev/null
  #done
  #echo -e "\e[36m        \_sublist3r count: \e[32m$(cat  Subdomains/Trash/sublist3r.txt | tr '[:upper:]' '[:lower:]'| anew | wc -l)\e[0m"
  echo -e "${GREEN} Started Filtering Subdomains: ${ENDCOLOR}"

  for x in $(cat $domain)
  do
  cat Subdomains/Trash/* | grep -i $x | anew >> Subdomains/Trash/final-result
  done
  cat Subdomains/Trash/final-result | sort -u >> Subdomains/Subdomains/Final_Subdomains.txt
  echo -e "\e[36mFinal Subdomains count: \e[32m$(cat Subdomains/Subdomains/Final_Subdomains.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  cat Subdomains/Subdomains/Final_Subdomains.txt | httpx -o Subdomains/Subdomains/livesub.txt &>/dev/null
  echo -e "\e[36mFinal live Subdomains count: \e[32m$(cat Subdomains/Subdomains/livesub.txt | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  echo -e "${GREEN} Starting Filter Intresting subs: ${ENDCOLOR}"
  cat Subdomains/Subdomains/livesub.txt | grep -E "auth|corp|sign_in|sign_up|ldap|idp|dev|api|admin|login|signup|jira|gitlab|signin|ftp|ssh|git|jenkins|kibana|administration|administrator|administrative|grafana|vpn|jfroge" >> Subdomains/Subdomains/intrested_live_sub.txt
  echo -e "\e[36m          \_Final Intresting live subs count: \e[32m$(cat Subdomains/Subdomains/intrested_live_sub.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  cat Subdomains/Subdomains/Final_Subdomains.txt | grep -E "auth|corp|sign_in|sign_up|ldap|idp|dev|api|admin|login|signup|jira|gitlab|signin|ftp|ssh|git|jenkins|kibana|administration|administrator|administrative|grafana|vpn|jfroge" >> Subdomains/Subdomains/intrested_sub.txt
  echo -e "\e[36m          \_Final Intresting subs count: \e[32m$(cat Subdomains/Subdomains/intrested_sub.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  echo -e "${GREEN} Starting Find Admin Panels: ${ENDCOLOR} "
  cat Subdomains/Subdomains/Final_Subdomains.txt | httpx  -sc -mc 200,302,401 -path `cat /root/admin.txt` >> Subdomains/Subdomains/adminpanel.txt &>/dev/null
  echo -e "\e[36m          \_Final Admin Panel count: \e[32m$(cat Subdomains/Subdomains/adminpanel.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  sleep 10
  #echo -e "${GREEN} Starting Screenshot... ${ENDCOLOR}"
  #cat Subdomains/Subdomains/livesub.txt | aquatone -out Subdomains/Screen-Shoot/livesub &>/dev/null
  #cat Subdomains/Subdomains/adminpanel.txt | aquatone -out Subdomains/Screen-Shoot/adminsub &>/dev/null
  echo -e "${YELLOW} Finish Subdomain Enum ${ENDCOLOR}" 
  echo -e " Finish Subdomain Enum " | notify &>/dev/null


}

portscan(){
    echo -e "${GREEN} Start Port Scan: ${ENDCOLOR}"
    naabu  -list Subdomains/Subdomains/Final_Subdomains.txt -p - -exclude-ports 80,443,8443,21,25,22 -o Subdomains/nabuu/port.txt &>/dev/null
    echo -e "\e[36m            \_Final Ports count: \e[32m$(cat  Subdomains/nabuu/port.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
    echo -e "${GREEN} Start Filter Port : ${ENDCOLOR}"
    cat Subdomains/nabuu/port.txt | httpx -o Subdomains/nabuu/liveport.txt &>/dev/null
    echo -e "\e[36m             \_Final Live Ports count: \e[32m$(cat  Subdomains/nabuu/liveport.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
    echo  -e " ${GREEN} Start Filter Intresting Ports: ${ENDCOLOR}"
    cat Subdomains/nabuu/port.txt | grep -E ":81|:300|:591|:593|:832|:981|:1010|:1311|:1099|:2082|:2095|:2096|:2480|:3000|:3128|:3333|:4243|:4567|:4711|:4712|:4993|:5000|:5104|:5108|:5280|:5281|:5601|:5800|:6543|:7000|:7001|:7396|:7474|:8000|:8001|:8008|:8014|:8042|:8060|:8069|:8080|:8081|:8083|:8088|:8090|:8091|:8095|:8118|:8123|:8172|:8181|:8222|:8243|:8280|:8281|:8333|:8337|:8443|:8500|:8834|:8880|:8888|:8983|:9000|:9001|:9043|:9060|:9080,|:9090|:9091|:9200|:9443|:9502|:9800|:9981|:10000|:10250|:11371|:12443|:15672|:16080|:17778|:18091|:18092|:20720|:32000|:55440|:55672" >> Subdomains/nabuu/intrested_port.txt
    echo -e "\e[36m              \_Final Intresting Ports count: \e[32m$(cat  Subdomains/nabuu/intersed_port.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
    cat Subdomains/nabuu/liveport.txt | grep -E ":81|:300|:591|:593|:832|:981|:1010|:1311|:1099|:2082|:2095|:2096|:2480|:3000|:3128|:3333|:4243|:4567|:4711|:4712|:4993|:5000|:5104|:5108|:5280|:5281|:5601|:5800|:6543|:7000|:7001|:7396|:7474|:8000|:8001|:8008|:8014|:8042|:8060|:8069|:8080|:8081|:8083|:8088|:8090|:8091|:8095|:8118|:8123|:8172|:8181|:8222|:8243|:8280|:8281|:8333|:8337|:8443|:8500|:8834|:8880|:8888|:8983|:9000|:9001|:9043|:9060|:9080,|:9090|:9091|:9200|:9443|:9502|:9800|:9981|:10000|:10250|:11371|:12443|:15672|:16080|:17778|:18091|:18092|:20720|:32000|:55440|:55672" >> Subdomains/nabuu/intested_liveport.txt
    echo -e "\e[36m               \_Final Intresting Live Ports count: \e[32m$(cat  Subdomains/nabuu/intersed_liveport.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
    echo -e "${GREEN} Starting Find Admin Panels: ${ENDCOLOR}"
    cat Subdomains/nabuu/port.txt | httpx -sc -mc 200,302,401 -path `cat /root/admin.txt` >>  Subdomains/nabuu/adminpanel.txt &>/dev/null
    echo -e "\e[36m                \_Final Admin Panel count: \e[32m$(cat Subdomains/nabuu/adminpanel.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
    sleep 10
    #echo -e "${GREEN} Starting Screenshot... ${ENDCOLOR} "
    #cat Subdomains/nabuu/liveport.txt | aquatone -out Subdomains/Screen-Shoot/liveport &>/dev/null
    #cat Subdomains/nabuu/adminpanel.txt | aquatone -out Subdomains/Screen-Shoot/adminport &>/dev/null
    echo -e "${YELLOW} Finished Port Scan ${ENDCOLOR}" 
    echo -e " Finished Port Scan " | notify &>/dev/null



}

vulnscan(){
  mkdir Subdomains/Nuclei/sub 
  mkdir Subdomains/Nuclei/port 
  echo -e "${GREEN} Starting Subdomain Vulnerability Scan: ${ENDCOLOR}"
  cat Subdomains/Subdomains/livesub.txt | nuclei -severity critical -t /root/nuclei-templates -o Subdomains/Nuclei/sub/critical.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/sub/critical.txt -bulk
  echo -e "\e[36m    \_Final Ciritcal Vuln  count: \e[32m$(cat Subdomains/Nuclei/sub/critical.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  cat Subdomains/Subdomains/livesub.txt | nuclei -severity high -t /root/nuclei-templates -o Subdomains/Nuclei/sub/high.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/sub/high.txt -bulk
  echo -e "\e[36m    \_Final high Vuln  count: \e[32m$(cat Subdomains/Nuclei/sub/high.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  cat Subdomains/Subdomains/livesub.txt | nuclei -severity medium -t /root/nuclei-templates -o Subdomains/Nuclei/sub/meduim.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/sub/meduim.txt -bulk
  echo -e "\e[36m    \_Final medium Vuln  count: \e[32m$(cat Subdomains/Nuclei/sub/meduim.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
  cat Subdomains/Subdomains/livesub.txt | nuclei -severity low -t /root/nuclei-templates -o Subdomains/Nuclei/sub/low.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/sub/low.txt -bulk
  echo -e "\e[36m    \_Final low Vuln  count: \e[32m$(cat Subdomains/Nuclei/sub/low.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"
 
  echo -e "${YELLOW} scan Sub_Vuln done ${ENDCOLOR} "
  echo -e " scan Sub_Vuln done  " | notify &>/dev/null



  #vuln_ports
  echo -e "${GREEN}Starting Ports vulnerability scan: ${ENDCOLOR}"

  cat Subdomains/nabuu/liveport.txt | nuclei -severity critical -t /root/nuclei-templates -o Subdomains/Nuclei/port/critical.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/port/critical.txt -bulk
  echo -e "\e[36m    \_Final Ciritcal Vuln  count: \e[32m$(cat Subdomains/nabuu/liveport.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"

  cat Subdomains/nabuu/liveport.txt | nuclei -severity high -t /root/nuclei-templates -o Subdomains/Nuclei/port/high.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/port/high.txt -bulk
  echo -e "\e[36m    \_Final high Vuln  count: \e[32m$(cat Subdomains/Nuclei/port/high.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"

  cat Subdomains/nabuu/liveport.txt | nuclei -severity medium -t /root/nuclei-templates -o Subdomains/Nuclei/port/meduim.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/port/meduim.txt -bulk
  echo -e "\e[36m    \_Final medium Vuln  count: \e[32m$(cat Subdomains/Nuclei/port/meduim.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"

  cat Subdomains/nabuu/liveport.txt | nuclei -severity low -t /root/nuclei-templates -o Subdomains/Nuclei/port/low.txt &>/dev/null; notify -rl 1 -silent -data Subdomains/Nuclei/port/low.txt -bulk
  echo -e "\e[36m    \_Final low Vuln  count: \e[32m$(cat Subdomains/Nuclei/port/low.txt  | tr '[:upper:]' '[:lower:]'| anew | grep -v " "|grep -v "@" | grep "\." | wc -l)\e[0m"

  echo "${YELLOW} scan Sub_port_Vuln done ${ENDCOLOR} "
  echo " scan Sub_port_Vuln done  " | notify &>/dev/null



  }

  end(){
    echo -e "Finished all Recon , Hope find ${RED}P1${ENDCOLOR} Bugs.  Happy Hunting 😊 "
  }

all(){
  file
  subdomain
  portscan
  vulnscan
  end
  }
subdomains(){
  echo -e "\e[94mCreate file \e[0m"
  mkdir  -p Subdomains/ 
  cd Subdomains
  mkdir  -p Subdomains/ Trash/
  cd ../
  subdomain
}
usage(){    
    echo -e ""
    echo -e "Usage: RecoX [OPTIONS] [PATH to domain/domainfile] [Scan flag]"
    echo -e "${GREEN}Example Usage${ENDCOLOR}"
    echo -e " ./recon_x.sh -dl ~/user/domains_file.txt -a"
    echo -e ""
    echo -e "${GREEN}Flags:${ENDCOLOR}"
    echo -e "   -dl, --domain-list                Add your domain file                               "
    echo -e "   -d, --domain                      Add your domain                                    "
    echo -e "   -a,  --all                        Run All scans                                      "
    echo -e "   -s, --subdomain                   Run Subdomain enumration                           "
    echo -e "   -h, --help                        show usage                                         "
    exit 0
}
#@> ARGUMENTS
while [ -n "$1" ]; do
    case $1 in
            -dl|--domain-list)
                domain=$2
                shift ;;
            -a|--all)
                all
                shift ;;
            -s|--subdomain)
                subdomains
                shift ;;
            -h|--help)
                usage
                shift ;;
            *)
                usage
    esac
    shift
done
