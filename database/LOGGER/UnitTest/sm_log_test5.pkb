create or replace package body sm_log_test5 as
  --@AOP_LOG
--------------------------------------------------------------------------------
--This package is to be woven, but it is really a test of logger performance.
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--to_LCD_from_MINS 
--transform MINS to LCD
--------------------------------------------------------------------------------
FUNCTION to_LCD_from_MINS(i_MINS    IN NUMBER
                         ,i_zeroval IN VARCHAR2 DEFAULT '00:00'
                         ,i_nullval IN VARCHAR2 DEFAULT  NULL) RETURN VARCHAR2 IS
  HHH    NUMBER;
  MI     NUMBER;
  l_MINS NUMBER;
  g_minus  CONSTANT VARCHAR2(1) := '-';
  l_sign            VARCHAR2(1);
 
BEGIN

  IF i_MINS IS NULL THEN
    RETURN i_nullval;
  ELSIF i_MINS = 0 THEN
    RETURN i_zeroval;
  END IF;
 
  IF i_MINS < 0 THEN
    l_sign := g_minus;
  END IF;

  l_MINS := ROUND(ABS(i_MINS));

  HHH := TRUNC(l_MINS/60);  
  MI  :=   MOD(l_MINS,60); 
 
  RETURN   l_sign
         ||CASE
             WHEN HHH < 100 THEN LPAD(NVL(HHH  ,0),2,'0')
             ELSE                TO_CHAR(HHH)
           END
         ||':'
         ||LPAD(NVL(MI,0),2,'0');

END;


  function test_clob_debugging return varchar2 is

 
    l_start_time date := sysdate;
    l_stop_time  date;
    l_clob clob;

  BEGIN
  	--""Start
  	--??Hi
    
    for j in 1 .. 4 LOOP
      l_clob := null;
      for i in 1 .. 1000 LOOP
        l_clob := l_clob || 'X';
      END LOOP;
    END LOOP;

    l_stop_time := sysdate;

    --""Stop

    l_clob := 'Timing MINS:SECS '||to_LCD_from_MINS(i_MINS => (l_stop_time - l_start_time) * 24*60*60);

    --raise no_data_found;

    return l_clob;
 
  end test_clob_debugging;


  function test_varchar2_debugging return varchar2 is

 
    l_start_time date := sysdate;
    l_stop_time  date;
    l_string varchar2(2000);

  BEGIN
  	--""Start
  	--??Hi
    
    for j in 1 .. 4 LOOP
      l_string := null;
      for i in 1 .. 1000 LOOP
        l_string := l_string || 'X';
      END LOOP;
    END LOOP;

    l_stop_time := sysdate;

    --""Stop

    l_string := 'Timing MINS:SECS '||to_LCD_from_MINS(i_MINS => (l_stop_time - l_start_time) * 24*60*60);

    --raise no_data_found;

    return l_string;
 
  end test_varchar2_debugging;


  function test_for_quiet_mode return varchar2 is

 
    l_start_time date;
    l_stop_time  date;
    l_string varchar2(2000);

  BEGIN

    l_start_time := sysdate;

  	--""Start
  	--??Hi
    
    for j in 1 .. 2 LOOP
      l_string := null;
      for i in 1 .. 1000 LOOP
        l_string := l_string || 'X';
      END LOOP;
    END LOOP;

    l_stop_time := sysdate;

    --""Stop

    l_string := 'Timing MINS:SECS '||to_LCD_from_MINS(i_MINS => (l_stop_time - l_start_time) * 24*60*60);

    raise no_data_found;

    return l_string;
 
  end test_for_quiet_mode;


  procedure test_sleeping1 is
  BEGIN
    null;
    --""message1
  END;

  procedure test_sleeping2 is
  BEGIN
    null;
    --""message1
  END;

  procedure test_sleeping is
  BEGIN
    test_sleeping1;
    test_sleeping2;
  END;

BEGIN
  
    null;
    --""initialise

 
end sm_log_test5;
/
execute sm_weaver.reapply_aspect(i_object_name=> 'sm_log_test5', i_versions => 'HTML,AOP');
--execute sm_api.set_module_debug(i_module_name => 'sm_log_test5');