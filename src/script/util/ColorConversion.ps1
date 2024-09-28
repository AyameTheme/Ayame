function Convert-HexToRgbHsl {
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