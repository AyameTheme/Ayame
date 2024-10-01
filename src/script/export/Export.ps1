<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                                Direct Export                                 │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │                        Copies files from src to bin.                         │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
[CmdletBinding()]
param (
    [switch] $Force
)
. '.\src\script\util\IO.ps1'
. '.\src\script\util\Logger.ps1'

LogInfo 'Starting task: Direct Export'

$Paths = Get-ChildItem '.\src' -Recurse -Filter '*.ayame-export*'
LogInfo "Found ($($Paths.Count)) files to export."
$PathSource = Convert-Path '.\src'

foreach ($P in $Paths) {
    if ($P.PSIsContainer) {
        Ensure $P
        continue
    }
    $PathOutput = Join-Path '.\bin' $P.FullName.Substring($PathSource.Length).Replace('.ayame-export', '')
    LogInfo "Working: '$P' -> '$PathOutput'"

    EnsureParent $PathOutput
    Copy-Item $P $PathOutput -Force:$Force
}

LogInfo 'Completed task: Direct Export'