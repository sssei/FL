type nat = Z | S of nat;;

let rec add (x : nat) (y : nat) =
  match y with
  | Z -> x
  | S s -> S (add x s);;

let rec sub (x : nat) (y : nat) =
  if x = Z then Z else 
  match y with
  | Z -> x
  | S s -> S (sub x s);;

let rec mul (x : nat) (y : nat) =
  match y with
  | Z -> Z
  | S s -> add (mul x s) x;;

let rec pow (x : nat) (y : nat) =
  match y with
  | Z -> S Z
  | S s -> mul (pow x s) x;;

let rec n2i (n : nat) =
  match n with
  | Z -> 0
  | S s -> 1 + n2i s;;

let rec i2n (n : int) =
  match n with
  | 0 -> Z
  | i -> S (i2n (i-1));;

