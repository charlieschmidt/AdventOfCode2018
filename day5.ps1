[cmdletbinding()]
param(
    [string]$InputString = (Get-Content "day5.input")
)

begin {
    function Optimize-Polymer {
        param([string]$PolymerString)
        
        process {
            $stack = new-object System.Collections.Stack

            foreach ($c in $PolymerString.ToCharArray()) {
                $i = [byte][char]$c
                if ($Stack.Count -gt 0 -and [Math]::Abs($stack.Peek() - $i) -eq 32) {
                    $Stack.Pop() | Out-Null
                } else {
                    $Stack.Push($i)
                }
            }

            $Stack.Count | Write-Output    
        }
    }
}

process {
    $Part1 = Optimize-Polymer -PolymerString $InputString

    Write-Output "Part 1: $($Part1)"


    $Part2 = $InputString.ToLower().ToCharArray() | Select-Object -Unique | foreach-object {
        [pscustomobject]@{
            Character = $_
            Length = Optimize-Polymer -PolymerString ($InputString -replace $_,'')
        } | Write-Output
    } | Sort-Object -Property Length | Select-Object -First 1 -ExpandProperty Length   
    
    Write-Output "Part 2: $($Part2)"
}
