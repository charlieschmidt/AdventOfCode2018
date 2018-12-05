[cmdletbinding()]
param(
    [string[]]$InputLines = (Get-Content "day4.input")
)

begin {
}

process {
    $InputObjects = $InputLines | Where-Object {$_ -match '^\[(?<date>[\-0-9]+) (?<hour>\d\d)\:(?<minute>\d\d)\] (?<info>(wakes up|falls asleep|Guard #(?<guard>\d+) begins shift))$'} | Foreach-Object {
        [pscustomobject]@{
            date = $matches['date']
            hour = [int]$matches['hour']
            minute = [int]$matches['minute']
            info = $matches['info']
            guard = [int]$matches['guard']
         } | write-output
    } | Sort-Object -Property Date,Hour,Minute

    $MinuteSleepCounts = @{}
    0..59 |% {$MinuteSleepCounts[$_] = 0}

    $GuardsSchedule = @{}
    $InputObjects.Guard | Select-Object -Unique | Foreach-Object {
        $GuardsSchedule[$_] = $MinuteSleepCounts.Clone()
    }

    $StartAsleep = $null
    $GuardOnDuty = $null
    foreach ($Instruction in $InputObjects) {
        switch -regex ($Instruction.info) {
            'guard.*' {
                $GuardOnDuty = $Instruction.Guard
            }
            'falls asleep' {
                $StartAsleep = $Instruction.Minute
            }
            'wakes up' {
                $GuardSchedule = $GuardsSchedule[$GuardOnDuty]
                for ($i = $StartAsleep; $i -lt $Instruction.Minute; $i++) {
                    $GuardSchedule[$i]++
                }
                $StartAsleep = $null
            }
        }
    }

    $GuardMostAsleep = $GuardsSchedule.GetEnumerator() | Foreach-Object {
        [pscustomobject]@{
            Guard = $_.Key
            MinutesAsleep = ($_.Value.Values | Measure-Object -sum).Sum
        }
    } | Sort-Object -Descending -Property MinutesAsleep | Select-Object -First 1 -ExpandProperty Guard

    $GuardSchedule = $GuardsSchedule[$GuardMostAsleep]
    $MinuteMostAsleep = $GuardSchedule.GetEnumerator() | Sort-Object -Descending Value | Select-Object -First 1 -ExpandProperty Key
    
    Write-Output "Part 1: $($GuardMostAsleep * $MinuteMostAsleep)"

    $GuardMostAsleepParticularMinute = $GuardsSchedule.GetEnumerator() | Foreach-Object {
        $Guard = $_.Key
        $_.Value.GetEnumerator() | Foreach-Object {
            [pscustomobject]@{
                Guard = $Guard
                Minute = $_.Key
                TimesAsleep = $_.Value
            } | Write-Output
        } | Write-Output
    } | Sort-Object -Descending TimesAsleep | Select -First 1

    Write-Output "Part 2: $($GuardMostAsleepParticularMinute.Guard * $GuardMostAsleepParticularMinute.Minute)"
}
