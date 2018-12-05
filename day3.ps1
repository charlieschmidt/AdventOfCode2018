[cmdletbinding()]
param(
    [string[]]$InputLines = (Get-Content "day3.input")
)

begin {
}

process {
    $InputObjects = $InputLines | Where-Object {$_ -match '#(?<Id>\d+) @ (?<LeftOffset>\d+),(?<TopOffset>\d+): (?<Width>\d+)x(?<Height>\d+)'} | Foreach-Object { 
        [pscustomobject]@{
            LeftOffset = [int]$Matches.LeftOffset
            TopOffset = [int]$Matches.TopOffset
            Width = [int]$Matches.Width
            Height = [int]$Matches.Height
            Id = $Matches.Id
        } | Write-Output
    }
    
    $Map = @{}

    foreach ($Box in $InputObjects) {
        for ($i = $Box.LeftOffset; $i -lt ($Box.LeftOffset + $Box.Width); $i++) {
            for ($j = $Box.TopOffset; $j -lt ($Box.TopOffset + $Box.Height); $j++) {
                $Key = "$i x $j"
                if ($Map.ContainsKey($Key)) {
                    $Map[$Key]++
                } else {
                    $Map[$Key] = 1
                }
            }
        }
    }
 
    $PartOne = $Map.GetEnumerator() | Where-Object {$_.Value -gt 1} | Measure-Object | Select-Object -Expand Count
    Write-output "Part 1: $PartOne"


    foreach ($Box in $InputObjects) {
        $Overlaps = $false
        for ($i = $Box.LeftOffset; $i -lt ($Box.LeftOffset + $Box.Width); $i++) {
            for ($j = $Box.TopOffset; $j -lt ($Box.TopOffset + $Box.Height); $j++) {
                $Key = "$i x $j"
                if ($Map[$Key] -gt 1) {
                    $Overlaps = $true
                }
            }
        }
        if ($Overlaps -eq $false) {
            Write-Output "Part 2 : $($Box.Id)"
            break
        }
    }
}
