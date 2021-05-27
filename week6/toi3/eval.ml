open Syntax

exception Unbound

let empty_env = []
let extend x v env = (x ,v) :: env

let rec lookup x env =
  try List.assoc x env with Not_found -> raise Unbound

let rec nth_list n list =
  match list with
  | first::rest -> if n = 1 then first else nth_list (n-1) rest
  | _ -> raise (Invalid_argument "list length is not enough")        

exception EvalErr

let rec make_vlist e elist env n =
  match e with
  | (f, x, e)::rest -> (VLetRec (n, elist, env))::(make_vlist rest elist env (n+1))
  | [] -> []                                        

let rec bind_vlist flist vlist env =
  match flist, vlist with
  | (fi, xi, ei)::frest, vfirst::vrest -> (fi, vfirst)::(bind_vlist frest vrest env)
  | [], [] -> env
  | _, _ -> assert false
    
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
    VFun (x, e, env)
  | EApp (e1, e2) ->
    let v1 = eval_expr env e1 in
    let v2 = eval_expr env e2 in
    (match v1 with
    | VFun (x, e, venv) -> eval_expr (extend x v2 (venv)) e
    | VLetRec (i, flist, venv) ->
      let (_, xi, ei) = nth_list i flist in
      eval_expr (extend xi v2 env) ei )
  | ELetRec (flist, e) ->
    let vlist = make_vlist flist flist env 1 in
    let ex_env = bind_vlist flist vlist env in
    eval_expr ex_env e 

let rec eval_command env c =
  match c with
  | CExp e -> ("-", env, eval_expr env e)
  | CDecl (id, var) -> ("-", extend id (eval_expr env var) env, eval_expr env var)
  | CRecDecl flist  ->
    let vlist = make_vlist flist flist env 1 in
    let ex_env = bind_vlist flist vlist env in
    ("-", ex_env, VLetRec (1, flist, env) )

