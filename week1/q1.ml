let rec sum_to n =
  match n with
  | 0 -> 0
  | x -> sum_to (x-1) + x;;


let is_prime n =
  let rec inner_is_prime x y =
    match y with
    | 0 -> false
    | 1 -> false
    | i -> ((x mod i) = 0) || (inner_is_prime x (i-1))
  in not (inner_is_prime n (n-1));;

let rec gcd a b =
  match b with
  | 0 -> a
  | _ -> gcd b (a mod b);;

