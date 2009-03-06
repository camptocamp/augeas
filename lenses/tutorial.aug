module Tutorial =

  (*
  let lns = [ label ("option httpchk" . "salut polu") . del "option" "option" . Util.del_ws_spc . del "httpchk" "httpchk" . Util.eol ] *
  *)

  let flag (s:string) = label ("option " . s ) .
                        del (/option[ \t]+/ . s) ("option " . s) .
                        Util.eol

  let opt  (s:string) = label ("option " . s ) .
                        del (/option[ \t]+/ . s) ("option " . s) .
                        store /[^\n]+/ .
                        del /[\n]+/ "\n"

  (* let lns = [ option "httpchk" | option "toto" ] * *)
  let lns = [ opt "httpchk" | flag "httpchk" ] *

  test lns get "option  httpchk
option httpchk blah
" = ?
        
(* Local Variables: *)
(* mode: caml       *)
(* End:             *)

