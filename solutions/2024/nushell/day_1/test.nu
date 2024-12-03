use .

const DIR = "data/2024/day_1"

def "path resolve" [user: string, x: string]: [ nothing -> path ] {
    $DIR | path join $user $"($x).txt"
}

const TESTS = [
    [ user, level ];

    [ '',  silver ],
    [ '',  gold ],
    [ a-stevan, silver ],
    [ a-stevan, gold ],
]

def main [--json] {
    let res = $TESTS | insert status { |test|
        if $test.level not-in [ "silver", "gold" ] {
            error make { msg: $"unknown level ($test.level)" }
        }

        let input = path resolve $test.user input
        let expected = path resolve $test.user $test.level | open $in | into int
        let run = match $test.level {
            "silver" => { { day_1 silver $input } },
            "gold" => { { day_1 gold $input } },
        }

        try {
            let actual = do $run
            if $actual == $expected {
                "pass"
            } else {
                "fail"
            }
        } catch { |e|
            $e.msg
        }
    }

    if $json {
        $res | to json
    } else {
        print $res
    }
}
