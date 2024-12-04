export def main []: [ string -> int ] {
    let grid = $in | lines | each { split chars }
    let n = $grid | length
    let m = $grid.0 | length

    mut candidates = []

    # horizontal
    print "horiz"
    for i in (seq 0 ($n - 1)) {
        print --no-newline $"($i)\r"
        for j in (seq 0 ($m - 4)) {
            $candidates ++= [ (seq 0 3 | each { |dj| [$i, ($j + $dj)] }) ]
        }
    }

    # vertical
    print "vert"
    for i in (seq 0 ($n - 4)) {
        for j in (seq 0 ($m - 1)) {
            $candidates ++= [ (seq 0 3 | each { |di| [($i + $di), $j] }) ] }
    }

    # diag
    print "diag"
    for i in (seq 0 ($n - 4)) {
        for j in (seq 0 ($m - 4)) {
            $candidates ++= [ (seq 0 3 | each { |d| [($i + $d), ($j + $d)] }) ]
        }
    }
    print "diag"
    for i in (seq 0 ($n - 4)) {
        for j in (seq 3 ($m - 1)) {
            $candidates ++= [ (seq 0 3 | each { |d| [($i + $d), ($j - $d)] }) ]
        }
    }

    $candidates = $candidates | uniq

    mut count = 0
    for c in $candidates {
        let four = $c | each { |p| $grid | get $p.0 | get $p.1 } | str join ''
        if $four == "XMAS" or $four == "SAMX" {
            $count += 1
        }
    }

    return $count
}
