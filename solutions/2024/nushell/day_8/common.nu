export def "parse antennas" []: [
    string -> record<
        antennas: table<frequency: string, x: int, y: int>,
        w: int,
        h: int,
    >
] {
    let grid = $in | lines | each { split chars }

    let cells = $in | str replace --all "\n" '' | split chars
    let dimensions = $in| lines | each { split chars } | { h: ($in | length), w: ($in.0 | length) }

    let antennas = $cells
        | enumerate
        | where $it.item != '.'
        | insert x { $in.index mod $dimensions.w }
        | insert y { $in.index // $dimensions.w }
        | reject index
        | rename --column { item: frequency }

    { antennas: $antennas, w: $dimensions.w, h: $dimensions.h }
}
