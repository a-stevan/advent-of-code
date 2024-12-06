export def main []: [ string -> int ] {
    let grid = $in | lines | each { split chars }
    let n = $grid | length
    let m = $grid.0 | length

    let horiz = seq 0 ($n - 1) | each { |i|
        print --no-newline $"horiz: ($i + 1) / ($n)\r"
        seq 0 ($m - 4) | each { |j|
            seq 0 3 | each { |dj| [$i, ($j + $dj)] }
        }
    } | flatten
    print ''

    let vert = seq 0 ($n - 4) | each { |i|
        print --no-newline $"vert: ($i + 1) / ($n - 3)\r"
        seq 0 ($m - 1) | each { |j|
            seq 0 3 | each { |di| [($i + $di), $j] }
        }
    } | flatten
    print ''

    let diag_1 = seq 0 ($n - 4) | each { |i|
        print --no-newline $"diag_1: ($i + 1) / ($n - 3)\r"
        seq 0 ($m - 4) | each { |j|
            seq 0 3 | each { |d| [($i + $d), ($j + $d)] }
        }
    } | flatten
    print ''

    let diag_2 = seq 0 ($n - 4) | each { |i|
        print --no-newline $"diag_2: ($i) / ($n - 3)\r"
        seq 3 ($m - 1) | each { |j|
            seq 0 3 | each { |d| [($i + $d), ($j - $d)] }
        }
    } | flatten
    print ''

    let candidates = $horiz ++ $vert ++ $diag_1 ++ $diag_2
    let nb_candidates = $candidates | length

    $candidates | enumerate | where { |c|
        print --no-newline $"candidates: ($c.index) / ($nb_candidates)\r"
        let four = $c.item | each { |p| $grid | get $p.0 | get $p.1 } | str join ''
        $four == "XMAS" or $four == "SAMX"
    } | math sum
}
