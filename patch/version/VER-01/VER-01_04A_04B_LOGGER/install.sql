PROMPT LOG TO VER-01_04A_04B_LOGGER.log
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

define patch_name = 'VER-01_04A_04B_LOGGER'
define patch_desc = 'Fix for quiet mode'
define patch_path = 'feature/log/VER-01/VER-01_04A_04B_LOGGER/'
SPOOL VER-01_04A_04B_LOGGER.log
CONNECT LOGGER/&&LOGGER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'VER-01_04A_04B_LOGGER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => 'LOGGER' -
 ,i_branch_name        => 'feature/log/VER-01' -
 ,i_tag_from           => 'VER-01.04A' -
 ,i_tag_to             => 'VER-01.04B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Fix for quiet mode' -
 ,i_patch_componants   => 'ms_test.pks' -
||',ms_logger.pkb' -
||',ms_test.pkb' -
 ,i_patch_create_date  => '03-17-2015' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => '' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch VER-01_01A_01B_LOGGER
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_04A_04B_LOGGER' -
,i_prereq_patch  => 'VER-01_01A_01B_LOGGER' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'VER-01_04A_04B_LOGGER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT PACKAGE SPECS

PROMPT ms_test.pks 
@&&patch_path.ms_test.pks;
Show error;

PROMPT PACKAGE BODIES

PROMPT ms_logger.pkb 
@&&patch_path.ms_logger.pkb;
Show error;

PROMPT ms_test.pkb 
@&&patch_path.ms_test.pkb;
Show error;

COMMIT;
PROMPT Compiling objects in schema LOGGER
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

