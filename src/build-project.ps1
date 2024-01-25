$PrevCWD = (Get-Item .).FullName
Set-Location $PSScriptRoot

$Ayame = Get-Content '.\ayame-colors.json' -Raw | ConvertFrom-Json

# --( Path Variables )----------------------------------------------------------

$AyameVariablesPath = 'ayame-variables.styl'
$AyameHexPath = 'ayame-hex.styl'
$AyameRGBPath = 'ayame-rgb.styl'
$AyameHSLPath = 'ayame-hsl.styl'
$IconsPath = '..\out\icon'
$ReadmePath = '..\README.md'
$ReadmeTemplatePath = '.\readme-template.md'

# --( ayame-variables.styl )----------------------------------------------------

$Prefix = '--ayame-'

Set-Content -Path $AyameVariablesPath -Value @"
$(($Ayame.colors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "aya-$($_.name) = var($Prefix$($_.name))$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "aya-$_ = var($Prefix$_)$Comment"
    }) -Join "`n"
}) -Join "`n")
:root
$(($Ayame.colors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " /* $($_.uses -Join ', ') */"
    }
    "    $($Prefix)$($_.name) $($_.hex);$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " /* $($ThisColor.uses -Join ', ') */"
        }
        "    $($Prefix)$_ aya-$($ThisColor.name);$Comment"
    }) -Join "`n"
}) -Join "`n")
"@

# --( ayame-hex.styl )----------------------------------------------------------

Set-Content -Path $AyameHexPath -Value @"
$(($Ayame.colors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "ayahex-$($_.name) = $($_.hex)$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayahex-$_ = $($ThisColor.hex)$Comment"
    }) -Join "`n"
}) -Join "`n")
"@

# --( ayame-rgb.styl )----------------------------------------------------------

Set-Content -Path $AyameRGBPath -Value @"
$(($Ayame.colors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "ayargb-$($_.name) = $($_.rgb)$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayargb-$_ = $($ThisColor.rgb)$Comment"
    }) -Join "`n"
}) -Join "`n")
"@

# --( ayame-hsl.styl )----------------------------------------------------------

Set-Content -Path $AyameHSLPath -Value @"
$(($Ayame.colors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "ayahsl-$($_.name) = $($_.hsl)$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayahsl-$_ = $($ThisColor.hsl)$Comment"
    }) -Join "`n"
}) -Join "`n")
"@

# --( out/icon/*.svg ) ---------------------------------------------------------

if (Test-Path $IconsPath) {
    Get-ChildItem $IconsPath | ForEach-Object { Remove-Item $_ -Recurse }
}
else {
    New-Item -ItemType Directory -Path $IconsPath -Force | Out-Null
}

foreach ($Color in $Ayame.colors) {
    $SVGPath = Join-Path -Path $IconsPath -ChildPath "$($Color.name).svg" 
    $SVGContent = @"
<svg width="16" height="16" xmlns="http://www.w3.org/2000/svg">
  <circle cx="8" cy="8" r="8" fill="$($Color.hex)" />
</svg>
"@
    New-Item -Path $SVGPath -Value $SVGContent | Out-Null
}

# --( README.md ) --------------------------------------------------------------

$IconURL = 'https://raw.githubusercontent.com/Nurdoidz/Ayame/master/out/icon/'

# Don’t waste three hours of your life like me and just accept the assignment
$Backtick = "``"

$AyamePaletteTable = ($Ayame.colors | ForEach-Object {
    @(
        "| ![]($($IconURL)$($_.name).svg) ``$($_.hex)`` |",
        " ``$($_.name)``",
        "$($_.aliases.Count -gt 0 ? ', ' : '')",
        "$(($_.aliases | ForEach-Object {
            "$Backtick$_$Backtick"
        }) -Join ', ') |",
        " $($_.uses -Join ', ') |"
    ) -Join ''
}) -Join "`n"

(Get-Content $ReadmeTemplatePath).Replace('@-ayame-palette-table', $AyamePaletteTable) | Set-Content $ReadmePath

Set-Location $PrevCWD

# --( Stylus ) -----------------------------------------------------------------

npx stylus src/ayame-variables.styl
npx stylus src/usercss --out out/usercss
