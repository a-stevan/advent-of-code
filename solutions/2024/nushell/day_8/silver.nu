use ./common.nu [ "parse antennas", "pair-by" ]

export def main []: [ string -> int ] {
    let parsed = $in | parse antennas

    let antinodes = $parsed.antennas
        | pair-by $.frequency
        | each {
            let dx = $in.0.x - $in.1.x
            let dy = $in.0.y - $in.1.y

            [
                { x: ($in.0.x + $dx), y: ($in.0.y + $dy) },
                { x: ($in.1.x - $dx), y: ($in.1.y - $dy) },
            ]
        }
        | flatten

    $antinodes
        | where $it.x >= 0 and $it.x < $parsed.w and $it.y >= 0 and $it.y < $parsed.h
        | uniq
        | length
}
