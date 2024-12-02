export def main []: [ string -> int ] {
    lines | each {
        let digits = $in | split row '' | where $it =~ '\d' | into int
        ($digits | first) * 10 + ($digits | last)
    } | math sum
}
