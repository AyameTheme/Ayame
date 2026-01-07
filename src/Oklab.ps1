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
}