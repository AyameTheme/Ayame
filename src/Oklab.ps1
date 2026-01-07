class Oklab {
    hidden [double] $ok_l
    hidden [double] $ok_a
    hidden [double] $ok_b
    hidden [double] $ok_alpha
    
    Oklab(
        [double] $l,
        [double] $a,
        [double] $b,
        [double] $alpha
    ) {
        $this.ok_l     = $l
        $this.ok_a     = $a
        $this.ok_b     = $b
        $this.ok_alpha = $alpha
    }
    
    static [Oklab] FromHexString([string] $str) {
        if ([string]::IsNullOrWhiteSpace($str)) {
            throw [System.ArgumentException]::new(
                "Hex string must not be null, empty, or whitespace.", "str"
            )
        }
        [string] $str = $str.Trim().Replace('#', '')
        if (
            ($str.Length -ne 3) -and
            ($str.Length -ne 6) -and
            ($str.Length -ne 8)) {
            throw [System.ArgumentException]::new(
                "Hex string must a length of 3, 6, or 8 not including '#'.", "str"
            )
        }
        if ($str -notmatch '^[0-9A-Fa-f]+$') {
            throw [System.ArgumentException]::new(
                "Hex string contains invalid characters.", "str"
            )
        }
        if ($str.Length -eq 3) {
            $str = $str[0] + $str[0] + $str[1] + $str[1] + $str[2] + $str[2]
        }
        
        [byte[]] $channels = [Convert]::FromHexString($str)
        [double] $red      = $channels[0]
        [double] $green    = $channels[1]
        [double] $blue     = $channels[2]
        [double] $alpha    = 1.0

        if ($channels.Count -eq 4) {
            $alpha = [double] ($channels[3] / 255.0)
        }

        return [Oklab]::RgbaToOklab($red, $green, $blue, $alpha)
    }

    static [Oklab] RgbaToOklab([double] $r, [double] $g, [double] $b, [double] $alpha) {
        $alpha = [Math]::Clamp($alpha, 0.0, 1.0)
        function ToLinear([double] $c) {
            if ($c -le 0.04045) { return $c / 12.92 }
            return [Math]::Pow(($c + 0.055) / 1.055, 2.4)
        }

        $rl = ToLinear($r / 255.0)
        $gl = ToLinear($g / 255.0)
        $bl = ToLinear($b / 255.0)

        $lp = 0.4122214708 * $rl + 0.5363325363 * $gl + 0.0514459929 * $bl
        $mp = 0.2119034982 * $rl + 0.6806995451 * $gl + 0.1073969566 * $bl
        $sp = 0.0883024619 * $rl + 0.2817188376 * $gl + 0.6299787005 * $bl

        $l = [Math]::Pow($lp, 1.0/3.0)
        $m = [Math]::Pow($mp, 1.0/3.0)
        $s = [Math]::Pow($sp, 1.0/3.0)

        return [Oklab]::new(
            0.2104542553 * $l + 0.7936177850 * $m - 0.0040720468 * $s,
            1.9779984951 * $l - 2.4285922050 * $m + 0.4505937099 * $s,
            0.0259040371 * $l + 0.7827717662 * $m - 0.8086757660 * $s,
            $alpha
        )
    }
    static [Oklab] RgbToOklab([double] $r, [double] $g, [double] $b) {
        return [Oklab]::RgbaToOklab($r, $g, $b, 1.0)
    }
    
    static [Oklch] OklabToOklch([Oklab] $lab) {
        $chroma = [Math]::Sqrt(
            [Math]::Pow($lab.ok_a, 2) +
            [Math]::Pow($lab.ok_b, 2))        
        $hue = [Math]::Atan2($lab.ok_b, $lab.ok_a) * 180.0 / [Math]::PI
        if ($hue -lt 0) { $hue += 360.0 }
        
        return [Oklch]::new($lab.ok_l, $chroma, $hue, $lab.ok_alpha)
    }
    static [Oklab] OklchToOklab([Oklch] $lch) {
        $hue_rad = $lch.ok_h * [Math]::PI / 180.0

        $a = $lch.ok_c * [Math]::Cos($hue_rad)
        $b = $lch.ok_c * [Math]::Sin($hue_rad)

        return [Oklab]::new($lch.ok_l, $a, $b, $lch.ok_alpha)
    }
}

class Oklch {
    [double] $ok_l
    [double] $ok_c
    [double] $ok_h
    [double] $ok_alpha
    Oklch([double] $l, [double] $c, [double] $h, [double] $alpha) {
        $this.ok_l     = $l
        $this.ok_c     = $c
        $this.ok_h     = $h
        $this.ok_alpha = $alpha
    }
}