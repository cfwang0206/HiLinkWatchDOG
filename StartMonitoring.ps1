<# 
​
Source:http://superuser.com/questions/226828/how-to-monitor-a-folder-and-trigger-a-command-line-action-when-a-file-is-created
   
Author by :nixda
   
Modified by   Cfwang 20151103   Z.Z
              Andylai 大神 20151117                                                                                                             　　#>
​
###     Define Variables Area  Start  by cfwang ###
$WatchPath="C:\WINDOWS\"                                       #要監控的資料夾
$LogFilePath="D:\LOG\"                      				   #要存放ｌｏｇ的資料夾
$LogFileName=(Get-Date -format "yyyy-MM-dd") + "_log.txt"      #紀錄輸出檔名 EX:2015-11-13_log.txt
$ValidWatchPath =Test-Path $WatchPath                          #變數:驗證監控資料夾
$ValidLogFilePath =Test-Path $LogFilePath                      #變數:驗證監控資料夾
$ScanTime="5"                                                  #多久掃描一次資料夾`,預設為５秒
$DebugMode="0"                                                 #Debug Mode=1 會輸出到Ｃｌｉ及記錄檔上
$LogType="EVENT"                                               #預設的紀錄方式，EVENT 寫到 系統記錄 > Application ; LOG 寫到檔案
$LogToEvent=New-EventLog -LogName "Windows PowerShell" -Source HiLinkWatchDog  #Modified by Andylai 
$WriteToEvent=Write-EventLog -LogName "Windows PowerShell" -EventId 5566 -Source HiLinkWatchDog -Message $LogType    #Modified by Andylai 
$Log=$LogFilePath + $LogFileName 
​
###      Define Variables Area  END     ###
​
​
###     Scripts Start    ###
​
Clear-Host                        #清除命令視窗目前的訊息
If ($ValidWatchPath -eq $True )   #判斷監控資料夾是否存在
{                                  
  If ($ValidLogFilePath -eq $True  ) #判斷監控紀錄資料夾存在
  {        
     If ($DebugMode -eq 1){
                          $LogFileName=(Get-Date -format "yyyy-MM-dd") + "_DEBUG_log.txt"   #Debug mode改紀錄輸出檔名 EX:2015-11-13_DEBUG_log.txt
                          Write-Output ("###     DEBUG MODE     ＃＃＃")
                          Write-Output ("###監看資料夾 " + $WatchPath + "　中＃＃＃＃")
                          Write-Output ("###系統記錄：  Windwows記錄 > Windows PowerShell 　＃＃＃＃") #Modified by Andylai 
                          Write-Output ("###紀錄檔案： $LogFilePath + $LogFileName 　＃＃＃＃")
                          Write-Output ("###     DEBUG MODE     ＃＃＃")
                         }
    #不是 Deubug Mode ，判斷紀錄型態，決定輸出提示
    Else{
          If ($LogType -eq "EVENT")
          {
              Write-Output ("###監看資料夾 " + $WatchPath + "　中＃＃＃＃")
              Write-Output ("###系統記錄：  Windwows記錄 > Windows PowerShell 　＃＃＃＃")
          }
          Else {
                  Write-Output ("###監看資料夾 " + $WatchPath + "　中＃＃＃＃")
                  Write-Output ("###紀錄檔案： " + $LogFilePath +　$LogFileName　+ "　＃＃＃＃")
               }
       }
  }
​
​
    ### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
        $watcher = New-Object System.IO.FileSystemWatcher
        $watcher.Path = $WatchPath
        $watcher.Filter = "*.*"
        $watcher.IncludeSubdirectories = $true
        $watcher.EnableRaisingEvents = $true  
​
​
    ### DEFINE ACTIONS AFTER A EVENT IS DETECTED
        $action = { $path = $Event.SourceEventArgs.FullPath
                    $changeType = $Event.SourceEventArgs.ChangeType
                    $logline = "$(Get-Date -format "yyyy-MM-dd HH:mm:ss"), $changeType, $path"
​
                    #If (-Not ($path.ToLower().EndsWith(".log")))  #Modified by Andylai  Define not watch type. 定義不紀錄的類型
                    If (($path -notlike "*.log") -and ($path -notlike "*.tmp") -and ($path -notlike "*.edb") -and ($path -notlike "*.dat") -and ($path -notlike "*.job") -and ($path -notlike "*.chk") -and ($path -notlike "*.bak") -and ($path -notlike "*'bTemp'b*") -and ($path -notlike "*'bdebug'b*"))
                    {
                        If ($DebugMode -eq "1")                                                              #判斷如果是Ｄｅｂｕｇ　ｍｏｄｅ輸出到螢幕並寫入記錄、寫入系統 LOG
                        { 
                          Write-Warning ( $logline )
                          Add-content ($LogFilePath + $LogFileName ) -value $logline 
                          New-EventLog -LogName "Windows PowerShell" -Source HiLinkWatchDog
                          Write-EventLog -LogName "Windows PowerShell" -EventId 5566 -Source HiLinkWatchDog -Message $logline   #寫到 Windwows記錄 > Windows PowerShell
                        }
​
                        Else                                                                     #不是 Ｄｅｂｕｇ　ｍｏｄｅ 的話，判斷是寫 EVENT 還是寫 LOG
                        { 
                         If($LogType -eq "EVENT")                                               #LogType=EVENTtoSysLog
                         {
                         New-EventLog -LogName "Windows PowerShell" -Source HiLinkWatchDog
                         Write-EventLog -LogName "Windows PowerShell" -EventId 5566 -Source HiLinkWatchDog -Message $logline
                         }
                         
                         Else{                                                                 #LogType=LogToFile
                         Add-content ($LogFilePath + $LogFileName ) -value $logline }
                        } 
                    }
                  }    
    ### DECIDE WHICH EVENTS SHOULD BE WATCHED + SET CHECK FREQUENCY  
        $created = Register-ObjectEvent $watcher "Created" -Action $action
        $changed = Register-ObjectEvent $watcher "Changed" -Action $action
        $deleted = Register-ObjectEvent $watcher "Deleted" -Action $action
        $renamed = Register-ObjectEvent $watcher "Renamed" -Action $action
        while ($true) {sleep $ScanTime}
​
}
          Else {
                Write-Warning  "*** LOG資料夾 $LogFilePath 不存在,請確認 LOG 資料夾是否設定正確！***"　
                Start-Sleep -s 5
                }
Else {
        Write-Warning  "***監控資料夾 $WatchPath 不存在,請確認監控資料夾是否設定正確！***"　
        Start-Sleep -s 5
      }
​
###     Scripts END    ###