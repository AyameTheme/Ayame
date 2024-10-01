<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                               Dot Icon Export                                │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │         Exports palette icons in the form of 16x16 pixel SVG files.          │
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

LogInfo 'Starting task: Dot Icon Export'
LogInfo "$($Colors.Count) colors loaded."

$ExportPath = '.\bin\icon'
if (Test-Path $ExportPath) {
    Get-ChildItem $ExportPath | ForEach-Object { Remove-Item $_ -Recurse }
}
else { Ensure $ExportPath }

foreach ($ColorKey in $Colors.Keys) {
    $SVGPath = Join-Path -Path $ExportPath -ChildPath "$($ColorKey).svg"
    LogDebug "Working: '$SVGPath'"
    $SVGContent = @"
<svg width="16" height="16" xmlns="http://www.w3.org/2000/svg">
  <circle cx="8" cy="8" r="8" fill="$($Colors[$ColorKey].hex)" />
</svg>
"@
    New-Item -Path $SVGPath -Value $SVGContent | Out-Null
}

LogInfo "Completed task: Dot Icon Export"
