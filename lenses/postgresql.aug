(* Parse postgresql.conf                                  *)
(* Author: Mathieu Bornoz <mathieu.bornoz@camptocamp.com> *)

module Postgresql =
  autoload xfm

let eol        = Util.eol
let comment    = Util.comment
let empty      = Util.empty
let spc        = Util.del_ws_spc
let sto_to_eol = store /([^ \t\n].*[^ \t\n]|[^ \t\n])/

(*                                                                                                      *)
(* The following options have been generated with this one-liner on a postgresql server.                *)
(* VARTYPE has been replaced by one of the following types : 'bool', 'string', 'integer' or 'real'      *)
(*                                                                                                      *)
(* $ echo "/$(echo $(psql -P pager=off -t -c "select name, vartype from pg_settings where vartype = \   *)
(*    'VARTYPE';" |awk '{ print $1 }') |sed 's/ /|/g')/"                                                *)
(*                                                                                                      *)

let bool_option_re = /add_missing_from|allow_system_table_mods|archive_mode|array_nulls|autovacuum|check_function_bodies|constraint_exclusion|db_user_namespace|debug_assertions|debug_pretty_print|debug_print_parse|debug_print_plan|debug_print_rewritten|default_transaction_read_only|default_with_oids|enable_bitmapscan|enable_hashagg|enable_hashjoin|enable_indexscan|enable_mergejoin|enable_nestloop|enable_seqscan|enable_sort|enable_tidscan|escape_string_warning|explain_pretty_print|fsync|full_page_writes|geqo|ignore_system_indexes|integer_datetimes|krb_caseins_users|log_checkpoints|log_connections|log_disconnections|log_duration|log_executor_stats|log_hostname|log_lock_waits|log_parser_stats|log_planner_stats|log_statement_stats|log_truncate_on_rotation|logging_collector|password_encryption|silent_mode|sql_inheritance|ssl|standard_conforming_strings|synchronize_seqscans|synchronous_commit|trace_notify|trace_sort|track_activities|track_counts|transaction_read_only|transform_null_equals|update_process_title|zero_damaged_pages/
 
let string_option_re = /archive_command|backslash_quote|bonjour_name|client_encoding|client_min_messages|config_file|custom_variable_classes|data_directory|DateStyle|default_tablespace|default_text_search_config|default_transaction_isolation|dynamic_library_path|external_pid_file|hba_file|ident_file|krb_realm|krb_server_hostname|krb_server_keyfile|krb_srvname|lc_collate|lc_ctype|lc_messages|lc_monetary|lc_numeric|lc_time|listen_addresses|local_preload_libraries|log_destination|log_directory|log_error_verbosity|log_filename|log_line_prefix|log_min_error_statement|log_min_messages|log_statement|log_timezone|regex_flavor|search_path|server_encoding|server_version|session_replication_role|shared_preload_libraries|ssl_ciphers|syslog_facility|syslog_ident|temp_tablespaces|TimeZone|timezone_abbreviations|transaction_isolation|unix_socket_directory|unix_socket_group|wal_sync_method|xmlbinary|xmloption/

let integer_option_re = /archive_timeout|authentication_timeout|autovacuum_analyze_threshold|autovacuum_freeze_max_age|autovacuum_max_workers|autovacuum_naptime|autovacuum_vacuum_cost_delay|autovacuum_vacuum_cost_limit|autovacuum_vacuum_threshold|bgwriter_delay|bgwriter_lru_maxpages|block_size|checkpoint_segments|checkpoint_timeout|checkpoint_warning|commit_delay|commit_siblings|deadlock_timeout|default_statistics_target|effective_cache_size|extra_float_digits|from_collapse_limit|geqo_effort|geqo_generations|geqo_pool_size|geqo_threshold|gin_fuzzy_search_limit|join_collapse_limit|log_autovacuum_min_duration|log_min_duration_statement|log_rotation_age|log_rotation_size|log_temp_files|maintenance_work_mem|max_connections|max_files_per_process|max_fsm_pages|max_fsm_relations|max_function_args|max_identifier_length|max_index_keys|max_locks_per_transaction|max_prepared_transactions|max_stack_depth|port|post_auth_delay|pre_auth_delay|server_version_num|shared_buffers|statement_timeout|superuser_reserved_connections|tcp_keepalives_count|tcp_keepalives_idle|tcp_keepalives_interval|temp_buffers|unix_socket_permissions|vacuum_cost_delay|vacuum_cost_limit|vacuum_cost_page_dirty|vacuum_cost_page_hit|vacuum_cost_page_miss|vacuum_freeze_min_age|wal_buffers|wal_writer_delay|work_mem/

let real_option_re = /autovacuum_analyze_scale_factor|autovacuum_vacuum_scale_factor|bgwriter_lru_multiplier|checkpoint_completion_target|cpu_index_tuple_cost|cpu_operator_cost|cpu_tuple_cost|geqo_selection_bias|random_page_cost|seq_page_cost/

let bool_value_re = /[yY][eE][sS]|[tT][rR][uU][eE]|[oO][nN]|1|[nN][oO]|[fF][aA][lL][sS][eE]|[oO][fF][fF]|0/
let string_value_re = /[^\n]+/
let integer_value_re = /[[0-9]+(kB|MB|GB|ms|s|min|h|d)?/
let real_value_re = /[0-9]+[.][0-9]/

let option (k:regexp) (v:regexp) = [ key k . spc . Util.del_str "=" . spc . store v . eol ]

let bool_option = option bool_option_re bool_value_re
let string_option = option string_option_re string_value_re
let integer_option = option integer_option_re integer_value_re
let real_option = option real_option_re real_value_re

let include = [ key "include" . spc . sto_to_eol . eol ]

(* Define lens *)
let lns = ( empty | comment | bool_option | string_option | integer_option | real_option | include )*

let xfm = transform lns (incl "/etc/postgresql/*/*/postgresql.conf")

