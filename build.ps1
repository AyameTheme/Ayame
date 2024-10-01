[CmdletBinding()]
param(
    [switch] $Force,
    [switch] $Clean,
    [switch] $All,
    [switch] $Neovim,
    [switch] $Stylus,
    [switch] $DotIcon,
    [switch] $SVG,
    [switch] $Template,
    [switch] $OfficeTheme
)

if (!$All -and !($Template -or
                 $Neovim   -or
                 $Stylus   -or
                 $DotIcon  -or
                 $SVG      -or
                 $OfficeTheme)) { $All = $true }

$PrevCWD = Get-Location
Set-Location $PSScriptRoot

. .\src\script\util\ColorConversion.ps1

$AyameColors = Get-Content '.\src\ayame-colors.json' -Raw | ConvertFrom-Json

# -- Path Variables ------------------------------------------------------------

$AyameRefPath       = '.\bin\ayame.json' # JSON holding Ayame reference object
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

# -- Export Scripts ------------------------------------------------------------

if ($All -or $Neovim)  { . '.\src\script\export\Neovim.ps1'  -Colors $AyameRef.colors -Force:$Force }
if ($All -or $Stylus)  { . '.\src\script\export\Stylus.ps1'  -Colors $AyameRef.colors -Force:$Force }
if ($All -or $DotIcon) { . '.\src\script\export\DotIcon.ps1' -Colors $AyameRef.colors -Force:$Force }
if ($All -or $SVG)     { . '.\src\script\export\SVG.ps1'                              -Force:$Force }

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

Set-Location $PrevCWD
