export def parse []: [
    string -> record<cells: list<int>, dimensions: record<w: int, h: int>>
] {
    {
        cells: ($in | lines | str join '' | split chars | into int),
        dimensions: ($in
            | lines
            | each { split chars }
            | { h: ($in | length), w: ($in.0 | length) }
        ),
    }
}

def trail [
    dimensions: record<w: int, h: int>,
    cells: list<int>,
]: [ record<x:int, y: int> -> list<table<x: int, y: int>> ] {
    def aux [pos: record<x:int, y: int>, val: int]: [ nothing -> list<table<x: int, y: int>> ] {
        let neighbours = [[0, 1], [0, -1], [1, 0], [-1, 0]]
            | each { |it|
                { x: ($pos.x + $it.0), y: ($pos.y + $it.1) }
            }
            | where (
                $it.x >= 0 and $it.x < $dimensions.w and
                $it.y >= 0 and $it.y < $dimensions.h and
                ($cells | get ($it.y * $dimensions.w + $it.x)) == $val
            )

        if ($neighbours | is-empty) {
            return [$pos]
        }

        let tails = $neighbours | each { aux $in ($val + 1) } | flatten

        $tails | each { prepend $pos }
    }

    aux $in 1
}


export def compute-trails []: [
    record<cells: list<int>, dimensions: record<w: int, h: int>>
    -> list<table<x: int, y: int>>
] {
    let input = $in

    $input.cells
        | enumerate
        | where $it.item == 0
        | get index
        | each {{ x: ($in mod $input.dimensions.w), y: ($in // $input.dimensions.w) }}
        | each { trail $input.dimensions $input.cells }
        | tee { describe | print }
}
