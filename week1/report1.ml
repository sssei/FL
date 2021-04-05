let rec sum_to n =
  match n with
  | 0 -> 0
  | x -> sum_to (x-1) + x;;


let is_prime n =
  let rec inner_is_prime x y =
    match y with
    | 0 -> false
    | i -> (x mod i) = 0 && inner_is_prime x (i-1)
  in inner_is_prime n (n-1);;

