type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree;;

let rec pre_order t =
  match t with
  | Leaf -> []
  | Node (a, left, right) -> (a::(pre_order left))@(pre_order right);;

let rec in_order t =
  match t with
  | Leaf -> []
  | Node (a, left, right) -> (in_order left)@[a]@(in_order right);;

let rec post_order t =
  match t with
  | Leaf -> []
  | Node (a, left, right) -> (post_order left)@(post_order right)@[a];;

