# NOTE: can't define `parse` as a module in `mod.nu` smh...
use parse.nu

export def main []: [ string -> int ] {
    let data = $in | parse

    let left = $data.left | sort
    let right = $data.right | sort

    $left
        | wrap left
        | merge ($right | wrap right)
        | each { $in.left - $in.right | math abs }
        | math sum
}
