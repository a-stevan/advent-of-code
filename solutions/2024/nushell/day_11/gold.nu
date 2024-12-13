use ./common.nu [ parse, solve ]

export def main []: [ string -> int ] {
    parse | solve --nb-blinks 75
}
