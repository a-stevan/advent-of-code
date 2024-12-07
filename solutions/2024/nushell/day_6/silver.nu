use ./main.nu *

export def main []: [ string -> int ] {
    $in | parse grid | simulate-guard | select x y | uniq | length
}
