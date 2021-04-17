let circle r =
  let pi = Float.pi in r *. r *. pi;;

circle 10.0;;
circle 15.0;;

let rec sigma f n
  = match n with
  | 0 -> f n
  | m -> sigma f (m-1) + f m;;
           
let f k = k * k + k;;  

sigma f 10;;

let rec map f x
  = match x with
  | [] -> []
  | y :: ys -> (f y)::(map f ys);;

map (fun x -> x * x) [1; 2; 3];;
