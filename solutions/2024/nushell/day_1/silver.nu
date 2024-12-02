use parse.nu

export def main [input: path]: [ nothing -> int ] {
    let data = parse $input

    let left = $data.left | sort
    let right = $data.right | sort

    $left
        | wrap left
        | merge ($right | wrap right)
        | each { $in.left - $in.right | math abs }
        | math sum
}
