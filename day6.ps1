[cmdletbinding()]
param(
    [string[]]$InputLines = (Get-Content "day6.input")
)

begin {
}

process {
    $LabeledPoints = $InputLines | Where-Object {$_ -match '(?<x>\d+), (?<y>\d+)'} | Foreach-Object { 
        [pscustomobject]@{
            PointName = $matches[0]
            x = [int]$matches.x
            y = [int]$matches.y
        } | Write-Output
    }

    $MaxX = $LabeledPoints | Measure-Object -Property x -Maximum | Select-Object -ExpandProperty Maximum
    $MaxY = $LabeledPoints | Measure-Object -Property y -Maximum | Select-Object -ExpandProperty Maximum
    $MaxGrid = (@($MaxX,$MaxY) | Sort-Object -Descending | Select-Object -First 1 )
    $MaxGrid = [int](([double]$MaxGrid) * 1.05)

    $GridPoints = New-Object 'System.Collections.Generic.List[object]' 
    $SafePoints = New-Object 'System.Collections.Generic.List[object]' 
    for ($x = 0; $x -le $MaxGrid; $x++) {
        for ($y = 0; $y -le $MaxGrid; $y++) {
            $MinDistance = $MaxGrid
            $MinPoint = $null
            $TotalDistance = 0

            for ($i = 0; $i -lt $LabeledPoints.Count; $i++) {
                $LabeledPoint = $LabeledPoints[$i]
                $Distance = [Math]::Abs($x - $LabeledPoint.x) + [Math]::Abs($y - $LabeledPoint.y) 

                $TotalDistance += $Distance
                
                if ($Distance -lt $MinDistance) {
                    $MinDistance = $Distance
                    $MinPoint = $LabeledPoint
                } elseif ($Distance -eq $MinDistance) {
                    $MinPoint = $null
                }
            }

            if ($TotalDistance -lt 10000) {
                $SafePoint = [pscustomobject]@{
                    x = $x
                    y = $y
                }
                $SafePoints.Add($SafePoint) | Out-Null
            }

            if ($MinPoint) {
                $MinPoint = [pscustomobject]@{
                    PointName = $MinPoint.PointName
                    x = $x
                    y = $y
                }
                $GridPoints.Add($MinPoint) | Out-Null
            }
        }
    }
    
    
    $NamedPointsWithBorder = $GridPoints | Where-Object {$_.x -eq 0 -or $_.x -eq $MaxGrid -or $_.y -eq 0 -or $_.y -eq $MaxGrid} | Select-Object -Unique -ExpandProperty PointName

    $Part1 = $GridPoints | Where-Object {$_.PointName -notin $NamedPointsWithBorder} | Group-Object PointName | Sort-Object Count -Descending | Select-Object -First 1 -ExpandProperty Count
    Write-Output "Part 1: $($Part1)"

    $Part2 = $SafePoints.Count
    Write-Output "Part 2: $($Part2)"

}
