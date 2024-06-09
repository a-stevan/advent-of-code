use std assert
use std log

const TESTS = [
    [ name,             bin,          input,               expected                      ];
    [ "silver",         "silver.lua", "silver/input.txt",  "silver/expected.txt"         ],
    [ "amtoine-silver", "silver.lua", "amtoine/input.txt", "amtoine/silver-expected.txt" ],
    [ "gold",           "gold.lua",   "gold/input.txt",    "gold/expected.txt"           ],
    [ "amtoine-gold",   "gold.lua",   "amtoine/input.txt", "amtoine/gold-expected.txt"   ],
]

def get-test-names [] {
    $TESTS.name
}

export def main [
    year: int,
    day: int,
    ...tests: string@get-test-names,
    --root: path = "../../../../",
] {
    let path = $root | path expand | path join data $"($year)" $"day_($day)"

    for test in $tests {
        let t = $TESTS | where name == $test | into record
        if $t == {} {
            log warning $"`($test)` is not a valid test: skipping..."
            continue
        }

        log info $"testing ($t.name)..."
        let actual = lua $t.bin ($path | path join $t.input)
        let expected = open ($path | path join $t.expected)
        assert equal $actual $expected
    }
}
