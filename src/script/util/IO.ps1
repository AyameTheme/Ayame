function Ensure {
    param(
        [Parameter(
            Mandatory                       = $true,
            Position                        = 0,
            ValueFromPipeline               = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage                     = "Path to one or more locations."
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $Path
    )
    
    PROCESS {
        foreach ($P in $Path) {
            if (!(Test-Path $P)) {
                New-Item $P -ItemType Directory -Force | Out-Null
            }
        }
    }
}

function EnsureParent {
    param(
        [Parameter(
            Mandatory                       = $true,
            Position                        = 0,
            ValueFromPipeline               = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage                     = "Path to one or more locations."
        )]
        [ValidateNotNullOrEmpty()]
        [string[]] $Path
    )
    
    PROCESS {
        foreach ($P in $Path) {
            $P = Split-Path $P -Parent
            if ($P) { Ensure($P) }
        }
    }
}

class AssignmentLineBatch {
    [int]       $IndentLength      = 0
    [string]    $LeftPrefix        = ''
    [string]    $LeftSuffix        = ''
    [int]       $LeftBasePad       = 0
    [string]    $Operator          = ''
    [string]    $RightPrefix       = ''
    [string]    $Picker            = ''
    [string]    $RightSuffix       = ''
    [int]       $RightBasePad      = 0
    [string]    $CommentPrefix     = ''
    [string]    $CommentSuffix     = ''
    [Management.Automation.OrderedHashtable]$Colors
    
    AssignmentLineBatch([Management.Automation.OrderedHashtable] $Colors) { $this.Colors = $Colors }
    
    [string] ToString() {
        if ($this.IndentLength -lt 0) { $this.IndentLength = 0 }
        [string] $Indent = ' ' * $this.IndentLength
        
        [int] $LeftPad = $this.LeftPrefix.Length + $this.LeftSuffix.Length + $this.LeftBasePad
        
        $this.Operator = $this.Operator.Trim()
        $this.Operator = $(if ($this.Operator) { " $($this.Operator) " } else { ' ' })
        
        $this.Picker = $this.Picker.Trim()
        
        [int] $RightPad = $this.RightPrefix.Length + $this.RightSuffix.Length + $this.RightBasePad
        
        [string[]] $Lines = @('') * $this.Colors.Count
        [int] $i = 0
        
        foreach ($ColorKey in $this.Colors.Keys) {
            [string] $Left = "$($this.LeftPrefix)$ColorKey$($this.LeftSuffix)".PadRight($LeftPad)

            $Color = $this.Colors[$ColorKey]
            [string] $Value = $(
                if ($this.Picker -eq '.') { $ColorKey }
                else { $Color[$this.Picker] }
            )
            
            [string] $Right = "$($this.RightPrefix)$Value$($this.RightSuffix)".PadRight($RightPad)
            
            [string] $Comment = $(
                if ($Color.uses.Count -gt 0) { " $($this.CommentPrefix)$($Color.uses -join ', ')$($this.CommentSuffix)" }
                else { '' }
            )
            
            $Lines[$i] = "$Indent$Left$($this.Operator)$Right$Comment"
            $i++
        }
        
        return $Lines -join "`n"
    }
}