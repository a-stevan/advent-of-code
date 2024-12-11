use std repeat

export def main []: [ string -> int ] {
    let disk = $in
        | str trim
        | split chars
        | into int
    let n = $disk | length | $in // 2
    let disk = $disk
        | reduce --fold { disk: [], id: 0, empty: false }  { |it, acc|
            print --no-newline $"reading disk: ($acc.id) / ($n)\r"
            let chunk = if $acc.empty {
                '' | repeat $it | wrap . | update . null | get .
            } else {
                $acc.id | repeat $it
            }
            let id = if $acc.empty {
                $acc.id
            } else {
                $acc.id + 1
            }
            { disk: ($acc.disk | append $chunk), id: $id, empty: (not $acc.empty) }
        }
        | get disk
    print ''

    print --no-newline "reading blocks... "
    let blocks = $disk
        | enumerate
        | where $it.item != null
        | group-by item --to-table
        | update items { get index }
        | insert start { $in.items | first }
        | insert length { $in.items | length }
        | reject items
        | rename --column { group: id }
    print ''

    let l = $disk | length
    let empty  = generate { |it|
        if $it.1 >= $l {
            return { }
        }
        print --no-newline $"reading empty sectors: ($it.1 + 1) / ($l)\r"

        let curr = $disk | get $it.1
        let prev = try { $disk | get ($it.1 - 1) } catch { null }

        if $curr != null and $prev == null { {
            out: { start: $it.2, length: $it.3 },
            next: [ false, ($it.1 + 1), 0, 0 ],
        } } else if $curr == null and $prev != null { {
            next: [ true, ($it.1 + 1), $it.1, 1 ],
        } } else { {
            next: [ $it.0, ($it.1 + 1), $it.2, ($it.3 + 1) ],
        } }
    } [ false, 0, 0, 0 ] | skip 1
    print ''

    let compacted  = generate { |bar|
        if $bar.1 < 0 {
            return { out: $bar.0 }
        }
        print --no-newline $"compacting disk: ($bar.1)         \r"

        let b = $blocks | get $bar.1
        let foo = $bar.2 | enumerate | where $it.item.length >= $b.length | get 0 --ignore-errors
        if $foo == null {
            return { next: ($bar | update 1 { $in - 1 }) }
        }

        let new_empty = if $foo.item.length == $b.length {
            $bar.2 | drop nth $foo.index
        } else {
            $bar.2 | update $foo.index {
                start: ($foo.item.start + $b.length),
                length: ($foo.item.length - $b.length),
            }
        }
        let new_disk = seq $b.start ($b.start + $b.length - 1) | reduce --fold $bar.0 { |it, acc|
            $acc | update $it null
        }
        let new_disk = $foo.item
            | seq $in.start ($in.start + $b.length - 1) | reduce --fold $new_disk { |it, acc|
                $acc | update $it $bar.1
            }

        { next: [ $new_disk, ($bar.1 - 1), $new_empty ] }
    } [ $disk, ($blocks | length | $in - 1), $empty ] | get 0
    print ''

    $compacted | enumerate | where $it.item != null | each { $in.index * $in.item } | math sum
}
