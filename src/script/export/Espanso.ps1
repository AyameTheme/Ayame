<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                                Neovim Export                                 │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │ Exports a palette.lua file containing a table of colors that can be used in  │
 │                             Neovim colorschemes.                             │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
[CmdletBinding()]
param (
    [Parameter(
        Mandatory = $true,
        Position  = 0
    )]
    [Management.Automation.OrderedHashtable] $Colors,
    [switch] $Force
)

. '.\src\script\util\IO.ps1'
. '.\src\script\util\Logger.ps1'

LogInfo "Starting task: Espanso Export"

[string] $EspansoPath     = '.\bin\espanso\ayame.yml'
[string] $RootVarStylPath = '.\src\stylus\ayame-root.styl'
[string] $RootVarCssPath  = '.\bin\usercss\ayame-root.css'
EnsureParent($EspansoPath)

LogInfo "$($Colors.Count) colors loaded."

[string[]] $Lines = @('') * $Colors.Count
[int]      $i     = 0
foreach ($ColorKey in $Colors.Keys) {
    $Color = $Colors.$ColorKey
    $Lines[$i] = @"
- trigger: ";a-$ColorKey;"
  replace: "$($Color.hex)"
"@
    $i++
}

Set-Content -Path $EspansoPath -Force:$Force -Value @"
matches:
$($Lines -join "`n")
"@

[string] $StylContent = [regex]::Replace((Get-Content -Path $RootVarStylPath -Raw), '(?m)^', '    ').TrimEnd()
[string] $CssContent  = [regex]::Replace((Get-Content -Path $RootVarCssPath  -Raw), '(?m)^', '    ').TrimEnd()

Add-Content -Path $EspansoPath -Force:$Force -Value @"
- trigger: ";a-rootstyl"
  replace: |
$StylContent
- trigger: ";a-rootcss"
  replace: |
$CssContent
"@

LogInfo "Completed task: Espanso Export"
