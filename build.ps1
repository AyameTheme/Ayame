$PrevCWD = (Get-Item .).FullName
Set-Location $PSScriptRoot

$Ayame = Get-Content '.\src\ayame-colors.json' -Raw | ConvertFrom-Json

# --( Path Variables )----------------------------------------------------------

$AyameJsonPath = '.\build\out\ayame.json'
$AyameVariablesPath = '.\src\ayame-variables.styl'
$AyameHexPath = '.\src\ayame-hex.styl'
$AyameRGBPath = '.\src\ayame-rgb.styl'
$AyameHSLPath = '.\src\ayame-hsl.styl'
$AyameLuaPath = '.\build\out\nvim\ayame.lua'
$IconsPath = '.\build\out\icon'
$ReadmePath = '.\README.md'
$ReadmeTemplatePath = '.\src\readme-template.md'

# --( ayame-colors.json )-------------------------------------------------------

function Convert-HexToRgbHsl {
    param(
        [string]
        $HexColor
    )

    # Calculate RGB. r[0,255], g[0,255], b[0,255]
    $HexColor = $HexColor.TrimStart('#')

    $r = [convert]::ToInt32($HexColor.Substring(0, 2), 16)
    $g = [convert]::ToInt32($HexColor.Substring(2, 2), 16)
    $b = [convert]::ToInt32($HexColor.Substring(4, 2), 16)

    # Calculate RGB. r_percent[0,1], g_percent[0,1], b_percent[0,1]
    $r_percent = $r / 255
    $g_percent = $g / 255
    $b_percent = $b / 255

    # Prepare to calculate HSL.
    $max = [math]::Max($r_percent, $g_percent)
    $max = [math]::Max($max, $b_percent)
    $min = [math]::Min($r_percent, $g_percent)
    $min = [math]::Min($min, $b_percent)
    $delta = $max - $min

    # Calculate hue. h[0,360]
    if ($delta -eq 0) { $h = 0 }
    elseif ($max -eq $r_percent) {
        $segment = ($g_percent - $b_percent) / $delta
        if ($segment -lt 0) { $shift = 360 / 60 }
        else { $shift = 0 }
        $h = $segment + $shift
    }
    elseif ($max -eq $g_percent) {
        $segment = ($b_percent - $r_percent) / $delta
        $shift = 120 / 60
        $h = $segment + $shift
    }
    else {
        $segment = ($r_percent - $g_percent) / $delta
        $shift = 240 / 60
        $h = $segment + $shift
    }
    $h *= 60

    # Calculate lightness. l[0,1]
    $l = ($max + $min) / 2

    # Calculate saturation. s[0,1]
    if ($delta -eq 0) {
        $s = 0
    }
    else {
        $s = $delta / (1 - [math]::Abs(2 * $l - 1))
    }

    return [ordered]@{
        hex = "#$HexColor"
        hex_upper = "#$HexColor".ToUpper()
        hex_bare = "$HexColor"
        hex_bare_upper = "$HexColor".ToUpper()
        r = $r
        red = $r
        red_percent = $r_percent
        g = $g
        green = $g
        green_percent = $g_percent
        b = $b
        blue = $b
        blue_percent = $b_percent
        rgb = "rgb($r, $g, $b)"
        h = $h
        hue = $h
        s = $s
        saturation = $s
        l = $l
        lightness = $l
        hsl = "hsl($([math]::Round($h)), $([math]::Round($s * 100))%, $([math]::Round($l * 100))%)"
    }
}

$AyameJson = [ordered]@{
    version = ''
    colors = [ordered]@{}
}

$AyameJson.version = (Get-Content .\package.json -Raw | ConvertFrom-Json).version

foreach ($Color in $Ayame.colors) {
    $AyameColorDef = Convert-HexToRgbHsl $Color.hex
    
    $AyameColorDef['uses'] = $Color.uses

    $AyameJson.colors[$Color.name] = $AyameColorDef
    foreach ($Alias in $Color.aliases) {
        $AyameJson.colors[$Alias] = $AyameColorDef
    }
}

$AyameJson | ConvertTo-Json -Depth 3 > $AyameJsonPath

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
    "    $($Prefix)$($_.name) $($AyameJson.colors[$_.name].hex);$Comment"
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
    "ayahex-$($_.name) = $($AyameJson.colors[$_.name].hex)$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayahex-$_ = $($AyameJson.colors[$ThisColor.name].hex)$Comment"
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
    "ayargb-$($_.name) = $($AyameJson.colors[$_.name].rgb)$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayargb-$_ = $($AyameJson.colors[$ThisColor.name].rgb)$Comment"
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
    "ayahsl-$($_.name) = $($AyameJson.colors[$_.name].hsl)$Comment"
}) -Join "`n")
$(($Ayame.colors | Where-Object { $_.aliases } | ForEach-Object {
    $ThisColor = $_
    ($_.aliases | ForEach-Object {
        $Comment = ''
        if ($ThisColor.uses -gt 0) {
            $Comment = " // $($ThisColor.uses -Join ', ')"
        }
        "ayahsl-$_ = $($AyameJson.colors[$ThisColor.name].hsl)$Comment"
    }) -Join "`n"
}) -Join "`n")
"@

# --( ayame.lua )---------------------------------------------------------------

if (!(Test-Path (Split-Path $AyameLuaPath -Parent))) {
    New-Item -ItemType Directory -Path (Split-Path $AyameLuaPath -Parent) -Force | Out-Null
}

$Ayamepedia = Get-Content $AyameJsonPath -Raw | ConvertFrom-Json -AsHashtable

# Remove Lua-reserved keywords from the hashtable. These keywords cannot be used
# as keys in a Lua table.
[string[]] $ReservedKeywordsLua = @(
    'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function',
    'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true',
    'until', 'while'
)
$AyamepediaLua = $Ayamepedia
$ReservedKeywordsLua | ForEach-Object { $AyamepediaLua.colors.Remove($_) }

# The length of the longest color ID is used to right-pad the ID with spaces in
# the resulting Lua table so that the '=' operators and comments align. This
# makes the table easier to read.
[int] $LengthIDMax = 0
foreach ($Color in $Ayame.colors) {
    $LengthIDMax = [Math]::Max($LengthIDMax, $Color.name.Length)
    
    foreach ($Alias in $Color.aliases) {
        $LengthIDMax = [Math]::Max($LengthIDMax, $Alias.Length)
    }
}

[string[]] $Lines = @('') * ($Ayamepedia.colors.Count)
[int] $i = 0
foreach ($ColorKey in $Ayamepedia.colors.Keys) {
    $Color = $Ayamepedia.colors[$ColorKey]
    [string] $Name       = $ColorKey
    [string] $NamePadded = $Name.PadRight($LengthIDMax, ' ')
    [string] $Hex        = $Color.hex
    [string] $Comment    = ''

    if ($Color.uses -gt 0) {
        $Comment = " -- $($Color.uses -join ', ')"
    }
    
    $Lines[$i] = "$(' ' * 8)$NamePadded = ""$Hex"",$Comment"
    $i += 1
}

[string] $LinesRaw = $Lines -join "`n"

Set-Content -Path $AyameLuaPath -Value @"
local M = {}

function M.get()
    return {
$LinesRaw
    }
end

return M
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
  <circle cx="8" cy="8" r="8" fill="$($AyameJson.colors[$Color.name].hex)" />
</svg>
"@
    New-Item -Path $SVGPath -Value $SVGContent | Out-Null
}

# --( README.md ) --------------------------------------------------------------

$IconURL = 'build/out/icon/'

# Don’t waste three hours of your life like me and just accept the assignment
$Backtick = "``"

$AyamePaletteTable = ($Ayame.colors | ForEach-Object {
    @(
        "| ![]($($IconURL)$($_.name).svg) ``$($AyameJson.colors[$_.name].hex)`` |",
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
New-Item -ItemType Directory -Path .\build\out\office\thmx -Force | Out-Null
Get-ChildItem -Path $OfficeSourcePath -Recurse | Where-Object {
    $_.Name -notlike '*.ayame-template*'
} | ForEach-Object {
    $Destination = Join-Path -Path '.\build\out\office\thmx' -ChildPath $_.FullName.Substring($OfficeSourcePath.ToString().Length)
    if ($_.PSIsContainer) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
    else {
        Copy-Item -LiteralPath $_.FullName -Destination $Destination -Force
    }
}

# --( *.ayame-template* ) -----------------------------------------------------

$Values = @{
    ayame = Get-Content $AyameJsonPath -Raw | ConvertFrom-Json
}

$Pattern = [regex]'\[{2}(ayame):(\w+(?:\.\w+)*)\]{2}'

$SourcePath = Resolve-Path '.\src'
Get-ChildItem -Path $SourcePath -Recurse -Filter '*.ayame-template*' | ForEach-Object {
    $Destination = Join-Path -Path '.\build\out' -ChildPath $_.FullName.Substring($SourcePath.ToString().Length).Replace('.ayame-template', '')
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
    inkscape '.\build\out\ayame-palette-graphic.svg' -o '.\build\out\ayame-palette-graphic.png'
}

# --( Office Theme cont. ) -----------------------------------------------------

if ($null -eq (Get-Command '7z' -ErrorAction SilentlyContinue)) {
    Write-Error '7z not found in PATH.'
}
else {
    Get-ChildItem -Path .\build\out\office\thmx | ForEach-Object {
        7z u -tzip Ayame.thmx $_.FullName
    }
}
Move-Item -Path Ayame.thmx -Destination .\build\out\office -Force
Remove-Item -Path .\build\out\office\thmx -Recurse -Force

# --( Stylus ) -----------------------------------------------------------------

npx stylus src/ayame-variables.styl
npx stylus src/usercss --out build/out/usercss

Set-Location $PrevCWD