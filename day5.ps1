[cmdletbinding()]
param(
    [string[]]$InputLines = (Get-Content "day5.input")
)

begin {
}

process {
    $Characters = $InputLines[0].ToCharArray()

    $stack = new-object System.Collections.Stack

    foreach ($c in $Characters) {
        if ($Stack.Count -gt 0 -and [Math]::Abs(([byte][char]$stack.Peek()) - ([byte][char]$c)) -eq 32) {
            $Stack.Pop() | Out-Null
        } else {
            $Stack.Push($c)
        }
    }

    Write-Output "Part 1: $($Stack.Count)"
}