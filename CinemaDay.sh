#!/bin/bash

UPLOAD(){
HOST=192.168.0.38
USER=o2decron2
PASSWD=02d3cr0n2
ftp -n $HOST >> ftp-upload.log << END_SCRIPT
quote USER $USER
quote PASS $PASSWD
pass
prompt
binary
hash
cd /prodreport/cinemaday
mput $fileCurrDate.txt
quit
END_SCRIPT
}
fileCurrDate=`date --date="0 day ago" "+%Y-%m-%d"`
sudo touch $fileCurrDate.txt
sudo chmod 777 $fileCurrDate.txt
mtCurrDate=`date --date="0 day ago" "+%Y%m%d"`
echo "mt$mtCurrDate"
currEventDate=`date --date="0 day ago" "+%Y-%m-%d 00:00:00"`
echo $currEventDate
prevEventDate=`date --date="+7 day ago" "+%Y-%m-%d 00:00:00"`
echo $prevEventDate
mysql -uroot -pact -h10.210.3.57 tenant -e "SELECT  s.Msisdn,x.token_code, s.uberraschung_registriert, de.value, e.smartphone_data_usage_name,x.event_date,x.consumed_date,ucg_std,x.campaign_name
FROM subscribers s inner join
(SELECT msisdn,event_date, consumed_date,token_code, campaign_name
FROM  tenant.token y inner JOIN campaigns c ON y.feature_id = c.campaign_id
where event_date >= '$prevEventDate' and event_date <='$currEventDate' and
consumed_date is NULL and campaign_name like  '%WEB%' )  x
on s.msisdn=x.msisdn inner join (select distinct  msisdn, token_code
from token_event where type<>'ACCEPT'  and event_date> '2014-10-22 15:00:00' ) te
on x.msisdn=te.msisdn and x.token_code=te.token_code
inner join  stats_dp_Engagement_subprofiles se on  (s.msisdn=se.msisdn) inner join dp_Engagement_subprofiles de on (de.id = se.value)
inner join tenant.id_smartphone_data_usage e on s.smartphone_data_usage=e.smartphone_data_usage
Where status_id = 1  and uberraschung_registriert=1 and e.smartphone_data_usage_name<>'Smartphone N, data usage N' and ucg_std=0 and  master_cg=0 and Cinema_Day ='1'  ORDER BY x.event_date DESC
" > /var/scripts/DataFromE4O.txt

mysql -upremium -psangennaro_2012 -h10.210.3.6 -A jmailer_de -e "SELECT phone FROM mt$mtCurrDate WHERE message LIKE 'Nicht%' OR message LIKE 'Warum%' ORDER BY acked DESC" > /var/scripts/DataFromMMP.txt

cd /var/scripts/
awk '{print substr($0,2,length()-1);}' DataFromMMP.txt > DataFromMMPFinal.txt
cat DataFromE4O.txt|awk -F"\t" '{print $1,$2,$6}' > DataFromE4O1.txt
cat DataFromE4O1.txt|awk '!x[$1]++' > DataFromE4OFinal.txt
if [ -s DataFromMMPFinal.txt ]
then
awk 'FNR==NR{a[$1]++;next}!a[$1]' DataFromMMPFinal.txt DataFromE4OFinal.txt > msisdn.txt
else
echo "file generated by 2nd sql query is empty "
mv DataFromE4OFinal.txt msisdn.txt
fi
#awk 'FNR==NR{a[$1]++;next}!a[$1]' DataFromMMPFinal.txt DataFromE4OFinal.txt > msisdn.txt
cat msisdn.txt|awk -F " " '{print $1,$2}' > DataFromE4OFinal.txt
cat DataFromE4OFinal.txt |awk '{if(NR>1)print "+"$0}' > msisdn.txt
cat msisdn.txt|sed -e 's/\s/,/g' > $fileCurrDate.txt
sudo rm -rf xa* output_file.txt
cat $fileCurrDate.txt|split -l 20000
number=0;
number=$(ls -lrth xa*| wc -l)
echo "number : $number"
sudo touch output_file.txt
sudo chmod 777 output_file.txt
if [ $number -le 4 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 5 -a $number -lt 6 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
#cat xae|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 6 -a $number -lt 7 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 7 -a $number -lt 8 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 8 -a $number -lt 9 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xah|awk -F "," '{ $(NF+1)="H"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 9 -a $number -lt 10 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xah|awk -F "," '{ $(NF+1)="H"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xai|awk -F "," '{ $(NF+1)="I"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 10 -a $number -lt 11 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xah|awk -F "," '{ $(NF+1)="H"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xai|awk -F "," '{ $(NF+1)="I"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaj|awk -F "," '{ $(NF+1)="J"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 11 -a $number -lt 12 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xah|awk -F "," '{ $(NF+1)="H"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xai|awk -F "," '{ $(NF+1)="I"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaj|awk -F "," '{ $(NF+1)="J"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 12 -a $number -lt 13 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xah|awk -F "," '{ $(NF+1)="H"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xai|awk -F "," '{ $(NF+1)="I"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaj|awk -F "," '{ $(NF+1)="J"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xak|awk -F "," '{ $(NF+1)="K"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 13 -a $number -lt 14 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xah|awk -F "," '{ $(NF+1)="H"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xai|awk -F "," '{ $(NF+1)="I"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaj|awk -F "," '{ $(NF+1)="J"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xak|awk -F "," '{ $(NF+1)="K"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xal|awk -F "," '{ $(NF+1)="L"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
if [ $number -ge 14 -a $number -lt 15 ]
then
echo "inside if condition"
cat xaa|awk -F "," '{ $(NF+1)="A"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xab|awk -F "," '{ $(NF+1)="B"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xac|awk -F "," '{ $(NF+1)="C"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xad|awk -F "," '{ $(NF+1)="D"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xae|awk -F "," '{ $(NF+1)="E"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaf|awk -F "," '{ $(NF+1)="F"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xag|awk -F "," '{ $(NF+1)="G"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xah|awk -F "," '{ $(NF+1)="H"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xai|awk -F "," '{ $(NF+1)="I"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xaj|awk -F "," '{ $(NF+1)="J"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xak|awk -F "," '{ $(NF+1)="K"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xal|awk -F "," '{ $(NF+1)="L"; ++i; OFS=","; print $0 }' >> output_file.txt
cat xam|awk -F "," '{ $(NF+1)="M"; ++i; OFS=","; print $0 }' >> output_file.txt
#value=$((value + 1))
fi
sed -e '1i*address,code,group' output_file.txt > $fileCurrDate.txt
#cat DataFromE4OFinal.txt|sed -e 's/\s/,/g' > $fileCurrDate.txt
sudo rm -rf xa* output_file.txt
UPLOAD
