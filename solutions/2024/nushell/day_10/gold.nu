use ./common.nu [ parse, compute-trails ]

export def main []: [ string -> int ] {
    parse | compute-trails | each { where ($it | length) == 10 | uniq | length } | math sum
}
