module Stack =
struct
  type 'a t = 'a list
  exception NoItem
  let empty = []
  let pop xs =
    match xs with
    | [] -> raise NoItem
    | y::ys -> (y, ys)
  let push x xs = x::xs
  let rec size_sub xs =
    match xs with
    | [] -> 0
    | y::ys -> 1 + size_sub ys
end

module type STACK =
sig
  type 'a t
  val empty : 'a list
  val pop : 'a list -> 'a * 'a list
  val push : 'a -> 'a list -> 'a list
  val size_sub : 'a list -> int
end

module AbstStack : STACK = Stack

