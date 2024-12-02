# NOTE: can't define `parse` as a module in `mod.nu` smh...
use parse.nu

export def main [input: path]: [ nothing -> int ] {
    let data = parse $input

    let foo: list<int> = $data | each { |report|
        let diffs = $report | zip ($report | skip 1) | each { $in.1 - $in.0 }
        if $diffs.0 == 0 {
            false
        } else {
            let bound = $diffs | math abs | all { $in >= 1 and $in <= 3 }
            let sign = $diffs | skip 1 | all { $in * $diffs.0 > 0 }

            $bound and $sign
        }
    } | into int

    $foo | math sum
}
