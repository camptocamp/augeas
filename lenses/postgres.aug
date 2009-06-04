(* Postgres Augeas lense *)
(* Author: François Deppierraz <francois.deppierraz@camptocamp.com> *)
(*                                            *)

module Postgres =
  autoload xfm

(************************************************************************
 * INI File settings
 *************************************************************************)

let empty    = IniFile.empty

let eol = Util.eol

let del_opt_ws = del /[ \t]*/
let del_opt_sq = del "'"? "'"

let sto_to_comment = del_opt_ws "" . del_opt_sq . store /[^;# \t\n][^;#\n]*[^;# \t\n]|[^;# \t\n]/ . del_opt_sq

let entry (kw:regexp) (sep:lens) (comment:lens) = [ key kw . sep . sto_to_comment? . (comment|eol) ] | comment

let entry_re = (/[A-Za-z][A-Za-z0-9\._-]+/  )
let sep      = IniFile.sep IniFile.sep_re IniFile.sep_default
let comment  = IniFile.comment IniFile.comment_re IniFile.comment_default

(* let entry    = IniFile.entry IniFile.entry_re sep comment *)

let myentry    = entry entry_re sep comment

let lns    = ( myentry | empty )+

let filter = (incl "/etc/postgresql/*/*/postgresql.conf")
             . Util.stdexcl

let xfm = transform lns filter

