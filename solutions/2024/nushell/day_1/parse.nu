export def main [input: path]: [ nothing -> record<left: list<int>, right: list<int>> ] {
    let data = open $input
        | detect columns --no-headers
        | rename left right
        | into int left right
        | transpose -i

    {
        left: ($data | get 0 | values),
        right: ($data | get 1 | values),
    }
}
