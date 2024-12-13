export def parse []: [ string -> list<int> ] {
    split row ' ' | into int
}

export def solve [--nb-blinks: int]: [ list<int> -> int ] {
    let stones = $in

    let final_stones = 1..$nb_blinks
        | reduce --fold $stones { |it, acc|
            print --no-newline $"blinking: ($it) / ($nb_blinks)\r"
            $acc | each { |s|
                if $s == 0 {
                    [1]
                } else {
                    let str = $s | into string
                    let n = $str | str length
                    if $n mod 2 == 0 {
                        [
                            ($str | str substring 0..<($n // 2)),
                            ($str | str substring ($n // 2)..),
                        ] | into int
                    } else {
                        $s * 2024
                    }
                }
            } | flatten
        }
    print ''

    $final_stones | length
}
