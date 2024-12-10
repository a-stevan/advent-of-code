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

    let compacted = generate { |d|
        let empty = $d | enumerate | where $it.item == null | first | get index
        let block = $d | enumerate | where $it.item != null | last | get index

        print $"($empty) ($block)"

        if $empty > $block {
            return { out: $d }
        }

        { next: ($d | update $empty ($d | get $block) | update $block null) }
    } $disk | get 0

    $compacted | where $it != null | enumerate | each { $in.index * $in.item } | math sum
}
