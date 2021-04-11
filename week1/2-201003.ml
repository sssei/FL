let twice f x = f (f x);;

let rec repeat f n x =
  match n with
  | 1 -> f x
  | i -> f (repeat f (i-1) x);;

