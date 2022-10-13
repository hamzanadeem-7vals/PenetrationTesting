#!/bin/bash

file="$1";
target="$2";

function check_syntax()
{
    invalid=false;
    while IFS= read -r line;
    do 

        grep '__target__' <<< "$line" > /dev/null
        if (( "$?" != 0 )); then
            invalid_line=$(grep -n "$line" $file | cut -d ':' -f1);
            echo "[*] Incompatible syntax at line $invalid_line"; 
            echo "$line --> invalid";
            invalid=true;
        fi;
    done < "$file";

    if (( "$invalid" )); then 
        echo "[*] Please fix the found syntax errors!";
        echo "[-] Exiting...";
        exit;
    fi;
}

function open_in_browser()
{
    # assign file descriptor to file for input fd#3
    exec 3< "target_dorks.txt";

    i=1;
    while IFS= read -r -u 3 line;
    do 
        firefox --new-tab "$line" > /dev/null &
        # echo "i:$i";
        if (( "$i" % 10 == 0 )); then 
            i=1;
            read -p "Do you want to continue (y|n):" user_choice
            if [[ "$user_choice" == 'y' ]]; then 
                continue;
            else 
                exit;
            fi;
        fi;
        i=$((i+1));
    done 3< "target_dorks.txt";    

    exec 3<&-
}

function create_target_dorks()
{
    sed "s/__target__/$target/g" "$file" > target_dorks.txt
}

check_syntax;
create_target_dorks;
open_in_browser;