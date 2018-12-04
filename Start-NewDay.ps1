[cmdletbinding()]
param([int]$Day)

@"
[cmdletbinding()]
param(
    [string[]]`$InputLines = (Get-Content "day$Day.input")
)

begin {
}

process {
}
"@ | Set-Content "day$day.ps1"
"" | Set-Content "day$day.input"
