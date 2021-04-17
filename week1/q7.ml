let perm list =
  let rec append l1 l2 =
    match l1 with
    | [] -> l2
    | first::rest -> first::(append rest l2)
  and shuffle x l = 
    let rec inner_shuffle y acc lst1 lst2 =
      let insert a l1 l2 =
        append l1 (a::l2) in
      match lst2 with
      | [] -> (insert y lst1 lst2)::acc
      | first::rest -> inner_shuffle y ((insert y lst1 lst2)::acc) (append lst1 [first]) rest in
    inner_shuffle x [] [] l
   (*# shuffle 1 [2;3];;
     - : [[1;2;3];[2;1;3];[2;3;1]] *)  
  and subperm x acc =
    match acc with
    | [] -> []
    | first::rest -> (shuffle x first)@(subperm x rest)
   (*# subperm 1 [[2;3];[5;7]]
     - : [[1;2;3];[2;1;3];[2;3;1];[1;5;7];[5;1;7];[5;7;1]]*)        
  and fold_right f x e =
    match x with
    | [] -> e 
    | y :: ys -> f y (fold_right f ys e) in
   fold_right subperm list [[]];;
                                     

