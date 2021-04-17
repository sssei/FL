type value = VInt of int | VBool of bool;;

type expr =
  | EConstInt of int
  | EAdd of expr * expr
  | ESub of expr * expr
  | EMul of expr * expr
  | EDib of expr * expr            
  | EConstBool of bool
  | Eeql of expr * expr
  | Elt of expr * expr
  | EBranch of expr * expr * expr;;          

