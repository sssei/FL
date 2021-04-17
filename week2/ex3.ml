let r = ref 0;;

let f = fun (x : int) ->
  let pre = !r in
  (r := x; pre);;
  
