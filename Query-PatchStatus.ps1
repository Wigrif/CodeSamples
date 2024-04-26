<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2018
	 Created on:   	2/21/2018 1:44 PM
	 Created by:   	AFUWXG2
	 Organization: 	SomeDomain
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Query the ISPs servers for patching status.  Send status updates to dashboard backends.
#>
$host.ui.RawUI.WindowTitle = "Query-PatchStatus / PID: " + $PID

Start-Job -Name "NorthISP1s" -ScriptBlock {
	$NorthISP1s = (Get-ADComputer -Filter * -SearchBase "OU=Northern Division ISP1s,OU=Store ISP1,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$NorthISP1s.name | %{
		$ISP = $_; Invoke-Command -ComputerName $ISP -ScriptBlock {
			function Send-Notification {
				param ($AlertType,
					$Name,
					$AlertSev,
					$AlertAttribute,
					$AlertValue)
				
				$DateTime = (Get-Date -Format G)
				$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
				$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
				$i1 = 0
				$i2 = 0
				#send notifitcation to Spectrum
				do {
					$i1++
					"Attempting to send notification to Spectrum...$i1"
					$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
					if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
				}
				until (($Sent1 -eq "200") -or ($i1 -ge 3))
				
				#Send notification to Snitch
				do {
					$i2++
					"Attempting to send notification to Snitch...$i2"
					$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
					if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
				}
				until (($Sent2 -eq "200") -or ($i2 -ge 3))
				
				
				if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
				Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
			}
			$os = Get-WmiObject win32_operatingsystem
			$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
			If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
			If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
			$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
			$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
			#Define update criteria.
			$Criteria = "IsInstalled=0 and Type='Software'";`
			#Search for relevant updates.
			$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
			$SearchResult = $Searcher.Search($Criteria).Updates;`
			$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
			$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
			$updatesearcher = $updatesession.CreateUpdateSearcher()
			$rebootresult = $updatesearcher.Search("RebootRequired=1")
			IF ($rebootresult.updates.count -eq 0) {
				$RebootRequired = "NO"
				Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
			}
			IF ($rebootresult.updates.count -ge 1) {
				$RebootRequired = "YES"
				Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
				Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
			}
			IF ($uptime.totaldays -ge 45) {
				$RebootRequired = "YES"
				Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
			}
			IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
				$AlertSev = "Green"
				Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
				Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			}
		}
	}
}

Start-Job -Name "SouthISP1s" -ScriptBlock {
	$SouthISP1s = (Get-ADComputer -Filter * -SearchBase "OU=Southern Division ISP1s,OU=Store ISP1,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$SouthISP1s.name | %{
	$ISP = $_
	Invoke-Command -ComputerName $ISP -ScriptBlock {
		function Send-Notification {
			param ($AlertType,
				$Name,
				$AlertSev,
				$AlertAttribute,
				$AlertValue)
			
			$DateTime = (Get-Date -Format G)
			$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$i1 = 0
			$i2 = 0
			#send notifitcation to Spectrum
			do {
				$i1++
				"Attempting to send notification to Spectrum...$i1"
				$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
				if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent1 -eq "200") -or ($i1 -ge 3))
			
			#Send notification to Snitch
			do {
				$i2++
				"Attempting to send notification to Snitch...$i2"
				$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
				if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent2 -eq "200") -or ($i2 -ge 3))
			
			
			if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
			Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
		}
		$os = Get-WmiObject win32_operatingsystem
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
		If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
		$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
		$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
		#Define update criteria.
		$Criteria = "IsInstalled=0 and Type='Software'";`
		#Search for relevant updates.
		$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
		$SearchResult = $Searcher.Search($Criteria).Updates;`
		$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
		$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
		$updatesearcher = $updatesession.CreateUpdateSearcher()
		$rebootresult = $updatesearcher.Search("RebootRequired=1")
		IF ($rebootresult.updates.count -eq 0) {
			$RebootRequired = "NO"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($rebootresult.updates.count -ge 1) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($uptime.totaldays -ge 45) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
		}
		IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
			$AlertSev = "Green"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
		}
	}
}	
}

Start-Job -Name "WestISP1s" -ScriptBlock {
	$WestISP1s = (Get-ADComputer -Filter * -SearchBase "OU=Western Division ISP1s,OU=Store ISP1,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$WestISP1s.name | %{
	$ISP = $_; Invoke-Command -ComputerName $ISP -ScriptBlock {
		function Send-Notification {
			param ($AlertType,
				$Name,
				$AlertSev,
				$AlertAttribute,
				$AlertValue)
			
			$DateTime = (Get-Date -Format G)
			$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$i1 = 0
			$i2 = 0
			#send notifitcation to Spectrum
			do {
				$i1++
				"Attempting to send notification to Spectrum...$i1"
				$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
				if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent1 -eq "200") -or ($i1 -ge 3))
			
			#Send notification to Snitch
			do {
				$i2++
				"Attempting to send notification to Snitch...$i2"
				$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
				if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent2 -eq "200") -or ($i2 -ge 3))
			
			
			if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
			Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
		}
		$os = Get-WmiObject win32_operatingsystem
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
		If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
		$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
		$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
		#Define update criteria.
		$Criteria = "IsInstalled=0 and Type='Software'";`
		#Search for relevant updates.
		$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
		$SearchResult = $Searcher.Search($Criteria).Updates;`
		$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
		$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
		$updatesearcher = $updatesession.CreateUpdateSearcher()
		$rebootresult = $updatesearcher.Search("RebootRequired=1")
		IF ($rebootresult.updates.count -eq 0) {
			$RebootRequired = "NO"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($rebootresult.updates.count -ge 1) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($uptime.totaldays -ge 45) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
		}
		IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
			$AlertSev = "Green"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
		}
	}
}
}

Start-Job -Name "PilotISP1s" -ScriptBlock {
	$PilotISP1s = (Get-ADComputer -Filter * -SearchBase "OU=Pilot ISP1s,OU=Store ISP1,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$PilotISP1s.name | %{
	$ISP = $_; Invoke-Command -ComputerName $ISP -ScriptBlock {
		function Send-Notification {
			param ($AlertType,
				$Name,
				$AlertSev,
				$AlertAttribute,
				$AlertValue)
			
			$DateTime = (Get-Date -Format G)
			$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$i1 = 0
			$i2 = 0
			#send notifitcation to Spectrum
			do {
				$i1++
				"Attempting to send notification to Spectrum...$i1"
				$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
				if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent1 -eq "200") -or ($i1 -ge 3))
			
			#Send notification to Snitch
			do {
				$i2++
				"Attempting to send notification to Snitch...$i2"
				$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
				if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent2 -eq "200") -or ($i2 -ge 3))
			
			
			if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
			Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
		}
		$os = Get-WmiObject win32_operatingsystem
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
		If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
		$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
		$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
		#Define update criteria.
		$Criteria = "IsInstalled=0 and Type='Software'";`
		#Search for relevant updates.
		$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
		$SearchResult = $Searcher.Search($Criteria).Updates;`
		$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
		$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
		$updatesearcher = $updatesession.CreateUpdateSearcher()
		$rebootresult = $updatesearcher.Search("RebootRequired=1")
		IF ($rebootresult.updates.count -eq 0) {
			$RebootRequired = "NO"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($rebootresult.updates.count -ge 1) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($uptime.totaldays -ge 45) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
		}
		IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
			$AlertSev = "Green"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
		}
	}
}
}

Start-Job -Name "NorthISP2s" -ScriptBlock {
	$NorthISP2s = (Get-ADComputer -Filter * -SearchBase "OU=Northern Division ISP2s,OU=Store ISP2,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$NorthISP2s.name | %{
	$ISP = $_; Invoke-Command -ComputerName $ISP -ScriptBlock {
		function Send-Notification {
			param ($AlertType,
				$Name,
				$AlertSev,
				$AlertAttribute,
				$AlertValue)
			
			$DateTime = (Get-Date -Format G)
			$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$i1 = 0
			$i2 = 0
			#send notifitcation to Spectrum
			do {
				$i1++
				"Attempting to send notification to Spectrum...$i1"
				$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
				if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent1 -eq "200") -or ($i1 -ge 3))
			
			#Send notification to Snitch
			do {
				$i2++
				"Attempting to send notification to Snitch...$i2"
				$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
				if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent2 -eq "200") -or ($i2 -ge 3))
			
			
			if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
			Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
		}
		$os = Get-WmiObject win32_operatingsystem
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
		If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
		$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
		$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
		#Define update criteria.
		$Criteria = "IsInstalled=0 and Type='Software'";`
		#Search for relevant updates.
		$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
		$SearchResult = $Searcher.Search($Criteria).Updates;`
		$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
		$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
		$updatesearcher = $updatesession.CreateUpdateSearcher()
		$rebootresult = $updatesearcher.Search("RebootRequired=1")
		IF ($rebootresult.updates.count -eq 0) {
			$RebootRequired = "NO"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($rebootresult.updates.count -ge 1) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($uptime.totaldays -ge 45) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
		}
		IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
			$AlertSev = "Green"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
		}
	}
}
}

Start-Job -Name "SouthISP2s" -ScriptBlock {
	$SouthISP2s = (Get-ADComputer -Filter * -SearchBase "OU=Southern Division ISP2s,OU=Store ISP2,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$SouthISP2s.name | %{
	$ISP = $_; Invoke-Command -ComputerName $ISP -ScriptBlock {
		function Send-Notification {
			param ($AlertType,
				$Name,
				$AlertSev,
				$AlertAttribute,
				$AlertValue)
			
			$DateTime = (Get-Date -Format G)
			$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$i1 = 0
			$i2 = 0
			#send notifitcation to Spectrum
			do {
				$i1++
				"Attempting to send notification to Spectrum...$i1"
				$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
				if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent1 -eq "200") -or ($i1 -ge 3))
			
			#Send notification to Snitch
			do {
				$i2++
				"Attempting to send notification to Snitch...$i2"
				$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
				if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent2 -eq "200") -or ($i2 -ge 3))
			
			
			if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
			Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
		}
		$os = Get-WmiObject win32_operatingsystem
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
		If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
		$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
		$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
		#Define update criteria.
		$Criteria = "IsInstalled=0 and Type='Software'";`
		#Search for relevant updates.
		$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
		$SearchResult = $Searcher.Search($Criteria).Updates;`
		$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
		$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
		$updatesearcher = $updatesession.CreateUpdateSearcher()
		$rebootresult = $updatesearcher.Search("RebootRequired=1")
		IF ($rebootresult.updates.count -eq 0) {
			$RebootRequired = "NO"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($rebootresult.updates.count -ge 1) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($uptime.totaldays -ge 45) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
		}
		IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
			$AlertSev = "Green"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
		}
	}
}
}

Start-Job -Name "WestISP2s" -ScriptBlock {
	$WestISP2s = (Get-ADComputer -Filter * -SearchBase "OU=Western Division ISP2s,OU=Store ISP2,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$WestISP2s.name | %{
	$ISP = $_; Invoke-Command -ComputerName $ISP -ScriptBlock {
		function Send-Notification {
			param ($AlertType,
				$Name,
				$AlertSev,
				$AlertAttribute,
				$AlertValue)
			
			$DateTime = (Get-Date -Format G)
			$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$i1 = 0
			$i2 = 0
			#send notifitcation to Spectrum
			do {
				$i1++
				"Attempting to send notification to Spectrum...$i1"
				$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
				if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent1 -eq "200") -or ($i1 -ge 3))
			
			#Send notification to Snitch
			do {
				$i2++
				"Attempting to send notification to Snitch...$i2"
				$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
				if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent2 -eq "200") -or ($i2 -ge 3))
			
			
			if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
			Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
		}
		$os = Get-WmiObject win32_operatingsystem
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
		If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
		$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
		$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
		#Define update criteria.
		$Criteria = "IsInstalled=0 and Type='Software'";`
		#Search for relevant updates.
		$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
		$SearchResult = $Searcher.Search($Criteria).Updates;`
		$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
		$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
		$updatesearcher = $updatesession.CreateUpdateSearcher()
		$rebootresult = $updatesearcher.Search("RebootRequired=1")
		IF ($rebootresult.updates.count -eq 0) {
			$RebootRequired = "NO"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($rebootresult.updates.count -ge 1) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($uptime.totaldays -ge 45) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
		}
		IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
			$AlertSev = "Green"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
		}
	}
}
}

Start-Job -Name "PilotISP2s" -ScriptBlock {
	$PilotISP2s = (Get-ADComputer -Filter * -SearchBase "OU=Pilot ISP2s,OU=Store ISP2,OU=ISPs,OU=Store Clusters,DC=stores,DC=SomeDomain,DC=com") | ?{ $_.name -notlike "W0*" } | ?{ $_.name -notlike "S07*" } | ?{ $_.name -notlike "S08*" } | ?{ $_.name -notlike "S09*" } | sort
	$PilotISP2s.name | %{
	$ISP = $_; Invoke-Command -ComputerName $ISP -ScriptBlock {
		function Send-Notification {
			param ($AlertType,
				$Name,
				$AlertSev,
				$AlertAttribute,
				$AlertValue)
			
			$DateTime = (Get-Date -Format G)
			$Uri1 = ("http://apm.SomeDomain.com/cgi-bin/storeEvent.cgi?AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$Uri2 = ("http://CLTINFSUPPD02:888/AlertType=" + $AlertType + "&Name=" + $Name + "&AlertSev=" + $AlertSev + "&AlertAttribute=" + $AlertAttribute + "&AlertValue=" + $AlertValue + "&DateTime=" + $DateTime)
			$i1 = 0
			$i2 = 0
			#send notifitcation to Spectrum
			do {
				$i1++
				"Attempting to send notification to Spectrum...$i1"
				$Sent1 = (Invoke-WebRequest -URI $Uri1).StatusCode
				if ($Sent1 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent1 -eq "200") -or ($i1 -ge 3))
			
			#Send notification to Snitch
			do {
				$i2++
				"Attempting to send notification to Snitch...$i2"
				$Sent2 = (Invoke-WebRequest -URI $Uri2).StatusCode
				if ($Sent2 -ne "200") { Start-Sleep -Seconds 5 }
			}
			until (($Sent2 -eq "200") -or ($i2 -ge 3))
			
			
			if ([System.Diagnostics.EventLog]::Exists('Support') -ne $true) { New-EventLog -LogName Support -Source Spectrum }
			Write-EventLog -LogName Support -Source Spectrum -EntryType Information -EventId 0 -Message $Uri2
		}
		$os = Get-WmiObject win32_operatingsystem
		$uptime = ((Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime)))
		If ($uptime.totaldays -ge "45") { $AlertSev = "Red" }
		If ($uptime.totaldays -lt "45") { $AlertSev = "Yellow" }
		$uptimestring = ([STRING]$uptime.days) + "." + ([STRING]$uptime.hours)
		$DisplayUp = " uptime is " + [math]::Round($Uptime.TotalHours) + " hours.  "
		#Define update criteria.
		$Criteria = "IsInstalled=0 and Type='Software'";`
		#Search for relevant updates.
		$Searcher = New-Object -ComObject Microsoft.Update.Searcher;`
		$SearchResult = $Searcher.Search($Criteria).Updates;`
		$DisplayUpdates = " has " + $SearchResult.count + " updates pending,"
		$updatesession = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session"))
		$updatesearcher = $updatesession.CreateUpdateSearcher()
		$rebootresult = $updatesearcher.Search("RebootRequired=1")
		IF ($rebootresult.updates.count -eq 0) {
			$RebootRequired = "NO"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($rebootresult.updates.count -ge 1) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
			Send-Notification -AlertType PatchStatus -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute $SearchResult.count -AlertValue $uptimestring
		}
		IF ($uptime.totaldays -ge 45) {
			$RebootRequired = "YES"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue (([STRING]$uptime.totaldays).split(".") | select -First 1)
		}
		IF (($uptime.totaldays -lt 45) -and ($rebootresult.updates.count -eq 0)) {
			$AlertSev = "Green"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "Uptime >45 days" -AlertValue "na"
			Send-Notification -AlertType Device -Name $env:COMPUTERNAME -AlertSev $AlertSev -AlertAttribute "RebootNeeded" -AlertValue "Patching"
		}
	}
}
}

get-job | %{ wait-job -id $_.id }

