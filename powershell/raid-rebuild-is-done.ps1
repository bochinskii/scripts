
while ($true) {

    $DP = "list volume" | diskpart | ? { $_ -match "^  [^-]" }
    #echo $dp
    
    foreach ($ROW in $DP) {

        # skip first line
        if (!$ROW.Contains("###")) {
        
            #$ROW -match "Зеркальный|Mirror"
            if ($row -match "\s\s(Том\s\d)\s+([A-Z])\s+(.*)\s\s(NTFS|FAT)\s+(Зеркальный|Mirror|RAID-5|Stripe|Spanned)\s+(\d+)\s+(..)\s\s([A-Za-z]*\s?[A-Za-z]*)(\s\s)*.*") {
            
                #echo $ROW
                $VOLUME = $matches[2]
                $RAID_TYPE = $matches[5]
                #echo $DISK
            
                if ($ROW -match "Исправен|Healthy") {
            
                    $STATUS_TEXT = "is healthy"
				    $STATUS_CODE = 0
				    $STATUS = "OK"

                }
                elseif ($ROW -match "Перестрои|Rebuild") {
            
                    $STATUS_TEXT = "is rebuilting"
				    $STATUS_CODE = 1
				    $STATUS = "OK"
            
                }
                elseif ($ROW -match "Failed|At Risk") {
            
                    $STATUS_TEXT = "failed"
				    $STATUS_CODE = 2
				    $STATUS = "CRITICAL"

                }
            
                echo ("-"*100)
                echo ""
                echo "Status codes: 0 - ""Healthy"", 1 - ""Rebuild"", 2 - ""Failed"""
                echo ""
                echo ("-"*100)
                echo ""
                echo "Status code is ""$STATUS_CODE"" Status is - ""$STATUS"" - Software RAID ($RAID_TYPE) on volume $VOLUME : ""$STATUS_TEXT"""
                echo ""
                echo ("-"*100)

            }
    
        }

    }


    if ($STATUS_CODE -eq 0) {
        
        $wshell = New-Object -ComObject Wscript.Shell
        $Output = $wshell.Popup("Перестроение RAID ($RAID_TYPE) тома $VOLUME выполнено",0,"Статус RAID",0)
        exit

    }

    sleep -Seconds 120

}
