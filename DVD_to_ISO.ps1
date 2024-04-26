#DVD to ISO
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer 
$DVDPath = (Get-CimInstance Win32_CDROMDrive |?{$_.Caption -notmatch 'Virtual'}).Drive
$DVDName = (Get-CimInstance Win32_CDROMDrive |?{$_.Caption -notmatch 'Virtual'}).VolumeName
$DestPath = "G:\DVDCOPY\$DVDName.iso" #no slash
function Eject-DVD {
    (new-object -COM Shell.Application).NameSpace(17).ParseName($DVDPath).InvokeVerb('Eject')
}
function Rip-DVD {
    "Waiting for disc..."
    $speak.Speak('Waiting for disk')
    do { Start-Sleep -Seconds 1 } until ((Get-CimInstance Win32_CDROMDrive |?{$_.Caption -notmatch 'Virtual'}).VolumeName -ne $null)
    
    "Disc Loaded, waiting for VLC..."
    $speak.Speak('Disk Loaded, Waiting for V L C')
    do { Start-sleep -Seconds 1 } until (get-process VLC -ErrorAction SilentlyContinue)
    Start-Sleep -Seconds 5
    
    "VLC loaded, initiating rip"
    (Select-Window -ProcessName vlc).minimize()
    $speak.Speak('V L C loaded, initiating rip')
    $DVDPath = (Get-CimInstance Win32_CDROMDrive |?{$_.Caption -notmatch 'Virtual'}).Drive
    $DVDName = (Get-CimInstance Win32_CDROMDrive |?{$_.Caption -notmatch 'Virtual'}).VolumeName
    $DestPath = "K:\Homeschool_Media\Grade_06\$DVDName.iso" #no slash
    if (Test-Path $DestPath) {
        "Save path exists..."
        $speak.Speak('I think you did this one already')
        
        "Stopping VLC"
        $speak.Speak('Stopping V L C')
        do { Start-sleep -Seconds 1; Get-Process VLC -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue } until (!(get-process VLC -ErrorAction SilentlyContinue))
        Start-Sleep -Seconds 3
        Eject-DVD
    }
    if (!(Test-Path $DestPath)) {
        $speak.Speak('Ripping')
        & 'C:\Program Files (x86)\ImgBurn\ImgBurn.exe' /MODE READ /START /DEST $DestPath
        do { Start-sleep -Seconds 1 } until (!(get-process imgburn -ErrorAction SilentlyContinue))
        $speak.Speak('Stopping V L C')
        do { Start-sleep -Seconds 1; Get-Process VLC -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue } until (!(get-process VLC -ErrorAction SilentlyContinue))
        Start-Sleep -Seconds 3
        #$speak.Speak('Moving Files')
        #(dir 'g:\dvdcopy').fullname
        #Start-Process 'c:\Program Files\TeraCopy\TeraCopy.exe' -ArgumentList "Move G:\DVDCopy\ K:\Homeschool_Media\Grade_06"
        Eject-DVD
        $speak.Speak('Ready to repeat')
    }
}
while ($true) { Rip-DVD }
