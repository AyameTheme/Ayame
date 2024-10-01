$Files = Get-ChildItem '.\src\windowsterminal' | Where-Object { $_.Extension -eq '.json' }
$Lines = @('') * $Files.Count
$i     = 0
foreach ($File in $Files) {
    $Content = Get-Content $File.FullName -Raw | ConvertFrom-Json
    $Name = $Content.name
    $Path = $File.Name.Replace('.ayame-template', '')

    $Lines[$i] = "- [$Name]($Path)"
    $i++
}

return $Lines -join "`n"