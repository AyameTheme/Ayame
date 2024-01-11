$PrevCWD = (Get-Item .).FullName
Set-Location $PSScriptRoot

$Ayame = Get-Content '.\ayame-colors.json' -Raw | ConvertFrom-Json

# --( Path Variables )----------------------------------------------------------

$CSSVariablesPath = '..\out\ayame-variables.css'
$IconsPath = '..\out\icon'

# --( out/ayame-variables.css )-------------------------------------------------

$AliasesCount = 0
foreach ($Color in $Ayame.colors) {
    $AliasesCount += $Color.aliases.Count
}

$CSSAliases = [string[]]::new($AliasesCount)
$CSSVariables = [string[]]::new($Ayame.colors.Count)
$AliasIdx = 0

for ($ColorIdx = 0; $ColorIdx -lt $Ayame.colors.Count; $ColorIdx++) {
    $ThisColor = $Ayame.colors[$ColorIdx]
    $CSSVariables[$ColorIdx] = "  --ayame-$($ThisColor.name): $($ThisColor.hex);"
    
    if ($ThisColor.uses.Count -gt 0) {
        $CSSVariables[$ColorIdx] += " /* $($ThisColor.uses -Join ", ") */"
    }

    for ($ThisAliasIdx = 0; $ThisAliasIdx -lt $ThisColor.aliases.Count; $ThisAliasIdx++) {
        $ThisAlias = $ThisColor.aliases[$ThisAliasIdx]
        $CSSAliases[$AliasIdx] = "  --ayame-$($ThisAlias): var(--ayame-$($ThisColor.name));"

        if ($ThisColor.uses.Count -gt 0) {
            $CSSAliases[$AliasIdx] += " /* $($ThisColor.uses -Join ", ") */"
        }

        $AliasIdx++
    }
}

Set-Content -Path $CSSVariablesPath -Value @"
:root {
$($CSSVariables -Join "`n")
$($CSSAliases -Join "`n")
}
"@

# --( out/icon/*.svg ) ---------------------------------------------------------

if (Test-Path $IconsPath) {
    Get-ChildItem $IconsPath | ForEach-Object { Remove-Item $_ -Recurse }
}
else {
    New-Item -ItemType Directory -Path $IconsPath -Force
}

foreach ($Color in $Ayame.colors) {
    $SVGPath = Join-Path -Path $IconsPath -ChildPath "$($Color.name).svg" 
    $SVGContent = @"
<svg width="16" height="16" xmlns="http://www.w3.org/2000/svg">
  <circle cx="8" cy="8" r="8" fill="$($Color.hex)" />
</svg>
"@
    New-Item -Path $SVGPath -Value $SVGContent
}

Set-Location $PrevCWD
