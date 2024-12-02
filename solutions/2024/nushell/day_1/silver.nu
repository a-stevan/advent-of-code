export def main [input: path]: [ nothing -> int ] {
    let data = open $input
        | detect columns --no-headers
        | rename left right
        | into int left right
        | transpose -i

    let left = $data | get 0 | values | sort
    let right = $data | get 1 | values | sort

    $left
        | wrap left
        | merge ($right | wrap right)
        | each { $in.left - $in.right | math abs }
        | math sum
}
