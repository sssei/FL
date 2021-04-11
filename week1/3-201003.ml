let rec fix f x = f (fix f) x;;

let sum_to n = 
  let f g x =
    match x with
    | 0 -> 0
    | i -> g (i-1) + i
   in fix f n;; 

let is_prime n =
  let f g x =
    match x with
    | 1 -> false
    | 2 -> true
    | i -> if (n mod (i-1) = 0) then false else g(i-1)
  in fix f n;;

let gcd a b =
  let f g x =
    match x with
    | (i, 0) -> i
    | (i, j) -> g (j, i mod j)
  in fix f (a,b);;

