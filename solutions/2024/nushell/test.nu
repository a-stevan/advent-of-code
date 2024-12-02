def main [--json]: [ nothing -> string ] {
    let tests = $env.FILE_PWD
        | path join ** test.nu
        | into glob
        | ls $in
        | get name
        | wrap path
        | insert day { |it|
            $it.path | path dirname | path basename | split row '_' | get 1 | into int
        }

    let days = $tests | each { |t|
        nu $t.path --json | from json | insert day $t.day
    }

    $days | reduce --fold [] { |it, acc| $acc | append $it } | if $json { to json } else { $in }
}
