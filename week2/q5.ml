#use "./q4.ml";;
type value = VInt of int | VBool of bool
exception Eval_error;;
type expr =
    EConstInt of int
  | EAdd of expr * expr
  | ESub of expr * expr
  | EMul of expr * expr
  | EDiv of expr * expr
  | EConstBool of bool
  | Eeql of expr * expr
  | Elt of expr * expr
  | EBranch of expr * expr * expr;;

let rec eval (e: expr) =
  match e with
  | EConstInt i -> VInt i
  | EAdd (e1, e2) -> let ex1 = eval e1 and ex2 = eval e2 in
    (match ex1, ex2 with
    | VInt i1, VInt i2 -> VInt (i1+i2)
    | _ -> raise Eval_error)
  | ESub (e1, e2) -> let ex1 = eval e1 and ex2 = eval e2 in
    (match ex1, ex2 with
    | VInt i1, VInt i2 -> VInt (i1-i2)
    | _ -> raise Eval_error)
  | EMul (e1, e2) -> let ex1 = eval e1 and ex2 = eval e2 in
    (match ex1, ex2 with
    | VInt i1, VInt i2 -> VInt (i1*i2)
    | _ -> raise Eval_error)
  | EDiv (e1, e2) -> let ex1 = eval e1 and ex2 = eval e2 in
    (match ex1, ex2 with
    | VInt i1, VInt i2 -> VInt (i1/i2)
    | _ -> raise Eval_error)
  | EConstBool b -> VBool b
  | Eeql (e1, e2) -> let ex1 = eval e1 and ex2 = eval e2 in
    VBool (ex1 = ex2)
  | Elt (e1, e2) -> let ex1 = eval e1 and ex2 = eval e2 in
    (match ex1, ex2 with
    | VInt i1, VInt i2 -> VBool (i1 < i2)
    | _ -> raise Eval_error)
  | EBranch (e1, e2, e3) -> let ex1 = eval e1 in
    if ex1 = VBool true then eval e2 else eval e3;;

 

  
