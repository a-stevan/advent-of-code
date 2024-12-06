export def main []: [ string -> int ] {
    let tmp = $in | lines | split list ''
    let rules = $tmp.0
        | parse "{before}|{after}"
        | into int before after
        | group-by before --to-table
        | update items { get after }
        | transpose --header-row
        | into record
    let updates = $tmp.1 | each { split words | into int }

    $updates
        | wrap update
        | insert valid { |u|
            let n = $u.update | length

            0..<$n
                | each { |i|
                    let before = $u.update | get $i
                    ($i + 1)..<$n | each { |j|
                        let after = $u.update | get $j
                        $after in ($rules | get ($before | into string) -i | default [])
                    }
                }
                | flatten
                | all { $in }
        }
        | where valid
        | each { |it| $it.update | get ($it.update | length | $in // 2) }
        | math sum
}
