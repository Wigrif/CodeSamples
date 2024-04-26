Import-Module -Name WASP
#region Functions
function Get-4x4PixelColor {
	Param (
		[Int]$X,
		[Int]$Y
	)
	$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
	
	#region create pixel block
	$X = $x - 2
	$Y = $Y - 2
	1..4 | foreach {
		1..4 | foreach {
			$ColorofPixel += (, ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name)
			$Y++
		}
		$X++
		$Y = $Y - 4
	}
	#endregion
	# Find unique
	$ColorofPixel = $ColorofPixel | Get-Unique
	Return $ColorofPixel
}
function Expand-ZIPFile($file, $destination) {
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace($file)
	foreach ($item in $zip.items()) {
		$shell.Namespace($destination).copyhere($item)
	}
}
function Do-LeftPath {
	Start-Job -Name "DoEasyPath" -ScriptBlock {
		Import-Module WASP
		
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#region mouse click left
		$signature = @'
[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		#region Functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function Click-Waypoint {
			Param (
				$X,
				$Y
			)
			Start-Sleep -Milliseconds 50
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
			Start-Sleep -Milliseconds 50
			Click-mousebutton -button left
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			Start-Sleep -Milliseconds 50
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			Start-Sleep -Milliseconds 200
		}
		function Do-EasyWayPoints {
			$XIncrement = 65
			$YIncrement = 44
			
			#Clear-Host
			
			# Current Location
			$CurrentX = 742
			$CurrentY = 462
			# Click Center to NorthWest
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			
			# Click Center to North
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
			
			# Click Center to NorthEast
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			
			# Click Center to East
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
			
			# Click Center to SouthEast
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			
			# Click Center to South
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
			
			# Click Center to SouthWest
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			
			# Click Center to West
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
			
		}
		#endregion
		Do {
			do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
			until ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1")
			do { Do-EasyWayPoints }
			until ((Get-PixelColor -X 1395 -Y 742) -ne "c2c1c1")
		}
		until ($true -eq $false)
	} | out-null
}
function Do-RightPath {
	Start-Job -Name "DoHardPath" -ScriptBlock {
		Import-Module WASP
		
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#region mouse click left
		$signature = @'
[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		#region Functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function Click-Waypoint {
			Param (
				$X,
				$Y
			)
			Start-Sleep -Milliseconds 3
			
			#region Functions
			Add-Type -AssemblyName System.Drawing
			Add-Type -AssemblyName System.Windows.Forms
			#endregion
			
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
			Start-Sleep -Milliseconds 50
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			Start-Sleep -Milliseconds 50
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			Start-Sleep -Milliseconds 200
		}
		function Do-HardWayPoints {
			$XIncrement = 65
			$YIncrement = 44
			
			# Current Location
			$CurrentX = 742
			$CurrentY = 462
			
			# Click Center to South
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
			
			# Click Center to SouthEast
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			
			# Click Center to East
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
			
			# Click Center to NorthEast
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			
			# Click Center to North
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
			
			# Click Center to NorthWest
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			
			# Click Center to West
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
			
			# Click Center to SouthWest
			if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
		}
		
		#endregion
		
		Do {
			do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
			until ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1")
			do { Do-HardWayPoints }
			until ((Get-PixelColor -X 1395 -Y 742) -ne "c2c1c1")
		}
		until ($true -eq $false)
	} | out-null
}
function Do-DeadManCheck {
	param (
		$jobid,
		[String]$jobname
	)
	$GohomeDone = $false
	$Currentcount = $StatusBox.Lines.Count()
	# Populate $Global:DeadmanTimer value
	if ($currentcount -eq $Global:Deadmancount) {
		$Global:DeadmanTimer++
	}
	else {
		$Global:Deadmancount = $Currentcount
		$Global:DeadmanTimer = 0
	}
	
	# take action based on $Global:DeadmanTimer value
	
	if ($Global:DeadmanTimer -lt 180) {
		$labelSystemStatus.BackColor = 'Green'
		$labelSystemStatus.Text = "System Status: Normal"
		Write-Host $global:Deadmancount
	}
	elseif (($Global:DeadmanTimer -ge 180) -and $Global:DeadmanTimer -lt 300) {
		$labelSystemStatus.Text = "System Status: Possible Hang"
		$labelSystemStatus.BackColor = 'Orange'
		Write-Host $global:Deadmancount
	}
	# Game hung or job hung, stop job
	elseif ($Global:DeadmanTimer -ge 300) {
		Write-Host $global:Deadmancount
		$Subject = "MCOC on $env:computername has hung.  Autocorrect initiated."
		$body = "MCOC hung, attempting to autocorrect.  Hang condition:"
		$HangOutput = "$JobName hung, killing process."
		$labelSystemStatus.Text = "System Status: Hang Detected"
		$labelSystemStatus.BackColor = 'Red'
		Write-ShellOutput -outputtext $HangOutput
		if ($StatusLastUpdateTime -gt 300) {
			$body = $body + " Arena"
		}
		if ($global:possiblehang -eq 5) {
			$body = $body + " Pixel"
		}
		if (($Global:MailSent -ne $true) -or (($global:sendtime).addminutes(15) -lt (Get-date))) {
			Send-Email -Recipient $NotificationTarget -subject $Subject -Body $Body
			$Global:MailSent = $true
			$global:sendtime = Get-Date
		}
		if ($GohomeDone -ne $true) {
			Go-Home
		}
		$GohomeDone = $true
		1..50 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		Start-Process -FilePath 'C:\Program Files (x86)\MotherShip\MotherShip.exe' -ArgumentList Resume
	}
}
function move-window {
	$BluestacksLocation = Select-Window -Title "Bluestacks App Player" | Get-WindowPosition
	Select-window -title "MCOC MotherShip*" | set-windowposition -Top $BluestacksLocation.Top -left $BluestacksLocation.Right
}
function move-bluestackswindow {
	param (
	$top,
	$left
)
	Select-window -title "Bluestacks App Player" | set-windowposition -Top $Top -left $left
}
Function Send-Email {
	param ($subject, $Recipient, $Body)
	$EmailFrom = "MCOC.Bot@gmail.com"
	$SMTPServer = "smtp.gmail.com"
	$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
	$SMTPClient.EnableSsl = $true
	$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("MCOC.Bot", "Mothership9000?");
	$SMTPClient.Send($EmailFrom, $Recipient, $Subject, $Body)
}
Function Create-activationkey {
	
	Param (
		[int]$length = 20,
		[string[]]$sourcedata
	)
	For ($loop = 1; $loop –le $length; $loop++) {
		
		$activationkey += ($sourcedata | GET-RANDOM)
		
	}
	[string]$machinename = $env:COMPUTERNAME
	$namepart = [System.Text.Encoding]::UTF8.GetBytes($machinename)
	$namepart = [System.Convert]::ToBase64String($namepart)
	$namepartsub5 = $namepart.Substring(0, 5)
	$activationkey = $activationkey + $namepartsub5
	return $activationkey
	
}
function Create-Seed {
	# Generate random string for activation key seed
	$AsciiCharacters = "1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z"
	$AsciiCharacters = $AsciiCharacters.Split(",")
	# Create password variable
	$keystring = Create-activationkey -sourcedata $AsciiCharacters
	$keysave = $keystring | ConvertTo-SecureString -AsPlainText -Force
	$savepath = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\adr323d.xml"
	if (!(test-path -Path $savepath)) {
		New-item -ItemType directory -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1")
	}
	$keysave | Export-Clixml -Path $savepath
	$KeyContents = Get-Content -Path $savepath
	$savepath = Set-ItemProperty -Path hklm:\software\MalliumSoftware\Mothership -Name ActivationKey -Value $KeyContents
	return $keystring
}
function Validate-productkey {
	$keyentered = $activationcode.text.tostring()
	if ($keyentered -ne $null) {
		$savepath = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\adr323d.xml"
		$registrykey = Get-ItemProperty -Path hklm:\software\wow6432node\MalliumSoftware\Mothership -Name ActivationKey
		$registrykey.activationkey | out-file $savepath
		$Key = Import-Clixml $savepath
		$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($key)
		$decryptedkey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
		if ($keyentered -eq $decryptedkey) {
			$keyvalid = $true
		}
		if ($keyvalid -eq $true) {
			$namepartentered = $keyentered.Substring(20, 5)
			[string]$machinename = $env:COMPUTERNAME
			$namepart = [System.Text.Encoding]::UTF8.GetBytes($machinename)
			$namepart = [System.Convert]::ToBase64String($namepart)
			$namepartsub5 = $namepart.Substring(0, 5)
			if ($namepartentered -eq $namepartsub5) {
				$keyvalid = $true
				$ActivationKey = Set-Activation
				Set-ItemProperty -Path hklm:\software\MalliumSoftware\Mothership -Name Registration -Value $ActivationKey
				Set-ItemProperty -Path hklm:\software\MalliumSoftware\Mothership -Name NotificationAddress -Value $NotificationAddress.Text
			}
			else {
				$keyvalid = $false
			}
		}
	}
	else {
		WRITE-HOST "pattern mismatch"
		$keyvalid = $false
	}
	return $keyvalid
}
Function Set-Activation {
	$machinename = $env:COMPUTERNAME
	$namepart = [System.Text.Encoding]::UTF8.GetBytes($machinename)
	$namepart = [System.Convert]::ToBase64String($namepart)
	$Activatedpart = [System.Text.Encoding]::UTF8.GetBytes("Activated")
	$Activatedpart = [System.Convert]::ToBase64String($Activatedpart)
	$ActivatedKey = $namepart + $Activatedpart
	Return $activatedKey
}
Function Get-Activation {
	Param (
		$ActivatedKey
	)
	
	$CompPart = $ActivatedKey.substring(0, ($activatedkey.Length - 12))
	$ActivatedPart = $ActivatedKey.substring(($activatedkey.Length - 12), 12)
	$convertcompbytes = [System.Convert]::FromBase64String($CompPart)
	$CompKeyString = [System.Text.Encoding]::UTF8.GetString($convertcompbytes)
	$convertActivatebytes = [System.Convert]::FromBase64String($Activatedpart)
	$ActivateKeyString = [System.Text.Encoding]::UTF8.GetString($convertactivatebytes)
	if (($CompKeyString -eq $env:COMPUTERNAME) -and ($ActivateKeyString -eq "Activated")) {
		$activated = $true
	}
	else {
		$activated = $false
	}
	
	Return $Activated
	
}
function Validate-Notification {
	
	$emailvalidate = '^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$'
	
	if ($NotificationAddress.text -match $emailvalidate) {
		$notificationvalid = $true
	}
	else {
		$notificationvalid = $false
	}
	return $notificationvalid
}
Function Test-BlueStacksInstall {
	param (
		$architecture
	)
	if ($architecture -eq "64") {
		$RegistryPath = "HKLM:\SOFTWARE\Wow6432Node\BlueStacks"
	}
	else {
		$RegistryPath = "HKLM:\SOFTWARE\BlueStacks"
	}
	If ((Test-Path -Path $RegistryPath) -eq $true) {
		$BlueStacksInstalled = $true
	}
	else {
		$BlueStacksInstalled = $false
	}
	Return $BlueStacksInstalled
}
Function Get-InternetTime {
	param ($NtpServer = 'utcnist.colorado.edu')
	
	try {
		$address = [Net.Dns]::GetHostEntry($NtpServer).AddressList[0]
	}
	catch {
		Write-Host "Could not resolve ip address from '" + $NtpServer + "'.", "ntpServer"
		return
	}
	$ep = New-Object Net.IPEndPoint($address, 123)
	
	$s = New-Object Net.Sockets.Socket(
	[Net.Sockets.AddressFamily]::InterNetwork,
	[Net.Sockets.SocketType]::Dgram,
	[Net.Sockets.ProtocolType]::Udp)
	
	$s.Connect($ep)
	$buffer = New-Object byte[] 48
	$buffer[0] = '0X1B'
	[Void]$s.Send($buffer)
	[Void]$s.Receive($buffer)
	
	$offsetTransmitTime = 40
	$intpart = 0
	$fractpart = 0
	
	for ($i = 0; $i -le 3; $i++) {
		$intpart = 256 * $intpart + $buffer[$offsetTransmitTime + $i]
	}
	for ($i = 4; $i -le 7; $i++) {
		$fractpart = 256 * $fractpart + $buffer[$offsetTransmitTime + $i]
	}
	
	$milliseconds = $intpart * 1000 + ($fractpart * 1000) / 0x100000000L
	$s.Close()
	
	$timeSpan = [TimeSpan]::FromTicks($milliseconds * [TimeSpan]::TicksPerMillisecond)
	
	$dateTime = New-Object DateTime(1900, 1, 1)
	$dateTime += $timeSpan
	
	$offsetAmount = [TimeZone]::CurrentTimeZone.GetUtcOffset($dateTime)
	$networkDateTime = $dateTime + $offsetAmount
	
	$networkDateTime
}
Function Get-ScriptDirectory {
	[OutputType([string])]
	param ()
	if ($hostinvocation -ne $null) {
		Split-Path $hostinvocation.MyCommand.path
	}
	else {
		Split-Path $script:MyInvocation.MyCommand.Path
	}
}
Function Load-ListBox {
	Param (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListBox]$ListBox,
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		$Items,
		[Parameter(Mandatory = $false)]
		[string]$DisplayMember,
		[switch]$Append
	)
	
	if (-not $Append) {
		$listBox.Items.Clear()
	}
	
	if ($Items -is [System.Windows.Forms.ListBox+ObjectCollection]) {
		$listBox.Items.AddRange($Items)
	}
	elseif ($Items -is [Array]) {
		$listBox.BeginUpdate()
		foreach ($obj in $Items) {
			$listBox.Items.Add($obj)
		}
		$listBox.EndUpdate()
	}
	else {
		$listBox.Items.Add($Items)
	}
	
	$listBox.DisplayMember = $DisplayMember
}
Function Write-ShellOutput {
	param (
		[String]$outputtext
	)
	if ($outputtext.Length -ne 0) {
		$outputtext = $outputtext + "`r`n"
		$StatusBox.AppendText($outputtext)
	}
}
function take-twostarScreenshots {
	$xstartleft = 798
	$ystarttop = 183
	$xendright = 938
	$yendbottom = 213
	$bounds = [Drawing.Rectangle]::FromLTRB($xstartleft, $ystarttop, $xendright, $yendbottom)
	$imagecap = screenshot $bounds
	$2StarScore.BackgroundImage = $imagecap
	#$mothershipmain.refresh()
	$xstartleft = 350
	$ystarttop = 183
	$xendright = 415
	$yendbottom = 220
	$bounds = [Drawing.Rectangle]::FromLTRB($xstartleft, $ystarttop, $xendright, $yendbottom)
	$imagecap = screenshot $bounds
	$2StarStreak.BackgroundImage = $imagecap
	#$mothershipmain.refresh()
}
function take-fourstarScreenshots {
	$xstartleft = 798
	$ystarttop = 183
	$xendright = 938
	$yendbottom = 213
	$bounds = [Drawing.Rectangle]::FromLTRB($xstartleft, $ystarttop, $xendright, $yendbottom)
	$imagecap = screenshot $bounds
	$4StarScore.BackgroundImage = $imagecap
	#$mothershipmain.refresh()
	$xstartleft = 350
	$ystarttop = 183
	$xendright = 415
	$yendbottom = 220
	$bounds = [Drawing.Rectangle]::FromLTRB($xstartleft, $ystarttop, $xendright, $yendbottom)
	$imagecap = screenshot $bounds
	$4StarStreak.BackgroundImage = $imagecap
	#$mothershipmain.refresh()
}
function screenshot {
	param (
		[Drawing.Rectangle]$bounds)
	$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
	$graphics = [Drawing.Graphics]::FromImage($bmp)
	$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
	return $bmp
}
function Get-PixelColor {
	Param (
		[Int]$X,
		[Int]$Y
	)
	$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
	
	$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
	if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
		#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
	}
	Return $ColorofPixel
}
function Send-MouseDown {
	Param
	(
		$X,
		$Y,
		$Sleep
	)
	[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
	1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
	#region mouse click
	$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
	$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
	#endregion
	$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
	if ($Sleep -eq $null) {
		Start-Sleep -Milliseconds 50
	}
	else {
		Start-Sleep -Milliseconds $Sleep
	}
}
Function Send-MouseUp {
	#region mouse click
	$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
	$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
	#endregion
	$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
	Start-Sleep -Milliseconds 50
}
Function Update-Check {
	$UpdateURL = "https://www.dropbox.com/s/0q1hh32x0mn6rql/MotherShipUpdate.txt?raw=1"
	$UpdateCheck = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\UpdateCheck.txt"
	$wc = new-object system.net.webclient
	$wc.UseDefaultCredentials = $true
	$wc.downloadfile($UpdateURL, $UpdateCheck)
	$UpdateVersion = Get-Content $UpdateCheck
	$InstalledMotherShip = Get-ItemProperty -Path "C:\Program Files (x86)\MotherShip\MotherShip.exe"
	$InstalledVersion = $InstalledMotherShip.VersionInfo.FileVersion
	If ($UpdateVersion -gt $InstalledVersion) {
		$UpdateRequired = $true
	}
	return $UpdateRequired
}
function Add-LootItem {
	param (
		[Drawing.Rectangle]$bounds)
	$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
	$graphics = [Drawing.Graphics]::FromImage($bmp)
	$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
	$LootImages.Images.Add($bmp)
}
function Sort-ListViewColumn {
	param (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListView]$ListView,
		[Parameter(Mandatory = $true)]
		[int]$ColumnIndex,
		[System.Windows.Forms.SortOrder]$SortOrder = 'None')
	
	if (($ListView.Items.Count -eq 0) -or ($ColumnIndex -lt 0) -or ($ColumnIndex -ge $ListView.Columns.Count)) {
		return;
	}
	
	#region Define ListViewItemComparer
	try {
		$local:type = [ListViewItemComparer]
	}
	catch {
		Add-Type -ReferencedAssemblies ('System.Windows.Forms') -TypeDefinition  @" 
	using System;
	using System.Windows.Forms;
	using System.Collections;
	public class ListViewItemComparer : IComparer
	{
	    public int column;
	    public SortOrder sortOrder;
	    public ListViewItemComparer()
	    {
	        column = 0;
			sortOrder = SortOrder.Ascending;
	    }
	    public ListViewItemComparer(int column, SortOrder sort)
	    {
	        this.column = column;
			sortOrder = sort;
	    }
	    public int Compare(object x, object y)
	    {
			if(column >= ((ListViewItem)x).SubItems.Count)
				return  sortOrder == SortOrder.Ascending ? -1 : 1;
		
			if(column >= ((ListViewItem)y).SubItems.Count)
				return sortOrder == SortOrder.Ascending ? 1 : -1;
		
			if(sortOrder == SortOrder.Ascending)
	        	return String.Compare(((ListViewItem)x).SubItems[column].Text, ((ListViewItem)y).SubItems[column].Text);
			else
				return String.Compare(((ListViewItem)y).SubItems[column].Text, ((ListViewItem)x).SubItems[column].Text);
	    }
	}
"@ | Out-Null
	}
	#endregion
	
	if ($ListView.Tag -is [ListViewItemComparer]) {
		#Toggle the Sort Order
		if ($SortOrder -eq [System.Windows.Forms.SortOrder]::None) {
			if ($ListView.Tag.column -eq $ColumnIndex -and $ListView.Tag.sortOrder -eq 'Ascending') {
				$ListView.Tag.sortOrder = 'Descending'
			}
			else {
				$ListView.Tag.sortOrder = 'Ascending'
			}
		}
		else {
			$ListView.Tag.sortOrder = $SortOrder
		}
		
		$ListView.Tag.column = $ColumnIndex
		$ListView.Sort()#Sort the items
	}
	else {
		if ($SortOrder -eq [System.Windows.Forms.SortOrder]::None) {
			$SortOrder = [System.Windows.Forms.SortOrder]::Ascending
		}
		
		#Set to Tag because for some reason in PowerShell ListViewItemSorter prop returns null
		$ListView.Tag = New-Object ListViewItemComparer ($ColumnIndex, $SortOrder)
		$ListView.ListViewItemSorter = $ListView.Tag #Automatically sorts
	}
}
function Add-ListViewItem {
	Param (
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		[System.Windows.Forms.ListView]$ListView,
		[ValidateNotNull()]
		[Parameter(Mandatory = $true)]
		$Items,
		[int]$ImageIndex = -1,
		[string[]]$SubItems,
		$Group,
		[switch]$Clear)
	
	if ($Clear) {
		$ListView.Items.Clear();
	}
	
	$lvGroup = $null
	if ($Group -is [System.Windows.Forms.ListViewGroup]) {
		$lvGroup = $Group
	}
	elseif ($Group -is [string]) {
		#$lvGroup = $ListView.Group[$Group] # Case sensitive
		foreach ($groupItem in $ListView.Groups) {
			if ($groupItem.Name -eq $Group) {
				$lvGroup = $groupItem
				break
			}
		}
		
		if ($lvGroup -eq $null) {
			$lvGroup = $ListView.Groups.Add($Group, $Group)
		}
	}
	
	if ($Items -is [Array]) {
		$ListView.BeginUpdate()
		foreach ($item in $Items) {
			$listitem = $ListView.Items.Add($item.ToString(), $ImageIndex)
			#Store the object in the Tag
			$listitem.Tag = $item
			
			if ($SubItems -ne $null) {
				$listitem.SubItems.AddRange($SubItems)
			}
			
			if ($lvGroup -ne $null) {
				$listitem.Group = $lvGroup
			}
		}
		$ListView.EndUpdate()
	}
	else {
		#Add a new item to the ListView
		$listitem = $ListView.Items.Add($Items.ToString(), $ImageIndex)
		#Store the object in the Tag
		$listitem.Tag = $Items
		
		if ($SubItems -ne $null) {
			$listitem.SubItems.AddRange($SubItems)
		}
		
		if ($lvGroup -ne $null) {
			$listitem.Group = $lvGroup
		}
	}
}
function Go-Home {
	#Return to home screen
	do {
		select-window -Name "HD-FrontEnd" | Send-Keys -Keys "{esc}"
		1..25 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
	}
	until (($GoHomeColors1 -contains (Get-PixelColor -X $GoHomeLocationX1 -Y $GoHomeLocationY1)) -and ($GoHomeColors2 -contains (Get-PixelColor -X $GoHomeLocationX2 -Y $GoHomeLocationY2)))
	
	#Send ESC once more to goto home screen
	select-window -Name "HD-FrontEnd" | Send-Keys -Keys "{esc}"
	1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
}
Function Clean-Memory {
	[System.GC]::Collect()
}
function Validate-IsEmail ([string]$Email) {
	<#
		.SYNOPSIS
			Validates if input is an Email
	
		.DESCRIPTION
			Validates if input is an Email
	
		.PARAMETER  Email
			A string containing an email address
	
		.INPUTS
			System.String
	
		.OUTPUTS
			System.Boolean
	#>
	
	return $Email -match "^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$"
}
#endregion
#region scriptblocks
#region arenas
$RunArena = {
	Param (
		[String]$ArenaType,
		[Boolean]$Continous,
		[Boolean]$recoil,
		[String]$FightStyle
	)
	if ($recoil -eq $null) {
		$recoil = $false
	}
	if ($FightStyle -eq $null) {
		$FightStyle = "Normal"
	}
	#region Assemblies
	Import-Module WASP
	Add-Type -AssemblyName Microsoft.VisualBasic
	[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
	Add-Type -AssemblyName System.Drawing
	Add-Type -AssemblyName System.Windows.Forms
	#endregion
	#region Functions
	function move-bluestackswindow {
		param (
			$top,
			$left
		)
		Select-window -title "Bluestacks App Player" | set-windowposition -Top $Top -left $left
	}
	
	function Get-4x4PixelColor {
		Param (
			[Int]$X,
			[Int]$Y
		)
		$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
		
		#region create pixel block
		$X = $x - 2
		$Y = $Y - 2
		1..4 | foreach {
			1..4 | foreach {
				$ColorofPixel += (, ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name)
				$Y++
			}
			$X++
			$Y = $Y - 4
		}
		#endregion
		# Find unique
		$ColorofPixel = $ColorofPixel | Get-Unique
		Return $ColorofPixel
	}
	function Start-Jobs {
		#region jobs
		if ($FightStyle -eq "Normal") {
			Start-Job -Name "FightSequence" -ScriptBlock $NormalFight | out-null
		}
		elseif ($FightStyle -eq "Aggressive") {
			Start-Job -Name "FightSequence" -ScriptBlock $AggressiveFight | out-null
		}
		elseif ($FightStyle -eq "Evasive") {
			Start-Job -Name "FightSequence" -ScriptBlock $EvasiveFight | out-null
		}
		elseif ($FightStyle -eq "Dynamic") {
			Start-Job -Name "FightSequence" -ScriptBlock $TessSequence | out-null
		}
		else {
			Start-Job -Name "FightSequence" -ScriptBlock $NormalFight | out-null
		} #default fight sequence
		Start-Job -Name "ActivateSpecials" -ScriptBlock $ActivateSpecials | Out-Null
		Start-Job -Name "AfterTheFight" -ScriptBlock $AfterFight | out-null
		#endregion
	}
	function Stop-Jobs {
		(Get-Job).id | %{ Stop-Job -Id $_ }; (Get-Job).id | %{ Remove-Job -Id $_ -Force }
	}
	function Go-Home {
		#Return to home screen
		do {
			select-window -Name "HD-FrontEnd" | Send-Keys -Keys "{esc}"
			1..25 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until (($GoHomeColors1 -contains (Get-PixelColor -X $GoHomeLocationX1 -Y $GoHomeLocationY1)) -and ($GoHomeColors2 -contains (Get-PixelColor -X $GoHomeLocationX2 -Y $GoHomeLocationY2)))
		
		#Send ESC once more to goto home screen
		select-window -Name "HD-FrontEnd" | Send-Keys -Keys "{esc}"
		1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
	}
	Function Clean-Memory {
		[System.GC]::Collect()
	}
	function Get-PixelColor {
		Param (
			[Int]$X,
			[Int]$Y
		)
		$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
		
		$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
		
		Return $ColorofPixel
	}
	function Send-MouseDown {
		Param
		(
			$X,
			$Y,
			$Sleep
		)
		[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		#region mouse click
		$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
		if ($Sleep -eq $null) {
			Start-Sleep -Milliseconds 50
		}
		else {
			Start-Sleep -Milliseconds $Sleep
		}
	}
	function Send-MouseUp {
		Param
		(
			$Sleep
		)
		#region mouse click
		$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
		if ($Sleep -eq $null) {
			Start-Sleep -Milliseconds 50
		}
		else {
			Start-Sleep -Milliseconds $Sleep
		}
	}
	function Invoke-MoveCursorToLocation {
		
		
		[CmdletBinding()]
		
		PARAM (
			
			[Parameter(Mandatory = $true)]
			[uint32]$X,
			
			[Parameter(Mandatory = $true)]
			[uint32]$Y,
			
			[Parameter()]
			[uint32]$NumberOfMoves = 50,
			
			[Parameter()]
			[uint32]$WaitBetweenMoves = 50
			
		)
		
		Try {
			
			$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
			
			#region - Calculate positiveXChange
			if (($currentCursorPosition.X - $X) -ge 0) {
				
				$positiveXChange = $false
				
			}
			
			else {
				
				$positiveXChange = $true
				
			}
			#endregion - Calculate positiveXChange
			
			#region - Calculate positiveYChange
			if (($currentCursorPosition.Y - $Y) -ge 0) {
				
				$positiveYChange = $false
				
			}
			
			else {
				
				$positiveYChange = $true
				
			}
			#endregion - Calculate positiveYChange
			
			#region - Setup Trig Values
			
			### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
			### going to be the adjacent and opposite values of the triangle
			$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
			$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
			
			### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
			if ($xTotalDelta -ge $yTotalDelta) {
				
				$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
				
				if ($NumberOfMoves -gt $xTotalDelta) {
					
					$NumberOfMoves = $xTotalDelta
					
				}
				
				$xMoveIncrement = $xTotalDelta / $NumberOfMoves
				$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
				
			}
			else {
				
				$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
				
				if ($NumberOfMoves -gt $yTotalDelta) {
					
					$NumberOfMoves = $yTotalDelta
					
				}
				
				$yMoveIncrement = $yTotalDelta / $NumberOfMoves
				$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
			}
			#endregion - Setup Trig Values
			
			#region Verbose Output (Before for loop)
			Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
			Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
			Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
			Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
			#endregion
			
			for ($i = 0; $i -lt $NumberOfMoves; $i++) {
				
				##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
				##$yMoveIncrement = $yTotalDelta - $yPos
				
				#region Calculate X movement direction
				switch ($positiveXChange) {
					
					$true    { $currentCursorPosition.X += $xMoveIncrement }
					$false   { $currentCursorPosition.X -= $xMoveIncrement }
					default { $currentCursorPosition.X = $currentCursorPosition.X }
					
				}
				#endregion Calculate X movement direction
				
				#region Calculate Y movement direction
				switch ($positiveYChange) {
					
					$true    { $currentCursorPosition.Y += $yMoveIncrement }
					$false   { $currentCursorPosition.Y -= $yMoveIncrement }
					default { $currentCursorPosition.Y = $currentCursorPosition.Y }
					
				}
				#endregion Calculate Y movement direction
				
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Start-Sleep -Milliseconds $WaitBetweenMoves
				
				#region Verbose Output (During Loop)
				Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
				#endregion Verbose Output (During Loop)
			}
			
			$currentCursorPosition.X = $X
			$currentCursorPosition.Y = $Y
			[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
			Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
			
		}
		
		Catch {
			
			Write-Error $_.Exception.Message
			
		}
	}
	Function Center-Up {
		$StartX = $Global:Player2LocationX
		$StartY = $Global:Player2LocationY
		$EndY = $Global:Player1LocationY
		Send-MouseDown -X $StartX -Y $StartY
		Invoke-MoveCursorToLocation -X $StartX -y $EndY -WaitBetweenMoves 20 -NumberOfMoves 15
		Send-MouseUp
	}
	Function Center-Down {
		$StartX = $Global:Player2LocationX
		$StartY = $Global:Player2LocationY
		$EndY = $Global:Player3LocationY
		Send-MouseDown -X $StartX -Y $StartY
		Invoke-MoveCursorToLocation -X $StartX -y $EndY -WaitBetweenMoves 20 -NumberOfMoves 15
		Send-MouseUp
	}
	Function Top-Bottom {
		$StartX = $Global:Player1LocationX
		$StartY = $Global:Player1LocationY
		$EndY = $Global:Player3LocationY
		Send-MouseDown -X $StartX -Y $StartY
		Invoke-MoveCursorToLocation -X $StartX -y $EndY -WaitBetweenMoves 20 -NumberOfMoves 15
		Send-MouseUp
	}
	Function Load-Slot1 {
		$Color1 = "57827"
		$X1 = $Global:Slot1LocationX
		$Y1 = $Global:Slot1LocationY
		if ((Get-PixelColor -X $X1 -Y $Y1) -ne $Color1) {
			$StartX = $Global:SelectChampionLocationX
			$StartY = $Global:SelectChampionLocationY
			$EndX = $Global:Slot1LocationX
			$EndY = $Global:Slot1LocationY
			Send-MouseDown -X $StartX -Y $StartY
			Invoke-MoveCursorToLocation -X $EndX -y $EndY -WaitBetweenMoves 20 -NumberOfMoves 15
			Send-MouseUp
		}
	}
	Function Load-Slot3 {
		$Color1 = "57827"
		$X1 = 399
		$Y1 = 267
		if ((Get-PixelColor -X $X1 -Y $Y1) -ne $Color1) {
			$StartX = $Global:SelectChampionLocationX
			$StartY = $Global:SelectChampionLocationY
			$EndX = $Global:Slot3LocationX
			$EndY = $Global:Slot3LocationY
			Send-MouseDown -X $StartX -Y $StartY
			Invoke-MoveCursorToLocation -X $EndX -y $EndY -WaitBetweenMoves 20 -NumberOfMoves 15
			Send-MouseUp
		}
	}
	function Rig-Fights2 {
		$PS1 = New-Object –TypeName PSObject
		$PS2 = New-Object –TypeName PSObject
		$PS3 = New-Object –TypeName PSObject
		$ES1 = New-Object –TypeName PSObject
		$ES2 = New-Object –TypeName PSObject
		$ES3 = New-Object –TypeName PSObject
		$TMP1 = New-Object –TypeName PSObject
		$TMP2 = New-Object –TypeName PSObject
		$TMP3 = New-Object –TypeName PSObject
		Add-Member -Force -InputObject $PS1 -MemberType NoteProperty -Name "StartingSlot" -Value 1
		Add-Member -Force -InputObject $PS2 -MemberType NoteProperty -Name "StartingSlot" -Value 2
		Add-Member -Force -InputObject $PS3 -MemberType NoteProperty -Name "StartingSlot" -Value 3
		Add-Member -Force -InputObject $PS1 -MemberType NoteProperty -Name "CurrentSlot" -Value 1
		Add-Member -Force -InputObject $PS2 -MemberType NoteProperty -Name "CurrentSlot" -Value 2
		Add-Member -Force -InputObject $PS3 -MemberType NoteProperty -Name "CurrentSlot" -Value 3
		Add-Member -Force -InputObject $PS1 -MemberType NoteProperty -Name "Class" -Value "Empty"
		Add-Member -Force -InputObject $PS2 -MemberType NoteProperty -Name "Class" -Value "Empty"
		Add-Member -Force -InputObject $PS3 -MemberType NoteProperty -Name "Class" -Value "Empty"
		Add-Member -Force -InputObject $ES1 -MemberType NoteProperty -Name "Class" -Value "Empty"
		Add-Member -Force -InputObject $ES2 -MemberType NoteProperty -Name "Class" -Value "Empty"
		Add-Member -Force -InputObject $ES3 -MemberType NoteProperty -Name "Class" -Value "Empty"
		$PS1.Class = Get-PlayerSlot1
		$PS2.Class = Get-PlayerSlot2
		$PS3.Class = Get-PlayerSlot3
		$ES1.Class = Get-EnemySlot1
		$ES2.Class = Get-EnemySlot2
		$ES3.Class = Get-EnemySlot3
		Add-Member -Force -InputObject $PS1 -MemberType NoteProperty -Name "EnemySlot" -Value $ES1.Class
		Add-Member -Force -InputObject $PS2 -MemberType NoteProperty -Name "EnemySlot" -Value $ES2.Class
		Add-Member -Force -InputObject $PS3 -MemberType NoteProperty -Name "EnemySlot" -Value $ES3.Class
		$PS1, $PS2, $PS3 | % {
			Add-Member -Force -InputObject $_ -MemberType NoteProperty -Name "ES1" -Value 0
			Add-Member -Force -InputObject $_ -MemberType NoteProperty -Name "ES2" -Value 0
			Add-Member -Force -InputObject $_ -MemberType NoteProperty -Name "ES3" -Value 0
			Add-Member -Force -InputObject $_ -MemberType NoteProperty -Name "Locked" -Value "No"
		}
		$iteration = 0
		do {
			$Move = 0
			if (($PS1.locked -eq "No") -and ($Move -eq 0)) {
				if ($PS1.ES1 -eq "-1") {
					#"PS1 is disadvantaged in slot1, seek to swap it out."
					if ((($PS1.ES2 -ne "-1") -and ($PS2.ES1 -ne "-1")) -and ($PS2.locked -ne "Yes") -and ($PS1.Class -ne $PS2.Class) -and ($LastMove -ne "Center-Up")) {
						Center-Up
						$LastMove = "Center-Up"
						$Move = 1
						$TMP = $PS2
						$PS2 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					elseif ((($PS1.ES3 -ne "-1") -and ($PS3.ES1 -ne "-1")) -and ($PS3.locked -ne "Yes") -and ($PS1.Class -ne $PS3.Class) -and ($LastMove -ne "Top-Bottom")) {
						Top-Bottom
						$LastMove = "Top-Bottom"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					else {
						#"No move allowed." }
					}
				}
			}
			if (($PS2.locked -eq "No") -and ($Move -eq 0)) {
				if ($PS2.ES2 -eq "-1") {
					#"PS2 is disadvantaged in slot2, seek to swap it out."
					if ((($PS2.ES1 -ne "-1") -and ($PS1.ES2 -ne "-1")) -and ($PS1.locked -ne "Yes") -and ($PS1.Class -ne $PS2.Class) -and ($LastMove -ne "Center-Up")) {
						Center-Up
						$LastMove = "Center-Up"
						$Move = 1
						$TMP = $PS2
						$PS2 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					elseif ((($PS2.ES3 -ne "-1") -and ($PS3.ES2 -ne "-1")) -and ($PS3.locked -ne "Yes") -and ($PS2.Class -ne $PS3.Class) -and ($LastMove -ne "Center-Down")) {
						Center-Down
						$LastMove = "Center-Down"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS2
						$PS2 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					else {
						#"No move allowed." }
					}
				}
			}
			if (($PS3.locked -eq "No") -and ($Move -eq 0)) {
				if ($PS3.ES3 -eq "-1") {
					#"PS3 is disadvantaged in slot3, seek to swap it out."
					if ((($PS3.ES1 -ne "-1") -and ($PS1.ES3 -ne "-1")) -and ($PS1.locked -ne "Yes") -and ($PS1.Class -ne $PS3.Class) -and ($LastMove -ne "Top-Bottom")) {
						Top-Bottom
						$LastMove = "Top-Bottom"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					elseif ((($PS3.ES2 -ne "-1") -and ($PS2.ES3 -ne "-1")) -and ($PS2.locked -ne "Yes") -and ($PS2.Class -ne $PS3.Class) -and ($LastMove -ne "Center-Down")) {
						Center-Down
						$LastMove = "Center-Down"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS2
						$PS2 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					else {
						#"No move allowed." }
					}
				}
			}
			if (($PS1.locked -eq "No") -and ($Move -eq 0)) {
				if ($PS1.ES1 -eq "0") {
					#"Seeking to swap PS1 for advantage."
					if (($PS2.ES1 -gt $PS3.ES1) -and ($PS2.locked -ne "Yes") -and ($PS1.Class -ne $PS2.Class) -and ($LastMove -ne "Center-Up")) {
						Center-Up
						$LastMove = "Center-Up"
						$Move = 1
						$TMP = $PS2
						$PS2 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					elseif (($PS3.ES1 -gt $PS2.ES1) -and ($PS3.locked -ne "Yes") -and ($PS1.Class -ne $PS3.Class) -and ($LastMove -ne "Top-Bottom")) {
						Top-Bottom
						$LastMove = "Top-Bottom"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					else {
						#"No move allowed." }
					}
				}
			}
			if (($PS2.locked -eq "No") -and ($Move -eq 0)) {
				if ($PS2.ES2 -eq "0") {
					#"Seeking to swap PS2 for advantage."
					if (($PS1.ES2 -gt $PS3.ES2) -and ($PS1.locked -ne "Yes") -and ($PS1.Class -ne $PS2.Class) -and ($LastMove -ne "Center-Up")) {
						Center-Up
						$LastMove = "Center-Up"
						$Move = 1
						$TMP = $PS2
						$PS2 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					elseif (($PS3.ES2 -gt $PS1.ES2) -and ($PS3.locked -ne "Yes") -and ($PS2.Class -ne $PS3.Class) -and ($LastMove -ne "Center-Down")) {
						Center-Down
						$LastMove = "Center-Down"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS2
						$PS2 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					else {
						#"No move allowed." }
					}
				}
			}
			if (($PS3.locked -eq "No") -and ($Move -eq 0)) {
				if ($PS3.ES3 -eq "0") {
					#"Seeking to swap PS3 for advantage."
					if (($PS1.ES3 -gt $PS2.ES3) -and ($PS1.locked -ne "Yes") -and ($PS1.Class -ne $PS3.Class) -and ($LastMove -ne "Top-Bottom")) {
						Top-Bottom
						$LastMove = "Top-Bottom"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS1
						$PS1 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					elseif (($PS2.ES3 -gt $PS1.ES3) -and ($PS2.locked -ne "Yes") -and ($PS2.Class -ne $PS3.Class) -and ($LastMove -ne "Center-Down")) {
						Center-Down
						$LastMove = "Center-Down"
						$Move = 1
						$TMP = $PS3
						$PS3 = $PS2
						$PS2 = $TMP
						$PS1.CurrentSlot = 1
						$PS2.CurrentSlot = 2
						$PS3.CurrentSlot = 3
						$PS1.EnemySlot = $ES1.Class
						$PS2.EnemySlot = $ES2.Class
						$PS3.EnemySlot = $ES3.Class
					}
					else {
						#"No move allowed." }
					}
				}
			}
			#Zeros all advantages results
			$PS1, $PS2, $PS3 | % { $_.ES1 = 0; $_.ES2 = 0; $_.ES3 = 0 }
			#Add exit if last move -eq current move.
			#Exits loop
			
			$TMP1 = $PS1; $TMP2 = $PS2; $TMP3 = $PS3
			$PS1 = ($TMP1, $TMP2, $TMP3 | ? { $_.currentslot -eq 1 })
			$PS2 = ($TMP1, $TMP2, $TMP3 | ? { $_.currentslot -eq 2 })
			$PS3 = ($TMP1, $TMP2, $TMP3 | ? { $_.currentslot -eq 3 })
			$Move = 0
			
			$PS1, $PS2, $PS3 | % {
				#Advantage
				if (($_.class -eq "Skill") -and ($ES1.class -eq "Science")) { $_.ES1 = 1 }
				if (($_.class -eq "Science") -and ($ES1.class -eq "Mystic")) { $_.ES1 = 1 }
				if (($_.class -eq "Mystic") -and ($ES1.class -eq "Cosmic")) { $_.ES1 = 1 }
				if (($_.class -eq "Cosmic") -and ($ES1.class -eq "Tech")) { $_.ES1 = 1 }
				if (($_.class -eq "Tech") -and ($ES1.class -eq "Mutant")) { $_.ES1 = 1 }
				if (($_.class -eq "Mutant") -and ($ES1.class -eq "Skill")) { $_.ES1 = 1 }
				if (($_.class -eq "Skill") -and ($ES2.class -eq "Science")) { $_.ES2 = 1 }
				if (($_.class -eq "Science") -and ($ES2.class -eq "Mystic")) { $_.ES2 = 1 }
				if (($_.class -eq "Mystic") -and ($ES2.class -eq "Cosmic")) { $_.ES2 = 1 }
				if (($_.class -eq "Cosmic") -and ($ES2.class -eq "Tech")) { $_.ES2 = 1 }
				if (($_.class -eq "Tech") -and ($ES2.class -eq "Mutant")) { $_.ES2 = 1 }
				if (($_.class -eq "Mutant") -and ($ES2.class -eq "Skill")) { $_.ES2 = 1 }
				if (($_.class -eq "Skill") -and ($ES3.class -eq "Science")) { $_.ES3 = 1 }
				if (($_.class -eq "Science") -and ($ES3.class -eq "Mystic")) { $_.ES3 = 1 }
				if (($_.class -eq "Mystic") -and ($ES3.class -eq "Cosmic")) { $_.ES3 = 1 }
				if (($_.class -eq "Cosmic") -and ($ES3.class -eq "Tech")) { $_.ES3 = 1 }
				if (($_.class -eq "Tech") -and ($ES3.class -eq "Mutant")) { $_.ES3 = 1 }
				if (($_.class -eq "Mutant") -and ($ES3.class -eq "Skill")) { $_.ES3 = 1 }
				
				#Disadvantage
				if (($_.class -eq "Mystic") -and ($ES1.class -eq "Science")) { $_.ES1 = -1 }
				if (($_.class -eq "Cosmic") -and ($ES1.class -eq "Mystic")) { $_.ES1 = -1 }
				if (($_.class -eq "Tech") -and ($ES1.class -eq "Cosmic")) { $_.ES1 = -1 }
				if (($_.class -eq "Mutant") -and ($ES1.class -eq "Tech")) { $_.ES1 = -1 }
				if (($_.class -eq "Skill") -and ($ES1.class -eq "Mutant")) { $_.ES1 = -1 }
				if (($_.class -eq "Science") -and ($ES1.class -eq "Skill")) { $_.ES1 = -1 }
				if (($_.class -eq "Mystic") -and ($ES2.class -eq "Science")) { $_.ES2 = -1 }
				if (($_.class -eq "Cosmic") -and ($ES2.class -eq "Mystic")) { $_.ES2 = -1 }
				if (($_.class -eq "Tech") -and ($ES2.class -eq "Cosmic")) { $_.ES2 = -1 }
				if (($_.class -eq "Mutant") -and ($ES2.class -eq "Tech")) { $_.ES2 = -1 }
				if (($_.class -eq "Skill") -and ($ES2.class -eq "Mutant")) { $_.ES2 = -1 }
				if (($_.class -eq "Science") -and ($ES2.class -eq "Skill")) { $_.ES2 = -1 }
				if (($_.class -eq "Mystic") -and ($ES3.class -eq "Science")) { $_.ES3 = -1 }
				if (($_.class -eq "Cosmic") -and ($ES3.class -eq "Mystic")) { $_.ES3 = -1 }
				if (($_.class -eq "Tech") -and ($ES3.class -eq "Cosmic")) { $_.ES3 = -1 }
				if (($_.class -eq "Mutant") -and ($ES3.class -eq "Tech")) { $_.ES3 = -1 }
				if (($_.class -eq "Skill") -and ($ES3.class -eq "Mutant")) { $_.ES3 = -1 }
				if (($_.class -eq "Science") -and ($ES3.class -eq "Skill")) { $_.ES3 = -1 }
			}
			#"Advantages have been checked."
			$TMP1 = $PS1
			$TMP2 = $PS2
			$TMP3 = $PS3
			$PS1 = ($TMP1, $TMP2, $TMP3 | ? { $_.currentslot -eq 1 })
			$PS2 = ($TMP1, $TMP2, $TMP3 | ? { $_.currentslot -eq 2 })
			$PS3 = ($TMP1, $TMP2, $TMP3 | ? { $_.currentslot -eq 3 })
			$Move = 0
			if (($PS1.class -eq "Skill") -and ($ES1.class -eq "Science")) { $PS1.Locked = "Yes"; }
			if (($PS1.class -eq "Science") -and ($ES1.class -eq "Mystic")) { $PS1.Locked = "Yes"; }
			if (($PS1.class -eq "Mystic") -and ($ES1.class -eq "Cosmic")) { $PS1.Locked = "Yes"; }
			if (($PS1.class -eq "Cosmic") -and ($ES1.class -eq "Tech")) { $PS1.Locked = "Yes"; }
			if (($PS1.class -eq "Tech") -and ($ES1.class -eq "Mutant")) { $PS1.Locked = "Yes"; }
			if (($PS1.class -eq "Mutant") -and ($ES1.class -eq "Skill")) { $PS1.Locked = "Yes"; }
			if (($PS2.class -eq "Skill") -and ($ES2.class -eq "Science")) { $PS2.Locked = "Yes"; }
			if (($PS2.class -eq "Science") -and ($ES2.class -eq "Mystic")) { $PS2.Locked = "Yes"; }
			if (($PS2.class -eq "Mystic") -and ($ES2.class -eq "Cosmic")) { $PS2.Locked = "Yes"; }
			if (($PS2.class -eq "Cosmic") -and ($ES2.class -eq "Tech")) { $PS2.Locked = "Yes"; }
			if (($PS2.class -eq "Tech") -and ($ES2.class -eq "Mutant")) { $PS2.Locked = "Yes"; }
			if (($PS2.class -eq "Mutant") -and ($ES2.class -eq "Skill")) { $PS2.Locked = "Yes"; }
			if (($PS3.class -eq "Skill") -and ($ES3.class -eq "Science")) { $PS3.Locked = "Yes"; }
			if (($PS3.class -eq "Science") -and ($ES3.class -eq "Mystic")) { $PS3.Locked = "Yes"; }
			if (($PS3.class -eq "Mystic") -and ($ES3.class -eq "Cosmic")) { $PS3.Locked = "Yes"; }
			if (($PS3.class -eq "Cosmic") -and ($ES3.class -eq "Tech")) { $PS3.Locked = "Yes"; }
			if (($PS3.class -eq "Tech") -and ($ES3.class -eq "Mutant")) { $PS3.Locked = "Yes"; }
			if (($PS3.class -eq "Mutant") -and ($ES3.class -eq "Skill")) { $PS3.Locked = "Yes"; }
			$iteration++
		}
		until ($iteration -eq 10)
		$P1 = $PS1.class
		$P2 = $PS2.class
		$P3 = $PS3.class
		$E1 = $PS1.enemyslot
		$E2 = $PS2.enemyslot
		$E3 = $PS3.enemyslot
		write-output "Hero:    Enemy:"
		1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		write-output "---------------"
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		write-output "$P1    $E1"
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		write-output "$P2    $E2"
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		write-output "$P3    $E3"
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
	}
	function Menu-DropDown {
		$Collaspedmenu = $false
		$ExpandedMenu = $false
		do {
			$DetectCollaspedMenu = Get-4x4PixelColor -x $CollaspedMenuLocationX -y $CollaspedMenuLocationY
			$DetectExpandedMenu = Get-4x4PixelColor -X $ExpandedMenuLocationX -Y $ExpandedMenuLocationY
			foreach ($color in $CollaspedMenuColors) {
				if ($DetectCollaspedMenu -contains $Color) {
					$Collaspedmenu = $true
				}
			}
			foreach ($color in $ExpandedMenuColors) {
				if ($DetectExpandedMenu -contains $Color) {
					$ExpandedMenu = $true
				}
			}
		}
		Until (($Collaspedmenu -eq $true) -or ($ExpandedMenu -eq $true))
		IF ($CollaspedMenu -eq $true) {
			Send-MouseDown -X $CollaspedMenuLocationX -Y $CollaspedMenuLocationY
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
	}
	function Menu-FightButton {
		$fightmenu = $false
		do {
			Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
			$DetectFightColors = Get-4x4PixelColor -X $menufightLocationX -Y $menufightLocationY
			foreach ($color in $DetectFightColors) {
				if ($FightColors -contains $Color) {
					$fightmenu = $true
				}
			}
		}
		Until ($fightmenu -eq $true)
		IF ($fightMenu -eq $true) {
			Send-MouseDown -X $menufightLocationX -Y $menufightLocationY
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
	}
	function Versus-Button {
		$Versusmenu = $false
		$Versusmenu2 = $false
		do {
			$DetectVersusColors = Get-4x4PixelColor -X $VersusLocationX -Y $VersusLocationY
			$DetectVersusColors2 = Get-4x4PixelColor -X $VersusLocationX2 -Y $VersusLocationY2
			foreach ($color in $DetectVersusColors) {
				if ($VersusColors -contains $Color) {
					$versusmenu = $true
				}
			}
			foreach ($color in $DetectVersusColors2) {
				if ($VersusColors2 -contains $Color) {
					$versusmenu2 = $true
				}
			}
			Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
		}
		Until (($Versusmenu -eq $true) -or ($Versusmenu2 -eq $true))
		If ($Versusmenu -eq $true) {
			Do {
				Send-MouseDown -X $VersusLocationX -Y $VersusLocationY
				Send-MouseUp
				1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until ($VersusColors -notcontains (Get-PixelColor -X $VersusLocationX -Y $VersusLocationY))
		}
		elseIf ($Versusmenu2 -eq $true) {
			Do {
				Send-MouseDown -X $VersusLocationX2 -Y $VersusLocationY2
				Send-MouseUp
				1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until ($VersusColors2 -notcontains (Get-PixelColor -X $VersusLocationX2 -Y $VersusLocationY2))
		}
	}
	function Test-ArenaPage {
		$TestArena = $false
		$arenaanchor = Get-4x4PixelColor -x $global:arenaanchorLocation[0] -y $Global:arenaanchorLocation[1]
		foreach ($color in $arenaanchor) {
			if ($global:arenaanchorcolors -contains $Color) {
				
				$TestArena = $true
			}
		}
		
		return $TestArena
	}
	Function Run-Arena {
		param (
			$ArenaType
		)
		do {
			$TestArenaPage = Test-ArenaPage
		}
		until ($TestArenaPage -eq $true)
		
		Switch ($ArenaType) {
			"3Star" {
				Clean-Memory
				#click 3-Star Arena
				Write-Output " "
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				write-output "Executing 3-star arena"
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Do {
					Send-MouseDown -X $threestarLocationX -Y $threestarLocationY
					Send-MouseUp
					1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					$TestArenaPage = Test-ArenaPage
				}
				Until ($TestArenaPage -eq $false)
			}
			"4Star" {
				Clean-Memory
				#click 4-Star Arena
				Write-Output " "
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				write-output "Executing 4-star arena"
				Do {
					Send-MouseDown -X $fourstarLocationX -Y $fourstarLocationY
					Send-MouseUp
					1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					$TestArenaPage = Test-ArenaPage
				}
				Until ($TestArenaPage -eq $false)
			}
			"4StarCat" {
				Clean-Memory
				# Right align screen
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				$dragright = $ColorLocationTable.rightfightboxlocation[0]
				$dragleft = $ColorLocationTable.leftfightboxLocation[0]
				$dragy = $ColorLocationTable.leftfightboxLocation[1]
				do {
					Send-MouseDown -X $dragright -Y $dragy
					Invoke-MoveCursorToLocation -X $dragleft -Y $dragy -NumberOfMoves 20 -WaitBetweenMoves 20
					Send-MouseUp
					Send-MouseDown -X $dragright -Y $dragy
					Invoke-MoveCursorToLocation -X $dragleft -Y $dragy -NumberOfMoves 20 -WaitBetweenMoves 20
					Send-MouseUp
					1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					#click Tier4 Cat Arena
					$X = $Global:SpecialArenaLocation[0]
					$Y = $Global:SpecialArenaLocation[1]
					Write-Output " "
					1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					write-output "Executing Tier 4 Cat arena"
					Send-MouseDown -X $X -Y $Y
					Send-MouseUp
					1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					$TestArenaPage = Test-ArenaPage
				}
				Until ($TestArenaPage -eq $false)
			}
		}
	}
	function Pick-3 {
		#Wait for Find Match Button
		#region cooldown and help
		do {
			do {
				#Request Help
				$Color1 = "57827"
				$CooldownColors = @("5741f", "57a29", "5731f", "57a2a", "57d2e", "57a29", "57d2e", "5731c", "5741e", "5731e", "57a28", "57c2c", "57b2b", "57e2f", "5721c", "5721c", "57c2b", "57b2c")
				do {
					$Slot4colors = @()
					$Slot3colors = @()
					$slot2colors = @()
					$Slot1colors = @()
					#Slot 4
					$X4 = $Global:help4LocationX
					$Y4 = $Global:help4LocationY
					$Slot4Colors += Get-20HorizontalPixelColor -x $x4 -y $y4
					$Slot4Colors += Get-20verticalPixelColor -x $x4 -y $y4
					
					#Slot 3
					$X3 = $Global:help3LocationX
					$Y3 = $Global:help3LocationY
					$Slot3Colors += Get-20HorizontalPixelColor -x $x3 -y $y3
					$Slot3Colors += Get-20verticalPixelColor -x $x3 -y $y3
					#Slot 2
					$X2 = $Global:help2LocationX
					$Y2 = $Global:help2LocationY
					$Slot2Colors += Get-20HorizontalPixelColor -x $x2 -y $y2
					$Slot2Colors += Get-20verticalPixelColor -x $x2 -y $y2
					#Slot 1
					$X1 = $Global:help1LocationX
					$Y1 = $Global:help1LocationY
					$Slot1Colors += Get-20HorizontalPixelColor -x $x1 -y $y1
					$Slot1Colors += Get-20verticalPixelColor -x $x1 -y $y1
					$ClickSlot4 = $false
					$ClickSlot3 = $false
					$ClickSlot2 = $false
					$ClickSlot1 = $false
					foreach ($Color in $CooldownColors) {
						if ($ClickSlot4 -eq $false) {
							if ($Slot4Colors -contains $Color) {
								$clickslot4 = $true
							}
						}
						if ($ClickSlot3 -eq $false) {
							if ($Slot3Colors -contains $Color) {
								$clickslot3 = $true
							}
						}
						if ($ClickSlot2 -eq $false) {
							if ($Slot2Colors -contains $Color) {
								$clickslot2 = $true
							}
						}
						if ($ClickSlot1 -eq $false) {
							if ($Slot1Colors -contains $Color) {
								$clickslot1 = $true
							}
						}
						
					}
					
					#region Click cooldown slots
					If ($ClickSlot4 -eq $true) {
						Send-MouseDown -X $X4 -Y $Y4
						Send-MouseUp
						Start-Sleep -Milliseconds 200
					}
					If ($ClickSlot3 -eq $true) {
						Send-MouseDown -X $X3 -Y $Y3
						Send-MouseUp
						Start-Sleep -Milliseconds 200
					}
					If ($ClickSlot2 -eq $true) {
						Send-MouseDown -X $X2 -Y $Y2
						Send-MouseUp
						Start-Sleep -Milliseconds 200
					}
					If ($ClickSlot1 -eq $true) {
						Send-MouseDown -X $X1 -Y $Y1
						Send-MouseUp
						Start-Sleep -Milliseconds 200
					}
					#endregion
					1..5 | foreach { Start-Sleep -Milliseconds 200 }
					$colorcheck = Get-4x4PixelColor -x $x1 -y $y1
				}
				while ($colorcheck -contains $Color1)
				
				#Character CoolDown
				$Color = "212aaf"
				$X = $Global:help1LocationX
				$Y = $Global:help1LocationY
				if ((Get-4x4PixelColor -x $x -y $y) -contains $Color) {
					$ArenaEnded = $True
					write-output "Arena ended."
				}
				else {
					#Load Slot one time
					if ($arenatype -eq "1v1") {
						Load-Slot1
						1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					}
					else {
						Load-Slot3
						1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					}
					#Character in cooldown popup needs help
					if ((((Get-PixelColor -x 674 -y 376) -eq "14196d") -and ((Get-PixelColor -x 818 -y 570) -eq "222a2b")) -or (((Get-PixelColor -x 674 -y 376) -eq "14196c") -and ((Get-PixelColor -x 818 -y 570) -eq "232727"))) {
						$X = 823
						$Y = 515
						Send-MouseDown -X $X -Y $Y
						Send-MouseUp
						1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					}
					#Character in cooldown popup help already requested
					if ((((Get-PixelColor -x 674 -y 376) -eq "191716") -and ((Get-PixelColor -x 818 -y 570) -ne "ffffff")) -or (((Get-PixelColor -x 674 -y 376) -eq "a") -and ((Get-PixelColor -x 818 -y 570) -ne "a"))) {
						select-window "HD-Frontend" | send-keys -key "{ESC}"
						1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					}
				}
				$findmatchmenu = $false
				Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
				$DetectFindmatchColors = Get-4x4PixelColor -x $FindmatchLocationX -Y $FindmatchLocationY
				foreach ($color in $DetectFindmatchColors) {
					if ($findmatchcolors -contains $Color) {
						$findmatchmenu = $true
					}
				}
			}
			until (($findmatchmenu -eq $true) -or ($ArenaEnded -eq $True))
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until (($findmatchmenu -eq $true) -or ($ArenaEnded -eq $True))
	}
	function Select-TopOpponent {
		#Find Match Button
		$findmatchmenu = $false
		Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
		$DetectFindmatchColors = Get-4x4PixelColor -x $FindmatchLocationX -Y $FindmatchLocationY
		foreach ($color in $DetectFindmatchColors) {
			if ($findmatchcolors -contains $Color) {
				$findmatchmenu = $true
			}
		}
		until ($findmatchmenu -eq $true)
		Do {
			Send-MouseDown -x $FindmatchLocationX -Y $FindmatchLocationY
			Send-MouseUp
			$findmatchmenu = $false
			1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			$DetectFindmatchColors = Get-4x4PixelColor -x $FindmatchLocationX -Y $FindmatchLocationY
			foreach ($color in $DetectFindmatchColors) {
				if ($findmatchcolors -contains $Color) {
					$findmatchmenu = $true
				}
			}
		}
		until ($findmatchmenu -eq $false)
		
		#Find Match Continue Button
		
		$findmatchacceptmenu = $false
		Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
		$DetectAcceptmatchColors = Get-4x4PixelColor -x $acceptmatchLocationX -Y $acceptmatchLocationY
		foreach ($color in $DetectAcceptmatchColors) {
			if ($acceptmatchcolors -contains $Color) {
				$findmatchacceptmenu = $true
			}
		}
		until ($findmatchacceptmenu -eq $true)
		Send-MouseDown -x $acceptmatchLocationX -Y $acceptmatchLocationY
		Send-MouseUp
		1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
	}
	function Get-EnemySlot1 {
		$Colors = @()
		$Data = @()
		$Colors += Get-20verticalPixelColor -X $Global:Enemy1LocationX -Y $Global:Enemy1LocationY
		$Colors += Get-20HorizontalPixelColor -X $Global:Enemy1LocationX -Y $Global:Enemy1LocationY
		foreach ($Color in $Colors) {
			if ($EnemySlot1 -eq $null) {
				if ($CosmicColors -like "*$Color*") {
					$EnemySlot1 = "Cosmic"
				}
				elseif ($MysticColors -like "*$Color*") {
					$EnemySlot1 = "Mystic"
				}
				elseif ($TechColors -like "*$Color*") {
					$EnemySlot1 = "Tech"
				}
				elseif ($SkillColors -like "*$Color*") {
					$EnemySlot1 = "Skill"
				}
				elseif ($ScienceColors -like "*$Color*") {
					$EnemySlot1 = "Science"
				}
				elseif ($MutantColors -like "*$Color*") {
					$EnemySlot1 = "Mutant"
				}
				else {
					$EnemySlot1 = $null
				}
			}
		}
		if ($EnemySlot1 -eq $null) {
			$EnemySlot1 = "Unknown"
		}
		Return $EnemySlot1
	}
	function Get-EnemySlot2 {
		$Colors = @()
		$Data = @()
		$Colors += Get-20verticalPixelColor -X $Global:Enemy2LocationX -Y $Global:Enemy2LocationY
		$Colors += Get-20HorizontalPixelColor -X $Global:Enemy2LocationX -Y $Global:Enemy2LocationY
		foreach ($Color in $Colors) {
			if ($EnemySlot2 -eq $null) {
				if ($CosmicColors -like "*$Color*") {
					$EnemySlot2 = "Cosmic"
				}
				elseif ($MysticColors -like "*$Color*") {
					$EnemySlot2 = "Mystic"
				}
				elseif ($TechColors -like "*$Color*") {
					$EnemySlot2 = "Tech"
				}
				elseif ($SkillColors -like "*$Color*") {
					$EnemySlot2 = "Skill"
				}
				elseif ($ScienceColors -like "*$Color*") {
					$EnemySlot2 = "Science"
				}
				elseif ($MutantColors -like "*$Color*") {
					$EnemySlot2 = "Mutant"
				}
				else {
					$EnemySlot2 = $null
				}
			}
		}
		if ($EnemySlot2 -eq $null) {
			$EnemySlot2 = "Unknown"
		}
		Return $EnemySlot2
	}
	function Get-EnemySlot3 {
		$Colors = @()
		$Data = @()
		$Colors += Get-20verticalPixelColor -X $Global:Enemy3LocationX -Y $Global:Enemy3LocationY
		$Colors += Get-20HorizontalPixelColor -X $Global:Enemy3LocationX -Y $Global:Enemy3LocationY
		foreach ($Color in $Colors) {
			if ($EnemySlot3 -eq $null) {
				if ($CosmicColors -like "*$Color*") {
					$EnemySlot3 = "Cosmic"
				}
				elseif ($MysticColors -like "*$Color*") {
					$EnemySlot3 = "Mystic"
				}
				elseif ($TechColors -like "*$Color*") {
					$EnemySlot3 = "Tech"
				}
				elseif ($SkillColors -like "*$Color*") {
					$EnemySlot3 = "Skill"
				}
				elseif ($ScienceColors -like "*$Color*") {
					$EnemySlot3 = "Science"
				}
				elseif ($MutantColors -like "*$Color*") {
					$EnemySlot3 = "Mutant"
				}
				else {
					$EnemySlot3 = $null
				}
			}
		}
		if ($EnemySlot3 -eq $null) {
			$EnemySlot3 = "Unknown"
		}
		Return $EnemySlot3
	}
	function Get-PlayerSlot1 {
		$Colors = @()
		$Data = @()
		$Colors += Get-20verticalPixelColor -X $Global:Player1LocationX -Y $Global:Player1LocationY
		$Colors += Get-20HorizontalPixelColor -X $Global:Player1LocationX -Y $Global:Player1LocationY
		foreach ($Color in $Colors) {
			if ($PlayerSlot1 -eq $null) {
				if ($CosmicColors -like "*$Color*") {
					$PlayerSlot1 = "Cosmic"
				}
				elseif ($MysticColors -like "*$Color*") {
					$PlayerSlot1 = "Mystic"
				}
				elseif ($TechColors -like "*$Color*") {
					$PlayerSlot1 = "Tech"
				}
				elseif ($SkillColors -like "*$Color*") {
					$PlayerSlot1 = "Skill"
				}
				elseif ($ScienceColors -like "*$Color*") {
					$PlayerSlot1 = "Science"
				}
				elseif ($MutantColors -like "*$Color*") {
					$PlayerSlot1 = "Mutant"
				}
				else {
					$PlayerSlot1 = $null
				}
			}
		}
		if ($PlayerSlot1 -eq $null) {
			$PlayerSlot1 = "Unknown"
		}
		Return $PlayerSlot1
	}
	function Get-PlayerSlot2 {
		$Colors = @()
		$Data = @()
		$Colors += Get-20verticalPixelColor -X $Global:Player2LocationX -Y $Global:Player2LocationY
		$Colors += Get-20HorizontalPixelColor -X $Global:Player2LocationX -Y $Global:Player2LocationY
		foreach ($Color in $Colors) {
			if ($PlayerSlot2 -eq $null) {
				if ($CosmicColors -like "*$Color*") {
					$PlayerSlot2 = "Cosmic"
				}
				elseif ($MysticColors -like "*$Color*") {
					$PlayerSlot2 = "Mystic"
				}
				elseif ($TechColors -like "*$Color*") {
					$PlayerSlot2 = "Tech"
				}
				elseif ($SkillColors -like "*$Color*") {
					$PlayerSlot2 = "Skill"
				}
				elseif ($ScienceColors -like "*$Color*") {
					$PlayerSlot2 = "Science"
				}
				elseif ($MutantColors -like "*$Color*") {
					$PlayerSlot2 = "Mutant"
				}
				else {
					$PlayerSlot2 = $null
				}
			}
		}
		if ($PlayerSlot2 -eq $null) {
			$PlayerSlot2 = "Unknown"
		}
		Return $PlayerSlot2
	}
	function Get-PlayerSlot3 {
		$Colors = @()
		$Data = @()
		$Colors += Get-20verticalPixelColor -X $Global:Player3LocationX -Y $Global:Player3LocationY
		$Colors += Get-20HorizontalPixelColor -X $Global:Player3LocationX -Y $Global:Player3LocationY
		foreach ($Color in $Colors) {
			if ($PlayerSlot3 -eq $null) {
				if ($CosmicColors -like "*$Color*") {
					$PlayerSlot3 = "Cosmic"
				}
				elseif ($MysticColors -like "*$Color*") {
					$PlayerSlot3 = "Mystic"
				}
				elseif ($TechColors -like "*$Color*") {
					$PlayerSlot3 = "Tech"
				}
				elseif ($SkillColors -like "*$Color*") {
					$PlayerSlot3 = "Skill"
				}
				elseif ($ScienceColors -like "*$Color*") {
					$PlayerSlot3 = "Science"
				}
				elseif ($MutantColors -like "*$Color*") {
					$PlayerSlot3 = "Mutant"
				}
				else {
					$PlayerSlot3 = $null
				}
			}
		}
		if ($PlayerSlot3 -eq $null) {
			$PlayerSlot3 = "Unknown"
		}
		Return $PlayerSlot3
	}
	function Accept-Opponent {
		#Set Lineup Accept Button
		$findacceptmenu = $false
		Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
		$DetectAcceptColors = Get-4x4PixelColor -x $acceptsortLocationX -Y $acceptsortLocationY
		foreach ($color in $DetectAcceptColors) {
			if ($acceptsortcolors -contains $Color) {
				$findacceptmenu = $true
			}
		}
		until ($findacceptmenu -eq $true)
		Do {
			Send-MouseDown -x $acceptsortLocationX -Y $acceptsortLocationY
			Send-MouseUp
			1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			$DetectAcceptColors = Get-4x4PixelColor -x $acceptsortLocationX -Y $acceptsortLocationY
			$findacceptmenu = $false
			foreach ($color in $DetectAcceptColors) {
				if ($acceptsortcolors -contains $Color) {
					$findacceptmenu = $true
				}
			}
		}
		until ($findacceptmenu -eq $false)
		# Start bottom right continue button job
		Start-Job -Name "BottomRightContinueButton" -ScriptBlock $BottomRightContinueButton | Out-Null
		Do {
			Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
		}
		Until ((Get-Job -Name "BottomRightContinueButton").state -eq "Running")
	}
	function All-Done2 {
		Write-Output "Waiting for progress..."
		do {
			$checkscores = Receive-Job -Name "BottomRightContinueButton"
			$FightActive = Receive-Job -Name "FightSequence"
			if ($checkscores -eq "Take-ScreenShots") {
				Write-Output "Take-ScreenShots"
			}
			if ($FightActive -eq "FightDetected") {
				Write-Output "FightDetected"
				$startfighttime = get-date
			}
			if ($FightActive -eq "FightEnded") {
				$endfighttime = Get-Date
				[int]$totalfighttime = ($endfighttime - $startfighttime).seconds
				Write-Output "Duration:$totalfighttime"
			}
			If ($FightActive -like "*:*") {
				1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Write-Output $FightActive
			}
			#Monitor for Victory/Defeat
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			if ((($Victory1Colors -contains (Get-PixelColor -x $Victory1LocationX -y $victory1locationY)) -and ($Victory2Colors -contains (Get-PixelColor -x $Victory2LocationX -y $victory2locationY))) -or (($Defeat1Colors -contains (Get-PixelColor -x $Defeat1LocationX -y $Defeat1LocationY)) -and ($Defeat2Colors -contains (Get-PixelColor -x $Defeat2LocationX -y $Defeat2LocationY)))) {
				if ($CollaspedMenuColors -notcontains (Get-PixelColor -X $CollaspedMenuLocationX -Y $CollaspedMenuLocationY)) {
					Send-MouseDown -X 300 -Y 300
					Send-MouseUp
				}
			}
			$TestArenaPage = $false
			$arenaanchor = Get-4x4PixelColor -x $global:arenaanchorLocation[0] -y $Global:arenaanchorLocation[1]
			foreach ($color in $arenaanchor) {
				if ($global:arenaanchorcolors -contains $Color) {
					$TestArenaPage = $true
				}
			}
		}
		until ($TestArenaPage -eq $true)
		
		# Stop Bottom right continue button
		Stop-Job -Name "BottomRightContinueButton"
		Remove-Job -Name "BottomRightContinueButton" -Force
		Clean-Memory
	}
	function Get-20verticalPixelColor {
		Param (
			[Int]$X,
			[Int]$Y
		)
		$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
		$PixelLine = @()
		1..20 | foreach {
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			$Y = $Y + 1
			$PixelLine += $ColorofPixel
		}
		Return $PixelLine
	}
	function Get-20HorizontalPixelColor {
		Param (
			[Int]$X,
			[Int]$Y
		)
		$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
		$PixelLine = @()
		$X = $X - 10
		1..20 | foreach {
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			$X = $X + 1
			$PixelLine += $ColorofPixel
		}
		$PixelLine = $PixelLine | Get-Unique
		Return $PixelLine
	}
	function Check-Continue {
		If ($continuecolors -contains (Get-PixelColor -x $x -y $y)) {
			Return $true
		}
		else {
			Return $false
		}
	}
	function check-accept {
		$findaccept = $false
		$DetectAcceptColors = Get-4x4PixelColor -x $acceptsortLocationX -Y $acceptsortLocationY
		foreach ($color in $DetectAcceptColors) {
			if ($acceptsortcolors -contains $Color) {
				$findaccept = $true
			}
		}
		return $findaccept
	}
	#endregion
	#endregion
	#region variables
	$CosmicColors = "c69a00 , 9e7c07 , 24241e , a07e07 , c39801 , 2d2b1d , 997909 , 8c700c , bf9501 , b99002 , 514516 , 9d7c07 , c59900 , c69a00 , 846a0c , 39331a , c39801 , c39800 , 332e1b , 90720a , 8a6f0d , c09601 , 635212 , 36311b , 977809 , a17f07 , c69a00 , c09601 , 39331a , 83690c , 78610e , 3b341a , c19601 , bd9302 , 2e2b1c , 544715 , 3a341a , b58e03 , c69a00 , 625112 , 39331a , c29701 , b18b04 , 29281d , aa8505 , c09601 , 3a3623 , 846a0c , 35301b , b38c03 , 896e0b , 2e2b1c , b58d03 , 463d17 , 715c10 , c59900 , 49401e , 8e710a , 937509"
	$MutantColors = "1e88aa , 1bc1f8 , 1d96bc , 232825 , 205867 , 1d9ac2 , 223537 , 1bbff5 , 1d99c1 , 24241f , 262621 , 223d41 , 1cb1e2 , 1bc0f7 , 1f6b81 , 1f748d , 1bbff6 , 21464e , 206478 , 1bbef4 , 1bc1f8 , 1caede , 223131 , 232521 , 1bb9ed , 1cb4e6 , 223132 , 1bbaee , 1bb7eb , 242622 , 24241f , 252520 , 206174 , 1bbbf0 , 223638 , 1bbdf2 , 1f7893 , 1bb9ed , 1bc1f8 , 214e5a , 1d9fc9 , 1bbdf3 , 222d2c , 1da2cd , 215362 , 24241f , 232521 , 1e81a0 , 205665 , 214c57 , 1bc0f7 , 1d98c0 , 1bc1f8 , 1e87a7 , 214d58 , 1e85a6 , 223436 , 1f82a1 , 1e7d9a , 21515e , 1bbef4 , 1bbdf2 , 205766 , 232521 , 1d95bb , 1d9bc4 , 232825"
	$MysticColors = "c622bc , c522bb , 61235a , 5e2357 , 53294e , 4a2344 , 40233a , 4a2343 , 6c2365 , c622bc , c422ba , 382332 , c022b6 , 692361 , 151413 , 7b2274 , 282323 , 3d2337 , b322a9 , 2f232a , 262321 , 62235b , 9d2294 , 30232b , 2a2325 , 84227c , c622bc , b122a8 , 382333 , c522bb , 60285a , bf22b5 , 5e2357 , 272322 , 7f2277 , c422ba , 34232f , 292323 , 252320 , 2c2327 , 2e2329 , c122b7 , c622bc , 682361 , 892281 , b323aa , 282323 , bf22b6 , 5a2353 , 292324 , a3229a"
	$ScienceColors = "1a8544 , 1b793f , 1a8845 , 189f4e , 17aa52 , 1f7540 , 1e5933 , 18a34f , 223123 , 17a851 , 213c28 , 18a34f , 198f48 , 1b7c40 , 1b7d41 , 19944a , 17a851 , 17aa52 , 262a23 , 1f4f2f , 17a751 , 20442b , 213525 , 19954a , 1b8042 , 1b7b40 , 198e47 , 17a550 , 17aa52 , 255234 , 23251f , 198f48 , 1a8343 , 23241e , 1a8744 , 1e5732 , 17a952 , 17aa52 , 17a751 , 1b7b40 , 213826 , 18a450 , 1c773e , 17a851"
	$TechColors = "2d261d , cd5606 , d85904 , b95008 , bc5108 , ad4c0a , 563318 , 1a1a17 , 100f0d , c0b0b , 1f1f1e , 2a2c32 , 472e19 , d65804 , b44e09 , 412c1a , 5a3316 , c25307 , ca5506 , d85904 , 563217 , 643615 , 623615 , 36291b , 934611 , 1f1f1d , 171715 , af4d0a , 2f261c , a54a0b , d65804 , 763c12 , 7a3d12 , 773c12 , b95008 , ce5605 , d85904 , 9b470d , 3a2a1b , 94450e , b34e0a , bd5109 , 97460d , 34281c , ce5605 , 442d19 , d35805 , d85904 , d55804 , 392a1b , 91440e , 2e261c , 653715 , 623615 , d45805 , 2f271c , 30271c , b24e09 , c45307 , 9c470d , ce5605 , 96450e , bc5108 , 26241e , bf5208 , d45805 , 472e19 , 483321 , a94b0b , 864110 , 753c12 , 28241d , 4c2f18"
	$SkillColors = "1d1d65 , 1616b5 , 1212eb , 24245c , 1b1b80 , 1313d9 , 222229 , 212139 , 1f1f4a , 22222a , 1313dc , 1616c0 , 1c1c70 , 1414d9 , 1f1f51 , 232323 , 1c1c6d , 1212eb , 1e1e8b , 1e1e5e , 1212e9 , 1717b3 , 1313df , 1414d1 , 1f1f4b , 1f1f52 , 1414ce , 1a1a85 , 1818a3 , 1313de , 1f1f51 , 1313e3 , 1212eb , 1313df , 252526 , 191995 , 1818a8 , 1c1c73 , 212136 , 21213a , 1212e7 , 1d1d61 , 1212e5 , 1b1b84 , 23231f"
	[int]$averagefighttime = 0
	[int]$totalfighttime = 0
	[datetime]$startfighttime = $null
	[DateTime]$endfighttime = $null
	[int]$fightcount = 0
	[String]$LastMove = $null
	#endregion
	#region Import Locations and Colors
	$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
	$bluestackstop = $ColorLocationTable.bluestackstop
	$bluestacksleft = $ColorLocationTable.bluestacksleft
	$CollaspedMenuColors = $ColorLocationTable.CollaspedMenuColors
	$ExpandedMenuColors = $ColorLocationTable.ExpandedMenuColors
	$FightColors = $ColorLocationTable.FightColors
	$VersusColors = $ColorLocationTable.VersusColors
	$VersusColors2 = $ColorLocationTable.VersusColors2
	$threestarcolors = $ColorLocationTable.threestarcolors
	$fourstarcolors = $ColorLocationTable.fourstarcolors
	$findmatchcolors = $ColorLocationTable.findmatchcolors
	$acceptmatchcolors = $ColorLocationTable.acceptmatchcolors
	$acceptsortcolors = $ColorLocationTable.acceptsortcolors
	$continuecolors = $ColorLocationTable.continuecolors
	$pausecolors = $ColorLocationTable.pausecolors
	$GoHomeColors1 = $ColorLocationTable.GoHomeColors
	$GoHomeColors2 = $ColorLocationTable.GoHomeColors2
	$CollaspedMenuLocationX = $ColorLocationTable.CollaspedMenuLocation[0]
	$ExpandedMenuLocationX = $ColorLocationTable.ExpandedMenuLocation[0]
	$menufightLocationX = $ColorLocationTable.FightLocation[0]
	$VersusLocationX = $ColorLocationTable.VersusLocation[0]
	$VersusLocationX2 = $ColorLocationTable.VersusLocation2[0]
	$threestarLocationX = $ColorLocationTable.threestarLocation[0]
	$fourstarLocationX = $ColorLocationTable.fourstarLocation[0]
	$Global:SpecialArenaLocation = $ColorLocationTable.SpecialArenaLocation
	$FindmatchLocationX = $ColorLocationTable.findmatchLocation[0]
	$acceptmatchLocationX = $ColorLocationTable.acceptmatchLocation[0]
	$acceptsortLocationX = $ColorLocationTable.acceptsortLocation[0]
	$continueLocationX = $ColorLocationTable.continueLocation[0]
	$PauseLocationX = $ColorLocationTable.pauseLocation[0]
	$GoHomeLocationX1 = $ColorLocationTable.GoHomeLocation[0]
	$GoHomeLocationX2 = $ColorLocationTable.GoHomeLocation2[0]
	$CollaspedMenuLocationY = $ColorLocationTable.CollaspedMenuLocation[1]
	$ExpandedMenuLocationY = $ColorLocationTable.ExpandedMenuLocation[1]
	$menufightLocationY = $ColorLocationTable.FightLocation[1]
	$VersusLocationY = $ColorLocationTable.VersusLocation[1]
	$VersusLocationY2 = $ColorLocationTable.VersusLocation2[1]
	$threestarLocationY = $ColorLocationTable.threestarLocation[1]
	$fourstarLocationY = $ColorLocationTable.fourstarLocation[1]
	$FindmatchLocationY = $ColorLocationTable.findmatchLocation[1]
	$acceptmatchLocationY = $ColorLocationTable.acceptmatchLocation[1]
	$acceptsortLocationY = $ColorLocationTable.acceptsortLocation[1]
	$continueLocationY = $ColorLocationTable.continueLocation[1]
	$PauseLocationY = $ColorLocationTable.pauseLocation[1]
	$GoHomeLocationY1 = $ColorLocationTable.GoHomeLocation[1]
	$GoHomeLocationY2 = $ColorLocationTable.GoHomeLocation2[1]
	$Global:Player1LocationX = $ColorLocationTable.Player1Location[0]
	$Global:Player2LocationX = $ColorLocationTable.Player2Location[0]
	$Global:Player3LocationX = $ColorLocationTable.Player3Location[0]
	$Global:Enemy1LocationX = $ColorLocationTable.Enemy1Location[0]
	$Global:Enemy2LocationX = $ColorLocationTable.Enemy2Location[0]
	$Global:Enemy3LocationX = $ColorLocationTable.Enemy3Location[0]
	$Global:Player1LocationY = $ColorLocationTable.Player1Location[1]
	$Global:Player2LocationY = $ColorLocationTable.Player2Location[1]
	$Global:Player3LocationY = $ColorLocationTable.Player3Location[1]
	$Global:Enemy1LocationY = $ColorLocationTable.Enemy1Location[1]
	$Global:Enemy2LocationY = $ColorLocationTable.Enemy2Location[1]
	$Global:Enemy3LocationY = $ColorLocationTable.Enemy3Location[1]
	$Global:help1LocationX = $ColorLocationTable.help1Location[0]
	$Global:help1LocationY = $ColorLocationTable.help1Location[1]
	$Global:help1colors = $ColorLocationTable.help1colors
	$Global:help2LocationX = $ColorLocationTable.help2Location[0]
	$Global:help2LocationY = $ColorLocationTable.help2Location[1]
	$Global:help2colors = $ColorLocationTable.help2colors
	$Global:help3LocationX = $ColorLocationTable.help3Location[0]
	$Global:help3LocationY = $ColorLocationTable.help3Location[1]
	$Global:help3colors = $ColorLocationTable.help3colors
	$Global:help4LocationX = $ColorLocationTable.help4Location[0]
	$Global:help4LocationY = $ColorLocationTable.help4Location[1]
	$Global:help4colors = $ColorLocationTable.help4colors
	$Global:SelectChampionLocationX = $ColorLocationTable.SelectChampionLocation[0]
	$Global:SelectChampionLocationY = $ColorLocationTable.SelectChampionLocation[1]
	$Global:Slot1LocationX = $ColorLocationTable.Slot1Location[0]
	$Global:Slot2LocationX = $ColorLocationTable.Slot2Location[0]
	$Global:Slot3LocationX = $ColorLocationTable.Slot3Location[0]
	$Global:Slot1LocationY = $ColorLocationTable.Slot1Location[1]
	$Global:Slot2LocationY = $ColorLocationTable.Slot2Location[1]
	$Global:Slot3LocationY = $ColorLocationTable.Slot3Location[1]
	$Global:Victory1Location = $ColorLocationTable.Victory1Location
	$Global:Victory1Colors = $ColorLocationTable.Victory1Colors
	$Global:Victory2Location = $ColorLocationTable.Victory2Location
	$Global:Victory2Colors = $ColorLocationTable.Victory2Colors
	$Global:Defeat1Location = $ColorLocationTable.Defeat1Location
	$Global:Defeat1Colors = $ColorLocationTable.Defeat1Colors
	$Global:Defeat2Location = $ColorLocationTable.Defeat2Location
	$Global:Defeat2Colors = $ColorLocationTable.Defeat2Colors
	$Global:arenaanchorLocation = $ColorLocationTable.arenaanchorLocation
	$Global:arenaanchorcolors = $ColorLocationTable.arenaanchorcolors
	#endregion
	#region Scriptblocks
	$BottomRightContinueButton = {
		#region assemblies
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region Functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			
			Return $ColorofPixel
		}
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			#region mouse click
			$signature = @' 
     [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
     public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 50
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				$SleepCount = [math]::ceiling($Sleep / 200)
				1..$SleepCount | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
     [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
     public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				$SleepCount = [math]::ceiling($Sleep / 200)
				1..$SleepCount | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$continuecolors = $ColorLocationTable.continuecolors
		$continueLocationX = $ColorLocationTable.continueLocation[0]
		$continueLocationY = $ColorLocationTable.continueLocation[1]
		#endregion
		do {
			$X = $continueLocationX
			$Y = $continueLocationY
			DO { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
			until ($continuecolors -contains (Get-PixelColor -x $x -y $y))
			Do {
				Write-Output "Continue"
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Write-Output "Take-ScreenShots"
				1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Send-MouseDown -X $X -Y $Y
				Send-MouseUp
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until ($continuecolors -notcontains (Get-PixelColor -x $x -y $y))
		}
		until ($true -eq $false)
	}
	$AfterFight = {
		#region assemblies
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		function Get-4x4PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			#region create pixel block
			$X = $x - 2
			$Y = $Y - 2
			1..4 | foreach {
				1..4 | foreach {
					$ColorofPixel += (, ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name)
					$Y++
				}
				$X++
				$Y = $Y - 4
			}
			#endregion
			# Find unique
			$ColorofPixel = $ColorofPixel | Get-Unique
			Return $ColorofPixel
		}
		function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$Victory1LocationX = $ColorLocationTable.Victory1Location[0]
		$Victory1LocationY = $ColorLocationTable.Victory1Location[1]
		$Victory1Colors = $ColorLocationTable.Victory1Colors
		$Victory2LocationX = $ColorLocationTable.Victory2Location[0]
		$Victory2LocationY = $ColorLocationTable.Victory2Location[1]
		$Victory2Colors = $ColorLocationTable.Victory2Colors
		$Defeat1LocationX = $ColorLocationTable.Defeat1Location[0]
		$Defeat1LocationY = $ColorLocationTable.Defeat1Location[1]
		$Defeat1Colors = $ColorLocationTable.Defeat1Colors
		$Defeat2LocationX = $ColorLocationTable.Defeat2Location[0]
		$Defeat2LocationY = $ColorLocationTable.Defeat2Location[1]
		$Defeat2Colors = $ColorLocationTable.Defeat2Colors
		$continuecolors = $ColorLocationTable.continuecolors
		$continueLocationX = $ColorLocationTable.continueLocation[0]
		$continueLocationY = $ColorLocationTable.continueLocation[1]
		$CollaspedMenuColors = $ColorLocationTable.CollaspedMenuColors
		$CollaspedMenuLocationX = $ColorLocationTable.CollaspedMenuLocation[0]
		$CollaspedMenuLocationY = $ColorLocationTable.CollaspedMenuLocation[1]
		#endregion
		Do {
			DO {
				1..5 | foreach {
					Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
				}
			}
			until ((($Victory1Colors -contains (Get-PixelColor -x $Victory1LocationX -y $victory1locationY)) -and ($Victory2Colors -contains (Get-PixelColor -x $Victory2LocationX -y $victory2locationY))) -or (($Defeat1Colors -contains (Get-PixelColor -x $Defeat1LocationX -y $Defeat1LocationY)) -and ($Defeat2Colors -contains (Get-PixelColor -x $Defeat2LocationX -y $Defeat2LocationY))))
			if ($CollaspedMenuColors -notcontains (Get-PixelColor -X $CollaspedMenuLocationX -Y $CollaspedMenuLocationY)) {
				Send-MouseDown -X 300 -Y 300
				Send-MouseUp
			}
		}
		until ($true -eq $false)
	}
	$AggressiveFight = {
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			Do {
				Quick-Attack
				light-attack
				light-attack
				Quick-Attack
				Heavy-Attack
				light-attack
				Medium-attack
				light-attack
				light-attack
				Quick-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$NormalFight = {
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			Do {
				Quick-Attack
				light-attack
				light-attack
				light-attack
				light-Attack
				Avoid-Attack
				FastAvoid-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$EvasiveFight = {
		#region assemblies
		Import-Module WASP
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Do {
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			#Sleep waiting for a fight to start
			Do {

				Block-Attack
				Avoid-Attack
				Quick-Attack
				light-attack
				light-attack
				light-attack
				light-attack
				Avoid-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$TessSequence = {
		Set-Location "C:\Program Files (x86)\Mothership\Tesseract"
		#Import System.Drawing and Tesseract libraries
		Add-Type -AssemblyName "System.Drawing"
		Add-Type -Path "C:\Program Files (x86)\Mothership\Tesseract\Lib\Tesseract.dll"
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#Create tesseract object, specify tessdata location and language
		$tesseract = New-Object Tesseract.TesseractEngine("C:\Program Files (x86)\Mothership\Tesseract\Lib\tessdata", "eng", [Tesseract.EngineMode]::Default, $null)
		$Tesseract.SetVariable("tessedit_char_whitelist", "0123456789")
		#region functions
		function Capture-CharacterPI {
			param (
				[int]$xstartleft,
				[int]$ystarttop,
				[int]$xendright,
				[int]$yendbottom
			)
			$bounds = [Drawing.Rectangle]::FromLTRB($xstartleft, $ystarttop, $xendright, $yendbottom)
			$imagecap = New-Object Drawing.Bitmap $bounds.width, $bounds.height
			$graphics = [Drawing.Graphics]::FromImage($imagecap)
			$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
			$filename = "C:\Tools\Tesseract\" + "$$ystarttop" + "$yendbottom" + "$xstartleft" + "$yendbottom" + ".bmp"
			$imagecap.save($filename)
			Return $imagecap
		}
		function Hero-PI {
			$xstartleft = $PlayerPILeftLocationX
			$ystarttop = $PlayerPILeftLocationY
			$xendright = $PlayerPIRightLocationX
			$yendbottom = $PlayerPIRightLocationY
			[Drawing.Bitmap]$PIbmp = Capture-CharacterPI -xstartleft $xstartleft -xendright $xendright -ystarttop $ystarttop -yendbottom $yendbottom
			$pipix = [Tesseract.PixConverter]::ToPix($PIbmp)
			$pipage = $tesseract.Process($pipix)
			[Int]$HeroPI = $pipage.GetText()
			if ($pipage.GetMeanConfidence -lt 0.7) {
				$HeroPI = "unknown"
			}
			$pipage.Dispose()
			return $HeroPI
		}
		function Enemy-PI {
			$xstartleft = $EnemyPILeftLocationX
			$ystarttop = $EnemyPILeftLocationY
			$xendright = $EnemyPIRightLocationX
			$yendbottom = $EnemyPIRightLocationY
			$PIbmp = Capture-CharacterPI -xstartleft $xstartleft -xendright $xendright -ystarttop $ystarttop -yendbottom $yendbottom
			$pipix = [Tesseract.PixConverter]::ToPix($PIbmp)
			$pipage = $tesseract.Process($pipix)
			[Int]$EnemyPI = $pipage.GetText()
			if ($pipage.GetMeanConfidence -lt 0.7) {
				$EnemyPI = "unknown"
			}
			$pipage.Dispose()
			return $EnemyPI
		}
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			#Compare hero and enemy pi, adjust fight sequence
			$HeroPI = Hero-PI
			$EnemyPI = Enemy-PI
			if (($HeroPI -ne "unknown") -and ($EnemyPI -ne "unknown")) {
				if (($HeroPI * 0.75) -gt $EnemyPI) {
					$fightbehavior = "Aggressive"
				}
				elseif (($heroPI * 2) -le $EnemyPI) {
					$fightbehavior = "Evasive"
				}
				else {
					$fightbehavior = "Normal"
				}
			}
			else {
				$fightbehavior = "Normal"
			}
			$Writefightstyle = 0
			switch ($fightbehavior) {
				"Aggressive" {
					Do {
						Quick-Attack
						light-attack
						light-attack
						Quick-Attack
						Heavy-Attack
						light-attack
						Medium-attack
						light-attack
						light-attack
						Quick-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
				"Normal" {
					Do {
						Quick-Attack
						light-attack
						light-attack
						light-attack
						light-attack
						Avoid-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
				"Evasive" {
					Do {
						Block-Attack
						Quick-Attack
						light-attack
						light-attack
						light-attack
						light-attack
						Avoid-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
			}
			
		}
		Until ($true -eq $false)
	}
	$ActivateSpecials = {
		
		#region assemblies
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Import-Module WASP
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			$EnergyDrain = $false
			clear-host
			Do {
				$GreenCheck = if ($GreenSpecialColors -contains (Get-PixelColor -x $GreenSpecialLocationX -y $GreenSpecialLocationY)) { $True }
				$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
				$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
				If ($GreenCheck -eq $true) {
					write-host  "Wait for Yellow, if energy goes in reverse use any special"
					Do {
						$GreenCheck = if ($GreenSpecialColors -contains (Get-PixelColor -x $GreenSpecialLocationX -y $GreenSpecialLocationY)) { $True }
						$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
						if ($YellowCheck -eq $true) {
							do {
								write-host  "Wait for Red, if energy goes in reverse use any special"
								$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
								$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
								Start-Sleep -Milliseconds 200
								if ($RedCheck -eq $true) {
									write-host  "Use Special"
									do {
										Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
										Start-Sleep -Milliseconds 200
									}
									until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
								}
							}
							Until (($YellowCheck -eq $false) -or ($RedCheck -eq $true))
							if (($yellowcheck -eq $false) -and ($RedCheck -eq $false)) { $EnergyDrain = $true }
						}
						Start-Sleep -Milliseconds 1000
					}
					Until (($GreenCheck -eq $true) -or ($YellowCheck -eq $true))
					if (($yellowcheck -eq $false) -and ($greenCheck -eq $false)) { $EnergyDrain = $true }
				}
				elseif ($YellowCheck -eq $true) {
					do {
						write-host  "Wait for Red, if energy goes in reverse use any special"
						$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
						$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
						if ($RedCheck -eq $true) {
							write-host  "Use Special"
							do {
								Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
								Start-Sleep -Milliseconds 200
							}
							until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
						}
						Start-Sleep -Milliseconds 1000
					}
					Until (($YellowCheck -eq $true) -or ($RedCheck -eq $true))
					if (($yellowcheck -eq $false) -and ($RedCheck -eq $false)) { $EnergyDrain = $true }
				}
				elseif ($RedCheck -eq $true) {
					write-host  "Use Special"
					do {
						Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
						Start-Sleep -Milliseconds 200
					}
					until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
				}
				else {
					if ($EnergyDrain -eq $true) {
						do {
							if ($SpecialColors -notcontains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) {
								write-host  "Use Special"
								do {
									Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
									Start-Sleep -Milliseconds 200
								}
								until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
							}
						}
						until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					}
				}
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
		}
		until ($true -eq $false)
	}
	#endregion
	#region run
	# focus bluestacks window
	move-bluestackswindow -top $bluestackstop -left $bluestacksleft
	[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
	$Colors = Get-PixelColor -x $global:arenaanchorLocation[0] -y $Global:arenaanchorLocation[1]
	$TestArenaPage = $false
	foreach ($color in $colors) {
		if ($global:arenaanchorcolors -contains $Color) {
			$TestArenaPage = $true
		}
	}
	if ($TestArenaPage -eq $false) {
		Go-Home
		Menu-DropDown
		Menu-FightButton
		Versus-Button
		if ($Continous -eq $true) {
			do {
				move-bluestackswindow -top $bluestackstop -left $bluestacksleft
				Run-Arena -ArenaType $ArenaType
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				$X = $continueLocationX
				$Y = $continueLocationY
				IF (Check-Continue -eq $true) {
					Write-Output "Recovering from deadman."
					Start-Job -Name "BottomRightContinueButton" -ScriptBlock $BottomRightContinueButton | Out-Null
					Start-Jobs
					All-Done2
					Stop-Jobs
				}
				elseif (check-accept -eq $true) {
					Write-Output "Recovering from deadman."
					Rig-Fights2
					Accept-Opponent
					Send-MouseUp
					Start-Jobs
					All-Done2
					Stop-Jobs
				}
				else {
					Pick-3
					if ($ArenaEnded -ne $true) {
						Select-TopOpponent
						Rig-Fights2
						Accept-Opponent
						Start-Jobs
						All-Done2
						Stop-Jobs
					}
				}
			}
			until (($true -eq $False) -or ($ArenaEnded -eq $true))
			
		}
		else {
			move-bluestackswindow -top $bluestackstop -left $bluestacksleft
			Run-Arena -ArenaType $ArenaType
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			$X = $continueLocationX
			$Y = $continueLocationY
			IF (Check-Continue -eq $true) {
				Write-Output "Recovering from deadman."
				Start-Job -Name "BottomRightContinueButton" -ScriptBlock $BottomRightContinueButton | Out-Null
				Start-Jobs
				All-Done2
				Stop-Jobs
			}
			elseif (check-accept -eq $true) {
				Write-Output "Recovering from deadman."
				Rig-Fights2
				Accept-Opponent
				Send-MouseUp
				Start-Jobs
				All-Done2
				Stop-Jobs
			}
			else {
				Pick-3
				if ($ArenaEnded -ne $true) {
					Select-TopOpponent
					Rig-Fights2
					Accept-Opponent
					Start-Jobs
					All-Done2
					Stop-Jobs
				}
			}
		}
	}
	else {
		if ($Continous -eq $true) {
			do {
				Run-Arena -ArenaType $ArenaType
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				$X = $continueLocationX
				$Y = $continueLocationY
				IF (Check-Continue -eq $true) {
					Write-Output "Recovering from deadman."
					Start-Job -Name "BottomRightContinueButton" -ScriptBlock $BottomRightContinueButton | Out-Null
					Start-Jobs
					All-Done2
					Stop-Jobs
				}
				elseif (check-accept -eq $true) {
					Write-Output "Recovering from deadman."
					Rig-Fights2
					Accept-Opponent
					Send-MouseUp
					Start-Jobs
					All-Done2
					Stop-Jobs
				}
				else {
					Pick-3
					if ($ArenaEnded -ne $true) {
						Select-TopOpponent
						Rig-Fights2
						Accept-Opponent
						Start-Jobs
						All-Done2
						Stop-Jobs
					}
				}
			}
			until (($true -eq $False) -or ($ArenaEnded -eq $true))
			
		}
		else {
			Run-Arena -ArenaType $ArenaType
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			$X = $continueLocationX
			$Y = $continueLocationY
			IF (Check-Continue -eq $true) {
				Write-Output "Recovering from deadman."
				Start-Job -Name "BottomRightContinueButton" -ScriptBlock $BottomRightContinueButton | Out-Null
				Start-Jobs
				All-Done2
				Stop-Jobs
			}
			else {
				Pick-3
				if ($ArenaEnded -ne $true) {
					Select-TopOpponent
					Rig-Fights2
					Accept-Opponent
					Start-Jobs
					All-Done2
					Stop-Jobs
				}
			}
		}
	}
	#endregion
}
#endregion
#region quests
$RunQuest = {
	param (
		[boolean]$SpecialQuests,
		[boolean]$UseMaxEnergy,
		[String]$QuestType,
		[String]$Difficulty,
		[String]$QuestPath,
		[String]$NotificationTarget,
		[boolean]$UseEnergy = $false,
		[Boolean]$recoil,
		[String]$FightStyle
	)
	if ($recoil -eq $null) {
		$recoil = $false
	}
	if ($FightStyle -eq $null) {
		$FightStyle = "Normal"
	}
	[Boolean]$continuequest = $true
	Import-Module WASP
	
	#Select BlueStacks Window
	Add-Type -AssemblyName Microsoft.VisualBasic
	[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
	Add-Type -AssemblyName System.Drawing
	Add-Type -AssemblyName System.Windows.Forms
	#region Functions
	function move-bluestackswindow {
		param (
			$top,
			$left
		)
		Select-window -title "Bluestacks App Player" | set-windowposition -Top $Top -left $left
	}
	
	function Start-Jobs {
		#region jobs
		Start-Job -Name "Skip" -ScriptBlock $SkipJob | Out-Null
		Start-Job -Name "OfferPopup" -ScriptBlock $OfferPopup -ArgumentList $NotificationTarget | Out-Null
		Start-Job -Name "AfterTheFight" -ScriptBlock $AfterFight | out-null
		Start-Job -Name "ActivateSpecials" -ScriptBlock $ActivateSpecials | Out-Null
		Start-Job -Name "EnemyLife & SpecialAttacks" -ScriptBlock {
			#region assemblies
			#Select BlueStacks Window
			Add-Type -AssemblyName Microsoft.VisualBasic
			[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
			Add-Type -AssemblyName System.Drawing
			Add-Type -AssemblyName System.Windows.Forms
			#endregion
			#region functions
			function Get-PixelColor {
				Param (
					[Int]$X,
					[Int]$Y
				)
				$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
				
				$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
				if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
					#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
				}
				Return $ColorofPixel
			}
			#endregion
			Do {
				#Sleep waiting for a fight to start
				$pausecolors = "3b7d3c", "387b39"
				Do {
					Start-Sleep -Milliseconds 200
				}
				until ($pausecolors -contains (Get-PixelColor -x 742 -y 66))
				
				#Check enemy life and player special meter
				Do {
					#Check enemy life meter and report changes
					$Half = (Get-PixelColor -x 1065 -y 145)
					$Quarter = (Get-PixelColor -x 1170 -y 145)
					If (($Half -ne "1b1b1b") -and ($Quarter -ne "1b1b1b")) { $EnemyLife = "2" }
					If (($Half -eq "1b1b1b") -and ($Quarter -ne "1b1b1b")) { $EnemyLife = "1" }
					If (($Half -eq "1b1b1b") -and ($Quarter -eq "1b1b1b")) { $EnemyLife = "0" }
					IF ($LastRun -ne $EnemyLife) {
						$LastRun = $EnemyLife
					}
					
					Check special color
					$SpecialMeter = (Get-PixelColor -x 260 -y 775)
					If ($SpecialMeter -eq "282828") { $SpecialColor = "Gray" }
					If ($SpecialMeter -eq "64e00") { $SpecialColor = "Green" }
					If ($SpecialMeter -eq "537e") { $SpecialColor = "Yellow" }
					If ($SpecialMeter -eq "77") { $SpecialColor = "Red" }
					IF ($LastColor -ne $SpecialColor) {
						Write-Host $SpecialColor
						$LastColor = $SpecialColor
					}
					
					#Attack only with red meter if enemy has over 1/2 life
					IF (($EnemyLife -eq "2") -and ($SpecialColor -eq "Red")) {
						Do {
							[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(260, 775)
							Start-Sleep -Milliseconds 50
							$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
							Start-Sleep -Milliseconds 50
							$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
						}
						Until (((Get-PixelColor -x 260 -y 775) -eq "282828") -or ((Get-PixelColor -x 742 -y 66) -ne "3b7d3c"))
					}
					
					#Attack only with red or yellow meter if enemy has 1/2 to 1/4 life
					IF (($EnemyLife -eq "1") -and (($SpecialColor -eq "Red") -or ($SpecialColor -eq "Yellow"))) {
						Do {
							[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(260, 775)
							Start-Sleep -Milliseconds 50
							$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
							Start-Sleep -Milliseconds 50
							$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
						}
						Until (((Get-PixelColor -x 260 -y 775) -eq "282828") -or ((Get-PixelColor -x 742 -y 66) -ne "3b7d3c"))
					}
					#>
					#Attack with any meter if enemy has less than 1/4 life
					$SpecialMeter = (Get-PixelColor -x 260 -y 775)
					IF (($EnemyLife -eq "0") -and ($SpecialMeter -ne "282828")) {
						Do {
							[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(260, 775)
							Start-Sleep -Milliseconds 50
							$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
							Start-Sleep -Milliseconds 50
							$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
						}
						until (((Get-PixelColor -x 260 -y 775) -eq "282828") -or ((Get-PixelColor -x 742 -y 66) -ne "3b7d3c"))
						
					}
					
					Start-Sleep -Milliseconds 100
				}
				until ($pausecolors -notcontains (Get-PixelColor -x 742 -y 66))
			}
			until ($true -eq $false)
		} | out-null
		if ($FightStyle -eq "Normal") {
			Start-Job -Name "FightSequence" -ScriptBlock $NormalFight | out-null
		}
		elseif ($FightStyle -eq "Aggressive") {
			Start-Job -Name "FightSequence" -ScriptBlock $AggressiveFight | out-null
			
		}
		elseif ($FightStyle -eq "Evasive") {
			Start-Job -Name "FightSequence" -ScriptBlock $EvasiveFight | out-null
			
		}
		elseif ($FightStyle -eq "Dynamic") {
			Start-Job -Name "FightSequence" -ScriptBlock $TessSequence | out-null
			
		}
		else {
			Start-Job -Name "FightSequence" -ScriptBlock $NormalFight | out-null
		}
		
		#endregion
	}
	Function Clean-Memory {
		[System.GC]::Collect()
	}
	function Send-MouseDown {
		Param
		(
			$X,
			$Y,
			$Sleep
		)
		[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		#region mouse click
		$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
		if ($Sleep -eq $null) {
			Start-Sleep -Milliseconds 50
		}
		else {
			Start-Sleep -Milliseconds $Sleep
		}
	}
	Function Send-MouseUp {
		#region mouse click
		$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
		Start-Sleep -Milliseconds 50
	}
	function Get-PixelColor {
		Param (
			[Int]$X,
			[Int]$Y
		)
		$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
		
		$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
		if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
			#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
		}
		Return $ColorofPixel
	}
	function Invoke-MoveCursorToLocation {
		[CmdletBinding()]
		
		PARAM (
			
			[Parameter(Mandatory = $true)]
			[uint32]$X,
			
			[Parameter(Mandatory = $true)]
			[uint32]$Y,
			
			[Parameter()]
			[uint32]$NumberOfMoves = 50,
			
			[Parameter()]
			[uint32]$WaitBetweenMoves = 50
			
		)
		
		Try {
			
			$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
			
			#region - Calculate positiveXChange
			if (($currentCursorPosition.X - $X) -ge 0) {
				
				$positiveXChange = $false
				
			}
			
			else {
				
				$positiveXChange = $true
				
			}
			#endregion - Calculate positiveXChange
			
			#region - Calculate positiveYChange
			if (($currentCursorPosition.Y - $Y) -ge 0) {
				
				$positiveYChange = $false
				
			}
			
			else {
				
				$positiveYChange = $true
				
			}
			#endregion - Calculate positiveYChange
			
			#region - Setup Trig Values
			
			### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
			### going to be the adjacent and opposite values of the triangle
			$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
			$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
			
			### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
			if ($xTotalDelta -ge $yTotalDelta) {
				
				$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
				
				if ($NumberOfMoves -gt $xTotalDelta) {
					
					$NumberOfMoves = $xTotalDelta
					
				}
				
				$xMoveIncrement = $xTotalDelta / $NumberOfMoves
				$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
				
			}
			else {
				
				$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
				
				if ($NumberOfMoves -gt $yTotalDelta) {
					
					$NumberOfMoves = $yTotalDelta
					
				}
				
				$yMoveIncrement = $yTotalDelta / $NumberOfMoves
				$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
			}
			#endregion - Setup Trig Values
			
			#region Verbose Output (Before for loop)
			Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
			Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
			Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
			Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
			#endregion
			
			for ($i = 0; $i -lt $NumberOfMoves; $i++) {
				
				##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
				##$yMoveIncrement = $yTotalDelta - $yPos
				
				#region Calculate X movement direction
				switch ($positiveXChange) {
					
					$true    { $currentCursorPosition.X += $xMoveIncrement }
					$false   { $currentCursorPosition.X -= $xMoveIncrement }
					default { $currentCursorPosition.X = $currentCursorPosition.X }
					
				}
				#endregion Calculate X movement direction
				
				#region Calculate Y movement direction
				switch ($positiveYChange) {
					
					$true    { $currentCursorPosition.Y += $yMoveIncrement }
					$false   { $currentCursorPosition.Y -= $yMoveIncrement }
					default { $currentCursorPosition.Y = $currentCursorPosition.Y }
					
				}
				#endregion Calculate Y movement direction
				
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Start-Sleep -Milliseconds $WaitBetweenMoves
				
				#region Verbose Output (During Loop)
				Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
				#endregion Verbose Output (During Loop)
			}
			
			$currentCursorPosition.X = $X
			$currentCursorPosition.Y = $Y
			[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
			Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
			
		}
		
		Catch {
			
			Write-Error $_.Exception.Message
			
		}
		
	}
	function Menu-DropDown {
		DO { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until (($CollaspedMenuColors -contains (Get-PixelColor -x $CollaspedMenuLocationX -y $CollaspedMenuLocationY)) -or ($FightColors -contains (Get-PixelColor -X $menufightLocationX -Y $menufightLocationY)))
		IF ($CollaspedMenuColors -contains (Get-PixelColor -x $CollaspedMenuLocationX -y $CollaspedMenuLocationY)) {
			Send-MouseDown -X $CollaspedMenuLocationX -Y $CollaspedMenuLocationY
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
	}
	function Menu-FightButton {
		DO { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ($FightColors -contains (Get-PixelColor -X $menufightLocationX -Y $menufightLocationY))
		IF ($FightColors -contains (Get-PixelColor -X $menufightLocationX -Y $menufightLocationY)) {
			Send-MouseDown -X $menufightLocationX -Y $menufightLocationY
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
	}
	function Click-EventQuests {
		#Event Quests Button (First Letter E in Event)
		$Color = "ffffff"
		$X1 = 452
		$X2 = 42
		$Y1 = 579
		$Y2 = 579
		DO { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until (((Get-PixelColor -x $x1 -y $y1) -eq $Color) -or ((Get-PixelColor -x $x2 -y $y2) -eq $Color))
		If ((Get-PixelColor -x $x1 -y $y1) -eq $Color) {
			Do {
				Send-MouseDown -X $X1 -Y $Y1
				Send-MouseUp
				1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until ((Get-PixelColor -x $x1 -y $y1) -ne $Color)
		}
		If ((Get-PixelColor -x $x2 -y $y2) -eq $Color) {
			Do {
				Send-MouseDown -X $X2 -Y $Y2
				Send-MouseUp
				1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until ((Get-PixelColor -x $x2 -y $y2) -ne $Color)
		}
	}
	function Click-ProvingGrounds {
		$Color = "ffffff"
		$X = 302
		$Y = 715
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x -y $y) -eq $Color)
		Do {
			Send-MouseDown -X $X -Y $Y
			Send-MouseUp
			1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x -y $y) -ne $Color)
	}
	function Click-ProvingGrounds2 {
		
		1..25 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		$dragright = 1200
		$dragleft = 200
		$dragy = 500
		Send-MouseDown -X $dragright -Y $dragy
		Invoke-MoveCursorToLocation -X $dragleft -Y $dragy -NumberOfMoves 20 -WaitBetweenMoves 20
		Send-MouseUp
		Send-MouseDown -X $dragright -Y $dragy
		Invoke-MoveCursorToLocation -X $dragleft -Y $dragy -NumberOfMoves 20 -WaitBetweenMoves 20
		Send-MouseUp
		1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		
		$X1 = 477
		$Y1 = 716
		$ColorDetect = Get-PixelColor -X $x1 -Y $y1
		Do {
			Send-MouseDown -X $X1 -Y $Y1
			Send-MouseUp
			1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		Until ((Get-PixelColor -X $x1 -Y $y1) -ne $ColorDetect)
	}
	function Click-ClassQuests {
		$Color = "fefefe"
		$X = 633
		$Y = 164
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x -y $y) -eq $Color)
		$x1 = 743
		$y1 = 438
		$ColorDetect = Get-PixelColor -X $x1 -Y $y1
		Do {
			Send-MouseDown -X $X1 -Y $Y1
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		Until ((Get-PixelColor -X $x1 -Y $y1) -ne $ColorDetect)
	}
	function Click-ClassQuests2 {
		1..25 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		$dragright = 1200
		$dragleft = 200
		$dragy = 500
		Send-MouseDown -X $dragright -Y $dragy
		Invoke-MoveCursorToLocation -X $dragleft -Y $dragy -NumberOfMoves 20 -WaitBetweenMoves 20
		Send-MouseUp
		Send-MouseDown -X $dragright -Y $dragy
		Invoke-MoveCursorToLocation -X $dragleft -Y $dragy -NumberOfMoves 20 -WaitBetweenMoves 20
		Send-MouseUp
		1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		
		$Color = "fefefe"
		$X = 633
		$Y = 164
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x -y $y) -eq $Color)
		
		$x1 = 905
		$y1 = 435
		$ColorDetect = Get-PixelColor -X $x1 -Y $y1
		Do {
			Send-MouseDown -X $X1 -Y $Y1
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		Until ((Get-PixelColor -X $x1 -Y $y1) -ne $ColorDetect)
	}
	function Click-BasicDifficultyEasy {
		#Waiting on class color coded diffuculties to show up
		$Color1 = "4700"
		$X1 = 490
		$Y1 = 250
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x1 -y $y1) -eq $Color1)
		Do {
			Send-MouseDown -X $X1 -Y $Y1
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x1 -y $y1) -ne $Color1)
	}
	function Click-BasicDifficultyEasy2 {
		#Waiting on class color coded diffuculties to show up
		$Color1 = "4700"
		$x2 = 705
		$y2 = 255
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x2 -y $y2) -eq $Color1)
		Do {
			Send-MouseDown -X $x2 -Y $y2
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x2 -y $y2) -ne $Color1)
	}
	function Click-BasicDifficultyMedium {
		#Waiting on class color coded diffuculties to show up
		$Color2 = "277ae"
		$X1 = 700
		$Y1 = 250
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x1 -y $y1) -eq $Color1)
		Do {
			Send-MouseDown -X $X1 -Y $Y1
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x1 -y $y1) -ne $Color1)
	}
	function Click-BasicDifficultyMedium2 {
		#Waiting on class color coded diffuculties to show up
		$Color2 = "277ae"
		$x2 = 925
		$y2 = 255
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x2 -y $y2) -eq $Color2)
		Do {
			Send-MouseDown -X $x2 -Y $y2
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x2 -y $y2) -ne $Color2)
	}
	function Click-BasicDifficultyHard {
		#Waiting on class color coded diffuculties to show up
		$Color1 = "88"
		$X1 = 875
		$Y1 = 250
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x1 -y $y1) -eq $Color1)
		Do {
			
			Send-MouseDown -X $X1 -Y $Y1
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			
		}
		until ((Get-PixelColor -x $x1 -y $y1) -ne $Color1)
	}
	function Click-BasicDifficultyHard2 {
		#Waiting on class color coded diffuculties to show up
		$Color1 = "88"
		$x2 = 1100
		$y2 = 255
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x2 -y $y2) -eq $Color1)
		Do {
			Send-MouseDown -X $X2 -Y $Y2
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x2 -y $y2) -ne $Color1)
	}
	function Click-ClassDifficultyEasy {
		#Waiting on class color coded diffuculties to show up
		$Color1 = "4700"
		$X1 = 722
		$Y1 = 253
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x1 -y $y1) -eq $Color1)
		Do {
			Send-MouseDown -X $X1 -Y $Y1
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x1 -y $y1) -ne $Color1)
	}
	function Click-ClassDifficultyMedium {
		$Color2 = "277ae"
		$X2 = 930
		$Y2 = 253
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x2 -y $y2) -eq $Color2)
		Do {
			Send-MouseDown -X $X2 -Y $Y2
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x2 -y $y2) -ne $Color2)
	}
	function Click-ClassDifficultyHard {
		$Color3 = "88"
		$X3 = 1100
		$Y3 = 253
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x3 -y $y3) -eq $Color3)
		Do {
			Send-MouseDown -X $X3 -Y $Y3
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x3 -y $y3) -ne $Color3)
	}
	function Begin-Quest {
		$Color = "ffffff"
		$X = 1241
		$Y = 838
		Do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
		until ((Get-PixelColor -x $x -y $y) -eq $Color)
		Do {
			Send-MouseDown -X $X -Y $Y
			Send-MouseUp
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		until ((Get-PixelColor -x $x -y $y) -ne $Color)
	}
	function Do-LeftPath {
		Start-Job -Name "DoEasyPath" -ScriptBlock {
			Import-Module WASP
			
			#Select BlueStacks Window
			Add-Type -AssemblyName Microsoft.VisualBasic
			[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
			Add-Type -AssemblyName System.Drawing
			Add-Type -AssemblyName System.Windows.Forms
			#region mouse click left
			$signature = @'
[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			#region Functions
			function Get-PixelColor {
				Param (
					[Int]$X,
					[Int]$Y
				)
				$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
				
				$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
				if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
					#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
				}
				Return $ColorofPixel
			}
			Function Click-Waypoint {
				Param (
					$X,
					$Y
				)
				Start-Sleep -Milliseconds 200
				[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
				Start-Sleep -Milliseconds 200
				Click-mousebutton -button left
				$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
				Start-Sleep -Milliseconds 200
				$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
				Start-Sleep -Milliseconds 400
			}
			function Do-EasyWayPoints {
				$XIncrement = 65
				$YIncrement = 44
				
				#Clear-Host
				
				# Current Location
				$CurrentX = 742
				$CurrentY = 462
				# Click Center to NorthWest
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
				
				# Click Center to North
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
				
				# Click Center to NorthEast
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
				
				# Click Center to East
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
				
				# Click Center to SouthEast
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
				
				# Click Center to South
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
				
				# Click Center to SouthWest
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
				
				# Click Center to West
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
				
				
			}
			#endregion
			Do {
				do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
				until ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1")
				do { Do-EasyWayPoints }
				until ((Get-PixelColor -X 1395 -Y 742) -ne "c2c1c1")
			}
			until ($true -eq $false)
		} | out-null
	}
	function Do-RightPath {
		Start-Job -Name "DoHardPath" -ScriptBlock {
			Import-Module WASP
			
			#Select BlueStacks Window
			Add-Type -AssemblyName Microsoft.VisualBasic
			[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
			Add-Type -AssemblyName System.Drawing
			Add-Type -AssemblyName System.Windows.Forms
			#region mouse click left
			$signature = @'
[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			#region Functions
			function Get-PixelColor {
				Param (
					[Int]$X,
					[Int]$Y
				)
				$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
				
				$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
				if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
					#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
				}
				Return $ColorofPixel
			}
			Function Click-Waypoint {
				Param (
					$X,
					$Y
				)
				Start-Sleep -Milliseconds 3
				
				#region Functions
				Add-Type -AssemblyName System.Drawing
				Add-Type -AssemblyName System.Windows.Forms
				#endregion
				
				[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
				Start-Sleep -Milliseconds 50
				$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
				Start-Sleep -Milliseconds 20
				$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
				Start-Sleep -Milliseconds 20
			}
			function Do-HardWayPoints {
				$XIncrement = 65
				$YIncrement = 44
				
				# Current Location
				$CurrentX = 742
				$CurrentY = 462
				
				# Click Center to South
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
				
				# Click Center to SouthEast
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
				
				# Click Center to East
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
				
				# Click Center to NorthEast
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
				
				# Click Center to North
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $currentx -Y $newY } } }
				
				# Click Center to NorthWest
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
				
				# Click Center to West
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $CurrentY } } }
				
				# Click Center to SouthWest
				if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { 1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") { Click-Waypoint -X $newx -Y $newY } } }
			}
			
			#endregion
			
			Do {
				do { Start-Sleep -Milliseconds 30 }
				until ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1")
				do { Do-HardWayPoints }
				until ((Get-PixelColor -X 1395 -Y 742) -ne "c2c1c1")
			}
			until ($true -eq $false)
		} | out-null
	}
	function Follow-Path {
		param (
			$Direction
		)
		Start-Job -Name "FollowPath" -ScriptBlock {
			param (
				$Direction
			)
			#region assemblies and modules
			Import-Module WASP
			Add-Type -AssemblyName Microsoft.VisualBasic
			[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
			Add-Type -AssemblyName System.Drawing
			Add-Type -AssemblyName System.Windows.Forms
			#endregion
			#region Functions
			function Get-PixelColor {
				Param (
					[Int]$X,
					[Int]$Y
				)
				$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
				
				$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
				if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
					#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
				}
				Return $ColorofPixel
			}
			function Send-MouseDown {
				Param
				(
					$X,
					$Y,
					$Sleep
				)
				[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				#region mouse click
				$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
				$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
				#endregion
				$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
				if ($Sleep -eq $null) {
					Start-Sleep -Milliseconds 50
				}
				else {
					Start-Sleep -Milliseconds $Sleep
				}
			}
			Function Send-MouseUp {
				#region mouse click
				$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
				$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
				#endregion
				$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
				Start-Sleep -Milliseconds 50
			}
			Function Click-Waypoint {
				Param (
					$X,
					$Y
				)
				Send-MouseDown -X $X -Y $Y
				Send-MouseUp
			}
			Function Add-Waypoint {
				Param (
					$X,
					$Y
				)
				$Var = "$X, $Y"
				return $var
			}
			Function Create-LeftWayPoints {
				#region variables
				$Locations = @()
				$CurrentX = 742
				$CurrentY = 462
				$XIncrement = 65
				$YIncrement = 44
				#endregion
				# Click Center to South
				1..6 | foreach { $newY = $CurrentY + ($_ * $YIncrement); $Locations += (Add-Waypoint -X $currentx -Y $newY) }
				
				# Click Center to SouthWest
				1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				
				# Click Center to West
				1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $Locations += (Add-Waypoint -X $newx -Y $CurrentY) }
				
				# Click Center to NorthWest
				1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				
				# Click Center to North
				1..6 | foreach { $newY = $CurrentY - ($_ * $YIncrement); $Locations += (Add-Waypoint -X $currentx -Y $newY) }
				
				# Click Center to NorthEast
				1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				
				# Click Center to East
				1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $Locations += (Add-Waypoint -X $newx -Y $CurrentY) }
				
				# Click Center to SouthEast
				1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				return $Locations
			}
			Function Create-RightWayPoints {
				#region variables
				$Locations = @()
				$CurrentX = 742
				$CurrentY = 462
				$XIncrement = 65
				$YIncrement = 44
				#endregion
				# Click Center to South
				1..6 | foreach { $newY = $CurrentY + ($_ * $YIncrement); $Locations += (Add-Waypoint -X $currentx -Y $newY) }
				
				# Click Center to SouthEast
				1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				
				# Click Center to East
				1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $Locations += (Add-Waypoint -X $newx -Y $CurrentY) }
				
				# Click Center to NorthEast
				1..6 | foreach { $NewX = $CurrentX + ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				
				# Click Center to North
				1..6 | foreach { $newY = $CurrentY - ($_ * $YIncrement); $Locations += (Add-Waypoint -X $currentx -Y $newY) }
				
				# Click Center to NorthWest
				1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY - ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				
				# Click Center to West
				1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $Locations += (Add-Waypoint -X $newx -Y $CurrentY) }
				
				# Click Center to SouthWest
				1..6 | foreach { $NewX = $CurrentX - ($_ * $XIncrement); $newY = $CurrentY + ($_ * $YIncrement); $Locations += (Add-Waypoint -X $newx -Y $newY) }
				
				return $Locations
			}
			Function Click-NextWaypoint {
				$Exitloop = $false
				$Break = $false
				Foreach ($Location in $Locations) {
					$LocSplit = $Location.split(",")
					$LocX = $LocSplit[0]
					$LocY = $LocSplit[1]
					$ColorGreen = "e200"
					1..10 | foreach {
						if ($Break -ne $true) {
							$Waypointnumber = $_
							$a = get-pixelcolor -X $locX -Y $LocY
							if ($a -eq $ColorGreen) {
								Click-Waypoint -X $LocX -Y $LocY
								$Break = $true
							}
							Start-Sleep -Milliseconds 50
						}
					}
				}
			}
			#endregion
			Do {
				If ($Direction -eq "Left") {
					$Locations = Create-LeftWayPoints
				}
				elseif ($direction -eq "Right") {
					$Locations = Create-RightWayPoints
				}
				do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
				until ((Get-PixelColor -X $ExitDoorX -Y $ExitDoorY) -eq "c2c1c1")
				do { Click-NextWaypoint }
				until ((Get-PixelColor -X $ExitDoorX -Y $ExitDoorY) -ne "c2c1c1")
			}
			until ($true -eq $false)
		} -ArgumentList $Direction | out-null
	}
	function Collect-Loot {
		do {
			1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }; [System.Windows.Forms.Application]::DoEvents()
			$stopquest = $false
			if ($UseEnergy -eq $true) {
				if ((Get-Job -Name "UseEnergyRefills").state -eq "Stopped") {
					$stopquest = $true
				}
			}
		}
		until (((Get-PixelColor -X 450 -Y 250) -eq "302c2b") -and ((Get-PixelColor -X 520 -Y 780) -eq "302c2b") -and ((Get-PixelColor -X 940 -Y 780) -eq "302c2b") -or ($stopquest -eq $true))
		1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		if ($stopquest -ne $true) {
			Write-Output "LootScreenShot"
			1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		}
		else {
			Write-Output "Out of energy refills."
		}
	}
	function Go-Home {
		#Return to home screen
		do {
			select-window -Name "HD-FrontEnd" | Send-Keys -Keys "{esc}"
			Start-Sleep -Milliseconds 3000
		}
		until (($GoHomeColors1 -contains (Get-PixelColor -X $GoHomeLocationX1 -Y $GoHomeLocationY1)) -and ($GoHomeColors2 -contains (Get-PixelColor -X $GoHomeLocationX2 -Y $GoHomeLocationY2)))
		
		#Send ESC once more to goto home screen
		select-window -Name "HD-FrontEnd" | Send-Keys -Keys "{esc}"
		Start-Sleep -Milliseconds 2000
	}
	#endregion
	#region ScriptBlocks
	$UseEnergyRefills = {
		#region assemblies
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			
			Return $ColorofPixel
		}
		function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		#endregion
		$outofrefills = $false
		Do {
			Do {
				Start-Sleep -Milliseconds 100
			}
			until (((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b"))
			if (((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b")) {
				# ask help click
				Send-MouseDown -X 480 -Y 650
				Send-MouseUp
				1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				if (((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b")) {
					# use little click
					Send-MouseDown -X 700 -Y 650
					Send-MouseUp
					1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					if ((((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 450 -Y 750) -eq "302c2b") -and ((Get-PixelColor -X 1000 -Y 750) -eq "302c2b")) -and (((Get-PixelColor -X 907 -Y 636) -ne "ffffff") -and ((Get-PixelColor -X 865 -Y 636) -ne "ffffff"))) {
						# use big click 1000 650
						Send-MouseDown -X 1000 -Y 650
						Send-MouseUp
						1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					}
					else {
						Write-Output "Out of refills."
						$outofrefills = $true
					}
				}
			}
		}
		Until (($true -eq $false) -or ($outofrefills = $true))
	}
	$SkipJob = {
		#region Assemblies
		
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		
		#endregion
		#region functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			Start-Sleep -Milliseconds 50
		}
		#endregion
		#Watch for Skip Text on Quest Screens
		do {
			$ClickSkip = "fefefe"
			$LoadheroSlot = "2b2c30"
			$QuestScreenExitColor = "302c2b"
			$X = 734
			$Y = 841
			$LoadHeroX = 103
			$LoadHeroY = 542
			$QuestScreenX = 158
			$QuestScreenY = 117
			DO { 1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
			until (((Get-PixelColor -x $X -y $Y) -eq $ClickSkip) -and ((Get-PixelColor -x $LoadHeroX -y $LoadHeroY) -ne $LoadheroSlot))
			Do {
				Send-MouseDown -X $X -Y $Y
				Send-MouseUp
				1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			Until ((Get-PixelColor -x $X -y $Y) -ne $ClickSkip)
		}
		until ($true -eq $false)
	}
	$OfferPopup = {
		param (
			$NotificationTarget
		)
		Import-Module WASP
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#region functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function Send-Email {
			param ($subject, $Recipient, $Body)
			$EmailFrom = "MCOC.Bot@gmail.com"
			$SMTPServer = "smtp.gmail.com"
			$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
			$SMTPClient.EnableSsl = $true
			$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("MCOC.Bot", "Mothership9000?");
			$SMTPClient.Send($EmailFrom, $Recipient, $Subject, $Body)
		}
		#endregion
		
		#Offer to buy Cats
		do {
			do { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
			until (((Get-PixelColor -X 1036 -Y 704) -eq "ffffff") -and ((Get-PixelColor -X 1052 -Y 704) -eq "ffffff") -and ((Get-PixelColor -X 1197 -Y 198) -eq "505050"))
			do {
				select-window -name "HD-FrontEnd" | send-keys -keys '{ESC}'
				1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until (((Get-PixelColor -X 1036 -Y 704) -ne "ffffff") -and ((Get-PixelColor -X 1052 -Y 704) -ne "ffffff") -and ((Get-PixelColor -X 1197 -Y 198) -ne "505050"))
			1..10 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			select-window -name "HD-FrontEnd" | send-keys -keys '{ESC}'
			#Alert for offer...
			$Subject = "MCOC on $env:computername has an offer to buy a catalyst."
			Send-Email -Recipient $NotificationTarget -subject $Subject -Body $Subject
		}
		until ($true -eq $false)
	}
	$BottomRightContinueButton = {
		#region assemblies
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region Functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			
			Return $ColorofPixel
		}
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			#region mouse click
			$signature = @' 
     [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
     public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 50
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				$SleepCount = [math]::ceiling($Sleep / 200)
				1..$SleepCount | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
     [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
     public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				$SleepCount = [math]::ceiling($Sleep / 200)
				1..$SleepCount | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$continuecolors = $ColorLocationTable.continuecolors
		$continueLocationX = $ColorLocationTable.continueLocation[0]
		$continueLocationY = $ColorLocationTable.continueLocation[1]
		#endregion
		do {
			$X = $continueLocationX
			$Y = $continueLocationY
			DO { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
			until ($continuecolors -contains (Get-PixelColor -x $x -y $y))
			Do {
				Write-Output "Continue"
				1..20 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Write-Output "Take-ScreenShots"
				1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Send-MouseDown -X $X -Y $Y
				Send-MouseUp
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until ($continuecolors -notcontains (Get-PixelColor -x $x -y $y))
		}
		until ($true -eq $false)
	}
	$AfterFight = {
		#region assemblies
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		function Get-4x4PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			#region create pixel block
			$X = $x - 2
			$Y = $Y - 2
			1..4 | foreach {
				1..4 | foreach {
					$ColorofPixel += (, ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name)
					$Y++
				}
				$X++
				$Y = $Y - 4
			}
			#endregion
			# Find unique
			$ColorofPixel = $ColorofPixel | Get-Unique
			Return $ColorofPixel
		}
		function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$Victory1LocationX = $ColorLocationTable.Victory1Location[0]
		$Victory1LocationY = $ColorLocationTable.Victory1Location[1]
		$Victory1Colors = $ColorLocationTable.Victory1Colors
		$Victory2LocationX = $ColorLocationTable.Victory2Location[0]
		$Victory2LocationY = $ColorLocationTable.Victory2Location[1]
		$Victory2Colors = $ColorLocationTable.Victory2Colors
		$Defeat1LocationX = $ColorLocationTable.Defeat1Location[0]
		$Defeat1LocationY = $ColorLocationTable.Defeat1Location[1]
		$Defeat1Colors = $ColorLocationTable.Defeat1Colors
		$Defeat2LocationX = $ColorLocationTable.Defeat2Location[0]
		$Defeat2LocationY = $ColorLocationTable.Defeat2Location[1]
		$Defeat2Colors = $ColorLocationTable.Defeat2Colors
		$continuecolors = $ColorLocationTable.continuecolors
		$continueLocationX = $ColorLocationTable.continueLocation[0]
		$continueLocationY = $ColorLocationTable.continueLocation[1]
		$CollaspedMenuColors = $ColorLocationTable.CollaspedMenuColors
		$CollaspedMenuLocationX = $ColorLocationTable.CollaspedMenuLocation[0]
		$CollaspedMenuLocationY = $ColorLocationTable.CollaspedMenuLocation[1]
		#endregion
		Do {
			DO {
				1..5 | foreach {
					Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
				}
			}
			until ((($Victory1Colors -contains (Get-PixelColor -x $Victory1LocationX -y $victory1locationY)) -and ($Victory2Colors -contains (Get-PixelColor -x $Victory2LocationX -y $victory2locationY))) -or (($Defeat1Colors -contains (Get-PixelColor -x $Defeat1LocationX -y $Defeat1LocationY)) -and ($Defeat2Colors -contains (Get-PixelColor -x $Defeat2LocationX -y $Defeat2LocationY))))
			if ($CollaspedMenuColors -notcontains (Get-PixelColor -X $CollaspedMenuLocationX -Y $CollaspedMenuLocationY)) {
				Send-MouseDown -X 300 -Y 300
				Send-MouseUp
			}
		}
		until ($true -eq $false)
	}
	$AggressiveFight = {
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			Do {
				Quick-Attack
				light-attack
				light-attack
				Quick-Attack
				Heavy-Attack
				light-attack
				Medium-attack
				light-attack
				light-attack
				Quick-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$NormalFight = {
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			Do {
				Quick-Attack
				light-attack
				light-attack
				light-attack
				light-Attack
				Avoid-Attack
				FastAvoid-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$EvasiveFight = {
		#region assemblies
		Import-Module WASP
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Do {
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			#Sleep waiting for a fight to start
			Do {
				Block-Attack
				Avoid-Attack
				Quick-Attack
				light-attack
				light-attack
				light-attack
				light-attack
				Avoid-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$TessSequence = {
		Set-Location "C:\Program Files (x86)\Mothership\Tesseract"
		#Import System.Drawing and Tesseract libraries
		Add-Type -AssemblyName "System.Drawing"
		Add-Type -Path "C:\Program Files (x86)\Mothership\Tesseract\Lib\Tesseract.dll"
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#Create tesseract object, specify tessdata location and language
		$tesseract = New-Object Tesseract.TesseractEngine("C:\Program Files (x86)\Mothership\Tesseract\Lib\tessdata", "eng", [Tesseract.EngineMode]::Default, $null)
		$Tesseract.SetVariable("tessedit_char_whitelist", "0123456789")
		#region functions
		function Capture-CharacterPI {
			param (
				[int]$xstartleft,
				[int]$ystarttop,
				[int]$xendright,
				[int]$yendbottom
			)
			$bounds = [Drawing.Rectangle]::FromLTRB($xstartleft, $ystarttop, $xendright, $yendbottom)
			$imagecap = New-Object Drawing.Bitmap $bounds.width, $bounds.height
			$graphics = [Drawing.Graphics]::FromImage($imagecap)
			$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
			$filename = "C:\Tools\Tesseract\" + "$$ystarttop" + "$yendbottom" + "$xstartleft" + "$yendbottom" + ".bmp"
			$imagecap.save($filename)
			Return $imagecap
		}
		function Hero-PI {
			$xstartleft = $PlayerPILeftLocationX
			$ystarttop = $PlayerPILeftLocationY
			$xendright = $PlayerPIRightLocationX
			$yendbottom = $PlayerPIRightLocationY
			[Drawing.Bitmap]$PIbmp = Capture-CharacterPI -xstartleft $xstartleft -xendright $xendright -ystarttop $ystarttop -yendbottom $yendbottom
			$pipix = [Tesseract.PixConverter]::ToPix($PIbmp)
			$pipage = $tesseract.Process($pipix)
			[Int]$HeroPI = $pipage.GetText()
			if ($pipage.GetMeanConfidence -lt 0.7) {
				$HeroPI = "unknown"
			}
			$pipage.Dispose()
			return $HeroPI
		}
		function Enemy-PI {
			$xstartleft = $EnemyPILeftLocationX
			$ystarttop = $EnemyPILeftLocationY
			$xendright = $EnemyPIRightLocationX
			$yendbottom = $EnemyPIRightLocationY
			$PIbmp = Capture-CharacterPI -xstartleft $xstartleft -xendright $xendright -ystarttop $ystarttop -yendbottom $yendbottom
			$pipix = [Tesseract.PixConverter]::ToPix($PIbmp)
			$pipage = $tesseract.Process($pipix)
			[Int]$EnemyPI = $pipage.GetText()
			if ($pipage.GetMeanConfidence -lt 0.7) {
				$EnemyPI = "unknown"
			}
			$pipage.Dispose()
			return $EnemyPI
		}
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			#Compare hero and enemy pi, adjust fight sequence
			$HeroPI = Hero-PI
			$EnemyPI = Enemy-PI
			if (($HeroPI -ne "unknown") -and ($EnemyPI -ne "unknown")) {
				if (($HeroPI * 0.75) -gt $EnemyPI) {
					$fightbehavior = "Aggressive"
				}
				elseif (($heroPI * 2) -le $EnemyPI) {
					$fightbehavior = "Evasive"
				}
				else {
					$fightbehavior = "Normal"
				}
			}
			else {
				$fightbehavior = "Normal"
			}
			$Writefightstyle = 0
			switch ($fightbehavior) {
				"Aggressive" {
					Do {
						Quick-Attack
						light-attack
						light-attack
						Quick-Attack
						Heavy-Attack
						light-attack
						Medium-attack
						light-attack
						light-attack
						Quick-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
				"Normal" {
					Do {
						Quick-Attack
						light-attack
						light-attack
						light-attack
						light-attack
						Avoid-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
				"Evasive" {
					Do {
						Block-Attack
						Quick-Attack
						light-attack
						light-attack
						light-attack
						light-attack
						Avoid-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
			}
			
		}
		Until ($true -eq $false)
	}
	
	$ActivateSpecials = {
		
		#region assemblies
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Import-Module WASP
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			$EnergyDrain = $false
			clear-host
			Do {
				$GreenCheck = if ($GreenSpecialColors -contains (Get-PixelColor -x $GreenSpecialLocationX -y $GreenSpecialLocationY)) { $True }
				$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
				$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
				If ($GreenCheck -eq $true) {
					write-host  "Wait for Yellow, if energy goes in reverse use any special"
					Do {
						$GreenCheck = if ($GreenSpecialColors -contains (Get-PixelColor -x $GreenSpecialLocationX -y $GreenSpecialLocationY)) { $True }
						$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
						if ($YellowCheck -eq $true) {
							do {
								write-host  "Wait for Red, if energy goes in reverse use any special"
								$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
								$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
								Start-Sleep -Milliseconds 200
								if ($RedCheck -eq $true) {
									write-host  "Use Special"
									do {
										Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
										Start-Sleep -Milliseconds 200
									}
									until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
								}
							}
							Until (($YellowCheck -eq $false) -or ($RedCheck -eq $true))
							if (($yellowcheck -eq $false) -and ($RedCheck -eq $false)) { $EnergyDrain = $true }
						}
						Start-Sleep -Milliseconds 1000
					}
					Until (($GreenCheck -eq $true) -or ($YellowCheck -eq $true))
					if (($yellowcheck -eq $false) -and ($greenCheck -eq $false)) { $EnergyDrain = $true }
				}
				elseif ($YellowCheck -eq $true) {
					do {
						write-host  "Wait for Red, if energy goes in reverse use any special"
						$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
						$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
						if ($RedCheck -eq $true) {
							write-host  "Use Special"
							do {
								Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
								Start-Sleep -Milliseconds 200
							}
							until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
						}
						Start-Sleep -Milliseconds 1000
					}
					Until (($YellowCheck -eq $true) -or ($RedCheck -eq $true))
					if (($yellowcheck -eq $false) -and ($RedCheck -eq $false)) { $EnergyDrain = $true }
				}
				elseif ($RedCheck -eq $true) {
					write-host  "Use Special"
					do {
						Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
						Start-Sleep -Milliseconds 200
					}
					until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
				}
				else {
					if ($EnergyDrain -eq $true) {
						do {
							if ($SpecialColors -notcontains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) {
								write-host  "Use Special"
								do {
									Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
									Start-Sleep -Milliseconds 200
								}
								until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
							}
						}
						until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					}
				}
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
		}
		until ($true -eq $false)
	}
	#endregion
	#region Import Locations and Colors
	$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
	$bluestackstop = $ColorLocationTable.bluestackstop
	$bluestacksleft = $ColorLocationTable.bluestacksleft
	$CollaspedMenuColors = $ColorLocationTable.CollaspedMenuColors
	$ExpandedMenuColors = $ColorLocationTable.ExpandedMenuColors
	$FightColors = $ColorLocationTable.FightColors
	$VersusColors = $ColorLocationTable.VersusColors
	$VersusColors2 = $ColorLocationTable.VersusColors2
	$threestarcolors = $ColorLocationTable.threestarcolors
	$fourstarcolors = $ColorLocationTable.fourstarcolors
	$findmatchcolors = $ColorLocationTable.findmatchcolors
	$acceptmatchcolors = $ColorLocationTable.acceptmatchcolors
	$acceptsortcolors = $ColorLocationTable.acceptsortcolors
	$continuecolors = $ColorLocationTable.continuecolors
	$pausecolors = $ColorLocationTable.pausecolors
	$GoHomeColors1 = $ColorLocationTable.GoHomeColors
	$GoHomeColors2 = $ColorLocationTable.GoHomeColors2
	$CollaspedMenuLocationX = $ColorLocationTable.CollaspedMenuLocation[0]
	$ExpandedMenuLocationX = $ColorLocationTable.ExpandedMenuLocation[0]
	$menufightLocationX = $ColorLocationTable.FightLocation[0]
	$VersusLocationX = $ColorLocationTable.VersusLocation[0]
	$VersusLocationX2 = $ColorLocationTable.VersusLocation2[0]
	$3starLocationX = $ColorLocationTable.threestarLocation[0]
	$4starLocationX = $ColorLocationTable.fourstarLocation[0]
	$FindmatchLocationX = $ColorLocationTable.findmatchLocation[0]
	$acceptmatchLocationX = $ColorLocationTable.acceptmatchLocation[0]
	$acceptsortLocationX = $ColorLocationTable.acceptsortLocation[0]
	$continueLocationX = $ColorLocationTable.continueLocation[0]
	$PauseLocationX = $ColorLocationTable.pauseLocation[0]
	$GoHomeLocationX1 = $ColorLocationTable.GoHomeLocation[0]
	$GoHomeLocationX2 = $ColorLocationTable.GoHomeLocation2[0]
	$CollaspedMenuLocationY = $ColorLocationTable.CollaspedMenuLocation[1]
	$ExpandedMenuLocationY = $ColorLocationTable.ExpandedMenuLocation[1]
	$menufightLocationY = $ColorLocationTable.FightLocation[1]
	$VersusLocationY = $ColorLocationTable.VersusLocation[1]
	$VersusLocationY2 = $ColorLocationTable.VersusLocation2[1]
	$3starLocationY = $ColorLocationTable.threestarLocation[1]
	$4starLocationY = $ColorLocationTable.fourstarLocation[1]
	$FindmatchLocationY = $ColorLocationTable.findmatchLocation[1]
	$acceptmatchLocationY = $ColorLocationTable.acceptmatchLocation[1]
	$acceptsortLocationY = $ColorLocationTable.acceptsortLocation[1]
	$continueLocationY = $ColorLocationTable.continueLocation[1]
	$PauseLocationY = $ColorLocationTable.pauseLocation[1]
	$GoHomeLocationY1 = $ColorLocationTable.GoHomeLocation[1]
	$GoHomeLocationY2 = $ColorLocationTable.GoHomeLocation2[1]
	$Global:Player1LocationX = $ColorLocationTable.Player1Location[0]
	$Global:Player2LocationX = $ColorLocationTable.Player2Location[0]
	$Global:Player3LocationX = $ColorLocationTable.Player3Location[0]
	$Global:Enemy1LocationX = $ColorLocationTable.Enemy1Location[0]
	$Global:Enemy2LocationX = $ColorLocationTable.Enemy2Location[0]
	$Global:Enemy3LocationX = $ColorLocationTable.Enemy3Location[0]
	$Global:Player1LocationY = $ColorLocationTable.Player1Location[1]
	$Global:Player2LocationY = $ColorLocationTable.Player2Location[1]
	$Global:Player3LocationY = $ColorLocationTable.Player3Location[1]
	$Global:Enemy1LocationY = $ColorLocationTable.Enemy1Location[1]
	$Global:Enemy2LocationY = $ColorLocationTable.Enemy2Location[1]
	$Global:Enemy3LocationY = $ColorLocationTable.Enemy3Location[1]
	#endregion
	move-bluestackswindow -top $bluestackstop -left $bluestacksleft
	Write-Output "Monitor Energy: $UseMaxEnergy"
	1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
	if ($UseMaxEnergy -eq $true) {
		do {
			If ((Get-PixelColor –x 715 -y 115) –eq “2aeff”) { $BarColor = “Orange” }
			If ((Get-PixelColor –x 715 -y 115) –eq “82572c”) { $BarColor = “Blue” }
			
			If ($BarColor –eq “Orange”) {
				If ((Get-PixelColor –x 784 -y 108) –ne “65c4”) {
					Write-Output "Not enough energy"
					1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					$continuequest = $false
				}
				Elseif ((Get-PixelColor –x 784 -y 108) –eq “65c4”) {
					Write-Output "Adequate energy"
					1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
					$ContinueQuest = $true
				}
			}
		}
		until ($BarColor -ne "Blue")
	}
	if ($ContinueQuest -eq $true) {
		Write-Output "Navigation dropdown"
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		Menu-DropDown
		Write-Output "Fight"
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		Menu-FightButton
		Write-Output "Event Quests"
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		Click-EventQuests
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		move-bluestackswindow -top $bluestackstop -left $bluestacksleft
		if ((Get-PixelColor -X 1395 -Y 742) -eq "c2c1c1") {
			Write-Output "Continuing Path"
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			Follow-Path -Direction $QuestPath
			if ($UseEnergy -eq $true) {
				Start-Job -Name "UseEnergyRefills" -ScriptBlock $UseEnergyRefills | Out-Null
			}
			Write-Output "Collecting Loot"
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			Collect-Loot
			go-home
		}
		else {
			If ($SpecialQuests -eq $true) # Special quests active
			{
				Write-Output "Special quest alignment"
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Switch ($QuestType) {
					"Basic" { Write-Output "Menu Proving Grounds"; 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }; Click-ProvingGrounds2 }
					"Class" { Write-Output "Menu Class Quests"; 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }; Click-ClassQuests2 }
				}
			}
			else # Special quests not active
			{
				Switch ($QuestType) {
					"Basic" { Write-Output "Proving Grounds"; 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }; Click-ProvingGrounds }
					"Class" { Write-Output "Class Quests"; 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }; Click-ClassQuests }
				}
			}
			Switch ($Difficulty) {
				"Easy" {
					If ($QuestType -eq "Basic") {
						Write-Output "Basic Easy"
						1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
						if ($SpecialQuests -eq $true) {
							Click-BasicDifficultyEasy2
						}
						else {
							Click-BasicDifficultyEasy
						}
					}
					elseif ($QuestType -eq "Class") {
						Write-Output "Class Easy"
						1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
						Click-ClassDifficultyEasy
					}
				}
				"Medium" {
					If ($QuestType -eq "Basic") {
						Write-Output "Basic Medium"
						1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
						if ($SpecialQuests -eq $true) {
							Click-BasicDifficultyMedium2
						}
						else {
							Click-BasicDifficultyMedium
						}
					}
					elseif ($QuestType -eq "Class") {
						Write-Output "Class Medium"
						1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
						Click-ClassDifficultyMedium
					}
				}
				"Hard" {
					If ($QuestType -eq "Basic") {
						Write-Output "Basic Hard"
						1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
						if ($SpecialQuests -eq $true) {
							Click-BasicDifficultyHard2
						}
						else {
							Click-BasicDifficultyHard
						}
					}
					elseif ($QuestType -eq "Class") {
						Write-Output "Class Hard"
						1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
						Click-ClassDifficultyHard
					}
				}
			}
			Write-Output "Starting quest"
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			Begin-Quest
			#region jobs
			Start-Jobs
			#endregion
			Switch ($QuestPath) {
				"Left" { Write-Output "Following left path"; 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }; Do-LeftPath }
				"Right" { Write-Output "Following Right path"; 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }; Do-RightPath }
			}
			if ($UseEnergy -eq $true) {
				Start-Job -Name "UseEnergyRefills" -ScriptBlock $UseEnergyRefills | Out-Null
			}
			Write-Output "Collecting Loot"
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			Collect-Loot
			go-home
		}
	}
}
$ManualNavigation = {
	param (
		[Boolean]$recoil,
		[String]$FightStyle
	)
	if ($recoil -eq $null) {
		$recoil = $false
	}
	if ($FightStyle -eq $null) {
		$FightStyle = "Normal"
	}
	Import-Module WASP
	#Select BlueStacks Window
	Add-Type -AssemblyName Microsoft.VisualBasic
	[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
	Add-Type -AssemblyName System.Drawing
	Add-Type -AssemblyName System.Windows.Forms
	#region Functions
	function move-bluestackswindow {
		param (
			$top,
			$left
		)
		Select-window -title "Bluestacks App Player" | set-windowposition -Top $Top -left $left
	}
	
	Function Clean-Memory {
		[System.GC]::Collect()
	}
	function Send-MouseDown {
		Param
		(
			$X,
			$Y,
			$Sleep
		)
		[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
		1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
		#region mouse click
		$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
		if ($Sleep -eq $null) {
			Start-Sleep -Milliseconds 50
		}
		else {
			Start-Sleep -Milliseconds $Sleep
		}
	}
	Function Send-MouseUp {
		#region mouse click
		$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
		$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
		#endregion
		$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
		Start-Sleep -Milliseconds 50
	}
	function Get-PixelColor {
		Param (
			[Int]$X,
			[Int]$Y
		)
		$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
		
		$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
		if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
			#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
		}
		Return $ColorofPixel
	}
	function Invoke-MoveCursorToLocation {
		[CmdletBinding()]
		
		PARAM (
			
			[Parameter(Mandatory = $true)]
			[uint32]$X,
			
			[Parameter(Mandatory = $true)]
			[uint32]$Y,
			
			[Parameter()]
			[uint32]$NumberOfMoves = 50,
			
			[Parameter()]
			[uint32]$WaitBetweenMoves = 50
			
		)
		
		Try {
			
			$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
			
			#region - Calculate positiveXChange
			if (($currentCursorPosition.X - $X) -ge 0) {
				
				$positiveXChange = $false
				
			}
			
			else {
				
				$positiveXChange = $true
				
			}
			#endregion - Calculate positiveXChange
			
			#region - Calculate positiveYChange
			if (($currentCursorPosition.Y - $Y) -ge 0) {
				
				$positiveYChange = $false
				
			}
			
			else {
				
				$positiveYChange = $true
				
			}
			#endregion - Calculate positiveYChange
			
			#region - Setup Trig Values
			
			### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
			### going to be the adjacent and opposite values of the triangle
			$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
			$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
			
			### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
			if ($xTotalDelta -ge $yTotalDelta) {
				
				$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
				
				if ($NumberOfMoves -gt $xTotalDelta) {
					
					$NumberOfMoves = $xTotalDelta
					
				}
				
				$xMoveIncrement = $xTotalDelta / $NumberOfMoves
				$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
				
			}
			else {
				
				$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
				
				if ($NumberOfMoves -gt $yTotalDelta) {
					
					$NumberOfMoves = $yTotalDelta
					
				}
				
				$yMoveIncrement = $yTotalDelta / $NumberOfMoves
				$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
			}
			#endregion - Setup Trig Values
			
			#region Verbose Output (Before for loop)
			Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
			Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
			Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
			Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
			#endregion
			
			for ($i = 0; $i -lt $NumberOfMoves; $i++) {
				
				##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
				##$yMoveIncrement = $yTotalDelta - $yPos
				
				#region Calculate X movement direction
				switch ($positiveXChange) {
					
					$true    { $currentCursorPosition.X += $xMoveIncrement }
					$false   { $currentCursorPosition.X -= $xMoveIncrement }
					default { $currentCursorPosition.X = $currentCursorPosition.X }
					
				}
				#endregion Calculate X movement direction
				
				#region Calculate Y movement direction
				switch ($positiveYChange) {
					
					$true    { $currentCursorPosition.Y += $yMoveIncrement }
					$false   { $currentCursorPosition.Y -= $yMoveIncrement }
					default { $currentCursorPosition.Y = $currentCursorPosition.Y }
					
				}
				#endregion Calculate Y movement direction
				
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Start-Sleep -Milliseconds $WaitBetweenMoves
				
				#region Verbose Output (During Loop)
				Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
				#endregion Verbose Output (During Loop)
			}
			
			$currentCursorPosition.X = $X
			$currentCursorPosition.Y = $Y
			[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
			Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
			
		}
		
		Catch {
			
			Write-Error $_.Exception.Message
			
		}
		
	}
	#endregion
	#region Scriptblocks
	$BottomRightContinueButton = {
		#region assemblies
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region Functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			
			Return $ColorofPixel
		}
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			#region mouse click
			$signature = @' 
     [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
     public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 50
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				$SleepCount = [math]::ceiling($Sleep / 200)
				1..$SleepCount | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
     [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
     public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				$SleepCount = [math]::ceiling($Sleep / 200)
				1..$SleepCount | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$continuecolors = $ColorLocationTable.continuecolors
		$continueLocationX = $ColorLocationTable.continueLocation[0]
		$continueLocationY = $ColorLocationTable.continueLocation[1]
		#endregion
		do {
			$X = $continueLocationX
			$Y = $continueLocationY
			DO { 1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() } }
			until ($continuecolors -contains (Get-PixelColor -x $x -y $y))
			Do {
				Write-Output "Continue"
				1..15 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
				Send-MouseDown -X $X -Y $Y
				Send-MouseUp
				1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			}
			until ($continuecolors -notcontains (Get-PixelColor -x $x -y $y))
		}
		until ($true -eq $false)
	}
	$AfterFight = {
		#region assemblies
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		function Get-4x4PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			#region create pixel block
			$X = $x - 2
			$Y = $Y - 2
			1..4 | foreach {
				1..4 | foreach {
					$ColorofPixel += (, ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name)
					$Y++
				}
				$X++
				$Y = $Y - 4
			}
			#endregion
			# Find unique
			$ColorofPixel = $ColorofPixel | Get-Unique
			Return $ColorofPixel
		}
		function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			1..5 | foreach { Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents() }
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 50
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$Victory1LocationX = $ColorLocationTable.Victory1Location[0]
		$Victory1LocationY = $ColorLocationTable.Victory1Location[1]
		$Victory1Colors = $ColorLocationTable.Victory1Colors
		$Victory2LocationX = $ColorLocationTable.Victory2Location[0]
		$Victory2LocationY = $ColorLocationTable.Victory2Location[1]
		$Victory2Colors = $ColorLocationTable.Victory2Colors
		$Defeat1LocationX = $ColorLocationTable.Defeat1Location[0]
		$Defeat1LocationY = $ColorLocationTable.Defeat1Location[1]
		$Defeat1Colors = $ColorLocationTable.Defeat1Colors
		$Defeat2LocationX = $ColorLocationTable.Defeat2Location[0]
		$Defeat2LocationY = $ColorLocationTable.Defeat2Location[1]
		$Defeat2Colors = $ColorLocationTable.Defeat2Colors
		$continuecolors = $ColorLocationTable.continuecolors
		$continueLocationX = $ColorLocationTable.continueLocation[0]
		$continueLocationY = $ColorLocationTable.continueLocation[1]
		$CollaspedMenuColors = $ColorLocationTable.CollaspedMenuColors
		$CollaspedMenuLocationX = $ColorLocationTable.CollaspedMenuLocation[0]
		$CollaspedMenuLocationY = $ColorLocationTable.CollaspedMenuLocation[1]
		#endregion
		Do {
			DO {
				1..5 | foreach {
					Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
				}
			}
			until ((($Victory1Colors -contains (Get-PixelColor -x $Victory1LocationX -y $victory1locationY)) -and ($Victory2Colors -contains (Get-PixelColor -x $Victory2LocationX -y $victory2locationY))) -or (($Defeat1Colors -contains (Get-PixelColor -x $Defeat1LocationX -y $Defeat1LocationY)) -and ($Defeat2Colors -contains (Get-PixelColor -x $Defeat2LocationX -y $Defeat2LocationY))))
			if ($CollaspedMenuColors -notcontains (Get-PixelColor -X $CollaspedMenuLocationX -Y $CollaspedMenuLocationY)) {
				Send-MouseDown -X 300 -Y 300
				Send-MouseUp
			}
		}
		until ($true -eq $false)
	}
	$AggressiveFight = {
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			Do {
				Quick-Attack
				light-attack
				light-attack
				Quick-Attack
				Heavy-Attack
				light-attack
				Medium-attack
				light-attack
				light-attack
				Quick-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$NormalFight = {
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			Do {
				Quick-Attack
				light-attack
				light-attack
				light-attack
				light-Attack
				Avoid-Attack
				FastAvoid-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$EvasiveFight = {
		#region assemblies
		Import-Module WASP
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Do {
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			#Sleep waiting for a fight to start
			Do {
				Block-Attack
				Avoid-Attack
				Quick-Attack
				light-attack
				light-attack
				light-attack
				light-attack
				Avoid-Attack
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightEnded"
		}
		Until ($true -eq $false)
	}
	$TessSequence = {
		Set-Location "C:\Program Files (x86)\Mothership\Tesseract"
		#Import System.Drawing and Tesseract libraries
		Add-Type -AssemblyName "System.Drawing"
		Add-Type -Path "C:\Program Files (x86)\Mothership\Tesseract\Lib\Tesseract.dll"
		#region assemblies
		Import-Module wasp
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#Create tesseract object, specify tessdata location and language
		$tesseract = New-Object Tesseract.TesseractEngine("C:\Program Files (x86)\Mothership\Tesseract\Lib\tessdata", "eng", [Tesseract.EngineMode]::Default, $null)
		$Tesseract.SetVariable("tessedit_char_whitelist", "0123456789")
		#region functions
		function Capture-CharacterPI {
			param (
				[int]$xstartleft,
				[int]$ystarttop,
				[int]$xendright,
				[int]$yendbottom
			)
			$bounds = [Drawing.Rectangle]::FromLTRB($xstartleft, $ystarttop, $xendright, $yendbottom)
			$imagecap = New-Object Drawing.Bitmap $bounds.width, $bounds.height
			$graphics = [Drawing.Graphics]::FromImage($imagecap)
			$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)
			$filename = "C:\Tools\Tesseract\" + "$$ystarttop" + "$yendbottom" + "$xstartleft" + "$yendbottom" + ".bmp"
			$imagecap.save($filename)
			Return $imagecap
		}
		function Hero-PI {
			$xstartleft = $PlayerPILeftLocationX
			$ystarttop = $PlayerPILeftLocationY
			$xendright = $PlayerPIRightLocationX
			$yendbottom = $PlayerPIRightLocationY
			[Drawing.Bitmap]$PIbmp = Capture-CharacterPI -xstartleft $xstartleft -xendright $xendright -ystarttop $ystarttop -yendbottom $yendbottom
			$pipix = [Tesseract.PixConverter]::ToPix($PIbmp)
			$pipage = $tesseract.Process($pipix)
			[Int]$HeroPI = $pipage.GetText()
			if ($pipage.GetMeanConfidence -lt 0.7) {
				$HeroPI = "unknown"
			}
			$pipage.Dispose()
			return $HeroPI
		}
		function Enemy-PI {
			$xstartleft = $EnemyPILeftLocationX
			$ystarttop = $EnemyPILeftLocationY
			$xendright = $EnemyPIRightLocationX
			$yendbottom = $EnemyPIRightLocationY
			$PIbmp = Capture-CharacterPI -xstartleft $xstartleft -xendright $xendright -ystarttop $ystarttop -yendbottom $yendbottom
			$pipix = [Tesseract.PixConverter]::ToPix($PIbmp)
			$pipage = $tesseract.Process($pipix)
			[Int]$EnemyPI = $pipage.GetText()
			if ($pipage.GetMeanConfidence -lt 0.7) {
				$EnemyPI = "unknown"
			}
			$pipage.Dispose()
			return $EnemyPI
		}
		Function Send-MouseDown {
			Param
			(
				$X,
				$Y,
				$Sleep
			)
			[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
			Start-Sleep -Milliseconds 25
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000002, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		Function Send-MouseUp {
			Param
			(
				$Sleep
			)
			#region mouse click
			$signature = @' 
      [DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
      public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
			$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru
			#endregion
			$SendMouseClick::mouse_event(0x00000004, 0, 0, 0, 0)
			if ($Sleep -eq $null) {
				Start-Sleep -Milliseconds 25
			}
			else {
				Start-Sleep -Milliseconds $Sleep
			}
		}
		function Invoke-MoveCursorToLocation {
			
			[CmdletBinding()]
			
			PARAM (
				[Parameter(Mandatory = $true)]
				[uint32]$X,
				[Parameter(Mandatory = $true)]
				[uint32]$Y,
				[Parameter()]
				[uint32]$NumberOfMoves = 50,
				[Parameter()]
				[uint32]$WaitBetweenMoves = 50
			)
			
			Try {
				$currentCursorPosition = [System.Windows.Forms.Cursor]::Position
				
				#region - Calculate positiveXChange
				if (($currentCursorPosition.X - $X) -ge 0) {
					
					$positiveXChange = $false
					
				}
				else {
					
					$positiveXChange = $true
					
				}
				#endregion - Calculate positiveXChange
				
				#region - Calculate positiveYChange
				if (($currentCursorPosition.Y - $Y) -ge 0) {
					
					$positiveYChange = $false
					
				}
				
				else {
					
					$positiveYChange = $true
					
				}
				#endregion - Calculate positiveYChange
				
				#region - Setup Trig Values
				
				### We're always going to use Tan and ArcTan to calculate the movement increments because we know the x/y values which are always
				### going to be the adjacent and opposite values of the triangle
				$xTotalDelta = [Math]::Abs($X - $currentCursorPosition.X)
				$yTotalDelta = [Math]::Abs($Y - $currentCursorPosition.Y)
				
				### To avoid any strange behavior, we're always going to calculate our movement values using the larger delta value
				if ($xTotalDelta -ge $yTotalDelta) {
					
					$tanAngle = [Math]::Tan($yTotalDelta / $xTotalDelta)
					
					if ($NumberOfMoves -gt $xTotalDelta) {
						
						$NumberOfMoves = $xTotalDelta
						
					}
					
					$xMoveIncrement = $xTotalDelta / $NumberOfMoves
					$yMoveIncrement = $yTotalDelta - (([Math]::Atan($tanAngle) * ($xTotalDelta - $xMoveIncrement)))
					
				}
				else {
					
					$tanAngle = [Math]::Tan($xTotalDelta / $yTotalDelta)
					
					if ($NumberOfMoves -gt $yTotalDelta) {
						
						$NumberOfMoves = $yTotalDelta
						
					}
					
					$yMoveIncrement = $yTotalDelta / $NumberOfMoves
					$xMoveIncrement = $xTotalDelta - (([Math]::Atan($tanAngle) * ($yTotalDelta - $yMoveIncrement)))
				}
				#endregion - Setup Trig Values
				
				#region Verbose Output (Before for loop)
				Write-Verbose "StartingX: $($currentCursorPosition.X)`t`t`t`t`t`tStartingY: $($currentCursorPosition.Y)"
				Write-Verbose "Total X Delta: $xTotalDelta`t`t`t`t`tTotal Y Delta: $yTotalDelta"
				Write-Verbose "Positive X Change: $positiveXChange`t`t`tPositive Y Change: $positiveYChange"
				Write-Verbose "X Move Increment: $xMoveIncrement`t`t`tY Move Increment: $yMoveIncrement"
				#endregion
				
				for ($i = 0; $i -lt $NumberOfMoves; $i++) {
					
					##$yPos = [Math]::Atan($tanAngle) * ($xTotalDelta - $currentCursorPosition.X)
					##$yMoveIncrement = $yTotalDelta - $yPos
					
					#region Calculate X movement direction
					switch ($positiveXChange) {
						
						$true    { $currentCursorPosition.X += $xMoveIncrement }
						$false   { $currentCursorPosition.X -= $xMoveIncrement }
						default { $currentCursorPosition.X = $currentCursorPosition.X }
						
					}
					#endregion Calculate X movement direction
					
					#region Calculate Y movement direction
					switch ($positiveYChange) {
						
						$true    { $currentCursorPosition.Y += $yMoveIncrement }
						$false   { $currentCursorPosition.Y -= $yMoveIncrement }
						default { $currentCursorPosition.Y = $currentCursorPosition.Y }
						
					}
					#endregion Calculate Y movement direction
					
					[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
					Start-Sleep -Milliseconds $WaitBetweenMoves
					
					#region Verbose Output (During Loop)
					Write-Verbose "Current X Position:`t $($currentCursorPosition.X)`tCurrent Y Position: $($currentCursorPosition.Y)"
					#endregion Verbose Output (During Loop)
				}
				
				$currentCursorPosition.X = $X
				$currentCursorPosition.Y = $Y
				[System.Windows.Forms.Cursor]::Position = $currentCursorPosition
				Write-Verbose "End X Position: $($currentCursorPosition.X)`tEnd Y Position: $($currentCursorPosition.Y)"
				
			}
			
			Catch {
				
				Write-Error $_.Exception.Message
				
			}
			
		}
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		Function light-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Medium-attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $rightfightboxlocationX -Y $rightfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Heavy-Attack {
			Send-MouseDown -X $rightcenterfightboxlocationX -Y $rightcenterfightboxlocationY -Sleep 450
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function Avoid-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftfightboxlocationX -Y $leftfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY -Sleep 400
		}
		Function Quick-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp -Sleep 100
			Start-Sleep -Milliseconds 100
		}
		Function FastAvoid-Attack {
			Send-MouseDown -X $leftfightboxlocationX -Y $leftfightboxlocationY
			Invoke-MoveCursorToLocation -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -WaitBetweenMoves 0 -NumberOfMoves 15
			Send-MouseUp
			Send-MouseUp -Sleep 100
		}
		Function Block-Attack {
			Send-MouseDown -X $leftcenterfightboxlocationX -Y $leftcenterfightboxlocationY -Sleep 1500
			Send-MouseUp -Sleep 100
		}
		#endregion
		#region variables
		$Specialcolors = $RedSpecialColors
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		[INT]$EnemyPILeftLocationX = $ColorLocationTable.EnemyPILeftLocation[0]
		[INT]$EnemyPILeftLocationY = $ColorLocationTable.EnemyPILeftLocation[1]
		[INT]$EnemyPIRightLocationX = $ColorLocationTable.EnemyPIRightLocation[0]
		[INT]$EnemyPIRightLocationY = $ColorLocationTable.EnemyPIRightLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$leftcenterfightboxLocationX = $ColorLocationTable.leftcenterfightboxLocation[0]
		[INT]$leftcenterfightboxLocationY = $ColorLocationTable.leftcenterfightboxLocation[1]
		[INT]$leftfightboxLocationX = $ColorLocationTable.leftfightboxLocation[0]
		[INT]$leftfightboxLocationY = $ColorLocationTable.leftfightboxLocation[1]
		[INT]$PlayerPILeftLocationX = $ColorLocationTable.PlayerPILeftLocation[0]
		[INT]$PlayerPILeftLocationY = $ColorLocationTable.PlayerPILeftLocation[1]
		[INT]$PlayerPIRightLocationX = $ColorLocationTable.PlayerPIRightLocation[0]
		[INT]$PlayerPIRightLocationY = $ColorLocationTable.PlayerPIRightLocation[1]
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$rightcenterfightboxLocationX = $ColorLocationTable.rightcenterfightboxlocation[0]
		[INT]$rightcenterfightboxLocationY = $ColorLocationTable.rightcenterfightboxlocation[1]
		[INT]$rightfightboxLocationX = $ColorLocationTable.rightfightboxlocation[0]
		[INT]$rightfightboxLocationY = $ColorLocationTable.rightfightboxlocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			Write-Output "FightDetected"
			#Compare hero and enemy pi, adjust fight sequence
			$HeroPI = Hero-PI
			$EnemyPI = Enemy-PI
			if (($HeroPI -ne "unknown") -and ($EnemyPI -ne "unknown")) {
				if (($HeroPI * 0.75) -gt $EnemyPI) {
					$fightbehavior = "Aggressive"
				}
				elseif (($heroPI * 2) -le $EnemyPI) {
					$fightbehavior = "Evasive"
				}
				else {
					$fightbehavior = "Normal"
				}
			}
			else {
				$fightbehavior = "Normal"
			}
			$Writefightstyle = 0
			switch ($fightbehavior) {
				"Aggressive" {
					Do {
						Quick-Attack
						light-attack
						light-attack
						Quick-Attack
						Heavy-Attack
						light-attack
						Medium-attack
						light-attack
						light-attack
						Quick-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
				"Normal" {
					Do {
						Quick-Attack
						light-attack
						light-attack
						light-attack
						light-attack
						Avoid-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
				"Evasive" {
					Do {
						Block-Attack
						Quick-Attack
						light-attack
						light-attack
						light-attack
						light-attack
						Avoid-Attack
					}
					until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					Write-Output "FightEnded"
				}
			}
			
		}
		Until ($true -eq $false)
	}
	
	$ActivateSpecials = {
		
		#region assemblies
		#Select BlueStacks Window
		Add-Type -AssemblyName Microsoft.VisualBasic
		[Microsoft.VisualBasic.Interaction]::AppActivate((Get-Process | Where-Object { $_.Name -like "HD-Frontend" }).id)
		Add-Type -AssemblyName System.Drawing
		Add-Type -AssemblyName System.Windows.Forms
		#endregion
		#region functions
		function Get-PixelColor {
			Param (
				[Int]$X,
				[Int]$Y
			)
			$GetDisplayColor = Add-Type -MemberDefinition @'
[DllImport("user32.dll")]
static extern IntPtr GetDC(IntPtr hwnd);

[DllImport("user32.dll")]
static extern Int32 ReleaseDC(IntPtr hwnd, IntPtr hdc);

[DllImport("gdi32.dll")]
static extern uint GetPixel(IntPtr hdc,int nXPos,int nYPos);

static public int GetPixelColor(int x, int y)
{
    IntPtr hdc = GetDC(IntPtr.Zero);
    uint pixel = GetPixel(hdc, x, y);
    ReleaseDC(IntPtr.Zero,hdc);

    return (int)pixel;
}
'@ -Name GetDisplayColor -PassThru
			
			$ColorofPixel = ([System.Drawing.Color]::FromArgb($GetDisplayColor::GetPixelColor($X, $Y))).name
			if ($env:COMPUTERNAME -eq "MDB-SNIPER") {
				#"$X, $Y, $ColorofPixel" | out-file C:\Tools\Pixelcolors.txt -Append
			}
			Return $ColorofPixel
		}
		#endregion
		#region Import Locations and Colors
		$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
		$GreenSpecialColors = $ColorLocationTable.GreenSpecialColors
		$YellowSpecialColors = $ColorLocationTable.YellowSpecialColors
		$RedSpecialColors = $ColorLocationTable.RedSpecialColors
		$NoSpecialColors = $ColorLocationTable.SpecialColorS
		[INT]$RedSpecialLocationX = $ColorLocationTable.RedSpecialLocation[0]
		[INT]$RedSpecialLocationY = $ColorLocationTable.RedSpecialLocation[1]
		[INT]$YellowSpecialLocationX = $ColorLocationTable.YellowSpecialLocation[0]
		[INT]$YellowSpecialLocationY = $ColorLocationTable.YellowSpecialLocation[1]
		[INT]$GreenSpecialLocationX = $ColorLocationTable.GreenSpecialLocation[0]
		[INT]$GreenSpecialLocationY = $ColorLocationTable.GreenSpecialLocation[1]
		[INT]$SpecialLocationX = $ColorLocationTable.SpecialLocation[0]
		[INT]$SpecialLocationY = $ColorLocationTable.SpecialLocation[1]
		$pausecolors = $ColorLocationTable.pausecolors
		$PauseLocationX = $ColorLocationTable.pauseLocation[0]
		$PauseLocationY = $ColorLocationTable.pauseLocation[1]
		#endregion
		Import-Module WASP
		Do {
			#Sleep waiting for a fight to start
			Do {
				Start-Sleep -Milliseconds 200
			}
			until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
			$EnergyDrain = $false
			clear-host
			Do {
				$GreenCheck = if ($GreenSpecialColors -contains (Get-PixelColor -x $GreenSpecialLocationX -y $GreenSpecialLocationY)) { $True }
				$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
				$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
				If ($GreenCheck -eq $true) {
					write-host  "Wait for Yellow, if energy goes in reverse use any special"
					Do {
						$GreenCheck = if ($GreenSpecialColors -contains (Get-PixelColor -x $GreenSpecialLocationX -y $GreenSpecialLocationY)) { $True }
						$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
						if ($YellowCheck -eq $true) {
							do {
								write-host  "Wait for Red, if energy goes in reverse use any special"
								$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
								$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
								Start-Sleep -Milliseconds 200
								if ($RedCheck -eq $true) {
									write-host  "Use Special"
									do {
										Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
										Start-Sleep -Milliseconds 200
									}
									until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
								}
							}
							Until (($YellowCheck -eq $false) -or ($RedCheck -eq $true))
							if (($yellowcheck -eq $false) -and ($RedCheck -eq $false)) { $EnergyDrain = $true }
						}
						Start-Sleep -Milliseconds 1000
					}
					Until (($GreenCheck -eq $true) -or ($YellowCheck -eq $true))
					if (($yellowcheck -eq $false) -and ($greenCheck -eq $false)) { $EnergyDrain = $true }
				}
				elseif ($YellowCheck -eq $true) {
					do {
						write-host  "Wait for Red, if energy goes in reverse use any special"
						$YellowCheck = if ($YellowSpecialColors -contains (Get-PixelColor -x $YellowSpecialLocationX -y $YellowSpecialLocationY)) { $True }
						$RedCheck = if ($RedSpecialColors -contains (Get-PixelColor -x $RedSpecialLocationX -y $RedSpecialLocationY)) { $True }
						if ($RedCheck -eq $true) {
							write-host  "Use Special"
							do {
								Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
								Start-Sleep -Milliseconds 200
							}
							until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
						}
						Start-Sleep -Milliseconds 1000
					}
					Until (($YellowCheck -eq $true) -or ($RedCheck -eq $true))
					if (($yellowcheck -eq $false) -and ($RedCheck -eq $false)) { $EnergyDrain = $true }
				}
				elseif ($RedCheck -eq $true) {
					write-host  "Use Special"
					do {
						Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
						Start-Sleep -Milliseconds 200
					}
					until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
				}
				else {
					if ($EnergyDrain -eq $true) {
						do {
							if ($SpecialColors -notcontains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) {
								write-host  "Use Special"
								do {
									Select-Window -Title "Bluestacks App Player" | Send-Keys -Keys " "
									Start-Sleep -Milliseconds 200
								}
								until (($SpecialColors -contains (Get-PixelColor -x $SpecialLocationX -y $SpecialLocationY)) -or ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY)))
							}
						}
						until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
					}
				}
			}
			until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
		}
		until ($true -eq $false)
	}
	#endregion
	#region Import Locations and Colors
	$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
	$CollaspedMenuColors = $ColorLocationTable.CollaspedMenuColors
	$ExpandedMenuColors = $ColorLocationTable.ExpandedMenuColors
	$FightColors = $ColorLocationTable.FightColors
	$VersusColors = $ColorLocationTable.VersusColors
	$VersusColors2 = $ColorLocationTable.VersusColors2
	$threestarcolors = $ColorLocationTable.threestarcolors
	$fourstarcolors = $ColorLocationTable.fourstarcolors
	$findmatchcolors = $ColorLocationTable.findmatchcolors
	$acceptmatchcolors = $ColorLocationTable.acceptmatchcolors
	$acceptsortcolors = $ColorLocationTable.acceptsortcolors
	$continuecolors = $ColorLocationTable.continuecolors
	$pausecolors = $ColorLocationTable.pausecolors
	$GoHomeColors1 = $ColorLocationTable.GoHomeColors
	$GoHomeColors2 = $ColorLocationTable.GoHomeColors2
	$CollaspedMenuLocationX = $ColorLocationTable.CollaspedMenuLocation[0]
	$ExpandedMenuLocationX = $ColorLocationTable.ExpandedMenuLocation[0]
	$menufightLocationX = $ColorLocationTable.FightLocation[0]
	$VersusLocationX = $ColorLocationTable.VersusLocation[0]
	$VersusLocationX2 = $ColorLocationTable.VersusLocation2[0]
	$3starLocationX = $ColorLocationTable.threestarLocation[0]
	$4starLocationX = $ColorLocationTable.fourstarLocation[0]
	$FindmatchLocationX = $ColorLocationTable.findmatchLocation[0]
	$acceptmatchLocationX = $ColorLocationTable.acceptmatchLocation[0]
	$acceptsortLocationX = $ColorLocationTable.acceptsortLocation[0]
	$continueLocationX = $ColorLocationTable.continueLocation[0]
	$PauseLocationX = $ColorLocationTable.pauseLocation[0]
	$GoHomeLocationX1 = $ColorLocationTable.GoHomeLocation[0]
	$GoHomeLocationX2 = $ColorLocationTable.GoHomeLocation2[0]
	$CollaspedMenuLocationY = $ColorLocationTable.CollaspedMenuLocation[1]
	$ExpandedMenuLocationY = $ColorLocationTable.ExpandedMenuLocation[1]
	$menufightLocationY = $ColorLocationTable.FightLocation[1]
	$VersusLocationY = $ColorLocationTable.VersusLocation[1]
	$VersusLocationY2 = $ColorLocationTable.VersusLocation2[1]
	$3starLocationY = $ColorLocationTable.threestarLocation[1]
	$4starLocationY = $ColorLocationTable.fourstarLocation[1]
	$FindmatchLocationY = $ColorLocationTable.findmatchLocation[1]
	$acceptmatchLocationY = $ColorLocationTable.acceptmatchLocation[1]
	$acceptsortLocationY = $ColorLocationTable.acceptsortLocation[1]
	$continueLocationY = $ColorLocationTable.continueLocation[1]
	$PauseLocationY = $ColorLocationTable.pauseLocation[1]
	$GoHomeLocationY1 = $ColorLocationTable.GoHomeLocation[1]
	$GoHomeLocationY2 = $ColorLocationTable.GoHomeLocation2[1]
	$Global:Player1LocationX = $ColorLocationTable.Player1Location[0]
	$Global:Player2LocationX = $ColorLocationTable.Player2Location[0]
	$Global:Player3LocationX = $ColorLocationTable.Player3Location[0]
	$Global:Enemy1LocationX = $ColorLocationTable.Enemy1Location[0]
	$Global:Enemy2LocationX = $ColorLocationTable.Enemy2Location[0]
	$Global:Enemy3LocationX = $ColorLocationTable.Enemy3Location[0]
	$Global:Player1LocationY = $ColorLocationTable.Player1Location[1]
	$Global:Player2LocationY = $ColorLocationTable.Player2Location[1]
	$Global:Player3LocationY = $ColorLocationTable.Player3Location[1]
	$Global:Enemy1LocationY = $ColorLocationTable.Enemy1Location[1]
	$Global:Enemy2LocationY = $ColorLocationTable.Enemy2Location[1]
	$Global:Enemy3LocationY = $ColorLocationTable.Enemy3Location[1]
	#endregion
	#region jobs
	Start-Job -Name "Skip" -ScriptBlock $SkipJob | Out-Null
	Start-Job -Name "AfterTheFight" -ScriptBlock $AfterFight | out-null
	Start-Job -Name "ActivateSpecials" -ScriptBlock $ActivateSpecials | Out-Null
	if ($FightStyle -eq "Normal") {
		Start-Job -Name "FightSequence" -ScriptBlock $NormalFight | out-null
	}
	elseif ($FightStyle -eq "Aggressive") {
		Start-Job -Name "FightSequence" -ScriptBlock $AggressiveFight | out-null
	}
	elseif ($FightStyle -eq "Evasive") {
		Start-Job -Name "FightSequence" -ScriptBlock $EvasiveFight | out-null
	}
	elseif ($FightStyle -eq "Dynamic") {
		Start-Job -Name "FightSequence" -ScriptBlock $TessSequence | out-null
		
	}
	else {
		Start-Job -Name "FightSequence" -ScriptBlock $NormalFight | out-null
	} #default fight sequence
	
	#endregion
	move-bluestackswindow -top $bluestackstop -left $bluestacksleft
	Do {
		Do {
			Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
		}
		until ($pausecolors -contains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
		Write-Output "FightDetected"
		Do {
			Start-Sleep -Milliseconds 200; [System.Windows.Forms.Application]::DoEvents()
		}
		until ($pausecolors -notcontains (Get-PixelColor -x $PauseLocationX -y $PauseLocationY))
	}
	while (1 -gt 0)
}
#endregion
#region maintenance
$MotherShipUpdate = {
	$MotherShipURL = "https://www.dropbox.com/s/oionokck1vmhvqp/MotherShip.exe?raw=1"
	$MotherShipUpdaterURL = "https://www.dropbox.com/s/un4tyhbsx53q76l/MotherShipUpdater.exe?raw=1"
	$TempUpdateFile = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\mothership.exe"
	$TempUpdaterFile = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\mothershipupdater.exe"
	$wc = new-object system.net.webclient
	$wc.UseDefaultCredentials = $true
	$wc.downloadfile($MotherShipURL, $TempUpdateFile)
	$wc2 = new-object system.net.webclient
	$wc2.UseDefaultCredentials = $true
	$wc2.downloadfile($MotherShipUpdaterURL, $TempUpdaterFile)
	Copy-Item $TempUpdaterFile -Destination 'C:\Program Files (x86)\MotherShip\mothershipupdater.exe'
}
#endregion
#endregion
#region variables
$ErrorActionPreference = 'SilentlyContinue'
[Boolean]$Global:Bluestackswindowposition = $false
[int]$Global:possiblehang = 0
[int]$global:MotherShipProcessID = ([System.Diagnostics.Process]::GetCurrentProcess()).id
[int]$global:StatusLength = 0
[boolean]$Global:UseEnergyCheck = $false
[boolean]$Global:RestartMailSent = $false
[boolean]$global:mailsent = $false
[boolean]$global:EventQuestAlign = $false
[boolean]$Global:SkipEnergyCheck = $false
[boolean]$global:StopAll = $false
[DateTime]$global:sendtime = $null
[DateTime]$Globa:restartsendtime = $null
[DateTime]$Global:ExeAge = (Get-ItemProperty -Path 'C:\Program Files (x86)\MotherShip\MotherShip.exe').LastWriteTime
$errorlogpath = $env:USERPROFILE + "\desktop\mcocerror.log"
$MotherShipConfigPath = $env:USERPROFILE + "\documents\MotherShipConfiguration"
$mothershiptemppath = $env:USERPROFILE + "\appdata\local\temp\asdfesd1"
$savenotificationpath = (Get-ItemProperty -Path hklm:\software\MalliumSoftware\Mothership -Name NotificationAddress).NotificationAddress
$saveEulaAcceptpath = (Get-ItemProperty -Path hklm:\software\MalliumSoftware\Mothership -Name EULAAccepted).EULAAccepted
$saveconfigpath = (Get-ItemProperty -Path hklm:\software\MalliumSoftware\Mothership -Name Registration).Registration
if ($saveEulaAcceptpath -eq $null) {
	$savenotificationpath = (Get-ItemProperty -Path HKLM:\SOFTWARE\MalliumSoftware\Mothership -Name NotificationAddress).notificationaddress
	$saveEulaAcceptpath = (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\MalliumSoftware\Mothership -Name EULAAccepted).EULAAccepted
	$saveconfigpath = (Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\MalliumSoftware\Mothership -Name Registration).Registration
}
$saverunconfigpath = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\dacxasf.xml"
$Saveaoconfigpath = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\asdf31asf.xml"
$savefightdatapath = $env:USERPROFILE + "\appdata\local\temp\asdfesd1\asdf32ass.xml"
$NotificationTarget = $savenotificationpath
$computer = $env:COMPUTERNAME
$OS = (Get-WmiObject -computername $computer -class Win32_OperatingSystem).Caption
if ((Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer -ea 0).OSArchitecture -eq '64-bit') {
	$architecture = "64"
}
else {
	$architecture = "32"
}
[int]$Global:fightcount = 0
[int]$Global:averagefight = 0
$WillPower = $false
$UseOnlyTopSpecial = $false
$SaveFightData = $false
$StartMSwithWindows = $false
$SaveRunConfig = $false
$ClassSelector = "Normal"
$FightStyle = "Normal"
$Global:LootCount = 0
[DateTime]$Global:LastStatus = $null
[int]$Global:DeadmanTimer = 0
[boolean]$Global:Processing = $false
#endregion
#region Import Locations and Colors
$ColorLocationTable = import-Clixml -Path ($env:USERPROFILE + "\appdata\local\temp\asdfesd1\colortable.xml")
$continuecolors = $ColorLocationTable.continuecolors
$continueLocationX = $ColorLocationTable.continueLocation[0]
$continueLocationY = $ColorLocationTable.continueLocation[1]
$GoHomeColors1 = $ColorLocationTable.GoHomeColors
$GoHomeColors2 = $ColorLocationTable.GoHomeColors2
$GoHomeLocationX1 = $ColorLocationTable.GoHomeLocation[0]
$GoHomeLocationX2 = $ColorLocationTable.GoHomeLocation2[0]
$GoHomeLocationY1 = $ColorLocationTable.GoHomeLocation[1]
$GoHomeLocationY2 = $ColorLocationTable.GoHomeLocation2[1]
$CollaspedMenuColors = $ColorLocationTable.CollaspedMenuColors
$ExpandedMenuColors = $ColorLocationTable.ExpandedMenuColors
$CollaspedMenuLocationX = $ColorLocationTable.CollaspedMenuLocation[0]
$ExpandedMenuLocationX = $ColorLocationTable.ExpandedMenuLocation[0]
$CollaspedMenuLocationY = $ColorLocationTable.CollaspedMenuLocation[1]
$ExpandedMenuLocationY = $ColorLocationTable.ExpandedMenuLocation[1]
#endregion