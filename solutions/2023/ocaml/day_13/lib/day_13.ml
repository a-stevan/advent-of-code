(** split a list on some item

    # Example
    ```ocaml
    split_list_at "" ["foo"; "bar"; ""; "baz"]
    ```
    will give `[["foo"; "bar"]; ["baz"]]`

    ```ocaml
    split_list_at "" ["foo"; "bar"; ""; "baz"; ""]
    ```
    will give `[["foo"; "bar"]; ["baz"]; []]`
 *)
let split_list_at v l =
  let rec aux v acc = function
    | [] -> [ acc ]
    | h :: t ->
        if h = v then acc :: aux v [] t else aux v (List.append acc [ h ]) t
  in
  aux v [] l

let parse input =
  String.split_on_char '\n' input
  |> List.map (fun l -> List.init (String.length l) (String.get l))
  |> split_list_at []

let transpose mat =
  let p = List.length @@ List.hd mat in
  List.init p (fun j -> List.map (fun l -> List.nth l j) mat)

let reflection_candidates lst =
  let rec aux i = function
    | [] -> []
    | a :: b :: t when a = b -> i :: aux (i + 1) (b :: t)
    | a :: b :: c :: t when a = c -> (i + 1) :: aux (i + 1) (b :: c :: t)
    | _ :: t -> aux (i + 1) t
  in
  aux 0 lst

let foo notes =
  let h = notes |> List.map (fun n -> n |> reflection_candidates) in
  let v =
    notes |> List.map (fun n -> n |> transpose |> reflection_candidates)
  in
  (h, v)

let silver input = String.length input
let gold input = String.length input
