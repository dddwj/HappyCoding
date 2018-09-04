#!/bin/bash
 
 DATE=$(date +%d)
 l_DATE=$(date -d yesterday +%d)
 DATEtxt=$DATE".dat"
 l_DATEtxt=$l_DATE".dat"
 diff=$DATE".dat"
 dif="Differ@"$diff
 today=$(date +"%x")


#*************爬虫服务***************
curl jwc.ecust.edu.cn/3938/list.htm | awk -F'title=' '{print $2}' | uniq | awk -F'>' '{print $1}' | uniq | grep -v class | grep -v target | uniq > /root/mytest/$DATEtxt
echo "*************************************************************">>/root/mytest/$DATEtxt
curl jwc.ecust.edu.cn/3940/list.htm | awk -F'title=' '{print $2}' | uniq | awk -F'>' '{print $1}' | uniq | grep -v class | grep -v target | uniq >> /root/mytest/$DATEtxt
diff /root/mytest/$DATEtxt /root/mytest/$l_DATEtxt > /root/mytest/$dif

#************邮箱提醒***************
rm /var/www/html/dif.html
diff /root/mytest/$DATEtxt /root/mytest/$l_DATEtxt > /var/www/html/dif.html

if [ -s /var/www/html/dif.html ]; then
	echo "Check out changes at http://144.168.62.45/dif.html !!    -------Powered by dddwj" | mail -s "$today CHANGE at jwc.ecust!" dwj2930@163.com
else
	echo "$today: NO changes today!!     -------Powered by dddwj" | mail -s "$today no change at jwc.ecust!" dwj2930@163.com
fi
