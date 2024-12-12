use ./common.nu [ parse, trail ]

export def main []: [ string -> int ] {
    let parsed = $in | parse

    let trails = $parsed.cells
        | enumerate
        | where $it.item == 0
        | get index
        | each {{ x: ($in mod $parsed.dimensions.w), y: ($in // $parsed.dimensions.w) }}
        | each { trail $parsed.dimensions $parsed.cells }

    $trails | each { where ($it | length) == 10 | uniq | length } | math sum
}
