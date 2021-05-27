open Syntax

exception Unbound

let empty_env = []
let extend x v env = (x ,v) :: env

let rec lookup x env =
  try List.assoc x env with Not_found -> raise Unbound

exception EvalErr

let rec eval_expr env e =
  match e with
  | EConstInt i ->
    VInt i
  | EConstBool b ->
    VBool b
  | EVar x ->
    (try
       lookup x env
     with
     |Unbound -> raise EvalErr)
  | ELet (e1, e2, e3) ->
    let v = eval_expr env e2 in 
    let ex_env = extend e1 v env in
    eval_expr ex_env e3
  | EAdd (e1, e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 + i2)
     | _ -> raise EvalErr)
  | ESub (e1, e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 - i2)
     | _ -> raise EvalErr)
  | EMul (e1, e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 * i2)
     | _ -> raise EvalErr)
  | EDiv (e1, e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VInt (i1 / i2)
     | _ -> raise EvalErr)
  | EEq (e1,e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VBool (i1 = i2)
     | _ -> raise EvalErr)
  | ELt (e1, e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1, v2 with
     | VInt i1, VInt i2 -> VBool (i1 < i2)
     | _ -> raise EvalErr)
  | EIf (e1, e2, e3) ->
    let v1 = eval_expr env e1 in
    (match v1 with
     | VBool b ->
       if b then eval_expr env e2 else eval_expr env e3
     | _ -> raise EvalErr)
  | EFun (x, e) ->
    VFun (x, e, ref env)
  | ELetRec (f, x, e1, e2) ->
    let oenv = ref [] in
    let v = VFun(x, e1, oenv) in
    (oenv := extend f v env;
     eval_expr (extend f v env) e2)
  | EApp (e1, e2) ->
    let VFun (x, e, oenv) = eval_expr env e1 in
    let v2 = eval_expr env e2 in
     eval_expr (extend x v2 (!oenv)) e 
    
let rec eval_command env c =
  match c with
  | CExp e -> ("-", env, eval_expr env e)
  | CDecl (id, var) -> ("-", extend id (eval_expr env var) env, eval_expr env var)
  | CRecDecl (id, x, e) -> let oenv = ref [] in let newenv = extend id (VFun (x, e, oenv)) env in
    (oenv := newenv; ("-", newenv, eval_expr newenv (EVar id)))
