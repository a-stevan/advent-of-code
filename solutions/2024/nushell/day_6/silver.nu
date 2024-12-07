use ./main.nu *

export def main []: [ string -> int ] {
    $in | parse grid | simulate-guard | uniq | length
}
