
prompt ms_test

set timing on
 
set pages 1000;
 
spool c:\ms_test.log

alter package ms_logger compile PLSQL_CCFlags = 'intlog:true' reuse settings 

prompt register this script  and the test package (may not need to reg package)
execute ms_logger.register_sql_script('ms_test.sql','10.0');  
execute ms_logger.register_package('ms_test','10.0');
 
prompt start test of internal debugging
set serveroutput on;
execute dbms_output.enable(null);

execute ms_logger.set_internal_debug;
 
execute ms_test.test_unit_types;
execute ms_logger.reset_internal_debug;
/*
 
execute ms_test.trap_an_oracle_error;

WHENEVER SQLERROR CONTINUE;

execute ms_test.raise_an_trap_error;

prompt THERE SHOULD BE AN ERROR [ORA-01403: no data found] ABOVE THIS LINE.

WHENEVER SQLERROR EXIT;


execute ms_test.raise_then_trap_trap_error;



 
prompt test max recursion raises error and disables package 
execute ms_test.test_node(i_node_count => 22);
 
--execute ms_logger.reset_internal_debug;
 
prompt Executing test_exception_propagation
execute ms_test.test_exception_propagation(i_number   => 1234    -
                                          ,i_varchar2 => 'ABCD'  -
                                          ,i_date     => SYSDATE -
                                          ,i_boolean  => FALSE);
prompt end test of internal debugging

prompt Setting message level at QUIET - test that exceptions still work
prompt Enabling test_unit_msg_mode
execute ms_logger.set_unit_quiet(i_module_name => 'ms_test'   -
                                  ,i_unit_name   => 'error_node');
  
prompt Executing test_exception_propagation
execute ms_test.test_exception_propagation(  i_number   => 1234    -
                                            ,i_varchar2 => 'ABCD'  -
                                            ,i_date     => SYSDATE -
                                            ,i_boolean  => FALSE);

*/
											
column my_unique_id_var noprint new_val my_unique_id
undefine my_unique_id

select 'MSTEST.'||ltrim(ms_process_seq.nextval) my_unique_id_var from dual;
 
--prompt new_process 
execute ms_logger.set_internal_debug;
execute ms_logger.new_process(i_module_name => 'ms_test.sql'  -
                               ,i_unit_name   => 'ms_test.sql' -
                               ,i_ext_ref     => '&&my_unique_id' -
                               ,i_comments    => 'Testing the ms_logger package');

--set serveroutput on;
 
 
BEGIN

  ms_test.test_traversal_tree(i_node_count => 20);
  
  ms_test.test_tree;
 
  ms_logger.set_unit_debug(i_module_name => 'ms_test'                
                            ,i_unit_name   => 'error_node');
                                  


  ms_test.test_message_tree(i_number   => 1234     
                          ,i_varchar2 => 'ABCD'  
                          ,i_date     => SYSDATE  
                          ,i_boolean  => FALSE);
                                  
  ms_logger.set_unit_debug(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;

 
  ms_logger.set_unit_normal(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;
 


  ms_logger.set_unit_quiet(i_module_name => 'ms_test'                 
                            ,i_unit_name   => 'msg_mode_node');
  ms_test.test_unit_msg_mode;
 

  ms_logger.set_internal_debug;
  ms_test.test_unit_types;
  ms_logger.reset_internal_debug;
  

  ms_test.test_internal_error;
 
 
END;
/
execute ms_logger.reset_internal_debug;

--execute ms_test.test_internal_error;
 
prompt Ext Ref is &&my_unique_id

SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
FROM ms_unit_traversal_vw
WHERE ext_ref = '&&my_unique_id'
START WITH parent_traversal_id IS NULL
CONNECT BY PRIOR traversal_id = parent_traversal_id
ORDER SIBLINGS BY traversal_id;

prompt Show all
SELECT lpad('+ ',(level-1)*2,'+ ')
||module_name||'.'
||unit_name
||chr(10)||(SELECT listagg('**'||name||':'||value,chr(10)) within group (order by traversal_id) from ms_reference where traversal_id = t.traversal_id)
||chr(10)||(SELECT listagg('--'||message,chr(10)) within group (order by message_id) from ms_message where traversal_id = t.traversal_id)
FROM ms_unit_traversal_vw t
START WITH parent_traversal_id IS NULL
CONNECT BY PRIOR traversal_id = parent_traversal_id
ORDER SIBLINGS BY traversal_id; 
 
alter package ms_logger compile PLSQL_CCFlags = 'intlog:false' reuse settings  
 
spool off;
