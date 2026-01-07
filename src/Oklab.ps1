class Oklab {
    hidden [float] $ok_l
    hidden [float] $ok_a
    hidden [float] $ok_b
    hidden [float] $alpha
    
    Oklab(
        [float] $l,
        [float] $a,
        [float] $b,
        [float] $alpha
    ) {
        $this.ok_l  = $l
        $this.ok_a  = $a
        $this.ok_b  = $b
        $this.alpha = $alpha
    }
}