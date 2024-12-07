use ./main.nu *

export def main []: [ string -> int ] {
    let parsed = $in | parse grid
    let trail = $parsed | simulate-guard | get trail
    let candidates = $trail | select x y | where not ($it.x == $trail.0.x and $it.y == $trail.0.y) | uniq

    let n = $candidates | length
    let loops = $candidates | enumerate | each { |c|
        print --no-newline $"($c.index + 1) / ($n)\r"
        if (
            $parsed.grid
                | update ([$c.item.y, $c.item.x] | into cell-path) '#'
                | each { str join '' }
                | str join "\n"
                | parse grid
                # | tee { get grid | each { str join ' ' } | print }
                | simulate-guard
                # | tee { get trail | print }
                | get loop
        ) {
            $c
        }
    }
    print ''

    $loops | length
}
