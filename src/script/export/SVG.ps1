<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                                SVG Conversion                                │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │                       Converts SVG files to PNG files.                       │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
[CmdletBinding()]
param (
    [switch] $Force
)

. '.\src\script\util\IO.ps1'
. '.\src\script\util\Logger.ps1'

LogInfo 'Starting task: SVG Conversion'

if ($null -eq (Get-Command 'inkscape' -ErrorAction SilentlyContinue)) {
    LogFatal 'inkscape not found in PATH.'
    return
}

$SourcePath = '.\src\image'
$OutputPath = '.\bin\image'
Ensure $OutputPath

$SVGPaths = Get-ChildItem $SourcePath | Where-Object { $_.Extension -eq '.svg' -and $_.Name -notlike "*.ayame-Template*" }
if ($SVGPaths.Count -lt 1) {
    LogWarn "No SVGs found in '$SourcePath'."
    return
}
LogInfo "Found ($($SVGPaths.Count)) non-template SVGs in '$SourcePath'."

foreach ($P in $SVGPaths) {
    LogDebug "Working: '$SourcePath\$($P.Name)' -> '$OutputPath\$($P.BaseName).png'"
    inkscape "$SourcePath\$($P.Name)" -o "$OutputPath\$($P.BaseName).png"
}

LogInfo 'Completed task: SVG Conversion'
