export def main []: [ string -> int ] {
    let equations = lines
        | parse "{result}: {nbs}"
        | into int result
        | update nbs { split row ' ' | into int }

    let n = $equations | length
    let possible_results = $equations | enumerate | each { |eq|
        print --no-newline $"($eq.index + 1) / ($n)\r"
        let nb_operators = $eq.item.nbs | length | $in - 1
        let combs = seq 0 (2 ** $nb_operators - 1) | each {
            fmt
                | get binary
                | parse "0b{bits}"
                | into record
                | get bits
                | fill --alignment right --character '0' --width $nb_operators
                | str replace --all '0' '+'
                | str replace --all '1' '*'
                | split chars
        }

        let possible = $combs | each {
            let actual = $in | zip ($eq.item.nbs | skip 1) | reduce --fold $eq.item.nbs.0 { |it, acc|
                match $it.0 {
                    '+' => { $acc + $it.1 },
                    '*' => { $acc * $it.1 },
                }
            }

            $actual == $eq.item.result
        } | any { $in }

        if $possible {
            $eq.item.result
        }
    }

    $possible_results | math sum
}
