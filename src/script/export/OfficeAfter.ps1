<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                   Office Theme (After Template Processor)                    │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │                 Creates the final .thmx file and cleans up.                  │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
if ($null -eq (Get-Command '7z' -ErrorAction SilentlyContinue)) {
    LogFatal '7z not found in PATH.'
}
else {
    $Paths = Get-ChildItem -Path .\bin\office\thmx | ForEach-Object {
        $_.FullName
    }
    7z u -tzip Ayame.thmx @Paths
}
Move-Item   '.\Ayame.thmx' '.\bin\office' -Force
Remove-Item '.\bin\office\thmx' -Recurse  -Force
