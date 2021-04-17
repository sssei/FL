type complex = {re : float; im : float};;

let prod {re = r1; im = i1} {re = r2 ; im = i2} =
  {re = r1 *. r2 -. i1 *. i2; im = r1 *. i2 +. r2 *. i1};;

type str_tree =
  | Leaf
  | Node of string * str_tree * str_tree;;

Node ("tree", Leaf, Leaf);;
Node ("tree", Node ("one", Leaf, Leaf), Leaf);;
Node ("tree", Node ("two", Leaf, Leaf), Node ("three", Leaf, Leaf));;

type ib_list = INil
             | ICons of int * bi_list
and bi_list = BNil
            | BCons of bool * ib_list;;

ICons (2, BNil);;
BCons (false, ICons (1, BNil));;
BCons (true, ICons (1, BCons (false, INil)));;
