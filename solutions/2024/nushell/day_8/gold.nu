use ./common.nu [ "parse antennas", "pair-by" ]

export def main [--debug]: [ string -> int ] {
    let parsed = $in | parse antennas

    let antinodes = $parsed.antennas
        | pair-by $.frequency
        | each {
            let dx = $in.0.x - $in.1.x
            let dy = $in.0.y - $in.1.y

            let p = $in.1
            let right = seq 0 $parsed.w | each { |t|
                { x: ($p.x + $dx * $t), y: ($p.y + $dy * $t) }
            }

            let p = $in.0
            let left = seq 0 $parsed.h | each { |t|
                { x: ($p.x - $dx * $t), y: ($p.y - $dy * $t) }
            }

            $left | append $right
        }
        | flatten

    $antinodes
        | where $it.x >= 0 and $it.x < $parsed.w and $it.y >= 0 and $it.y < $parsed.h
        | uniq
        | if $debug {
            tee {
                use std repeat
                $in | reduce --fold ('.' | repeat ($parsed.w * $parsed.h)) { |it, acc|
                    $acc | update ($it.x + $parsed.w * $it.y) '#'
                } | window $parsed.w --stride $parsed.w | each { str join '' } | print
            }
        } else { $in }
        | length
}
