export def main []: [ string -> int ] {
    let res = $in
        | parse --regex ('mul\((?<lhs>\d+),(?<rhs>\d+)\)|(?<do>do\(\))|(?<dont>don' + "'" + 't\(\))')
        | update lhs { if $in != '' { $in | into int } else { 0 } }
        | update rhs { if $in != '' { $in | into int } else { 0 } }
        | update do { not ($in | is-empty) }
        | update dont { not ($in | is-empty) }

    let do = generate {|it|
        if ($it.1 | is-empty) {
            return
        }

        let new = if $it.1.0.do {
            true
        } else if $it.1.0.dont {
            false
        } else {
            $it.0
        }

        { out: $it.0, next: [$new, ($it.1 | skip 1)] }
    } [ true, $res ]

    $res | merge ($do | wrap x) | where x | each { $in.lhs * $in.rhs } | math sum
}
