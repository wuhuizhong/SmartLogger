PROMPT LOG TO VER-01_01A_01B_ENDUSER.log
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

define patch_name = 'VER-01_01A_01B_ENDUSER'
define patch_desc = 'Synonyms for EndUser'
define patch_path = 'feature/log/VER-01/VER-01_01A_01B_ENDUSER/'
SPOOL VER-01_01A_01B_ENDUSER.log
CONNECT &&ENDUSER_user/&&ENDUSER_password@&&database
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT SYNONYMS

WHENEVER SQLERROR CONTINUE
PROMPT logger.syn 
@&&patch_path.logger.syn;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

