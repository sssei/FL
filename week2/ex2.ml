type iexpr =
  | EConstInt of int
  | EAdd of iexpr * iexpr
  | ESub of iexpr * iexpr
  | EMul of iexpr * iexpr;;

let rec eval x =
  match x with
  | EConstInt i -> i
  | EAdd (a, b) -> eval a + eval b
  | ESub (a, b) -> eval a - eval b
  | EMul (a, b) -> eval a * eval b;;

eval (EConstInt 10);;
eval (EAdd (EConstInt 10, EConstInt (-3)));;
let e1 = (EAdd (EConstInt 3, EConstInt 4));;
let e2 = (EMul (e1, EConstInt 8));;
eval (ESub (e2, EConstInt 6));;
