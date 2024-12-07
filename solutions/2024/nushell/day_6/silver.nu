export def main []: [ string -> int ] {
    let grid = $in | lines | each { split chars }
    let h = $grid | length
    let w = $grid.0 | length

    let vert = $grid | enumerate | find '^' | into record
    let horiz = $vert.item | ansi strip | split chars | skip 1 | enumerate | find '^' | into record
    let guard = { x: $horiz.index, y: $vert.index }

    let obstacles = $in
        | lines
        | str join ''
        | split chars
        | enumerate
        | find '#'
        | get index
        | each { |o| { x: ($o mod $w), y: ($o // $w) } }

    def "2d-vec to-str" [ v: record<x: int, y: int> ]: [ nothing -> string ] {
        $"\(($v.x), ($v.y)\)"
    }

    mut dir: record<x: int, y: int> = { x: 0, y: -1 }
    mut pos = $guard
    mut trail = [ $pos ]
    while true {
        # print $in
        # print $"pos: (2d-vec to-str $pos)"
        # print $"dir: (2d-vec to-str $dir)"
        let in_sight = if $dir.x == 1 {
            $obstacles | where $it.y == $pos.y and $it.x > $pos.x | sort-by x
        } else if $dir.x == -1 {
            $obstacles | where $it.y == $pos.y and $it.x < $pos.x | sort-by x --reverse
        } else if $dir.y == 1 {
            $obstacles | where $it.x == $pos.x and $it.y > $pos.y | sort-by y
        } else if $dir.y == -1 {
            $obstacles | where $it.x == $pos.x and $it.y < $pos.y | sort-by y --reverse
        }

        $in_sight | each { 2d-vec to-str $in } | to text | print

        if ($in_sight | is-empty) {
            break
        }

        let new = $in_sight.0 | { x: ($in.x + $dir.x * -1), y: ($in.y + $dir.y * -1) }
        let foo = $pos
        let bar = $dir
        $trail = $trail | append (
            seq 1 ($pos.x - $new.x + $pos.y - $new.y | math abs) | each { |i|
                { x: ($foo.x + $bar.x * $i), y: ($foo.y + $bar.y * $i) }
            }
        )
        $pos = $new
        let tmp: record<x: int, y: int> = { x: (-1 * $dir.y), y: $dir.x }
        $dir = $tmp
    }

    # print $"last pos: (2d-vec to-str $pos)"
    # print $"last dir: (2d-vec to-str $dir)"
    let border = if $dir.x == 1 {
        { x: ($w - 1), y: $pos.y }
    } else if $dir.x == -1 {
        { x: 0, y: $pos.y }
    } else if $dir.y == 1 {
        { x: $pos.x, y: ($h - 1) }
    } else if $dir.y == -1 {
        { x: $pos.x, y: 0 }
    }
    let tmp = { pos: $pos, dir: $dir }
    # print $border
    # print $pos
    # print ($tmp | te)
    # print ($pos.x - $border.x + $pos.y - $border.y)
    $trail = $trail | append (
        seq 1 ($pos.x - $border.x + $pos.y - $border.y | math abs) | each { |i|
            { x: ($tmp.pos.x + $tmp.dir.x * $i), y: ($tmp.pos.y + $tmp.dir.y * $i) }
        }
    )
    # print $trail

    $trail | uniq | length
}
