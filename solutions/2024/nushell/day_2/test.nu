use .

const DIR = "data/2024/day_2"

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
        let input = path resolve $test.user input
        let expected = path resolve $test.user $test.level | open $in | into int
        let actual = match $test.level {
            "silver" => { day_2 silver $input },
            "gold" => { day_2 gold $input },
            _ => { print $"could not run ($test)" },
        }

        $actual == $expected
    }

    if $json {
        $res | to json
    } else {
        print $res
    }
}
