export def main []: [ string -> int ] {
    let grid = $in | lines | each { split chars }

    let cells = $in | str replace --all "\n" '' | split chars
    let dimensions = $in | lines | each { split chars } | { h: ($in | length), w: ($in.0 | length) }

    let antennas = $cells
        | enumerate
        | where $it.item != '.'
        | insert x { $in.index mod $dimensions.w }
        | insert y { $in.index // $dimensions.w }
        | reject index
        | rename --column { item: antenna }

    let pairs = $antennas | group-by antenna | items { |_, v|
        $v | enumerate | each { |vi|
            $v | skip ($vi.index + 1) | each { |vj| [$vi.item, $vj] }
        } | flatten
    } | flatten

    let antinodes = $pairs
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
        | where $it.x >= 0 and $it.x < $dimensions.w and $it.y >= 0 and $it.y < $dimensions.h
        | uniq
        | length
}
