(*s: lib_parsing_php.mli *)
val is_php_filename: Common.filename -> bool

(* this will open the file and look possible for a #!/usr/bin/env php *)
val is_php_file: Common.filename -> bool
val is_php_script: Common.filename -> bool

val find_php_files_of_dir_or_files: 
  ?verbose:bool ->
  Common.path list -> Common.filename list

(*x: lib_parsing_php.mli *)
val ii_of_any: Ast_php.any -> Ast_php.tok list
(*x: lib_parsing_php.mli *)
(* do via side effects *)
val abstract_position_info_any: Ast_php.any -> Ast_php.any

(*x: lib_parsing_php.mli *)
val range_of_origin_ii: Ast_php.tok list -> (int * int) option
val min_max_ii_by_pos: Ast_php.tok list -> Ast_php.tok * Ast_php.tok

type match_format =
  (* ex: tests/misc/foo4.php:3
   *  foo(
   *   1,
   *   2);
   *)
  | Normal 
  (* ex: tests/misc/foo4.php:3: foo( *)
  | Emacs 
  (* ex: tests/misc/foo4.php:3: foo(1,2) *)
  | OneLine

val print_match: ?format:match_format -> Ast_php.tok list -> unit
val join_with_space_if_needed: string list -> string

(*x: lib_parsing_php.mli *)
val get_funcalls_any         : Ast_php.any -> string list
val get_constant_strings_any : Ast_php.any -> string list
val get_funcvars_any         : Ast_php.any -> string (* dname *) list
val get_vars_any              : Ast_php.any -> Ast_php.dname list
val get_static_vars_any       : Ast_php.any -> Ast_php.dname list
val get_returns_any           : Ast_php.any -> Ast_php.expr list
val get_vars_assignements_any : Ast_php.any -> (string * Ast_php.expr list) list

val top_statements_of_program: 
  Ast_php.program -> Ast_php.stmt list
val toplevel_to_entity: 
  Ast_php.toplevel -> Ast_php.entity

val functions_methods_or_topstms_of_program:
  Ast_php.program -> 
  (Ast_php.func_def list * Ast_php.method_def list * Ast_php.stmt list list) 

(*e: lib_parsing_php.mli *)
