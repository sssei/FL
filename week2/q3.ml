type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree;;

let bfs t = 
  let rec inner_bfs que acc =
    match que with
    | [] -> acc 
    | (Node (a, left, right))::hs -> inner_bfs (hs@[left; right]) (a::acc)
    | Leaf::hs -> inner_bfs hs acc in
  inner_bfs [t;] [];;

