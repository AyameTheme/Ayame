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

[string] $EspansoPath = '.\bin\espanso\ayame.yml'
EnsureParent($EspansoPath)

LogInfo "$($Colors.Count) colors loaded."

$EntryCount = $(
    $Result = 0
    foreach ($ColorKey in $Colors.Keys) {
        $Color = $Colors.$ColorKey
        foreach ($Property in $Color.Keys) {
            $Value = $Color.$Property
            if (!($Value.GetType().IsArray -or $Value.GetType().IsObject)) {
                $Result++
            }
        }
    }
    $Result
)
[string[]] $Lines = @('') * $EntryCount
[int]      $i     = 0
foreach ($ColorKey in $Colors.Keys) {
    $Color = $Colors.$ColorKey
    foreach ($Property in $Color.Keys) {
        $Value = $Color.$Property
        if (!($Value.GetType().IsArray -or $Value.GetType().IsObject)) {
            $Lines[$i] = @"
- trigger: "@@ayame.$ColorKey.$Property@"
  replace: "$Value"
"@
            $i++
        }
    }
}

Set-Content -Path $EspansoPath -Force:$Force -Value @"
matches:
$($Lines -join "`n")
"@

LogInfo "Completed task: Espanso Export"
