type order = LT | EQ | GT

module type ORDERED_TYPE = 
sig 
  type t
  val compare : t -> t -> order 
end

module type ASSOCIATIVEARRAY = 
  functor (T : ORDERED_TYPE) -> 
    sig 
      type t 
      val empty : t
      val add    : T.t -> T.t -> t -> t 
      val remove : T.t -> t -> t 
      val lookup : T.t -> t -> T.t
    end

module AssociativeArray : ASSOCIATIVEARRAY =
  functor (T : ORDERED_TYPE) -> struct
    type t = (T.t * T.t) list
    exception NotFound
    let empty = []
    let add a b x = (a, b)::x
    let rec remove a x =
      match x with
      | [] -> []
      | (key, value)::xs ->
        if a = key then xs
        else (key, value)::(remove a xs)
    let rec lookup a x =
      match x with
      | [] -> raise NotFound
      | (key, value)::xs ->
        if a = key then value
        else lookup a xs  
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




