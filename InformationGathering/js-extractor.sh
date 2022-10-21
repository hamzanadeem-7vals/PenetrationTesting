#!/bin/bash
source ~/.profile
if [[ -z $1 ]];
then
 echo "Please provide the root domain file name!"
exit
fi
rm -f allfiles.txt uniq_files.txt wayback_only_html.txt wayback_js_files.txt wayback_httprobe_file.txt wayback_json_files.txt important_http_urls.txt aws_s3_files.txt
echo "Currently waybackurls extract is in progress!!"
for i in $(cat $1)
do
  waybackurls $i >> allfiles.txt
  gau $i >> allfiles.txt
done
echo "Waybackurls extraction is complete!!"
sort -ru allfiles.txt >> uniq_files.txt
echo "Uniq file also created. please check [uniq_files.txt]"
echo "Now, we need to extract only html files from the list"
grep -iv -E '.js|.png|.jpg|.gif|.ico|.img|.css' uniq_files.txt >> wayback_only_html.txt
echo "We have extracted all html files.Please check [wayback_only_html.txt]"
echo "Next is to extracct js files from the list"
cat uniq_files.txt | grep "\.js" | uniq | sort >> wayback_js_files.txt
cat uniq_files.txt | grep "\.json" | uniq | sort >> wayback_json_files.txt
echo "Js files have been successfully extracted **************[wayback_js_files.txt]**************"
echo "Json files have been successfully extracted **************[wayback_json_files.txt]**************"
echo "Now extracting important urls from **************[wayback_only_html.txt]**************"
grep color=always -i -E 'admin|auth|api|jenkins|corp|dev|stag|stg|prod|sandbox|swagger|aws|azure|uat|test|vpn|cms' wayback_only_html.txt >> important_http_urls.txt
echo "Please check file **************[important_http_urls.txt]*************"
grep color=always -i -E 'aws|s3' uniq_files.txt >> aws_s3_files.txt
echo "Please check file **************aws_s3_files.txt]*************"
echo "Process is complete"
echo "Now start takin screensots selectively"
echo "The command:"
echo " "
echo "cat wayback_only_html.txt | aquatone -threads 20"