export def main []: [ string -> int ] {
    let grid = $in | lines | each { split chars }
    let h = $grid | length
    let w = $grid.0 | length

    let vert = $grid | enumerate | find '^' | into record
    let horiz = $vert.item | ansi strip | split chars | skip 1 | enumerate | find '^' | into record
    let guard = [$vert.index, $horiz.index]

    let obstacles = $in
        | lines
        | str join ''
        | split chars
        | enumerate
        | find '#'
        | get index
        | each { |o| [($o // $w), ($o mod $w)] }

    0
}
