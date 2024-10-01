$Files = Get-ChildItem '.\src\usercss' | Where-Object { $_.Extension -eq '.styl' }
$Lines = @('') * $Files.Count
$i     = 0
foreach ($File in $Files) {
    $Content = Get-Content $File.FullName
    $Name = $(
        foreach ($Line in $Content) {
            $Match = $Line | Select-String -Pattern '@name\s+(\S.+)'
            if ($Match) {
                $Match.Matches.Groups[1].Value
                break
            }
        }
    )
    $Description = $(
        foreach ($Line in $Content) {
            $Match = $Line | Select-String -Pattern '@description\s+(\S.+)'
            if ($Match) {
                $Match.Matches.Groups[1].Value
                break
            }
        }
    )
    $Domains = $(
        $T = "``"
        $Result = @()
        foreach ($Line in $Content) {
            $Match = $Line | Select-String -Pattern "domain\(['`"]([^'`"]+)['`"]\)" -AllMatches
            if ($Match) {
                foreach ($M in $Match.Matches) {
                    $Result += "$T$($M.Groups[1].Value)$T"
                }
            }
        }
        $Result -join ', '
    )
    $URL = "$($File.BaseName).css?raw=1"
    $Lines[$i] = "| [$Name]($URL) | $Description | $Domains |"
    $i++
}

return $Lines -join "`n"