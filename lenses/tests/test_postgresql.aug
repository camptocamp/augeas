module Test_postgresql =

let conf = "# - Connection Settings -
archive_timeout = false

"

test Spacevars.simple_lns get conf = ?
