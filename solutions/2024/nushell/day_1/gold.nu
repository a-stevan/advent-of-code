use parse.nu

export def main [input: path]: [ nothing -> int ] {
    let data = parse $input

    let foo: table = $data.right | uniq -c | into string value
    let occ = $foo | transpose -r | into record

    $data.left
        | zip ($data.left | each { |it| $occ | get $"($it)" -i | default 0 })
        | each { $in.0 * $in.1 }
        | math sum
}

