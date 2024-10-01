<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                                Stylus Export                                 │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │                  Exports Stylus variables and definitions.                   │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true,
        Position  = 0
    )]
    [hashtable] $Colors,
    [switch]    $Force
)

. '.\src\script\util\IO.ps1'
. '.\src\script\util\Logger.ps1'

LogInfo 'Starting task: Stylus Export'
LogInfo "$($Colors.Count) colors loaded."

[int] $LengthIDMax = 0
foreach ($Color in $Colors) {
    $LengthIDMax = [Math]::Max($LengthIDMax, $Color.name.Length)

    foreach ($Alias in $Color.aliases) {
        $LengthIDMax = [Math]::Max($LengthIDMax, $Alias.Length)
    }
}

$StylusPath    = ".\src\stylus"
Ensure $StylusPath
$StylusPathVar = "$StylusPath\ayame-variables.styl"
$StylusPathHex = "$StylusPath\ayame-hex.styl"
$StylusPathRGB = "$StylusPath\ayame-rgb.styl"
$StylusPathHSL = "$StylusPath\ayame-hsl.styl"

$LinesVar = [AssignmentLineBatch]::new($Colors)
$LinesVar.LeftPrefix    = 'aya-'
$LinesVar.LeftBasePad   = $LengthIDMax
$LinesVar.Operator      = '='
$LinesVar.RightPrefix   = 'var(--ayame-'
$LinesVar.Picker        = '.'
$LinesVar.RightSuffix   = ')'
$LinesVar.RightBasePad  = $LengthIDMax
$LinesVar.CommentPrefix = '// '

$LinesVarRoot = [AssignmentLineBatch]::new($Colors)
$LinesVarRoot.IndentSize    = 4
$LinesVarRoot.LeftPrefix    = '--ayame-'
$LinesVarRoot.LeftBasePad   = $LengthIDMax
$LinesVarRoot.Picker        = 'hex'
$LinesVarRoot.RightSuffix   = ';'
$LinesVarRoot.RightBasePad  = '#FFFFFF'.Length
$LinesVarRoot.CommentPrefix = '/* '
$LinesVarRoot.CommentSuffix = ' */'

$LinesHex = [AssignmentLineBatch]::new($Colors)
$LinesHex.LeftPrefix    = 'ayahex-'
$LinesHex.LeftBasePad   = $LengthIDMax
$LinesHex.Operator      = '='
$LinesHex.Picker        = 'hex'
$LinesHex.RightBasePad  = '#FFFFFF'.Length
$LinesHex.CommentPrefix = '//'

$LinesRGB = [AssignmentLineBatch]::new($Colors)
$LinesRGB.LeftPrefix    = 'ayargb-'
$LinesRGB.LeftBasePad   = $LengthIDMax
$LinesRGB.Operator      = '='
$LinesRGB.Picker        = 'rgb'
$LinesRGB.RightBasePad  = 'rgb(255, 255, 255)'.Length
$LinesRGB.CommentPrefix = '//'

$LinesHSL = [AssignmentLineBatch]::new($Colors)
$LinesHSL.LeftPrefix    = 'ayahsl-'
$LinesHSL.LeftBasePad   = $LengthIDMax
$LinesHSL.Operator      = '='
$LinesHSL.Picker        = 'hsl'
$LinesHSL.RightBasePad  = 'hsl(360, 100%, 100%)'.Length
$LinesHSL.CommentPrefix = '//'

Set-Content -Path $StylusPathVar -Value @"
$($LinesVar.ToString())
:root
$($LinesVarRoot.ToString())
"@
Set-Content -Path $StylusPathHex -Value ($LinesHex.ToString())
Set-Content -Path $StylusPathRGB -Value ($LinesRGB.ToString())
Set-Content -Path $StylusPathHSL -Value ($LinesHSL.ToString())

LogInfo "Converting 'src/ayame-variables.styl' -> CSS."
npx stylus src/ayame-variables.styl
LogInfo "Converting 'src/usercss/*.styl' -> CSS."
npx stylus src/usercss --out bin/usercss

LogInfo('Completed task: Stylus Export')
