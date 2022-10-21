#!/bin/bash

go_path="/root/go/bin"

if [[ -z "$1" ]]; then
        echo "[-]Usage: ./fru.sh domains_list_file";
        exit;

elif [[ ! -f "$1" ]]; then
        echo "[-]File Does not exist;";
        exit;
fi;

target_file="$1"

# echo "[*]Executing waybackurls";
# cat "$target_file" | $go_path/waybackurls > wayback.txt

# echo "[*]Executing gau";
# cat "$target_file" | $go_path/gau --subs --threads 10 --o gau.txt

# echo "[*]Executing getJS";
# sed 's/^/https:\/\//g' "$target_file" > live_urls.txt
# $go_path/getJS --complete --input live_urls.txt --output getjs.txt


# echo "[*]Execute the GoLinkFinder Manually only on main domain as it throw errors on subdomains";
# #echo "[*]Executing GoLinkFinder";
# #$go_path/GoLinkFinder -d " 2> /dev/null

# echo "[*]Warn: If there is a backoffice then login into it and copy and paste the source code of main page/dashboard into the terminal";
# sleep 15;

nano backoffice.txt

read -p "Enter Dashboard domain:" dashboard_domain

grep -oE 'src="\S+' backoffice.txt | tr -d '">' | grep -v 'http' | tr -d '^src=' | sed "s/^/$dashboard_domain/g" | sed 's/^/https:\/\//g' > back.txt

cat wayback.txt gau.txt getjs.txt back.txt > all.txt

grep '.js' all.txt | cut -d '?' -f1 | sort -u > unique_js_files.txt
file="unique_js_files.txt"
while IFS="\n" read -r line
do
    output=$(curl "$line" --write-out '%{http_code}:%{size_download}' -O -s &)
    status_code=$(cut -d ':' -f1 <<< "$output");
    response_size=$(cut -d ':' -f2 <<< "$output");

    if (( "$status_code" == 200 )) && (( "$response_size" > 0 )); then
        echo "$line";
    fi;

done < "$file";