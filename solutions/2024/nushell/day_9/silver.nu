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

    let empty = $disk | enumerate | where $it.item == null | get index
    let block = $disk | enumerate | where $it.item != null | get index
    let compacted = generate { |it|
        let e = $empty | get $it.1
        let b = $block | get $it.2
        print --no-newline $"compacting: ($e) - ($b)                 \r"

        if $e > $b {
            return { out: $it.0 }
        }

        { next: [
            ($it.0 | update $e ($it.0 | get $b) | update $b null),
            ($it.1 + 1),
            ($it.2 - 1),
        ] }
    } [$disk, 0, ($block | length | $in - 1)] | get 0
    print ''

    $compacted | where $it != null | enumerate | each { $in.index * $in.item } | math sum
}
