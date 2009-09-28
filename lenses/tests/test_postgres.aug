module Test_postgres =

(*
let fname = (Sys.getenv "abs_top_srcdir") . "/tests/postgres/postgresql.conf"
let str = (Sys.read_file fname)

test Postgres.lns get str = ?
*)

(*
  Test for values containing spaces
*)

test Spacevars.simple_lns get "#log_hostname = off\n|=|log_line_prefix = '%t '\t\t\t# Blah\n" = ?

let conf = "
# -----------------------------
# PostgreSQL configuration file
# -----------------------------
#
# This file consists of lines of the form:
#
#   name = value
#
# (The \"=\" is optional.)  Whitespace may be used.  Comments are introduced with
# \"#\" anywhere on a line.  The complete list of parameter names and allowed
# values can be found in the PostgreSQL documentation.
#
# The commented-out settings shown in this file represent the default values.
# Re-commenting a setting is NOT sufficient to revert it to the default value;
# you need to reload the server.
#
# This file is read on server startup and when the server receives a SIGHUP
# signal.  If you edit the file on a running system, you have to SIGHUP the
# server for the changes to take effect, or use \"pg_ctl reload\".  Some
# parameters, which are marked below, require a server shutdown and restart to
# take effect.
#
# Any parameter can also be given as a command-line option to the server, e.g.,
# \"postgres -c log_connections=on\".  Some paramters can be changed at run time
# with the \"SET\" SQL command.
#
# Memory units:  kB = kilobytes MB = megabytes GB = gigabytes
# Time units:    ms = milliseconds s = seconds min = minutes h = hours d = days


#------------------------------------------------------------------------------
# FILE LOCATIONS
#------------------------------------------------------------------------------

# The default values of these variables are driven from the -D command-line
# option or PGDATA environment variable, represented here as ConfigDir.

data_directory = '/var/lib/postgresql/8.3/main'		# use data in another directory
					# (change requires restart)
hba_file = '/etc/postgresql/8.3/main/pg_hba.conf'	# host-based authentication file
					# (change requires restart)
ident_file = '/etc/postgresql/8.3/main/pg_ident.conf'	# ident configuration file
					# (change requires restart)

# If external_pid_file is not explicitly set, no extra PID file is written.
external_pid_file = '/var/run/postgresql/8.3-main.pid'		# write an extra PID file
					# (change requires restart)


#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# - Connection Settings -

#listen_addresses = 'localhost'		# what IP address(es) to listen on;
					# comma-separated list of addresses;
					# defaults to 'localhost', '*' = all
					# (change requires restart)
port = 5432				# (change requires restart)
max_connections = 100			# (change requires restart)
# Note:  Increasing max_connections costs ~400 bytes of shared memory per 
# connection slot, plus lock space (see max_locks_per_transaction).  You might
# also need to raise shared_buffers to support more connections.
#superuser_reserved_connections = 3	# (change requires restart)
unix_socket_directory = '/var/run/postgresql'		# (change requires restart)
#unix_socket_group = ''			# (change requires restart)
#unix_socket_permissions = 0777		# begin with 0 to use octal notation
					# (change requires restart)
#bonjour_name = ''			# defaults to the computer name
					# (change requires restart)

# - Security and Authentication -

#authentication_timeout = 1min		# 1s-600s
#ssl = off				# (change requires restart)
#ssl_ciphers = 'ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH'	# allowed SSL ciphers
					# (change requires restart)
#password_encryption = on
#db_user_namespace = off

# Kerberos and GSSAPI
#krb_server_keyfile = ''		# (change requires restart)
#krb_srvname = 'postgres'		# (change requires restart, Kerberos only)
#krb_server_hostname = ''		# empty string matches any keytab entry
					# (change requires restart, Kerberos only)
#krb_caseins_users = off		# (change requires restart)
#krb_realm = ''           		# (change requires restart)

# - TCP Keepalives -
# see \"man 7 tcp\" for details

#tcp_keepalives_idle = 0		# TCP_KEEPIDLE, in seconds;
					# 0 selects the system default
#tcp_keepalives_interval = 0		# TCP_KEEPINTVL, in seconds;
					# 0 selects the system default
#tcp_keepalives_count = 0		# TCP_KEEPCNT;
					# 0 selects the system default


#------------------------------------------------------------------------------
# RESOURCE USAGE (except WAL)
#------------------------------------------------------------------------------

# - Memory -

shared_buffers = 24MB			# min 128kB or max_connections*16kB
					# (change requires restart)
#temp_buffers = 8MB			# min 800kB
#max_prepared_transactions = 5		# can be 0 or more
					# (change requires restart)
# Note:  Increasing max_prepared_transactions costs ~600 bytes of shared memory
# per transaction slot, plus lock space (see max_locks_per_transaction).
#work_mem = 1MB				# min 64kB
#maintenance_work_mem = 16MB		# min 1MB
#max_stack_depth = 2MB			# min 100kB

# - Free Space Map -

max_fsm_pages = 153600			# min max_fsm_relations*16, 6 bytes each
					# (change requires restart)
#max_fsm_relations = 1000		# min 100, ~70 bytes each
					# (change requires restart)

# - Kernel Resource Usage -

#max_files_per_process = 1000		# min 25
					# (change requires restart)
#shared_preload_libraries = ''		# (change requires restart)

# - Cost-Based Vacuum Delay -

#vacuum_cost_delay = 0			# 0-1000 milliseconds
#vacuum_cost_page_hit = 1		# 0-10000 credits
#vacuum_cost_page_miss = 10		# 0-10000 credits
#vacuum_cost_page_dirty = 20		# 0-10000 credits
#vacuum_cost_limit = 200		# 1-10000 credits

# - Background Writer -

#bgwriter_delay = 200ms			# 10-10000ms between rounds
#bgwriter_lru_maxpages = 100		# 0-1000 max buffers written/round
#bgwriter_lru_multiplier = 2.0		# 0-10.0 multipler on buffers scanned/round


#------------------------------------------------------------------------------
# WRITE AHEAD LOG
#------------------------------------------------------------------------------

# - Settings -

#fsync = on				# turns forced synchronization on or off
#synchronous_commit = on		# immediate fsync at commit
#wal_sync_method = fsync		# the default is the first option 
					# supported by the operating system:
					#   open_datasync
					#   fdatasync
					#   fsync
					#   fsync_writethrough
					#   open_sync
#full_page_writes = on			# recover from partial page writes
#wal_buffers = 64kB			# min 32kB
					# (change requires restart)
#wal_writer_delay = 200ms		# 1-10000 milliseconds

#commit_delay = 0			# range 0-100000, in microseconds
#commit_siblings = 5			# range 1-1000

# - Checkpoints -

#checkpoint_segments = 3		# in logfile segments, min 1, 16MB each
#checkpoint_timeout = 5min		# range 30s-1h
#checkpoint_completion_target = 0.5	# checkpoint target duration, 0.0 - 1.0
#checkpoint_warning = 30s		# 0 is off

# - Archiving -

#archive_mode = off		# allows archiving to be done
				# (change requires restart)
#archive_command = ''		# command to use to archive a logfile segment
#archive_timeout = 0		# force a logfile segment switch after this
				# time; 0 is off


#------------------------------------------------------------------------------
# QUERY TUNING
#------------------------------------------------------------------------------

# - Planner Method Configuration -

#enable_bitmapscan = on
#enable_hashagg = on
#enable_hashjoin = on
#enable_indexscan = on
#enable_mergejoin = on
#enable_nestloop = on
#enable_seqscan = on
#enable_sort = on
#enable_tidscan = on

# - Planner Cost Constants -

#seq_page_cost = 1.0			# measured on an arbitrary scale
#random_page_cost = 4.0			# same scale as above
#cpu_tuple_cost = 0.01			# same scale as above
#cpu_index_tuple_cost = 0.005		# same scale as above
#cpu_operator_cost = 0.0025		# same scale as above
#effective_cache_size = 128MB

# - Genetic Query Optimizer -

#geqo = on
#geqo_threshold = 12
#geqo_effort = 5			# range 1-10
#geqo_pool_size = 0			# selects default based on effort
#geqo_generations = 0			# selects default based on effort
#geqo_selection_bias = 2.0		# range 1.5-2.0

# - Other Planner Options -

#default_statistics_target = 10		# range 1-1000
#constraint_exclusion = off
#from_collapse_limit = 8
#join_collapse_limit = 8		# 1 disables collapsing of explicit 
					# JOIN clauses


#------------------------------------------------------------------------------
# ERROR REPORTING AND LOGGING
#------------------------------------------------------------------------------

# - Where to Log -

#log_destination = 'stderr'		# Valid values are combinations of
					# stderr, csvlog, syslog and eventlog,
					# depending on platform.  csvlog
					# requires logging_collector to be on.

# This is used when logging to stderr:
#logging_collector = off		# Enable capturing of stderr and csvlog
					# into log files. Required to be on for
					# csvlogs.
					# (change requires restart)

# These are only used if logging_collector is on:
#log_directory = 'pg_log'		# directory where log files are written,
					# can be absolute or relative to PGDATA
#log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'	# log file name pattern,
					# can include strftime() escapes
#log_truncate_on_rotation = off		# If on, an existing log file of the
					# same name as the new log file will be
					# truncated rather than appended to.
					# But such truncation only occurs on
					# time-driven rotation, not on restarts
					# or size-driven rotation.  Default is
					# off, meaning append to existing files
					# in all cases.
#log_rotation_age = 1d			# Automatic rotation of logfiles will
					# happen after that time.  0 to disable.
#log_rotation_size = 10MB		# Automatic rotation of logfiles will 
					# happen after that much log output.
					# 0 to disable.

# These are relevant when logging to syslog:
#syslog_facility = 'LOCAL0'
#syslog_ident = 'postgres'


# - When to Log -

#client_min_messages = notice		# values in order of decreasing detail:
					#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
					#   log
					#   notice
					#   warning
					#   error

#log_min_messages = notice		# values in order of decreasing detail:
					#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
					#   info
					#   notice
					#   warning
					#   error
					#   log
					#   fatal
					#   panic

#log_error_verbosity = default		# terse, default, or verbose messages

#log_min_error_statement = error	# values in order of decreasing detail:
				 	#   debug5
					#   debug4
					#   debug3
					#   debug2
					#   debug1
				 	#   info
					#   notice
					#   warning
					#   error
					#   log
					#   fatal
					#   panic (effectively off)

#log_min_duration_statement = -1	# -1 is disabled, 0 logs all statements
					# and their durations, > 0 logs only
					# statements running at least this time.

#silent_mode = off			# DO NOT USE without syslog or
					# logging_collector
					# (change requires restart)

# - What to Log -

#debug_print_parse = off
#debug_print_rewritten = off
#debug_print_plan = off
#debug_pretty_print = off
#log_checkpoints = off
#log_connections = off
#log_disconnections = off
#log_duration = off
#log_hostname = off
log_line_prefix = '%t '			# special values:
					#   %u = user name
					#   %d = database name
					#   %r = remote host and port
					#   %h = remote host
					#   %p = process ID
					#   %t = timestamp without milliseconds
					#   %m = timestamp with milliseconds
					#   %i = command tag
					#   %c = session ID
					#   %l = session line number
					#   %s = session start timestamp
					#   %v = virtual transaction ID
					#   %x = transaction ID (0 if none)
					#   %q = stop here in non-session
					#        processes
					#   %% = '%'
					# e.g. '<%u%%%d> '
#log_lock_waits = off			# log lock waits >= deadlock_timeout
#log_statement = 'none'			# none, ddl, mod, all
#log_temp_files = -1			# log temporary files equal or larger
					# than specified size;
					# -1 disables, 0 logs all temp files
#log_timezone = unknown			# actually, defaults to TZ environment
					# setting


#------------------------------------------------------------------------------
# RUNTIME STATISTICS
#------------------------------------------------------------------------------

# - Query/Index Statistics Collector -

#track_activities = on
#track_counts = on
#update_process_title = on


# - Statistics Monitoring -

#log_parser_stats = off
#log_planner_stats = off
#log_executor_stats = off
#log_statement_stats = off


#------------------------------------------------------------------------------
# AUTOVACUUM PARAMETERS
#------------------------------------------------------------------------------

#autovacuum = on			# Enable autovacuum subprocess?  'on' 
					# requires track_counts to also be on.
#log_autovacuum_min_duration = -1	# -1 disables, 0 logs all actions and
					# their durations, > 0 logs only
					# actions running at least that time.
#autovacuum_max_workers = 3		# max number of autovacuum subprocesses
#autovacuum_naptime = 1min		# time between autovacuum runs
#autovacuum_vacuum_threshold = 50	# min number of row updates before
					# vacuum
#autovacuum_analyze_threshold = 50	# min number of row updates before 
					# analyze
#autovacuum_vacuum_scale_factor = 0.2	# fraction of table size before vacuum
#autovacuum_analyze_scale_factor = 0.1	# fraction of table size before analyze
#autovacuum_freeze_max_age = 200000000	# maximum XID age before forced vacuum
					# (change requires restart)
#autovacuum_vacuum_cost_delay = 20	# default vacuum cost delay for
					# autovacuum, -1 means use
					# vacuum_cost_delay
#autovacuum_vacuum_cost_limit = -1	# default vacuum cost limit for
					# autovacuum, -1 means use
					# vacuum_cost_limit


#------------------------------------------------------------------------------
# CLIENT CONNECTION DEFAULTS
#------------------------------------------------------------------------------

# - Statement Behavior -

#search_path = '\"$user\",public'		# schema names
#default_tablespace = ''		# a tablespace name, '' uses the default
#temp_tablespaces = ''			# a list of tablespace names, '' uses
					# only default tablespace
#check_function_bodies = on
#default_transaction_isolation = 'read committed'
#default_transaction_read_only = off
#session_replication_role = 'origin'
#statement_timeout = 0			# 0 is disabled
#vacuum_freeze_min_age = 100000000
#xmlbinary = 'base64'
#xmloption = 'content'

# - Locale and Formatting -

datestyle = 'iso, mdy'
#timezone = unknown			# actually, defaults to TZ environment
					# setting
#timezone_abbreviations = 'Default'     # Select the set of available time zone
					# abbreviations.  Currently, there are
					#   Default
					#   Australia
					#   India
					# You can create your own file in
					# share/timezonesets/.
#extra_float_digits = 0			# min -15, max 2
#client_encoding = sql_ascii		# actually, defaults to database
					# encoding

# These settings are initialized by initdb, but they can be changed.
lc_messages = 'C'			# locale for system error message
					# strings
lc_monetary = 'C'			# locale for monetary formatting
lc_numeric = 'C'			# locale for number formatting
lc_time = 'C'				# locale for time formatting

# default configuration for text search
default_text_search_config = 'pg_catalog.english'

# - Other Defaults -

#explain_pretty_print = on
#dynamic_library_path = '$libdir'
#local_preload_libraries = ''


#------------------------------------------------------------------------------
# LOCK MANAGEMENT
#------------------------------------------------------------------------------

#deadlock_timeout = 1s
#max_locks_per_transaction = 64		# min 10
					# (change requires restart)
# Note:  Each lock table slot uses ~270 bytes of shared memory, and there are
# max_locks_per_transaction * (max_connections + max_prepared_transactions)
# lock table slots.


#------------------------------------------------------------------------------
# VERSION/PLATFORM COMPATIBILITY
#------------------------------------------------------------------------------

# - Previous PostgreSQL Versions -

#add_missing_from = off
#array_nulls = on
#backslash_quote = safe_encoding	# on, off, or safe_encoding
#default_with_oids = off
#escape_string_warning = on
#regex_flavor = advanced		# advanced, extended, or basic
#sql_inheritance = on
#standard_conforming_strings = off
#synchronize_seqscans = on

# - Other Platforms and Clients -

#transform_null_equals = off


#------------------------------------------------------------------------------
# CUSTOMIZED OPTIONS
#------------------------------------------------------------------------------

#custom_variable_classes = ''		# list of custom variable class names
"

test Spacevars.simple_lns get conf = ?
