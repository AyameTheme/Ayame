<#
 ╭──────────────────────────────────────────────────────────────────────────────╮
 │                              Template Processor                              │
 ├──────────────────────────────────────────────────────────────────────────────┤
 │                    Processes template variables in files.                    │
 ╰──────────────────────────────────────────────────────────────────────────────╯
 #>
[CmdletBinding()]
param (
    [switch] $Force
)

. '.\src\script\util\IO.ps1'
. '.\src\script\util\Logger.ps1'

LogInfo 'Starting task: Template Processor'

# -- START Lookup Tables -------------------------------------------------------

<#
    LOOKUP TABLES
    -------------

    The following hashtable contains lookup tables used for templates. Each key is referred to as a
    'root' key, and its corresponding value is another hashtable, called a lookup table, usually
    imported from a JSON.
   
    These lookup tables are accessed by specifying a root key, then a key path, in the following
    format in a file with a name like '*.ayame-template*':
   
    @rootkey:path.to.key@
   
    For example, if I have the following string in 'src/mycolors.ayame-template.css':
   
    @ayame:colors.red.hex@
   
    1.  The script begins by searching for the root key 'ayame'. It then tries loading its lookup
        table.
    2.  It then assumes the rest of the string between the first ':' and final '@' is a path, with
        each sub-path separated by a '.'. The path is split into sub-paths, also called sub-keys.
        
        ayame
        └───colors
            └───red
                └───hex

    3.  Each subkey is recursively accessed until the final subkey is reached in the split. The
        value associated with the final subkey is then used to replace the accessor string.
        
        ayame
        └───colors
            └───red
                └───hex: "#ff577e" <-- the value '#ff577e' is returned
        
        The accessor string is replaced with the returned value:

        @ayame:colors.red.hex@ -> #ff577e
        
    Limitations for lookup tables:
    -   Arrays are not supported as parent paths. For example, '@ayame:colors.red.uses[3]@' will
        fail. However, '@ayame:colors.red.uses@' will succeed, and return the entire array with each
        item separated by a space character (' '), which is PowerShell behavior for converting
        arrays to strings.
    -   Keys, including the root key, can only contain word characters. Word characters are alpha-
        numeric including underscore '_'. Regex equivalent: [a-zA-Z0-9_]
    -   A root key named 'template' will be ignored since it's reserved for template scripts.


    TEMPLATE SCRIPTS
    ----------------
    
    Template scripts are PowerShell or Python scripts located in 'src/template'. Like lookup tables,
    they are accessed by the root key 'template' and a path:

    @template:script@
    @template:scriptdir.script@
    @template:scriptdir.script:hello world 3@
    
    Once a string like above is found in a file with a name like '*.ayame-template', it recursively
    navigates through the path following ':', splitting sub-paths by '.', like lookup tables. It
    then executes the script with a matching file name of the final sub-key. It also passes any
    arguments it finds, separated by spaces after the second ':', to the script. For example:

    @template:convert.to_binary:22@
    
    src
    └───template
        └───convert
            └───to_binary
    
    src/template/convert/to_binary
    
    Once the path is resolved, it assumes the last key, 'to_binary', to be a script file. To
    execute the file, PowerShell looks for the following until it succeeds:
    1.  'src/template/convert/to_binary.ps1'
    2.  'src/template/convert/to_binary.py'
    3.  'src/template/convert/to_binary' with '#!' shebang in the first line of the file.

    When it finds a suitable file, it then passes '22' as the first argument to the script file.
#>
$Values = @{
    ayame = Get-Content '.\bin\ayame.json' -Raw | ConvertFrom-Json -AsHashtable
}
# -- END Lookup Tables ---------------------------------------------------------

$Pattern    = [regex]"@(\w+):(\w+(?:\.\w+)*)(?::([^@]+))?@"
$PathSource = Convert-Path '.\src'

$TemplatePaths = Get-ChildItem '.\src' -Recurse -Filter '*.ayame-template*'
foreach ($P in $TemplatePaths) {
    $Content         = Get-Content $P.FullName
    $PathOutputMatch = $Content[0] | Select-String -Pattern "@container:([^@]+)@"
    $PathOutput      = $(
        if ($P.FullName -like "*image*" -and $P.Extension -eq '.svg') { $P.FullName.Replace('.ayame-template', '') }
        elseif ($PathOutputMatch) {
            $Content[0] = ''
            Join-Path $PathOutputMatch.Matches.Groups[1].Value $P.Name.Replace('.ayame-template', '')
        }
        else { Join-Path '.\bin' $P.FullName.Substring($PathSource.Length).Replace('.ayame-template', '') }
    )
    if ($P.PSIsContainer) {
        New-Item $PathOutput -ItemType Directory -Force | Out-Null
        continue
    }
    EnsureParent $PathOutput
    LogInfo "Working: '$P' -> '$PathOutput'"

    for ($i = 0; $i -lt $Content.Length; $i++) {
        $Content[$i] = $Pattern.Replace($Content[$i], {
            param($Match)
            $Root = $Match.Groups[1].Value
            $Key  = $Match.Groups[2].Value
            
            if ($Root -eq 'template') {
                $PathScript = ".\src\template\$($Key.Replace('.', '\'))"
                $PathArgs   = $(if ($Match.Groups.Count -gt 3) { $Match.Groups[3].Value.Split(' ') } else { @('') })
                
                if (Test-Path "$PathScript.ps1" -PathType Leaf) {
                    $Result = & "$PathScript.ps1" @PathArgs
                    LogDebug "'$P' (Line $i): '$($Match.Groups[0].Value)' -> '$Result'"
                    $Result
                }
                elseif (Test-Path "$PathScript.py" -PathType Leaf) {
                    $Result = & python "$PathScript.py" @PathArgs
                    LogDebug "'$P' (Line $i): '$($Match.Groups[0].Value)' -> '$Result'"
                    $Result
                }
                else {
                    if (Test-Path $PathScript -PathType Leaf) {
                        $Shebang = Get-Content $PathScript -Head 1
                        if ($Shebang.StartsWith('#!') -and $Shebang -ne '#!/bin/false') {
                            $Result = & $Shebang.Substring(2) @PathArgs
                            LogDebug "'$P' (Line $i): '$($Match.Groups[0].Value)' -> '$Result'"
                            $Result
                        }
                        else { LogError "'$P' (Line $i): Cannot replace '$($Match.Groups[0].Value)' because '$PathScript' was found but is not a script file." }
                    }
                    else { LogError "'$P' (Line $i): Cannot replace '$($Match.Groups[0].Value)' because '$PathScript' was not found." }
                }
            }
            elseif ($Root -eq 'mock') {
                $Result = $Match.Groups[0].Value.Replace('mock', 'ayame')
                LogDebug "'$P' (Line $i): '$($Match.Groups[0].Value)' -> '$Result'"
                $Result
            }
            else {
                if (!$Values.ContainsKey($Root)) {
                    LogError "'$P' (Line $i): Cannot replace '$($Match.Groups[0].Value)' because '$Root' is not a valid root key."
                    $Match.Groups[0].Value
                }
                else {
                    $Object = $Values.$Root
                    foreach ($SubKey in $Key.Split('.')) {
                        $Object = $Object.$SubKey
                    }
                    LogDebug "'$P' (Line $i): '$($Match.Groups[0].Value)' -> '$Object'"
                    $Object
                }
            }
        })
    }
    Set-Content $PathOutput $Content -Force:$Force
}

LogInfo 'Completed task: Template Processor'
