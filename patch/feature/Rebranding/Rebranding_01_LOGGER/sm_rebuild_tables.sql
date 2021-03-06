--sm_rebuild_tables.sql

DROP TABLE sm_message;
DROP TABLE sm_call;
DROP TABLE sm_unit;
DROP TABLE sm_module;
DROP TABLE sm_session;
DROP TABLE sm_source;
DROP TABLE sm_config;

DROP SEQUENCE sm_message_seq;
DROP SEQUENCE sm_call_seq;
DROP SEQUENCE sm_unit_seq;
DROP SEQUENCE sm_module_seq;
DROP SEQUENCE sm_session_seq;

@@sm_session.tab
@@sm_module.tab
@@sm_unit.tab
@@sm_call.tab
@@sm_message.tab
@@sm_config.tab
@@sm_source.tab