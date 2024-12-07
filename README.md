# advent-of-code
A collection of solutions for the advent of code event each year from 2015.

## Disclaimer
This repo contains my personal solutions to the challenges in the "Advent of Code" events.
You might get spoiled.
You are warned!

Otherwise, enjoy my solutions :wink:

## The list of events
| year                                  | OCaml                        | Nushell                                                                       | Oberon                                                                 |
| ------------------------------------- | ---------------------------- | ----------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| [2024](https://adventofcode.com/2024) |                              | [here](solutions/2024/nushell)                                                |                                                                        |
| [2023](https://adventofcode.com/2023) | [here](solutions/2023/ocaml) |                                                                               |                                                                        |
| [2022](https://adventofcode.com/2022) |                              | [here](https://github.com/amtoine/advent-of-code/tree/2022/solutions/nushell) |                                                                        |
| [2021](https://adventofcode.com/2021) |                              |                                                                               | [here](https://github.com/amtoine/advent-of-code/tree/2021/challenges) |
| [2020](https://adventofcode.com/2020) |                              |                                                                               |                                                                        |
| [2019](https://adventofcode.com/2019) |                              |                                                                               |                                                                        |
| [2018](https://adventofcode.com/2018) |                              |                                                                               |                                                                        |
| [2017](https://adventofcode.com/2017) |                              |                                                                               |                                                                        |
| [2016](https://adventofcode.com/2016) |                              |                                                                               |                                                                        |
| [2015](https://adventofcode.com/2015) |                              |                                                                               |                                                                        |

## Some language specific instructions
- [OCaml](docs/ocaml.md)

## Get the input
the input for the challenges is different for each user and thus requires a session cookie.

### get the cookie
please follow the steps in [wimglenn/advent-of-code-wim#1](https://github.com/wimglenn/advent-of-code-wim/issues/1) to get your personal session cookie :thumbsup:

### store the cookie
according to [this sub reddit](https://www.reddit.com/r/adventofcode/comments/z9dhtd/please_include_your_contact_info_in_the_useragent/),
one should also include their email in the metadata of the GET requests :ok_hand:

please store your information in a NUON file with the following format:
```nushell
{
    cookie: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    mail: "xxxx@xxx.xxx"
}
```

i also recommend encrypting this sensitive file with
```shell
gpg --symmetric --armor --cipher-algo <algo> <file>
```
to have it available as a `.asc` file.

### test solutions with the AoC API
with Nushell,
```nushell
use toolkit.nu
use std assert

use solutions/2024/nushell/day_1
use solutions/2024/nushell/day_2
use solutions/2024/nushell/day_3
use solutions/2024/nushell/day_4
use solutions/2024/nushell/day_5
use solutions/2024/nushell/day_6
use solutions/2024/nushell/day_7
let sols = [
    [ day, silver, gold ];

    [ 1, { day_1 silver }, { day_1 gold } ],
    [ 2, { day_2 silver }, { day_2 gold } ],
    [ 3, { day_3 silver }, { day_3 gold } ],
    [ 4, { day_4 silver }, { day_4 gold } ],
    [ 5, { day_5 silver }, { day_5 gold } ],
    [ 6, { day_6 silver }, { day_6 gold } ],
    [ 7, { day_7 silver }, { day_7 gold } ],
]

let login = {
    cookie: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    mail: "xxxx@xxx.xxx"
}
let inputs = $sols.day | enumerate | each { |d|
    print --no-newline $"pulling inputs: day ($d.item) \(($d.index + 1) / ($sols | length)\)\r"
    toolkit aoc get-data --login $login --year 2024 $d.item
}
print ""
let answers = $sols.day | enumerate | each { |d|
    print --no-newline $"pulling answers: day ($d.item) \(($d.index + 1) / ($sols | length)\)\r"
    toolkit aoc get-answers --login $login --year 2024 $d.item
}
print ""

def timeit [code: closure, ...args: any]: [ any -> record<res: any, time: duration> ] {
    let start_time = date now

    let res = $in | do $code ...$args

    { res: $res, time: ((date now) - $start_time) }
}

let benchmarks = $inputs
    | wrap input
    | merge ($answers | wrap answers)
    | merge ($sols | wrap sol)
    | each { |day|
        print $"running day ($day.sol.day) part silver..."
        let silver = try {
            let res = $day.input | timeit $day.sol.silver
            let status = if $res.res == $day.answers.silver {
                "pass"
            } else {
                "fail"
            }
            { status: $status, time: $res.time }
        } catch { |e|
            { status: $e.msg, time: null }
        } | merge { day: $day.sol.day, part: "silver" }

        if $day.answers.gold != null {
            print $"running day ($day.sol.day) part gold... "
            let gold = try {
                let res = $day.input | timeit $day.sol.gold
                let status = if $res.res == $day.answers.gold {
                    "pass"
                } else {
                    "fail"
                }
                { status: $status, time: $res.time }
            } catch { |e|
                { status: $e.msg, time: null }
            } | merge { day: $day.sol.day, part: "gold" }
            return [$silver, $gold]
        }

        $silver
    }
    | flatten
```

> **Note**
>
> if the cookie has been encrypted, you can use
> ```nushell
> gpg --decrypt --armor <file> | from nuon
> ```

#### results
- Nushell install
| .                  | .                                   |
| ------------------ | ----------------------------------- |
| version            | 0.100.0                             |
| major              | 0                                   |
| minor              | 100                                 |
| patch              | 0                                   |
| branch             |                                     |
| commit_hash        |                                     |
| build_os           | linux-x86_64                        |
| build_target       | x86_64-unknown-linux-gnu            |
| rust_version       | rustc 1.80.1 (3f5fd8dd4 2024-08-06) |
| rust_channel       | 1.80.1-x86_64-unknown-linux-gnu     |
| cargo_version      | cargo 1.80.1 (376290515 2024-07-16) |
| build_time         | 2024-11-20 19:27:39 +01:00          |
| build_rust_channel | release                             |
| allocator          | mimalloc                            |
| features           | default, sqlite, trash              |
- CPU spec
| .                  | .                                        |
| ------------------ | ---------------------------------------- |
| Architecture       | x86_64                                   |
| CPU(s)             | 8                                        |
| Model name         | Intel(R) Core(TM) i5-8250U CPU @ 1.60GHz |
| Thread(s) per core | 2                                        |
| Core(s) per socket | 4                                        |
| Socket(s)          | 1                                        |
| CPU max MHz        | 3400.0000                                |
| CPU min MHz        | 400.0000                                 |
| BogoMIPS           | 3601.00                                  |
| L1d cache          | 128 KiB (4 instances)                    |
| L1i cache          | 128 KiB (4 instances)                    |
| L2 cache           | 1 MiB (4 instances)                      |
| L3 cache           | 6 MiB (1 instance)                       |
> **Note**
>
> ```nushell
> lscpu
>     | lines
>     | parse "{k}: {v}"
>     | str trim
>     | where k !~ "Vuln"
>     | transpose --header-row
>     | into record
>     | select ...[
>         "Architecture", "CPU(s)", "Model name", "Thread(s) per core",
>         "Core(s) per socket", "Socket(s)", "CPU max MHz", "CPU min MHz",
>         "BogoMIPS", "L1d cache", "L1i cache", "L2 cache", "L3 cache"
>     ]
> ```
- the results
| day | part   | status | time                          |
| --- | ------ | ------ | ----------------------------- |
| 1   | silver | pass   | 22ms 309µs 300ns             |
| 1   | gold   | pass   | 55ms 566µs 231ns             |
| 2   | silver | pass   | 498ms 416µs 227ns            |
| 2   | gold   | pass   | 3sec 225ms 867µs 677ns       |
| 3   | silver | pass   | 8ms 602µs 739ns              |
| 3   | gold   | pass   | 66ms 649µs 439ns             |
| 4   | silver | pass   | 5min 47sec 538ms 98µs 343ns  |
| 4   | gold   | pass   | 2min 10sec 978ms 55µs 516ns  |
| 5   | silver | pass   | 810ms 747µs 858ns            |
| 6   | silver | pass   | 756ms 571µs 417ns            |
| 6   | gold   | pass   | 33min 30sec 58ms 541µs 422ns |
| 7   | silver | pass   | 1min 44sec 747ms 847µs 772ns |
