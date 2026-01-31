. .\src\script\util\Oklab.ps1

function Convert-HexToColorDefinition {
    [Obsolete("Convert-HexToColorDefinition is deprecated. Use Convert-OklchToColorDefinition instead.")]
    param(
        [string]
        $HexColor
    )

    # Calculate RGB. r[0,255], g[0,255], b[0,255]
    $HexColor = $HexColor.TrimStart('#')

    $r = [convert]::ToInt32($HexColor.Substring(0, 2), 16)
    $g = [convert]::ToInt32($HexColor.Substring(2, 2), 16)
    $b = [convert]::ToInt32($HexColor.Substring(4, 2), 16)

    # Calculate RGB. r_percent[0,1], g_percent[0,1], b_percent[0,1]
    $r_percent = $r / 255
    $g_percent = $g / 255
    $b_percent = $b / 255

    # Prepare to calculate HSL.
    $max   = [math]::Max($r_percent, $g_percent)
    $max   = [math]::Max($max,       $b_percent)
    $min   = [math]::Min($r_percent, $g_percent)
    $min   = [math]::Min($min,       $b_percent)
    $delta = $max - $min

    # Calculate hue. h[0,360]
    if ($delta -eq 0) { $h = 0 }
    elseif ($max -eq $r_percent) {
        $segment = ($g_percent - $b_percent) / $delta
        if ($segment -lt 0) { $shift = 360 / 60 }
        else { $shift = 0 }
        $h = $segment + $shift
    }
    elseif ($max -eq $g_percent) {
        $segment = ($b_percent - $r_percent) / $delta
        $shift = 120 / 60
        $h = $segment + $shift
    }
    else {
        $segment = ($r_percent - $g_percent) / $delta
        $shift = 240 / 60
        $h = $segment + $shift
    }
    $h *= 60

    # Calculate lightness. l[0,1]
    $l = ($max + $min) / 2

    # Calculate saturation. s[0,1]
    if ($delta -eq 0) {
        $s = 0
    }
    else {
        $s = $delta / (1 - [math]::Abs(2 * $l - 1))
    }

    return [ordered]@{
        hex            = "#$HexColor"
        hex_upper      = "#$HexColor".ToUpper()
        hex_bare       = "$HexColor"
        hex_bare_upper = "$HexColor".ToUpper()
        r              = $r
        red            = $r
        red_percent    = $r_percent
        g              = $g
        green          = $g
        green_percent  = $g_percent
        b              = $b
        blue           = $b
        blue_percent   = $b_percent
        rgb            = "rgb($r, $g, $b)"
        h              = $h
        hue            = $h
        s              = $s
        saturation     = $s
        l              = $l
        lightness      = $l
        hsl            = "hsl($([math]::Round($h)), $([math]::Round($s * 100))%, $([math]::Round($l * 100))%)"
    }
}

function Convert-OklchToColorDefinition {
    param(
        # CSS-like Oklch definition string
        [Parameter(Mandatory=$true)]
        [string]
        $OklchDef,
        [int]
        $Shade
    )
    
    if ([string]::IsNullOrWhiteSpace($OklchDef)) {
        throw [System.ArgumentException]::new(
            "String cannot be null or whitespace.",
            'OklchDef'
        )
    }
    
    [Oklab] $oklab = [Oklab]::FromOklchString($OklchDef)
    
    if ($PSBoundParameters.ContainsKey('Shade') -and $Shade -ne 500) {
        $oklab = $oklab.WithShade($Shade)
    }
    
    return [ordered]@{
        hex            = $oklab.ToHex6Lower()
        hex_upper      = $oklab.ToHex6()
        hex_bare       = $oklab.ToHex6BareLower()
        hex_bare_upper = $oklab.ToHex6Bare()
        r              = $oklab.Red()
        red            = $oklab.Red()
        red_percent    = $oklab.Red()   / 255
        g              = $oklab.Green()
        green          = $oklab.Green()
        green_percent  = $oklab.Green() / 255
        b              = $oklab.Blue()
        blue           = $oklab.Blue()
        blue_percent   = $oklab.Blue()  / 255
        rgb            = $oklab.ToString('rgb')
        rgba           = $oklab.ToString('rgba')
        h              = $oklab.HslHue()
        hue            = $oklab.HslHue()
        s              = $oklab.HslSaturation()
        saturation     = $oklab.HslSaturation()
        l              = $oklab.HslLightness()
        lightness      = $oklab.HslLightness()
        hsl            = $oklab.ToString('hsl')
        hsla           = $oklab.ToString('hsla')
    }
}

function Convert-RgbToExcelColor {
    param([int]$R, [int]$G, [int]$B)
    $R = [Math]::Clamp($R, 0, 255)
    $G = [Math]::Clamp($G, 0, 255)
    $B = [Math]::Clamp($B, 0, 255)
    return ($B -shl 16) -bor ($G -shl 8) -bor $R
}

enum ReadableTextColor {
    Black
    White
}

function Get-ReadableTextColor {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateRange(0,255)]
        [int] $Red,

        [Parameter(Mandatory)]
        [ValidateRange(0,255)]
        [int] $Green,

        [Parameter(Mandatory)]
        [ValidateRange(0,255)]
        [int] $Blue
    )

    function ConvertTo-Linear {
        param([double]$c)
        if ($c -le 0.04045) {
            return $c / 12.92
        }
        return [math]::Pow(($c + 0.055) / 1.055, 2.4)
    }

    $r = ConvertTo-Linear ($Red   / 255)
    $g = ConvertTo-Linear ($Green / 255)
    $b = ConvertTo-Linear ($Blue  / 255)

    $L = 0.2126 * $r + 0.7152 * $g + 0.0722 * $b

    $contrast_white = (1.0 + 0.05) / ($L + 0.05)
    $contrast_black = ($L + 0.05) / (0.0 + 0.05)

    if ($contrast_white -gt $contrast_black) {
        return [ReadableTextColor]::White
    }
    return [ReadableTextColor]::Black
}