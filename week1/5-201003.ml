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

let filter f l =
  let reverse x = 
    let rec dig res y =
      match y with
      | [] -> res
      | h::hs -> dig (h::res) hs in
    dig [] x in
  let rec filter_dig res y =
    match y with
    | [] -> res
    | h::hs -> if f h then filter_dig (h::res) hs else filter_dig res hs in
  reverse(filter_dig [] l);;
   
