[cmdletbinding()]
param(
    [string[]]$InputLines = (Get-Content "day1.input")
)

begin {
}

process {
    $PartOne = $InputLines | Measure-Object -Sum | Select-Object -Expand Sum
    Write-Output "Part 1: $PartOne"

    [int]$s = 0
    [int]$i = 0
    $seen = @{0 = 1}
    while ($true) {
        $s += $InputLines[$i % ($InputLines.Count)]
        if ($seen.ContainsKey($s)) {
            write-output "Part 2: $s"
            break
        } else {
            
            $seen[$s] = 1
        }
        $i++
    }
}
