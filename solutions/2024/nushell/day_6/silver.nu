use ./main.nu *

export def main []: [ string -> int ] {
    $in | parse grid | simulate-guard | get trail | select x y | uniq | length
}
