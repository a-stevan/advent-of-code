# test solutions with the AoC API
with Nushell,
```nushell
use benchmarks/2024/nushell

let login = {
    cookie: "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    mail: "xxxx@xxx.xxx"
}
let inputs_and_answers = 1..7 | nushell pull --login $login
let benchmarks = $inputs_and_answers | nushell run
```

> **Note**
>
> if the cookie has been encrypted, you can use
> ```nushell
> gpg --decrypt --armor <file> | from nuon
> ```

# results
```nushell
use benchmarks/2024/nushell

let login = open ~/documents/aoc/cookie.nuon
let inputs_and_answers = 1..7 | nushell pull --login $login --force

let results = {
    nushell: (version),
    cpu: (nushell cpu),
    results: ($inputs_and_answers | nushell run),
}

$results | to nuon -i 4 | save benchmarks/2024/nushell/a-stevan.nuon
```

| day | silver         | $t_{\text{silver}}$           | gold            | $t_{\text{gold}}$             |
| --- | -------------- | ----------------------------- | --------------- | ----------------------------- |
| 1   | :green_circle: | 22ms 309µs 300ns             | :green_circle:  | 55ms 566µs 231ns             |
| 2   | :green_circle: | 498ms 416µs 227ns            | :green_circle:  | 3sec 225ms 867µs 677ns       |
| 3   | :green_circle: | 8ms 602µs 739ns              | :green_circle:  | 66ms 649µs 439ns             |
| 4   | :green_circle: | 5min 47sec 538ms 98µs 343ns  | :green_circle:  | 2min 10sec 978ms 55µs 516ns  |
| 5   | :green_circle: | 810ms 747µs 858ns            | :orange_circle: |                               |
| 6   | :green_circle: | 756ms 571µs 417ns            | :green_circle:  | 33min 30sec 58ms 541µs 422ns |
| 7   | :green_circle: | 1min 44sec 747ms 847µs 772ns | :orange_circle: |                               |

> **Note**
>
> to generate the table
> ```nushell
> open benchmarks/2024/nushell/a-stevan.nuon | get results | nushell render
> ```

