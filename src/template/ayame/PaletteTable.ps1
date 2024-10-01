$Colors  = Get-Content '.\src\ayame-colors.json' -Raw | ConvertFrom-Json
$IconURL = 'bin/icon'

# Don’t waste three hours of your life like me and just accept the assignment.
$T = "``"

foreach ($Color in $Colors) {
    $Name    = $Color.name
    $Hex     = $Color.hex
    $Uses    = $Color.uses -join ', '
    $Aliases = $(
        if ($Color.aliases.Count -gt 0) {
            ", $(($Color.aliases | ForEach-Object { "$T$_$T" }) -join ', ')"
        }
        else { '' }
    )
    "| ![]($IconURL/$Name.svg) $T$Hex$T | $T$Name$T$Aliases | $Uses |"
}
