# NOTE: can't define `parse` as a module in `mod.nu` smh...
use parse.nu

export def main [input: path]: [ nothing -> int ] {
    let data = parse $input

    $data
        | each { |report|
            let n = $report | length

            let relaxed_reports = seq 0 ($n - 1) | each { |i|
                # NOTE: range is annoying with 0..0
                let left = if $i == 0 {
                    []
                } else {
                    $report | range 0..<$i
                }
                let right = $report | range ($i + 1)..($n - 1)

                $left ++ $right | take ($n - 1) # NOTE: strange
            }

            $relaxed_reports | each { |report|
                let foo = $report | zip ($report | skip 1) | each { $in.1 - $in.0 }

                let bound = $foo | math abs | all { $in >= 1 and $in <= 3 }
                let sign = $foo | skip 1 | all { $in * $foo.0 > 0 }

                $bound and $sign
            } | into int | math sum
        }
        | where $it > 0
        | length
}
