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

LogInfo "Starting task: Neovim Export"

[string] $AyameLuaPath = '.\bin\nvim\ayame-palette.lua'
EnsureParent($AyameLuaPath)

LogInfo "$($Colors.Count) colors loaded."

# These Lua-reserved keywords cannot be used as keys in a Lua table.
LogInfo "Removing Lua-reserved keywords from color definition names."
[string[]] $ReservedKeywordsLua = @(
    'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'if', 'in', 'local',
    'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while'
)
foreach ($Keyword in $ReservedKeywordsLua) { $Colors.Remove($Keyword) }
LogInfo "$($Colors.Count) colors remaining."

# The length of the longest color ID is used to right-pad the ID with spaces in the resulting Lua
# table so that the '=' operators and comments align. This makes the table easier to read.
[int] $LengthIDMax = 0
foreach ($Color in $Colors) {
    $LengthIDMax = [Math]::Max($LengthIDMax, $Color.name.Length)

    foreach ($Alias in $Color.aliases) {
        $LengthIDMax = [Math]::Max($LengthIDMax, $Alias.Length)
    }
}

$LineBatch  = [AssignmentLineBatch]::new($Colors)
$LineBatch.IndentLength  = 8
$LineBatch.LeftBasePad   = $LengthIDMax
$LineBatch.Operator      = '='
$LineBatch.RightPrefix   = '"'
$LineBatch.Picker        = 'hex'
$LineBatch.RightSuffix   = '",'
$LineBatch.RightBasePad  = '"#FFFFFF"'.Length
$LineBatch.CommentPrefix = '-- '


Set-Content -Path $AyameLuaPath -Force:$Force -Value @"
local M = {}

function M.get()
    return {
$($LineBatch.ToString())
    }
end

return M
"@

LogInfo "Completed task: Neovim Export"
