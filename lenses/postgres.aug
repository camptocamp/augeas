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

let eol = Util.eol
let sto_to_comment = Util.del_opt_ws "" . store /[^;# \t\n][^;#\n]*[^;# \t\n]|[^;# \t\n]/
let entry (kw:regexp) (sep:lens) (comment:lens) = [ key kw . sep . sto_to_comment? . (comment|eol) ] | comment
let entry_re = (/[A-Za-z][A-Za-z0-9\._-]+/  )

(* let entry    = IniFile.entry IniFile.entry_re sep comment *)

let myentry    = entry entry_re sep comment

let lns    = ( myentry | empty )+

let filter = (incl "/etc/postgresql/*/*/postgresql.conf")
             . Util.stdexcl

let xfm = transform lns filter

