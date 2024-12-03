const HTTP_TIMESTAMP_DIR = $nu.home-path | path join ".local" "share" "http"
const HTTP_REQUEST_CACHE_DIR = $nu.home-path | path join ".cache" "http"
const AOC_API_COOLDOWN = 15min
const DATE_FORMAT = "%Y-%m-%d %H:%M:%S"

def "http get-with-cooldown" [
    url: string,
    --login: record<cookie: string, mail: string>,  # the HTTP request credentials
    --cooldown: duration,
    --cache
]: [ nothing -> record<body: string, status: int> ] {
    let timestamps_file = $HTTP_TIMESTAMP_DIR | path join ($url | url encode --all)
    let cache_file = $HTTP_REQUEST_CACHE_DIR | path join ($url | url encode --all)

    let now = date now
    let last_time = try { open $timestamps_file | lines | last | into datetime }

    if $last_time != null and ($now - $last_time) < $cooldown {
        error make --unspanned {
            msg: $"(ansi red_bold)http_request_cooldown_error(ansi reset)\n cooldown for (ansi purple)($url)(ansi reset) is not over",
            help: ([
                "",
                $"    - cooldown: (ansi green)($cooldown)(ansi reset)",
                $"    - last request: (ansi yellow)($last_time | format date $DATE_FORMAT)(ansi reset)",
                $"    - time since: (ansi red)($now - $last_time)(ansi reset)",
            ] | str join "\n"),
        }
    }

    let header = [
        Cookie $'session=($login.cookie)'
        User-Agent $'email: ($login.mail)'
    ]

    let res = http get --headers $header --full --allow-errors $url
    if $res.status != 200 {
        error make --unspanned {
          msg: $res.body
        }
    }

    if not ($HTTP_TIMESTAMP_DIR | path exists) {
        mkdir $HTTP_TIMESTAMP_DIR
    }
    $now | format date $DATE_FORMAT | $in + "\n" | save --append $timestamps_file

    if $cache {
        if not ($HTTP_REQUEST_CACHE_DIR | path exists) {
            mkdir $HTTP_REQUEST_CACHE_DIR
        }
        $res | to nuon | $in + "\n" | save --append $cache_file
    }

    $res
}

# get the data of the day for an authenticated user
#
# # Examples
# ```nushell
# # if `asc.nuon` is a GPG-encrypted file containing with the following signature
# # ```nushell
# # record<cookie: string, mail: string>
# # ```
# aoc get-data 1 --year 2022 --login (
#     gpg --quiet --decrypt aoc.nuon.asc | from nuon
# )
# ```
export def "aoc get-data" [
    day: int,  # the day of the event
    --year: int,  # the year to consider
    --login: record<cookie: string, mail: string>,  # the credentials to AoC
    --force, # force the HTTP request, bypassing the AOC API cooldown
    --cache, # store the response in a cache file
]: nothing -> string {
    let url = $'https://adventofcode.com/($year)/day/($day)/input'

    let cooldown = if $force { 0sec } else { $AOC_API_COOLDOWN }
    let res = http get-with-cooldown $url --login $login --cooldown $cooldown --cache=$cache
    $res.body
}

export def "aoc get-answers" [
    day: int,  # the day of the event
    --year: int,  # the year to consider
    --login: record<cookie: string, mail: string>,  # the credentials to AoC
    --force, # force the HTTP request, bypassing the AOC API cooldown
    --cache, # store the response in a cache file
]: [ nothing -> record<silver: int, gold: int> ] {
    let url = $'https://adventofcode.com/($year)/day/($day)'

    let cooldown = if $force { 0sec } else { $AOC_API_COOLDOWN }
    let res = http get-with-cooldown $url --login $login --cooldown $cooldown --cache=$cache

    let answers = $res.body
        | lines
        | parse --regex '.*Your puzzle answer was <code>(\d+)</code>.*'
        | get capture0

    {
        silver: $answers.0?,
        gold: $answers.1?,
    }
}

# get the number of stars for each day of a given year for an authenticated user
#
# # Examples
# ```nushell
# # if `asc.nuon` is a GPG-encrypted file containing with the following signature
# # ```nushell
# # record<cookie: string, mail: string>
# # ```
# aoc get-stars --year 2022 --login (
#     gpg --quiet --decrypt aoc.nuon.asc | from nuon
# )
# ```
export def "aoc get-stars" [
    --year: int,  # the year to consider
    --login: record<cookie: string, mail: string>,  # the credentials to AoC
    --force, # force the HTTP request, bypassing the AOC API cooldown
    --cache, # store the response in a cache file
]: nothing -> table<day: int, stars: int> {
    let url = $"https://adventofcode.com/($year)"

    let cooldown = if $force { 0sec } else { $AOC_API_COOLDOWN }
    let res = http get-with-cooldown $url --login $login --cooldown $cooldown --cache=$cache

    $res.body
        | lines
        | parse --regex '.*\<a aria-label="Day (?<day>\d+)(?<stars>.*)" href=.*'
        | into int day
        | sort-by day
        | update stars {
            if ($in | str contains "one") {
                1
            } else if ($in | str contains "two") {
                2
            } else {
                0
            }
        }
}

# jump to a solution
export def --env jump [] {
    let res = ls solutions/*/*/* | get name | find --invert "/_data/" | input list --fuzzy
    if $res == null {
        return
    }

    cd $res
}

export def "init ocaml" [year: int, day: int]: nothing -> nothing {
    let day = $"day_($day)"
    let target = ("solutions" | path join ($year | into string) "ocaml" $day)

    mkdir $target
    cp ("templates" | path join "ocaml" "*") $target --recursive

    # NOTE: this should work in `do { ... }`
    ls ($target | path join "**/*")
        | find day_x
        | get name
        | ansi strip
        | wrap old
        | insert new {|it| $it.old | str replace day_x $day}
        | each { mv $in.old $in.new }

    do {
        cd $target

        ^sd Day_x ($day | str capitalize) **/*
        ^sd day_x $day **/*
        ^sd yyyy $year **/*
    }

    mkdir ("data" | path join ($year | into string) $day)
}

export def "run ocaml" [code: closure, --year: int]: nothing -> nothing {
    let days = "solutions"
        | path join ($year | into string) "ocaml" "*"
        | into glob
        | ls $in
        | get name
    for day in $days {
        do {
            cd $day
            print $day
            overlay use ocaml.nu
            try { do $code }
        }
    }
}
