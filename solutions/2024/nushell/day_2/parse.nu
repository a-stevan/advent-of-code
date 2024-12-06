export def main []: [ string -> list<list<int>> ] {
    lines | each { split row ' ' | into int }
}
