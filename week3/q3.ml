type order = LT | EQ | GT

module type ORDERED_TYPE = 
sig 
  type t
  val compare : t -> t -> order 
end

module type MULTISET2 = 
  functor (T : ORDERED_TYPE) -> 
    sig 
      type t 
      val empty : t 
      val add    : T.t -> t -> t 
      val remove : T.t -> t -> t 
      val count  : T.t -> t -> int 
    end 

module Multiset2 : MULTISET2 =
  functor (T : ORDERED_TYPE) -> struct
    type t =
      | Leaf
      | Node of T.t * t * t
    let empty = Leaf
    let rec add a x =
      match x with
      | Leaf -> Node (a, Leaf, Leaf)
      | Node (y, left, right) ->
        (match T.compare a y with
         | LT -> Node (y, add a left, right)
         | EQ -> Node (y, add a left, right)
         | GT -> Node (y, left, add a right))
    let rec max x =
      match x with
      | Node (y, _ , Leaf) -> y
      | Node (y, _, right) -> max right
    let rec remove a x =
      match x with
      | Leaf -> Leaf
      | Node (y, Leaf, Leaf) ->
        (match T.compare a y with
         | EQ -> Leaf
         | _ -> Node (y, Leaf, Leaf))
      | Node (y, left, Leaf) ->
        (match T.compare a y with
         | EQ -> left
         | LT -> Node (y, remove a left, Leaf)
         | GT -> Node (y, left, Leaf))
      | Node (y, Leaf, right) ->
        (match T.compare a y with
         | EQ -> right
         | LT -> Node (y, Leaf, right)
         | GT -> Node (y, Leaf, remove a right))
      | Node (y, left, right) ->
        (match T.compare a y with
         | EQ -> Node (max left, remove (max left) left, right)
         | LT -> Node (y, remove a left, right)
         | GT -> Node (y, left, remove a right))
    let rec count a x =
      match x with
      | Leaf -> 0
      | Node (y, left, right) ->
        (match T.compare a y with
         | EQ -> 1 + count a left
         | LT -> count a left
         | GT -> count a right)
  end

module OrderedString =
struct
  type t = string
  let compare x y = 
    let r = Pervasives.compare x y in
      if      r > 0 then GT 
      else if r < 0 then LT 
      else               EQ
end 

module StringMultiset =
  Multiset2 (OrderedString)

           
           
        
