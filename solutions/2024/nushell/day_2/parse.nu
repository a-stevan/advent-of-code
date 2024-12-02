export def main [input: path]: [ nothing -> list<list<int>> ] {
    open $input | lines | each { split row ' ' | into int }
}
