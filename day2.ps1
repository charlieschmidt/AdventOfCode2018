[cmdletbinding()]
param(
    [string[]]$InputLines = (Get-Content "day2.input")
)

begin {
}

process {
    #region part1
    $Twos = 0
    $Threes = 0
    foreach ($line in $InputLines) {
        $Letters = $Line.ToCharArray()
        $Groups = $Letters | Group-Object
        if ($Groups | Where-Object {$_.Count -eq 3} | Select-Object -First 1) {
            $Threes++
        }

        if ($Groups | Where-Object {$_.Count -eq 2} | Select-Object -First 1) {
            $Twos++
        }
    }
    Write-Output "Part 1: $($Twos * $Threes)"
    #endregion
    

    #region part2
    :outer for ($i = 0; $i -lt $InputLines.Count; $i++) {
        :inner for ($j = $i+1; $j -lt $InputLines.Count; $j++) {
            $Line = $InputLines[$i]
            $OtherLine = $InputLines[$j]
            
            $Comparison = Compare-Object ($Line -split '')  ($OtherLine -split '') -SyncWindow 0 -IncludeEqual
            if (($Comparison | Where-Object {$_.SideIndicator -ne '=='}).count -eq 2) {
                
                $global:PartTwo =  $Comparison 
                $line
                $OtherLine
                $Same = ($Comparison | Where-Object {$_.SideIndicator -eq '=='} | Select-Object -Expand InputObject) -join ''
                Write-Output "Part 2: $Same"
                break outer
            }
        }
    }
    #endregion
}
