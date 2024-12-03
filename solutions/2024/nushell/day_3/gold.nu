export def main []: [ string -> int ] {
    let res = $in
        | parse --regex ('mul\((?<lhs>\d+),(?<rhs>\d+)\)|(?<do>do\(\))|(?<dont>don' + "'" + 't\(\))')
        | update lhs { if $in != '' { $in | into int } else { 0 } }
        | update rhs { if $in != '' { $in | into int } else { 0 } }
        | update do { not ($in | is-empty) }
        | update dont { not ($in | is-empty) }

    mut do = [true]
    for i in $res {
        let new = if $i.do {
            true
        } else if $i.dont {
            false
        } else {
            $do | last
        }

        $do = $do | append $new
    }

    $res | merge ($do | wrap x) | where x | each { $in.lhs * $in.rhs } | math sum
}
