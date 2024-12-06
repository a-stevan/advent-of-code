export def main []: [ string -> record<left: list<int>, right: list<int>> ] {
    let data = $in
        | detect columns --no-headers
        | rename left right
        | into int left right
        | transpose -i

    {
        left: ($data | get 0 | values),
        right: ($data | get 1 | values),
    }
}
