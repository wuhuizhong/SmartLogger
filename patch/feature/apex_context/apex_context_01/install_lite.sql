PROMPT LOG TO apex_context_01.log
PROMPT .
SET AUTOCOMMIT OFF
SET AUTOPRINT ON
SET ECHO ON
SET FEEDBACK ON
SET PAUSE OFF
SET SERVEROUTPUT ON SIZE 1000000
SET TERMOUT ON
SET TRIMOUT ON
SET VERIFY ON
SET trims on pagesize 3000
SET auto off
SET verify off echo off define on
WHENEVER OSERROR EXIT FAILURE ROLLBACK
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

define patch_name = 'apex_context_01'
define patch_desc = 'Apex Context'
define patch_path = 'feature/apex_context/apex_context_01/'
SPOOL apex_context_01.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT TABLES

WHENEVER SQLERROR CONTINUE
PROMPT sm_rebuild_tables.sql 
@&&patch_path.sm_rebuild_tables.sql
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

PROMPT VIEWS

 
PROMPT sm_views.vw 
@&&patch_path.sm_views.vw
 
PROMPT sm_apex_context_collection_v.vw 
@&&patch_path.sm_apex_context_collection_v.vw;
Show error;

PROMPT sm_context_tree_v.vw 
@&&patch_path.sm_context_tree_v.vw;
Show error;

PROMPT sm_db_context_tree_v.vw 
@&&patch_path.sm_db_context_tree_v.vw;
Show error;

PROMPT sm_session_v2.vw 
@&&patch_path.sm_session_v2.vw

PROMPT sm_session_v3.vw 
@&&patch_path.sm_session_v3.vw;
Show error;

PROMPT sm_source_v.vw 
@&&patch_path.sm_source_v.vw

PROMPT PACKAGE BODIES

PROMPT sm_api.pkb 
@&&patch_path.sm_api.pkb;
Show error;

PROMPT sm_logger.pkb 
@&&patch_path.sm_logger.pkb;
Show error;

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

