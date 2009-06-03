(* Postgres Augeas lense *)
(* Author: François Deppierraz <francois.deppierraz@camptocamp.com> *)
(*                                            *)

module Postgres =
  autoload xfm

(************************************************************************
 * INI File settings
 *************************************************************************)

let comment  = IniFile.comment IniFile.comment_re IniFile.comment_default
let sep      = IniFile.sep IniFile.sep_re IniFile.sep_default
let empty    = IniFile.empty

let entry    = IniFile.entry IniFile.entry_re sep comment

let lns    = ( entry | empty )+

let filter = (incl "/etc/postgresql/*/*/postgresql.conf")
             . Util.stdexcl

let xfm = transform lns filter

