type 'a m = ('a * 'a) list -> 'a * ('a * 'a) list

(** (>>=) : 'a m -> ('a -> 'b m) -> 'b m *)
let (>>=) (x : 'a m) (f : 'a -> 'b m) =
  fun init -> let (value, env) = x init in
    f value env 

(** return : 'a -> 'a m *)
let return x = fun [] -> (x, [])

let rec lookup x env =
  match env with
  | (key, value)::rest -> if x = key then value else lookup x rest

let rec update env n key f =
  if n > key then update ((key + 1, fst (f (key + 1) env))::env) n (key + 1) f
      else (fst (f n env), env)
        
(** memo : (int -> int m) -> int -> int m *)
let memo (f : int -> int m) n =
  (fun env -> match env with
     | (key, value)::rest -> if key >= n then (lookup n env, env)
                                              else update env n key f)
  
(** runMemo : 'a m -> 'a *)
let runMemo (x : 'a m) =
  let (value, env) = x [(1, 1)] in value 

let rec fib n =
  if n <= 1 then
    return n
  else
    (memo fib (n-2)) >>= (fun r1 ->
    (memo fib (n-1)) >>= (fun r2 ->
      return (r1 + r2)))

let _ =
  if runMemo (fib 80) = 23416728348467685 && runMemo (fib 10) = 55 then
    print_string "ok\n"
  else
    print_string "wrong\n"
