### 单独一个域名或者ip进行信息搜集工作，一般是小站，不必推测他的旁站以及是否有cdn情况
#!/bin/bash
#author: cool
#version: v1
#date: 2023-11-07

#####-----以下为正文内容-----#####

#!/bin/bash
read -p  "输入类型: 1代表域名 2 代表ip ：" a
var = $(pwd)
if [ $a = 1 ];
then 

read -p "请输入域名:" n
#解析域名寻找ip
host $n > tmp.txt&& 
cat tmp.txt | grep -Ev '.*com.*com|IPV6' |  grep -oE '[0-9.-]+\.[0-9.-]+\.[0-9.-]+\.[0-9.-]' > 1.txt

#收集端口
masscan -iL 1.txt -p 1-65535 --rate=100 > 2.txt &&
 
cat 2.txt | awk '{print"http://"$NF":"$4}' | sed 's#/tcp##g' > 3.txt

#扫描目录 dirsearch工具指定文件 或者将结果进行保存的时候路径必须为绝对路径
dirsearch -l $var/3.txt  -o $var/4.txt&&

#探测框架以及指纹
whatweb -i 3.txt --no-errors --colour=never > 4.txt&&
cat 4.txt | grep -Ev "| grep -Ev "ERROR" | awk '{print$1}'" > 5.txt
./allin -f 5.txt -o os.txt

else
#收集端口
read -p "请输入IP:" c
masscan $c -p 1-65535 --rate=100 > a1.txt&& 
cat a1.txt | awk '{print"http://"$NF":"$4}' | sed 's#/tcp##g' > a2.txt

#扫描目录 dirsearch工具指定文件 或者将结果进行保存的时候路径必须为绝对路径
dirsearch -l $var/a2.txt  -o $var/a3.txt&&

#探测框架以及指纹
whatweb -i a2.txt --no-errors --colour=never > a4.txt&&
cat a4.txt | grep -Ev "| grep -Ev "ERROR" | awk '{print$1}'" > a5.txt
./allin -f 5.txt -o os.txt

fi

echo "收集结束，"
