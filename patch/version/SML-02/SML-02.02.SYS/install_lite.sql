PROMPT LOG TO SML-02.02.SYS.log
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

define patch_name = 'SML-02.02.SYS'
define patch_desc = 'Create logger user'
define patch_path = 'version/SML-02/SML-02.02.SYS/'
SPOOL SML-02.02.SYS.log
CONNECT &&SYS_user/&&SYS_password@&&database as sysdba
set serveroutput on;
select user||'@'||global_name Connection from global_name;


PROMPT USERS

WHENEVER SQLERROR CONTINUE
PROMPT logger.user 
@&&patch_path.logger.user;
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

COMMIT;
COMMIT;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;


COMMIT;

