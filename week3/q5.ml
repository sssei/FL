module type SEMIRING =
sig
  type t
  val add : t -> t -> t
  val mul : t -> t -> t
  val unit : t
  val zero : t
end

module type MATRIX =
  functor (T: SEMIRING) ->
  sig
    type t
    val zero : int -> t
    val unit : int -> t
    val add : t -> t -> t
    val mul : t -> t -> t
  end
  
  
module Matrix : MATRIX =
  functor (T : SEMIRING) -> struct
    type t = (T.t list) list
    exception ArgumentError
    let rec sizeof a =
      match a with
      | [] -> 0
      | h::hs -> 1 + sizeof hs        
    let rec zero_line n =
      match n with
      | 0 -> []
      | i -> T.zero::(zero_line (i-1))
    let rec zero_matrix_sub x y =
      match y with
      | 0 -> []
      | i -> (zero_line x)::(zero_matrix_sub x (i-1))
    let zero n = zero_matrix_sub n n
    let rec one_line x y =
      match y with
      | 0 -> []
      | i -> if x = i then T.unit::(one_line x (i-1))
        else T.zero::(one_line x (i-1))
    let rec unit_sub x y =
      match y with
      | 0 -> []
      | i -> (one_line i x)::(unit_sub x (i-1))
    let unit n = unit_sub n n
    let rec add_line x y =
      match x, y with
      | [], [] -> []
      | t::ts, h::hs -> (T.add t h)::(add_line ts hs)
      | _, _ -> raise ArgumentError
    let rec add x y =
      match x, y with
      | [], [] -> []
      | t::ts, h::hs -> (add_line t h)::(add ts hs)
    let rec ptr l i =
      match l with
      | h::hs -> if i = 1 then h else ptr hs (i-1)
      | _ -> raise ArgumentError
    let rec mul_ij_sub a b i j k =
      match k with
      | 0 -> T.zero
      | l ->  T.add (T.mul (ptr (ptr a i) l) (ptr (ptr b l) j)) (mul_ij_sub a b i j (l-1))
    let mul_ij a b i j =
      let n = sizeof a in
      mul_ij_sub a b i j n
    let rec mul_i_sub a b i j =
      match j with
      | 0 -> []
      | l -> (mul_ij a b i l)::(mul_i_sub a b i (l-1))
    let mul_i a b i =
      let n = sizeof a in
      mul_i_sub a b i n
    let rec mul_sub a b i =
      match i with
      | 0 -> []
      | l -> (mul_i a b l)::(mul_sub a b (l-1))
    let mul a b =
      let n = sizeof a in
      mul_sub a b n
  end


module Bool : SEMIRING =
struct
  type t = bool
  let add a b = a || b 
  let mul a b = a && b 
  let unit = true
  let zero = false
end

module Z : SEMIRING =
struct
  type t = Int of int | INF
  let add a b =
    match a, b with
    | Int i, Int j -> if i >= j then Int j else Int i 
    | Int i, INF -> Int i
    | INF, Int j -> Int j
    | INF, INF -> INF
  let mul a b =
    match a, b with
    | Int i, Int j -> Int (i + j)
    | Int i, INF -> INF
    | INF, _ -> INF
  let unit = Int 0
  let zero = INF
end


module BoolMatrix = Matrix (Bool)
module ZMatrix = Matrix (Z)


                   
