# HiLinkWatchDOG
folder monitor  log and write to windows event 

fork from nixda script , Source:http://superuser.com/questions/226828/how-to-monitor-a-folder-and-trigger-a-command-line-action-when-a-file-is-created


by Cfwang 2015110 and Andylai  20151117

it old project for monitor spectifly folder [change/add/del] , for windows , fork form nixda script 

so , we mod this scripts and share it. :)

we also recommend install "eventlog-to-syslog" at your servers.

eventlog-to-syslog : convert event,  forward to syslog server ex:Rsyslog , or ELK (ELK Stack: Elasticsearch, Logstash, Kibana | Elastic ) atl.. 

for information security analysis.

cfwang 20200804 :)

REF:
1.eventlog-to-syslog:
https://code.google.com/p/eventlog-to-syslog/


 
#正體中文 
​
出處:http://superuser.com/questions/226828/how-to-monitor-a-folder-and-trigger-a-command-line-action-when-a-file-is-created
   
Author by :nixda
   
Modified by   Cfwang 20151103   Z.Z
              Andylai 大神 20151117                                                                                                             　　#>

這個專案是一個舊的專案，但主要目的是是同事 andylai 大神，有需求，要在 windows server 上去監控某個資料夾的存取(因為入侵者 ,會在一些資料夾放東西) ，

丟了一段給我看看能不能用，然後就花了一點自己的時間研究了一下，

改了一版，可以寫成 .log 或是寫成 windows event 的土炮工具 (我們還有在server上裝了 event2syslog 集中轉拋到 log collector 做後續的資訊安全判斷處理 )

可以參考[1]捕夢網的微軟系統日誌集中控管 自建資料庫式Log伺服器 ，或許還可以轉拋到 spunk 或是


#中文參考指南:
1.捕夢網,微軟系統日誌集中控管 自建資料庫式Log伺服器,https://blog.pumo.com.tw/archives/265,取得日:20200804
