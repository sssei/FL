let rec fold_right f x e =
  match x with
  | [] -> e 
  | y :: ys -> f y (fold_right f ys e);;
  
let rec fold_left f e x =
  match x with
  | [] -> e
  | y::ys -> fold_left f (f e y) ys;;
    
