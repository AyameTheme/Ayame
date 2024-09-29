# TODO: Add a non-positional parameter "All".
# TODO: Add parameters for specific scripts.
$PrevCWD = (Get-Item .).FullName
Set-Location $PSScriptRoot

. .\src\script\util\ColorConversion.ps1

$AyameColors = Get-Content '.\src\ayame-colors.json' -Raw | ConvertFrom-Json

# -- Path Variables ------------------------------------------------------------

$AyameRefPath       = '.\bin\ayame.json' # JSON holding Ayame reference object
$AyameVariablesPath = '.\src\ayame-variables.styl'
$AyameHexPath       = '.\src\ayame-hex.styl'
$AyameRGBPath       = '.\src\ayame-rgb.styl'
$AyameHSLPath       = '.\src\ayame-hsl.styl'
$IconsPath          = '.\bin\icon'
$ReadmePath         = '.\README.md'
$ReadmeTemplatePath = '.\src\readme-template.md'

# -- Ayame Reference JSON ------------------------------------------------------

$AyameRef = [ordered]@{
    version = ''
    colors  = [ordered]@{}
}

$AyameRef.version = (Get-Content '.\package.json' -Raw | ConvertFrom-Json).version

foreach ($Color in $AyameColors) {
    $ColorDef      = Convert-HexToRgbHsl $Color.hex
    $ColorDef.uses = $Color.uses

    $AyameRef.colors[$Color.name] = $ColorDef

    foreach ($Alias in $Color.aliases) {
        $AyameRef.colors[$Alias] = $ColorDef
    }
}

$AyameRef | ConvertTo-Json -Depth 3 > $AyameRefPath

. '.\src\script\export\Neovim.ps1' -Colors $AyameRef.colors

# --( ayame-variables.styl )----------------------------------------------------

$Prefix = '--ayame-'

Set-Content -Path $AyameVariablesPath -Value @"
$(($AyameColors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "aya-$($_.name) = var($Prefix$($_.name))$Comment"
}) -Join "`n")
$(($AyameColors | Where-Object { $_.aliases } | ForEach-Object {
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
$(($AyameColors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " /* $($_.uses -Join ', ') */"
    }
    "    $($Prefix)$($_.name) $($AyameRef.colors[$_.name].hex);$Comment"
}) -Join "`n")
$(($AyameColors | Where-Object { $_.aliases } | ForEach-Object {
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
$(($AyameColors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "ayahex-$($_.name) = $($AyameRef.colors[$_.name].hex)$Comment"
}) -Join "`n")
$(($AyameColors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayahex-$_ = $($AyameRef.colors[$ThisColor.name].hex)$Comment"
    }) -Join "`n"
}) -Join "`n")
"@

# --( ayame-rgb.styl )----------------------------------------------------------

Set-Content -Path $AyameRGBPath -Value @"
$(($AyameColors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "ayargb-$($_.name) = $($AyameRef.colors[$_.name].rgb)$Comment"
}) -Join "`n")
$(($AyameColors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayargb-$_ = $($AyameRef.colors[$ThisColor.name].rgb)$Comment"
    }) -Join "`n"
}) -Join "`n")
"@

# --( ayame-hsl.styl )----------------------------------------------------------

Set-Content -Path $AyameHSLPath -Value @"
$(($AyameColors | ForEach-Object {
    $Comment = ''
    if ($_.uses -gt 0) {
        $Comment = " // $($_.uses -Join ', ')"
    }
    "ayahsl-$($_.name) = $($AyameRef.colors[$_.name].hsl)$Comment"
}) -Join "`n")
$(($AyameColors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayahsl-$_ = $($AyameRef.colors[$ThisColor.name].hsl)$Comment"
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

foreach ($Color in $AyameColors) {
    $SVGPath = Join-Path -Path $IconsPath -ChildPath "$($Color.name).svg"
    $SVGContent = @"
<svg width="16" height="16" xmlns="http://www.w3.org/2000/svg">
  <circle cx="8" cy="8" r="8" fill="$($AyameRef.colors[$Color.name].hex)" />
</svg>
"@
    New-Item -Path $SVGPath -Value $SVGContent | Out-Null
}

# --( README.md ) --------------------------------------------------------------

$IconURL = 'bin/icon/'

# Don’t waste three hours of your life like me and just accept the assignment
$Backtick = "``"

$AyamePaletteTable = ($AyameColors | ForEach-Object {
    @(
        "| ![]($($IconURL)$($_.name).svg) ``$($AyameRef.colors[$_.name].hex)`` |",
        " ``$($_.name)``",
        "$($_.aliases.Count -gt 0 ? ', ' : '')",
        "$(($_.aliases | ForEach-Object {
            "$Backtick$_$Backtick"
        }) -Join ', ') |",
        " $($_.uses -Join ', ') |"
    ) -Join ''
}) -Join "`n"

(Get-Content $ReadmeTemplatePath).Replace('@-ayame-palette-table', $AyamePaletteTable) | Set-Content $ReadmePath

# --( Office Theme ) -----------------------------------------------------------

$OfficeSourcePath = Resolve-Path '.\src\office\thmx'
New-Item -ItemType Directory -Path .\bin\office\thmx -Force | Out-Null
Get-ChildItem -Path $OfficeSourcePath -Recurse | Where-Object {
    $_.Name -notlike '*.ayame-template*'
} | ForEach-Object {
    $Destination = Join-Path -Path '.\bin\office\thmx' -ChildPath $_.FullName.Substring($OfficeSourcePath.ToString().Length)
    if ($_.PSIsContainer) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
    else {
        Copy-Item -LiteralPath $_.FullName -Destination $Destination -Force
    }
}

# --( *.ayame-template* ) -----------------------------------------------------

$Values = @{
    ayame = Get-Content $AyameRefPath -Raw | ConvertFrom-Json
}

$Pattern = [regex]'\[{2}(ayame):(\w+(?:\.\w+)*)\]{2}'

$SourcePath = Resolve-Path '.\src'
Get-ChildItem -Path $SourcePath -Recurse -Filter '*.ayame-template*' | ForEach-Object {
    $Destination = Join-Path -Path '.\bin' -ChildPath $_.FullName.Substring($SourcePath.ToString().Length).Replace('.ayame-template', '')
    if ($_.PSIsContainer) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
    else {
        $Content = Get-Content $_.FullName
        for ($i = 0; $i -lt $Content.Length; $i++) {
            $Content[$i] = $Pattern.Replace($Content[$i], {
                param($Match)
                $Json = $Match.Groups[1].Value
                $Key = $Match.Groups[2].Value
                $Object = $Values.$Json
                foreach ($SubKey in $Key.Split('.')) {
                    $Object = $Object.$SubKey
                }
                $Object
            })
        }
        New-Item -ItemType Directory -Path (Split-Path -Path $Destination -Parent) -Force | Out-Null
        $Content > $Destination
    }
}

# --( ayame-palette-graphic.svg -> png ) ---------------------------------------

if ($null -eq (Get-Command 'inkscape' -ErrorAction SilentlyContinue)) {
    Write-Error 'inkscape not found in PATH.'
}
else {
    inkscape '.\bin\image\ayame-palette-graphic.svg' -o '.\bin\image\ayame-palette-graphic.png'
    inkscape '.\bin\image\ayame-palette.svg' -o '.\bin\image\ayame-palette.png'
}

# --( Office Theme cont. ) -----------------------------------------------------

if ($null -eq (Get-Command '7z' -ErrorAction SilentlyContinue)) {
    Write-Error '7z not found in PATH.'
}
else {
    Get-ChildItem -Path .\bin\office\thmx | ForEach-Object {
        7z u -tzip Ayame.thmx $_.FullName
    }
}
Move-Item -Path Ayame.thmx -Destination .\bin\office -Force
Remove-Item -Path .\bin\office\thmx -Recurse -Force

# --( Stylus ) -----------------------------------------------------------------

npx stylus src/ayame-variables.styl
npx stylus src/usercss --out bin/usercss

Set-Location $PrevCWD
