
while ($true) {

    $DP = "list volume" | diskpart | ? { $_ -match "^  [^-]" }
    #echo $dp
    echo ("-"*100)
    echo ""
    echo "Status codes: 0 - ""Healthy"", 1 - ""Rebuild"", 2 - ""Failed"""
    echo ""
    
    foreach ($ROW in $DP) {

        # skip first line
        if (!$ROW.Contains("###")) {
        
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
                echo "Status code is ""$STATUS_CODE"" Status is - ""$STATUS"" - Software RAID ($RAID_TYPE) on volume $VOLUME : ""$STATUS_TEXT"""
                echo ""
                echo ("-"*100)

                if ($STATUS_CODE -eq 1) {
        
                    $WSHELL = New-Object -ComObject Wscript.Shell
                    $OUTPUT = $WSHELL.Popup("Обнаружено перестроение RAID ($RAID_TYPE) тома $VOLUME. Хотите мониторить перестроение RAID?" ,0,"Статус RAID",4)
                    #echo $OUTPUT

                    if ($OUTPUT -eq 6) {
                    
                        #echo "YES"
                        while ($true) {
                        
                            foreach ($ROW in $DP) {
                            
                                if (!$ROW.Contains("###")) {
                                
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
                                        echo "Status code is ""$STATUS_CODE"" Status is - ""$STATUS"" - Software RAID ($RAID_TYPE) on volume $VOLUME : ""$STATUS_TEXT"""
                                        echo ""
                                        echo ("-"*100)

                                        if ($STATUS_CODE -eq 0) {
                                        
                                            $WSHELL = New-Object -ComObject Wscript.Shell
                                            $OUTPUT = $WSHELL.Popup("Перестроение RAID ($RAID_TYPE) тома $VOLUME выполнено",0,"Статус RAID",0)
                                            #echo $OUTPUT
                                            exit
                                        
                                        }
                                    
                                    }
                                
                                }

                            }
                            
                            sleep -Seconds 120    
                        
                        }
                    
                    }
                    else {
                    
                        #echo "NO"
                        exit

                    }
                    exit


                }

            }
           
    
        }

    }

    sleep -Seconds 120

}
