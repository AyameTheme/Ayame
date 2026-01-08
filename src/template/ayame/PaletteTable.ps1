<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                             Ayame Palette Table                              │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │           Generates a markdown table listing all colors in Ayame.            │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
$Colors   = Get-Content '.\src\ayame-colors.json' -Raw | ConvertFrom-Json
$AyameRef = Get-Content '.\bin\ayame.json'        -Raw | ConvertFrom-Json
$IconURL  = 'bin/icon'

# Don’t waste three hours of your life like me and just accept the assignment.
$T = "``"

$Lines = @('') * $Colors.Count
$i     = 0
foreach ($Color in $Colors) {
    $Name    = $Color.name
    $Hex     = $AyameRef.colors.$($Color.name).hex
    $Uses    = $Color.uses -join ', '
    $Aliases = $(
        if ($Color.aliases.Count -gt 0) {
            ", $(($Color.aliases | ForEach-Object { "$T$_$T" }) -join ', ')"
        }
        else { '' }
    )
    $Lines[$i] = "| ![]($IconURL/$Name.svg) $T$Hex$T | $T$Name$T$Aliases | $Uses |"

    $i++
}
return $Lines -join "`n"
