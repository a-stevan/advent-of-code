export def "parse grid" []: [
    string -> record<
        grid: list<list<string>>,
        guard: record<x: int, y: int>,
        obstacles: table<x: int, y: int>,
    >
] {
    let grid = $in | lines | each { split chars }
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

    { grid: $grid, guard: $guard, obstacles: $obstacles }
}

export def simulate-guard []: [
    record<
        grid: list<list<string>>,
        guard: record<x: int, y: int>,
        obstacles: table<x: int, y: int>,
    > -> record<trail: table<x: int, y: int, dx: int, dy: int>, loop: bool>
] {
    let grid = $in.grid
    let h = $grid | length
    let w = $grid.0 | length

    let guard = $in.guard
    let obstacles = $in.obstacles

    mut dir = { x: 0, y: -1 }
    mut pos = $guard
    mut trail = [ { x: $pos.x, y: $pos.y, dx: $dir.x, dy: $dir.y } ]
    while true {
        let in_sight = if $dir.x == 1 {
            $obstacles | where $it.y == $pos.y and $it.x > $pos.x | sort-by x
        } else if $dir.x == -1 {
            $obstacles | where $it.y == $pos.y and $it.x < $pos.x | sort-by x --reverse
        } else if $dir.y == 1 {
            $obstacles | where $it.x == $pos.x and $it.y > $pos.y | sort-by y
        } else if $dir.y == -1 {
            $obstacles | where $it.x == $pos.x and $it.y < $pos.y | sort-by y --reverse
        }

        if ($in_sight | is-empty) {
            break
        }

        let new = $in_sight.0 | { x: ($in.x + $dir.x * -1), y: ($in.y + $dir.y * -1) }
        let tmp = { pos: $pos, dir: $dir } # NOTE: required to avoid "capture of mutable variables"
        let partial_trail_length = $pos.x - $new.x + $pos.y - $new.y | math abs
        $trail = $trail | append (
            seq 1 ($partial_trail_length - 1) | each { |i| {
                x: ($tmp.pos.x + $tmp.dir.x * $i),
                y: ($tmp.pos.y + $tmp.dir.y * $i),
                dx: $tmp.dir.x,
                dy: $tmp.dir.y,
            } }
        )
        $pos = $new
        let tmp: record<x: int, y: int> = { x: (-1 * $dir.y), y: $dir.x } # NOTE: required to avoid "type mismatch"
        let end = { x: $new.x, y: $new.y, dx: $tmp.x, dy: $tmp.y }
        if $end in $trail {
            return { trail: ($trail | append $end), loop: true }
        }
        $trail = $trail | append $end
        $dir = $tmp
    }

    let border = if $dir.x == 1 {
        { x: ($w - 1), y: $pos.y }
    } else if $dir.x == -1 {
        { x: 0, y: $pos.y }
    } else if $dir.y == 1 {
        { x: $pos.x, y: ($h - 1) }
    } else if $dir.y == -1 {
        { x: $pos.x, y: 0 }
    }
    let tmp = { pos: $pos, dir: $dir } # NOTE: required to avoid "capture of mutable variables"
    let partial_trail_length = $pos.x - $border.x + $pos.y - $border.y | math abs
    $trail = $trail | append (
        seq 1 $partial_trail_length | each { |i| {
            x: ($tmp.pos.x + $tmp.dir.x * $i),
            y: ($tmp.pos.y + $tmp.dir.y * $i),
            dx: $tmp.dir.x,
            dy: $tmp.dir.y,
        } }
    )

    { trail: $trail, loop: false }
}
