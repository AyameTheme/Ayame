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