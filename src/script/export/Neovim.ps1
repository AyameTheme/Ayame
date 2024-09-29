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
    [hashtable] $Colors,
    [switch]    $Force
)

. '.\src\script\util\IO.ps1'
. '.\src\script\util\Logger.ps1'

LogInfo('Starting task: Neovim Export')

[string] $AyameLuaPath = '.\bin\nvim\ayame-palette.lua'
EnsureParent($AyameLuaPath)

LogInfo("$($Colors.Count) colors loaded.")

# These Lua-reserved keywords cannot be used as keys in a Lua table.
LogInfo('Removing Lua-reserved keywords from color definition names.')
[string[]] $ReservedKeywordsLua = @(
    'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'if', 'in', 'local',
    'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while'
)
foreach ($Keyword in $ReservedKeywordsLua) { $Colors.Remove($Keyword) }
LogInfo("$($Colors.Count) colors remaining.")

# The length of the longest color ID is used to right-pad the ID with spaces in the resulting Lua
# table so that the '=' operators and comments align. This makes the table easier to read.
[int] $LengthIDMax = 0
foreach ($Color in $AyameColors) {
    $LengthIDMax = [Math]::Max($LengthIDMax, $Color.name.Length)

    foreach ($Alias in $Color.aliases) {
        $LengthIDMax = [Math]::Max($LengthIDMax, $Alias.Length)
    }
}

[string[]] $Lines = @('') * ($Colors.Count)
[int]      $i     = 0
foreach ($ColorKey in $Colors.Keys) {
    $Color = $Colors[$ColorKey]
    [string] $Name       = $ColorKey
    [string] $NamePadded = $Name.PadRight($LengthIDMax, ' ')
    [string] $Hex        = $Color.hex
    [string] $Comment    = ''

    if ($Color.uses -gt 0) {
        $Comment = " -- $($Color.uses -join ', ')"
    }

    $Line = "$(' ' * 8)$NamePadded = ""$Hex"",$Comment"

    LogDebugCode $Line ($i + 4) ($Lines.Count + 4)

    $Lines[$i] = $Line
    $i++
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

LogInfo('Completed task: Neovim Export')
