const NB_BLINKS = 25

export def main []: [ string -> int ] {
    let stones = $in | split row ' ' | into int

    let final_stones = 1..$NB_BLINKS
        | reduce --fold $stones { |it, acc|
            print --no-newline $"blinking: ($it) / ($NB_BLINKS)\r"
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
