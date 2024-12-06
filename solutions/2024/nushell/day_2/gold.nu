# NOTE: can't define `parse` as a module in `mod.nu` smh...
use parse.nu

# deprecated
def "list reject" [i: int]: [ list -> list ] {
    let n = $in | length

    # NOTE: range is annoying with 0..0
    let left = $in | if $i == 0 {
        []
    } else {
        $in | range 0..<$i
    }
    let right = $in | range ($i + 1)..($n - 1)

    $left ++ $right | take ($n - 1) # NOTE: strange that this is required
}

export def main []: [ string -> int ] {
    let data = $in | parse

    $data
        | each { |report|
            let n = $report | length

            let relaxed_reports = seq 0 ($n - 1) | each { |i| $report | drop nth $i }

            $relaxed_reports | each { |report|
                let diffs = $report | zip ($report | skip 1) | each { $in.1 - $in.0 }

                let bound = $diffs | math abs | all { $in >= 1 and $in <= 3 }
                let sign = $diffs | skip 1 | all { $in * $diffs.0 > 0 }

                $bound and $sign
            } | into int | math sum
        }
        | where $it > 0
        | length
}
