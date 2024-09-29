function LogInfo($Message)  { Write-Host ' INFO '  -Back Blue    -Fore Black -NoN; Write-Host " $Message" }
function LogDebug($Message) { if ($DebugPreference -eq 'SilentlyContinue') { return }
                              Write-Host ' DEBUG ' -Back Green   -Fore Black -NoN; Write-Host " $Message" }
function LogWarn($Message)  { Write-Host ' WARN '  -Back Yellow  -Fore Black -NoN; Write-Host " $Message" }
function LogError($Message) { Write-Host ' ERROR ' -Back Red     -Fore Black -NoN; Write-Host " $Message" }
function LogFatal($Message) { Write-Host ' FATAL ' -Back DarkRed -Fore Black -NoN; Write-Host " $Message" }

function LogDebugCode([Parameter(Mandatory = $true)] [string] $Line,
                      [Parameter(Mandatory = $true)] [int]    $CurrentLineNum,
                      [Parameter(Mandatory = $true)] [int]    $TotalLineCount) {
    if ($CurrentLineNum -lt 1) { $CurrentLineNum = 1 }
    if ($TotalLineCount -lt 1) { $TotalLineCount = $CurrentLineNum }

    LogDebug($(
        [string] $LineTemplate   = "Working on: L{} |{}|"
        [int]    $LineLengthBase = $LineTemplate.Replace('{}', '').Length
        [int]    $LinePadding    = $TotalLineCount.ToString().Length
        [int]    $WindowWidth    = $Host.UI.RawUI.WindowSize.Width - 10

        if (($LineLengthBase + $LinePadding + $Line.Length) -gt $WindowWidth) {
            $Line = "$($Line.Substring(0, $WindowWidth - $LineLengthBase `
                                                       - $LinePadding `
                                                       - 3))..."
        }
        else {
            $Line = $Line.PadRight($WindowWidth - $LineLengthBase - $LinePadding)
        }
        
        $CurrentLineNumPadded = $CurrentLineNum.ToString().PadLeft($LinePadding)
        $LineParts            = $LineTemplate.Split('{}')

        "$($LineParts[0])$CurrentLineNumPadded$($LineParts[1])$Line$($LineParts[2])"
    ))
}