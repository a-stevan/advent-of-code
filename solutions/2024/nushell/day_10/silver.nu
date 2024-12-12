export def main []: [ string -> int ] {
    let cells = $in | lines | str join '' | split chars | into int
    let dimensions = $in | lines | each { split chars } | { h: ($in | length), w: ($in.0 | length) }

    def f [pos: record<x:int, y: int>, val: int] {
        # print --no-newline $"\(($pos.x), ($pos.y)\): "
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

        let tails = $neighbours | each { f $in ($val + 1) } | flatten

        $tails | each { prepend $pos }
    }

    let trails = $cells
        | enumerate
        | where $it.item == 0
        | get index
        | each {{ x: ($in mod $dimensions.w), y: ($in // $dimensions.w) }}
        | each { f $in 1 }

    $trails | each { where ($it | length) == 10 | each { last } | uniq | length } | math sum
}
