export def main []: [ string -> int ] {
    parse --regex 'mul\((?<lhs>\d+),(?<rhs>\d+)\)'
        | into int lhs rhs
        | each { $in.lhs * $in.rhs }
        | math sum
}
