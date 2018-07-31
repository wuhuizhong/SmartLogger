PROMPT LOG TO Rebranding_02_ENDUSER.log
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

define patch_name = 'Rebranding_02_ENDUSER'
define patch_desc = 'Rebranding for synonyms'
define patch_path = 'feature/Rebranding/Rebranding_02_ENDUSER/'
SPOOL Rebranding_02_ENDUSER.log
CONNECT &&ENDUSER_user/&&ENDUSER_password@&&database
set serveroutput on;
execute &&PATCH_ADMIN_user..patch_installer.patch_started( -
  i_patch_name         => 'Rebranding_02_ENDUSER' -
 ,i_patch_type         => 'feature' -
 ,i_db_schema          => '&&ENDUSER_user' -
 ,i_branch_name        => 'feature/Rebranding' -
 ,i_tag_from           => 'Rebranding.02A' -
 ,i_tag_to             => 'Rebranding.02B' -
 ,i_supplementary      => '' -
 ,i_patch_desc         => 'Rebranding for synonyms' -
 ,i_patch_componants   => 'logger.syn' -
 ,i_patch_create_date  => '07-31-2018' -
 ,i_patch_created_by   => 'Peter' -
 ,i_note               => 'For standalone deployment' -
 ,i_rerunnable_yn      => 'Y' -
 ,i_remove_prereqs     => 'N' -
 ,i_remove_sups        => 'N' -
 ,i_track_promotion    => 'Y'); 

PROMPT
PROMPT Checking Prerequisite patch Rebranding_01_LOGGER
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'Rebranding_02_ENDUSER' -
,i_prereq_patch  => 'Rebranding_01_LOGGER' );
PROMPT
PROMPT Checking Prerequisite patch Rebranding_02_LOGGER
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'Rebranding_02_ENDUSER' -
,i_prereq_patch  => 'Rebranding_02_LOGGER' );
PROMPT Ensure Patch Admin is late enough for this patch
execute &&PATCH_ADMIN_user..patch_installer.add_patch_prereq( -
i_patch_name     => 'Rebranding_02_ENDUSER' -
,i_prereq_patch  => 'TRK-01_01' );
select user||'@'||global_name Connection from global_name;


PROMPT SYNONYMS

PROMPT logger.syn 
@&&patch_path.logger.syn;

COMMIT;
PROMPT Compiling objects in schema &&ENDUSER_user
execute &&PATCH_ADMIN_user..patch_invoker.compile_post_patch;
execute &&PATCH_ADMIN_user..patch_installer.patch_completed;
COMMIT;
PROMPT 
PROMPT install.sql - COMPLETED.
spool off;


COMMIT;

