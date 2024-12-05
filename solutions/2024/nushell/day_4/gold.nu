export def main []: [ string -> int ] {
    let grid = $in | lines | each { split chars }
    let n = $grid | length
    let m = $grid.0 | length

    mut count = 0

    for i in (seq 1 ($n - 2)) {
        print --no-newline $"($i)\r"
        for j in (seq 1 ($m - 2)) {
            let diag_1 = seq -1 1 | each { |d| $grid | get ($i + $d) | get ($j + $d)} | str join ''
            let diag_2 = seq -1 1 | each { |d| $grid | get ($i + $d) | get ($j - $d)} | str join ''

            if ($diag_1 == "MAS" or $diag_1 == "SAM") and ($diag_2 == "MAS" or $diag_2 == "SAM") {
                $count += 1
            }
        }
    }

    $count
}
