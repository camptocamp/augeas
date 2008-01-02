# Parsing /etc/inittab

grammar {

  token SEP ':'

  token WORD /[^:]*(?:|\n)/ = 'none'

  token EOL '\n'

  token POUND_TO_EOL /#.*\n/ = '# '

  file: ( comment | record ) * {
    @0 { $file_name }
  }

  comment: ( /#.*?\n/ | /[ \t]*\n/ )

  record: ..? SEP ..? SEP ..? SEP ..? EOL {
    @0  { $seq }
    @$1 { 'id' = $1 }
    @$3 { 'runlevels' = $3 }
    @$5 { 'action' = $5 }
    @$7 { 'process' = $7 }
  }
}