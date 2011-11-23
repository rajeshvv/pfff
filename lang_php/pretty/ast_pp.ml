(* Julien Verlaguet
 *
 * Copyright (C) 2011 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)
(*
 * This file is mostly a copy paste of ast_php_simple.ml but with some
 * additional constructors for comments or newlines so that we can
 * pretty print code while maintaining the comments and newlines
 * of the original file.
 * 
 * Note that we assume all Newline below are esthetic newlines
 * (see ast_pp_build.ml).
 * 
 * todo: merge with ast_php_simple.ml ?
 * todo: factorize the Newline and Comment constructors in one subtype ?
 *)

(*****************************************************************************)
(* The AST related types *)
(*****************************************************************************)

type program = stmt list

and stmt =
  | Comment of string
  | Newline

  | Expr of expr

  (* pad: Noop could be Block [], but it's abused right now for debugging
   * purpose in the abstract interpreter
   *)
  | Noop
  | Block of stmt list

  | If of expr * stmt * stmt
  | Switch of expr * case list

  | While of expr * stmt list
  | Do of stmt list * expr
  | For of expr list * expr list * expr list * stmt list
  | Foreach of expr * expr * expr option * stmt list

  | Return of expr option
  | Break of expr option
  | Continue of expr option

  | Throw of expr
  | Try of stmt list * catch * catch list

  | InlineHtml of string

  (* only at toplevel in most of our code *)
  | ClassDef of class_def
  | FuncDef of func_def
  (* todo? factorize with ClassDef here too? *)
  | InterfaceDef of class_def
  (* only at toplevel *)
  | TraitDef of class_def

  | StaticVars of (string * expr option) list
  | Global of expr list

  and case =
  | Ccomment of string
  | Cnewline

  | Case of expr * stmt list
  | Default of stmt list

  (* catch(Exception $exn) { ... } => ("Exception", "$exn", [...]) *)
  and catch = string  * string * stmt list

and expr =
  | Int of string
  | Double of string

  | String of string
  | Guil of encaps list
  | HereDoc of string * encaps list * string

  (* valid for entities (functions, classes, constants) and variables, so
   * can have Id "foo" and Id "$foo"
   *)
  | Id of string

  | Array_get of expr * expr option

  (* often transformed in Id "$this" in the analysis *)
  | This
  (* e.g. Obj_get(Id "$o", Id "foo") when $o->foo *)
  | Obj_get of expr * expr
  (* e.g. Class_get(Id "A", Id "foo") when a::foo
   * (can contain "self", "parent", "static")
   *)
  | Class_get of expr * expr

  | Assign of Ast_php.binaryOp option * expr * expr
  | Infix of Ast_php.fixOp * expr
  | Postfix of Ast_php.fixOp * expr
  | Binop of Ast_php.binaryOp * expr * expr
  | Unop of Ast_php.unaryOp * expr

  | Call of expr * expr list

  | Ref of expr

  | Xhp of xml
  | ConsArray of array_value list
  | List of expr list

  | New of expr * expr list
  | InstanceOf of expr * expr

  | CondExpr of expr * expr * expr
  | Cast of Ast_php.ptype * expr

  | Lambda of lambda_def

  and array_value =
    | Aval of expr
    | Akval of expr * expr

  and encaps =
    | EncapsString of string
    | EncapsVar of expr
    | EncapsCurly of expr
    | EncapsDollarCurly of expr
    | EncapsExpr of expr

  and xhp =
    | XhpText of string
    | XhpExpr of expr
    | XhpXml of xml

    and xml = {
      xml_tag: string list;
      xml_attrs: (string * xhp_attr) list;
      xml_body: xhp list;
    }

      and xhp_attr =
        | AttrString of encaps list
        | AttrExpr of expr

and func_def = {
  f_ref: bool;
  f_name: string;
  f_params: parameter list;
  f_return_type: hint_type option;
  f_body: stmt list;
}

   and parameter = {
     p_type: hint_type option;
     p_ref: bool;
     p_name: string;
     p_default: expr option;
   }

   and hint_type =
     | Hint of string
     | HintArray

  and lambda_def = {
    l_ref: bool;
    l_params: parameter list;
    (* actually use parameter can't have a default value nor a type hint
     * so maybe we should use a more specific type 
     *)
    l_use: parameter list;
    l_body: stmt list;
  }

and class_def = {
  (* todo: move is_interface and is_trait into class_type *)
  c_is_interface: bool;
  c_is_trait: bool;
  c_type: class_type;
  c_name: string;
  c_extends: string list;
  c_implements: string list;
  c_body: class_element list;
}

  and class_element =
    | CEcomment of string
    | CEnewline

    | CEconst of (string * expr) list
    | CEdef of class_vars_def
    | CEmethod of method_def

  and class_type =
    | ClassRegular
    | ClassFinal
    | ClassAbstract

  and class_vars_def = {
    cv_final: bool;
    cv_static: bool;
    cv_abstract: bool;
    cv_visibility: visibility;
    cv_type: hint_type option;
    cv_vars: cvar list;
  }

  and cvar = string * expr option

  and method_def = {
    m_visibility: visibility;
    m_static: bool;
    m_final: bool;
    m_abstract: bool;
    m_ref: bool;
    m_name: string;
    m_params: parameter list;
    m_return_type: hint_type option;
    m_body: stmt list;
  }

   and visibility =
     | Novis
     | Public  | Private
     | Protected | Abstract

 (* with tarzan *)

(*****************************************************************************)
(* Helpers *)
(*****************************************************************************)

let has_modifier cv =
  cv.cv_final ||
  cv.cv_static ||
  cv.cv_abstract ||
  cv.cv_visibility <> Novis

let rec is_string_key = function
  | [] -> true
  | Aval _ :: _ -> false
  | Akval (String _, _) :: rl -> is_string_key rl
  | _ -> false

let rec key_length_acc c = function
  | Aval _ -> c
  | Akval (String s, _) -> max (String.length s + 2) c
  | _ -> c

let key_length l =
  List.fold_left key_length_acc 0 l