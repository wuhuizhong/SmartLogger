PROMPT LOG TO SML-0.0.1.log
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

SPOOL SML-0.0.1.log
Prompt installing PATCHES

PROMPT version\SML-02\SML-02.02.SYS 
@version\SML-02\SML-02.02.SYS\install_lite.sql;
PROMPT version\SML-02\SML-02.02.LOGGER 
@version\SML-02\SML-02.02.LOGGER\install_lite.sql;
PROMPT 
PROMPT install_lite.sql - COMPLETED.
spool off;