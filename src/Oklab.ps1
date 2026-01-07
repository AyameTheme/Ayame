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
}