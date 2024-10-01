<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                   Office Theme (Before Template Processor)                   │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │                Copies non-template Office theme files to bin.                │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
$PathSource = Resolve-Path '.\src\office\thmx'
Ensure '.\bin\office\thmx'
Get-ChildItem $PathSource -Recurse | Where-Object {
    $_.Name -notlike '*.ayame-template*'
} | ForEach-Object {
    $PathOutput = Join-Path -Path '.\bin\office\thmx' -ChildPath $_.FullName.Substring($PathSource.ToString().Length)
    if ($_.PSIsContainer) {
        Ensure $PathOutput
    }
    else {
        Copy-Item -LiteralPath $_.FullName -Destination $PathOutput -Force
    }
}
