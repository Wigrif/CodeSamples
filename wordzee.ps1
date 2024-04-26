<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2023 v5.8.219
	 Created on:   	5/17/2023 9:20 PM
	 Created by:   	wigrif
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
	-Add bogus words as you find them to the $NotWords variable below.
    -Ensure your games bonus tiles are correct in the $Row variables below.
    -Remember to use max length words to ensure wordzee bonus
    -Using this excessively will give you harder opponents.
#>
$NotWords= 'BOKEH|HEVEA|TWEER|YUKE|artigi|xed|tegu|yessir|argh|doh'
$Row3 = ('','','DL')
$Row4 = ('','DL','','')
$Row5 = ('','TL','','','')
$Row6 = ('DL','','','','','DW')
$Row7 = ('','','','TL','','','TW')

$VerbosePreference = "Continue"
$VerbosePreference = "SilentlyContinue"
function Get-SeedLetters {
    Get-Random -InputObject $Letters -Count 7
}
#Get-SeedLetters | %{ $Temp = $Temp + $_ }

function Get-WordList {
    Param (
        [Parameter(Mandatory = $true)]
        $Letters
    )
    $URL = ('https://wordunscrambler.me/unscramble/' + $Letters)
    $WebRequest = Invoke-WebRequest -Uri $URL -UseBasicParsing
    $List = $WebRequest.links.outerHTML | %{
        if ($_ -match 'data') { $_ }
    } | %{$pos = $_.IndexOf('>')
        $leftPart = $_.Substring(0, $pos)
        $rightPart = $_.Substring($pos + 1)
        $rightPart
    } | %{
        ($_).split(("`r`n")) | select -First 1
    }
    if ($NotWords -ne $null){$List = $List | ?{ $_ -notmatch $NotWords } }
    return $List
}
#$WordList = Get-WordList
function Best-WordForRow3 {
    $Row = $Row3
    $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
    Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
    
    $Data = foreach ($Word in $TempWordList) {
        $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
        Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
        1 .. ($Word.length) | %{
            if ($_ -eq 1) { $WordValue = 0 }
            $Letter = $Word[($_ - 1)]
            Write-Verbose -Message ('Letter: ' + $Letter)
            $LetterPosition = $_
            Write-Verbose -Message ('LetterPosition: ' + $LetterPosition)
            #Determine Letter Position Multiplier
            $LetterMultiplier = 1
            if (($Row[($LetterPosition) - 1]) -eq "DL") { $LetterMultiplier = 2 }
            if (($Row[($LetterPosition) - 1]) -eq "TL") { $LetterMultiplier = 3 }
            Write-Verbose -Message ('LetterMultiplier: ' + $LetterMultiplier)
            #Determine Letter Base Value
            if ($Letter -match 'A|E|I|L|N|O|R|S|T') { $LetterBaseValue = 1 }
            if ($Letter -match 'D|U') { $LetterBaseValue = 2 }
            if ($Letter -match 'G|M') { $LetterBaseValue = 3 }
            if ($Letter -match 'B|C|F|H|P|V|W|Y') { $LetterBaseValue = 4 }
            if ($Letter -match 'K') { $LetterBaseValue = 5 }
            if ($Letter -match 'X') { $LetterBaseValue = 8 }
            if ($Letter -match 'J|Q|Z') { $LetterBaseValue = 10 }
            if ($Round -eq $null) { $Round = 1 }
            $LetterRoundValue = ($LetterBaseValue * $Round)
            Write-Verbose -Message ('Round Bonus: ' + $Round)
            Write-Verbose -Message ('Letter Base Value: ' + $LetterBaseValue)
            Write-Verbose -Message ('Letter Round Value: ' + $LetterRoundValue)
            #Determine Letter Position Value
            $LetterFinalValue = $LetterRoundValue * $LetterMultiplier
            Write-Verbose -Message ('Letter Final Value: ' + $LetterFinalValue)
            $WordValue = $WordValue + $LetterFinalValue
            
            #Determine Word Multiplier
            if ($LetterPosition -eq $Word.length) {
                $WordMultiplier = 1
                if ($Row -eq "DW") { $WordMultiplier = 2 }
                if ($Row -eq "TW") { $WordMultiplier = 3 }
                Write-Verbose -Message ('WordMultiplier: ' + $WordMultiplier)
                $FinalWordValue = $WordValue * $WordMultiplier
                Write-Verbose -Message ('===')
            }
        }
        #Word Value
        $Hash = @{
            Row = $Row.Length
            __Word__ = $Word
            Value = $FinalWordValue
        }
        New-Object PSObject -Property $Hash
    }
    $Data | select Row, __Word__, Value | sort Value -Descending | select -First 1
}
function Best-WordForRow4 {
    $Row = $Row4
    $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
    Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
    
    $Data = foreach ($Word in $TempWordList) {
        $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
        Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
        1 .. ($Word.length) | %{
            if ($_ -eq 1) { $WordValue = 0 }
            $Letter = $Word[($_ - 1)]
            Write-Verbose -Message ('Letter: ' + $Letter)
            $LetterPosition = $_
            Write-Verbose -Message ('LetterPosition: ' + $LetterPosition)
            #Determine Letter Position Multiplier
            $LetterMultiplier = 1
            if (($Row[($LetterPosition) - 1]) -eq "DL") { $LetterMultiplier = 2 }
            if (($Row[($LetterPosition) - 1]) -eq "TL") { $LetterMultiplier = 3 }
            Write-Verbose -Message ('LetterMultiplier: ' + $LetterMultiplier)
            #Determine Letter Base Value
            if ($Letter -match 'A|E|I|L|N|O|R|S|T') { $LetterBaseValue = 1 }
            if ($Letter -match 'D|U') { $LetterBaseValue = 2 }
            if ($Letter -match 'G|M') { $LetterBaseValue = 3 }
            if ($Letter -match 'B|C|F|H|P|V|W|Y') { $LetterBaseValue = 4 }
            if ($Letter -match 'K') { $LetterBaseValue = 5 }
            if ($Letter -match 'X') { $LetterBaseValue = 8 }
            if ($Letter -match 'J|Q|Z') { $LetterBaseValue = 10 }
            if ($Round -eq $null) { $Round = 1 }
            $LetterRoundValue = ($LetterBaseValue * $Round)
            Write-Verbose -Message ('Round Bonus: ' + $Round)
            Write-Verbose -Message ('Letter Base Value: ' + $LetterBaseValue)
            Write-Verbose -Message ('Letter Round Value: ' + $LetterRoundValue)
            #Determine Letter Position Value
            $LetterFinalValue = $LetterRoundValue * $LetterMultiplier
            Write-Verbose -Message ('Letter Final Value: ' + $LetterFinalValue)
            $WordValue = $WordValue + $LetterFinalValue
            
            #Determine Word Multiplier
            if ($LetterPosition -eq $Word.length) {
                $WordMultiplier = 1
                if ($Row -eq "DW") { $WordMultiplier = 2 }
                if ($Row -eq "TW") { $WordMultiplier = 3 }
                Write-Verbose -Message ('WordMultiplier: ' + $WordMultiplier)
                $FinalWordValue = $WordValue * $WordMultiplier
                Write-Verbose -Message ('===')
            }
        }
        #Word Value
        $Hash = @{
            Row = $Row.Length
            __Word__ = $Word
            Value = $FinalWordValue
        }
        New-Object PSObject -Property $Hash
    }
    $Data | select Row, __Word__, Value | sort Value -Descending | select -First 1
}
function Best-WordForRow5 {
    $Row = $Row5
    $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
    Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
    
    $Data = foreach ($Word in $TempWordList) {
        $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
        Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
        1 .. ($Word.length) | %{
            if ($_ -eq 1) { $WordValue = 0 }
            $Letter = $Word[($_ - 1)]
            Write-Verbose -Message ('Letter: ' + $Letter)
            $LetterPosition = $_
            Write-Verbose -Message ('LetterPosition: ' + $LetterPosition)
            #Determine Letter Position Multiplier
            $LetterMultiplier = 1
            if (($Row[($LetterPosition) - 1]) -eq "DL") { $LetterMultiplier = 2 }
            if (($Row[($LetterPosition) - 1]) -eq "TL") { $LetterMultiplier = 3 }
            Write-Verbose -Message ('LetterMultiplier: ' + $LetterMultiplier)
            #Determine Letter Base Value
            if ($Letter -match 'A|E|I|L|N|O|R|S|T') { $LetterBaseValue = 1 }
            if ($Letter -match 'D|U') { $LetterBaseValue = 2 }
            if ($Letter -match 'G|M') { $LetterBaseValue = 3 }
            if ($Letter -match 'B|C|F|H|P|V|W|Y') { $LetterBaseValue = 4 }
            if ($Letter -match 'K') { $LetterBaseValue = 5 }
            if ($Letter -match 'X') { $LetterBaseValue = 8 }
            if ($Letter -match 'J|Q|Z') { $LetterBaseValue = 10 }
            if ($Round -eq $null) { $Round = 1 }
            $LetterRoundValue = ($LetterBaseValue * $Round)
            Write-Verbose -Message ('Round Bonus: ' + $Round)
            Write-Verbose -Message ('Letter Base Value: ' + $LetterBaseValue)
            Write-Verbose -Message ('Letter Round Value: ' + $LetterRoundValue)
            #Determine Letter Position Value
            $LetterFinalValue = $LetterRoundValue * $LetterMultiplier
            Write-Verbose -Message ('Letter Final Value: ' + $LetterFinalValue)
            $WordValue = $WordValue + $LetterFinalValue
            
            #Determine Word Multiplier
            if ($LetterPosition -eq $Word.length) {
                $WordMultiplier = 1
                if ($Row -eq "DW") { $WordMultiplier = 2 }
                if ($Row -eq "TW") { $WordMultiplier = 3 }
                Write-Verbose -Message ('WordMultiplier: ' + $WordMultiplier)
                $FinalWordValue = $WordValue * $WordMultiplier
                Write-Verbose -Message ('===')
            }
        }
        #Word Value
        $Hash = @{
            Row = $Row.Length
            __Word__ = $Word
            Value = $FinalWordValue
        }
        New-Object PSObject -Property $Hash
    }
    $Data | select Row, __Word__, Value | sort Value -Descending | select -First 1
}
function Best-WordForRow6 {
    $Row = $Row6
    $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
    Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
    
    $Data = foreach ($Word in $TempWordList) {
        $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
        Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
        1 .. ($Word.length) | %{
            if ($_ -eq 1) { $WordValue = 0 }
            $Letter = $Word[($_ - 1)]
            Write-Verbose -Message ('Letter: ' + $Letter)
            $LetterPosition = $_
            Write-Verbose -Message ('LetterPosition: ' + $LetterPosition)
            #Determine Letter Position Multiplier
            $LetterMultiplier = 1
            if (($Row[($LetterPosition) - 1]) -eq "DL") { $LetterMultiplier = 2 }
            if (($Row[($LetterPosition) - 1]) -eq "TL") { $LetterMultiplier = 3 }
            Write-Verbose -Message ('LetterMultiplier: ' + $LetterMultiplier)
            #Determine Letter Base Value
            if ($Letter -match 'A|E|I|L|N|O|R|S|T') { $LetterBaseValue = 1 }
            if ($Letter -match 'D|U') { $LetterBaseValue = 2 }
            if ($Letter -match 'G|M') { $LetterBaseValue = 3 }
            if ($Letter -match 'B|C|F|H|P|V|W|Y') { $LetterBaseValue = 4 }
            if ($Letter -match 'K') { $LetterBaseValue = 5 }
            if ($Letter -match 'X') { $LetterBaseValue = 8 }
            if ($Letter -match 'J|Q|Z') { $LetterBaseValue = 10 }
            if ($Round -eq $null) { $Round = 1 }
            $LetterRoundValue = ($LetterBaseValue * $Round)
            Write-Verbose -Message ('Round Bonus: ' + $Round)
            Write-Verbose -Message ('Letter Base Value: ' + $LetterBaseValue)
            Write-Verbose -Message ('Letter Round Value: ' + $LetterRoundValue)
            #Determine Letter Position Value
            $LetterFinalValue = $LetterRoundValue * $LetterMultiplier
            Write-Verbose -Message ('Letter Final Value: ' + $LetterFinalValue)
            $WordValue = $WordValue + $LetterFinalValue
            
            #Determine Word Multiplier
            $WordMultiplier = 1
            if ($LetterPosition -eq $Row.length) {
                if ($Row -eq "DW") { $WordMultiplier = 2 }
                if ($Row -eq "TW") { $WordMultiplier = 3 }
            }
            Write-Verbose -Message ('WordMultiplier: ' + $WordMultiplier)
            $FinalWordValue = $WordValue * $WordMultiplier
            Write-Verbose -Message ('===')
        }
        #Word Value
        $Hash = @{
            Row = $Row.Length
            __Word__ = $Word
            Value = $FinalWordValue
        }
        New-Object PSObject -Property $Hash
    }
    $Data | select Row, __Word__, Value | sort Value -Descending | select -First 1
}
function Best-WordForRow7 {
    $Row = $Row7
    $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
    Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
    
    $Data = foreach ($Word in $TempWordList) {
        $TempWordList = $WordList | ?{ $_.length -le $Row.Length }
        Write-Verbose -Message ('TempWordList: ' + "`n" + $TempWordList)
        1 .. ($Word.length) | %{
            if ($_ -eq 1) { $WordValue = 0 }
            $Letter = $Word[($_ - 1)]
            Write-Verbose -Message ('Letter: ' + $Letter)
            $LetterPosition = $_
            Write-Verbose -Message ('LetterPosition: ' + $LetterPosition)
            #Determine Letter Position Multiplier
            $LetterMultiplier = 1
            if (($Row[($LetterPosition) - 1]) -eq "DL") { $LetterMultiplier = 2 }
            if (($Row[($LetterPosition) - 1]) -eq "TL") { $LetterMultiplier = 3 }
            Write-Verbose -Message ('LetterMultiplier: ' + $LetterMultiplier)
            #Determine Letter Base Value
            if ($Letter -match 'A|E|I|L|N|O|R|S|T') { $LetterBaseValue = 1 }
            if ($Letter -match 'D|U') { $LetterBaseValue = 2 }
            if ($Letter -match 'G|M') { $LetterBaseValue = 3 }
            if ($Letter -match 'B|C|F|H|P|V|W|Y') { $LetterBaseValue = 4 }
            if ($Letter -match 'K') { $LetterBaseValue = 5 }
            if ($Letter -match 'X') { $LetterBaseValue = 8 }
            if ($Letter -match 'J|Q|Z') { $LetterBaseValue = 10 }
            if ($Round -eq $null) { $Round = 1 }
            $LetterRoundValue = ($LetterBaseValue * $Round)
            Write-Verbose -Message ('Round Bonus: ' + $Round)
            Write-Verbose -Message ('Letter Base Value: ' + $LetterBaseValue)
            Write-Verbose -Message ('Letter Round Value: ' + $LetterRoundValue)
            #Determine Letter Position Value
            $LetterFinalValue = $LetterRoundValue * $LetterMultiplier
            Write-Verbose -Message ('Letter Final Value: ' + $LetterFinalValue)
            $WordValue = $WordValue + $LetterFinalValue
            
            #Determine Word Multiplier
            $WordMultiplier = 1
            if ($LetterPosition -eq $Row.length) {
                if ($Row -eq "DW") { $WordMultiplier = 2 }
                if ($Row -eq "TW") { $WordMultiplier = 3 }
            }
            Write-Verbose -Message ('WordMultiplier: ' + $WordMultiplier)
            $FinalWordValue = $WordValue * $WordMultiplier
            Write-Verbose -Message ('===')
        }
        #Word Value
        $Hash = @{
            Row = $Row.Length
            __Word__ = $Word
            Value = $FinalWordValue
        }
        New-Object PSObject -Property $Hash
    }
    $Data | select Row, __Word__, Value | sort Value -Descending | select -First 1
}
function Wordzee {
    Param (
        [Parameter(Mandatory = $true)]
        $Round,
        [Parameter(Mandatory = $true)]
        $Letters
    )
    $WordList = Get-WordList $Letters
    Best-WordForRow3
    Best-WordForRow4
    Best-WordForRow5
    Best-WordForRow6
    Best-WordForRow7
}
cls
wordzee -Round 2 -Letters zeremol




#Special event layout
$Row3 = ('TL','DL','TL','  ','DW','DW','DW')
$Row4 = ('DL','  ','DL','  ','TW')
$Row5 = ('DL','  ','  ','DL','DW','TW')
$Row6 = ('  ','TL','DW','DW','  ')
$Row7 = ('  ','DL','  ','DL','  ','TW','TW')


