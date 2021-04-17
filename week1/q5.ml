let rec append l1 l2 = 
  let reverse x = 
    let rec dig res y =
      match y with
      | [] -> res
      | h::hs -> dig (h::res) hs in
    dig [] x in
  match reverse l1 with
  | [] -> l2
  | h::hs -> append (reverse hs) (h::l2);;

let rec filter f l =
  match l with
  | [] -> []
  | x::xs -> if f x then x::(filter f xs) else filter f xs;;

