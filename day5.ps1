[cmdletbinding()]
param(
    [string[]]$InputLines = (Get-Content "day5.input")
)

begin {
}

process {

    function React {
        param($Characters)
        process {
            $stack = new-object System.Collections.Stack

            foreach ($c in $Characters) {
                if ($Stack.Count -gt 0 -and [Math]::Abs(([byte][char]$stack.Peek()) - ([byte][char]$c)) -eq 32) {
                    $Stack.Pop() | Out-Null
                } else {
                    $Stack.Push($c)
                }
            }

            $Stack.Count | Write-Output    
        }
    }

    $InputCharacters = $InputLines[0].ToCharArray()
    $Part1 = React -Characters $InputCharacters

    Write-Output "Part 1: $($Part1)"

    $Part2 = $InputLines[0].ToLower().ToCharArray() | Select-Object -Unique | foreach-object {
        $TryCharacter = $_
        $TryCharactersLeft = ($InputLines[0] -replace $TryCharacter,'').ToCharArray()

        $TryLength = React -Characters $TryCharactersLeft

        [PSCustomObject]@{
            Character = $TryCharacter
            Length = $TryLength
        } | Write-Output
    } | Sort-Object -Property Length | Select-Object -First 1 -ExpandProperty Length
    
    
    Write-Output "Part 2: $($Part2)"
}