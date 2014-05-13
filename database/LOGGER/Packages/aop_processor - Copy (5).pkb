alter trigger aop_processor_trg disable;

--Ensure no inlining so ms_logger can be used
alter session set plsql_optimize_level = 1;

create or replace package body aop_processor is
  -- AUTHID CURRENT_USER
  -- @AOP_NEVER
  
--This package is not yet aware of commented code.
--IE it will perform incorrectly on code that has been commented out.

--TODO: Create a safety measure for commented code.
--Remove all comments -> AOP
--AOP -> Remove all comments
--Compare the results and alert the developer to any discrepancies.
--Aim to leave a AOP version of the code with original comments.
--(Any comments created by AOP will have to be retained.)
   

  g_package_name        CONSTANT VARCHAR2(30) := 'aop_processor'; 
 
  g_during_advise boolean:= false;
  
  g_aop_directive CONSTANT VARCHAR2(30) := '@AOP_LOG'; 
  

  
  g_for_aop_html      boolean := false;
  g_for_comment_htm   boolean := false;
  
  g_weave_start_time  date;
  
  g_weave_timeout_secs NUMBER := 5;   
  
  g_initial_level     constant integer := 0;
  
  g_code              CLOB;
  g_current_pos       INTEGER;

  x_weave_timeout      EXCEPTION; 
  x_invalid_keyword    EXCEPTION;
  x_string_not_found   EXCEPTION;
  
  ----------------------------------------------------------------------------
  -- REGULAR EXPRESSIONS
  ----------------------------------------------------------------------------
  g_word_search          VARCHAR2(10) := '\w+'; --'[A-Z|_]+';--'[^ ]+'; 
  
  
  
  procedure check_timeout is
  begin
    if (sysdate - g_weave_start_time) * 24 * 60 * 60 >  g_weave_timeout_secs then
	  raise x_weave_timeout;
	end if;
  
  end;
  
  

  --------------------------------------------------------------------
  -- during_advise
  --------------------------------------------------------------------
  
  function during_advise 
  return boolean
  is
  begin 
    return g_during_advise;
  end during_advise;

 
  --------------------------------------------------------------------
  -- validate_source
  --------------------------------------------------------------------
  function validate_source(i_name        IN VARCHAR2
                         , i_type        IN VARCHAR2
                         , i_text        IN CLOB
                         , i_aop_ver     IN VARCHAR2
					  ) RETURN boolean IS
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'validate_source');              
                      
    l_aop_source    aop_source%ROWTYPE;    
    PRAGMA AUTONOMOUS_TRANSACTION;
 
  BEGIN     
 
    ms_logger.param(l_node, 'i_name      '          ,i_name   );
    ms_logger.param(l_node, 'i_type      '          ,i_type      );
    --ms_logger.param(l_node, 'i_text    '          ,i_text          ); --too big.
	ms_logger.param(l_node, 'i_aop_ver   '           ,i_aop_ver      );

	--Prepare record.
    l_aop_source.name          := i_name;
	l_aop_source.type          := i_type;
    l_aop_source.aop_ver       := i_aop_ver;
    l_aop_source.text          := i_text;
    l_aop_source.load_datetime := sysdate;
    l_aop_source.valid_yn      := 'Y';
    l_aop_source.result        := 'Success.';
	
	if i_aop_ver like '%HTML' then
	  l_aop_source.valid_yn := NULL;
	else
	
      begin
	    execute immediate 'alter session set plsql_optimize_level = 1';
	  
        execute immediate i_text;  --11G CLOB OK
	  exception
        when others then
	      l_aop_source.result   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	  	l_aop_source.valid_yn := 'N';
          ms_logger.warn_error(l_node);   
	  end;
	end if;
 
	logger.ins_upd_aop_source(i_aop_source => l_aop_source);
     
    COMMIT;
	
	RETURN l_aop_source.valid_yn = 'Y';
   
      
  END;
 
 
 
  --------------------------------------------------------------------
  -- splice
  --------------------------------------------------------------------
    procedure splice( p_code     in out clob
                     ,p_new_code in varchar2
                     ,p_pos      in out number ) IS
                     
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'splice');  
	  l_new_code varchar2(32000);
	  
    BEGIN
  
      --ms_logger.param(l_node, 'p_code'          ,p_code );
      ms_logger.param(l_node, 'LENGTH(p_code)'  ,LENGTH(p_code)  );
      ms_logger.param(l_node, 'p_new_code'      ,p_new_code);
      ms_logger.param(l_node, 'p_pos     '      ,p_pos     );
	  
	  check_timeout;
	  
	  if g_for_aop_html then
	    --l_new_code := '<B>'||p_new_code||'</B>';
		--l_new_code := '<p style="background-color:#9CFFFE;">'||p_new_code||'</p>';
		l_new_code := '<span style="background-color:#9CFFFE;">'||p_new_code||'</span>';
	  elsif g_for_comment_htm then
		l_new_code := '<p style="background-color:#FFFF99;">'||p_new_code||'</p>';
	  else
	    l_new_code := p_new_code;
      end if;
 
      p_code:=     substr(p_code, 1, p_pos)
                 ||l_new_code
                 ||substr(p_code, p_pos+1);
  
	  p_pos := p_pos + length(l_new_code);	
	  
	  --ms_logger.note(l_node, 'p_code     '     ,p_code     );
	  ms_logger.note(l_node, 'p_pos     '      ,p_pos     );
 
    END;
 
  --------------------------------------------------------------------
  -- inject
  --------------------------------------------------------------------
    procedure inject( p_code     in out clob
                     ,p_new_code in varchar2
                     ,p_pos      in out number
					 ,p_level    in number) IS
      --Calls splice with p_new_code wrapped in CR
    BEGIN
 
      --indent every line using level
	  splice( p_code     =>  p_code
	         ,p_new_code => replace(chr(10)||p_new_code,chr(10),chr(10)||rpad(' ',(p_level-1)*2+2,' '))||chr(10)
	         ,p_pos      =>  p_pos); 
 
    END;
	
    procedure splice_here( i_new_code in varchar2 ) IS
	
	BEGIN
	  splice( p_code      => g_code    
	         ,p_new_code  => i_new_code
	         ,p_pos       => g_current_pos );  
	END;
 
	
    procedure inject_here( i_new_code in varchar2
					      ,i_level    in number) IS
	
	BEGIN
	  IF i_new_code IS NOT NULL THEN
	    inject( p_code      => g_code    
	           ,p_new_code  => i_new_code
	           ,p_pos       => g_current_pos     
	        	 ,p_level     => i_level );  
	  END IF;			 
	END;
	
	
	
	
  --------------------------------------------------------------------
  -- get_body
  --------------------------------------------------------------------
  function get_body
  ( p_object_name   in varchar2
  , p_object_owner  in varchar2
  ) return clob
  is
  
    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'get_body');     
    l_code clob;
  begin
    ms_logger.param(l_node, 'p_object_name  '          ,p_object_name   );
    ms_logger.param(l_node, 'p_object_owner '          ,p_object_owner  );
    -- make sure that dbms_metadata does return the package body 
    DBMS_METADATA.SET_TRANSFORM_PARAM 
    ( transform_handle  => dbms_metadata.SESSION_TRANSFORM
    , name              => 'BODY'
    , value             => true
    , object_type       => 'PACKAGE'
    );
    -- make sure that dbms_metadata does not return the package specification as well
    DBMS_METADATA.SET_TRANSFORM_PARAM 
    ( transform_handle  => dbms_metadata.SESSION_TRANSFORM
    , name              => 'SPECIFICATION'
    , value             => false
    , object_type       => 'PACKAGE'
    );
    l_code:= dbms_metadata.get_ddl('PACKAGE', p_object_name, p_object_owner);
    return l_code;
  end get_body;
 
 
	  
--      l_search  := '(\s|\<|\>)'||i_search||'(\s|\<|\>)'; 
 
 
--------------------------------------------------------------------------------- 
-- REFACTORED
--------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------- 
-- ATOMIC
--------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------- 
-- get_next - return first matching string, stripped of upto 1 leading and trailing whitespace
--------------------------------------------------------------------------------- 
FUNCTION get_next(i_search   IN VARCHAR2
                 ,i_modifier IN VARCHAR2 DEFAULT 'i' ) return VARCHAR2 IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'get_next');	
 
BEGIN
  check_timeout;
  ms_logger.param(l_node, 'i_search',i_search);
 
  RETURN REGEXP_REPLACE(TRIM(REGEXP_SUBSTR(g_code,i_search,g_current_pos,1,i_modifier)),'^\s|$\s','');
END;

FUNCTION get_next_lower(i_search IN VARCHAR2
                       ,i_modifier IN VARCHAR2 DEFAULT 'i') return VARCHAR2 IS
BEGIN
  RETURN LOWER(get_next(i_search   => i_search
                       ,i_modifier => i_modifier));
END;

FUNCTION get_next_upper(i_search IN VARCHAR2
                       ,i_modifier IN VARCHAR2 DEFAULT 'i') return VARCHAR2 IS
BEGIN
  RETURN UPPER(get_next(i_search   => i_search
                       ,i_modifier => i_modifier));
END;



--------------------------------------------------------------------------------- 
-- go_past
---------------------------------------------------------------------------------
PROCEDURE go_past(i_search IN VARCHAR2
                 ,i_modifier IN VARCHAR2 DEFAULT 'i') IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'go_past');
  l_new_pos INTEGER;
BEGIN
  check_timeout;
  ms_logger.param(l_node, 'i_search',i_search);
  l_new_pos := REGEXP_INSTR(g_code,i_search,g_current_pos,1,1,i_modifier);
  IF l_new_pos = 0 then
    raise x_string_not_found;
  end if;
  g_current_pos := l_new_pos;
END;

--------------------------------------------------------------------------------- 
-- go_prior
---------------------------------------------------------------------------------
PROCEDURE go_prior(i_search IN VARCHAR2
                  ,i_modifier IN VARCHAR2 DEFAULT 'i') IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'go_prior');
  l_new_pos INTEGER;
BEGIN
  check_timeout;
  ms_logger.param(l_node, 'i_search',i_search);
  l_new_pos := REGEXP_INSTR(g_code,i_search,g_current_pos,1,0,i_modifier);
  IF l_new_pos = 0 then
    raise x_string_not_found;
  end if;
  g_current_pos := l_new_pos - 1;
END;

--------------------------------------------------------------------------------- 
-- FORWARD DECLARATIONS
--------------------------------------------------------------------------------- 

--------------------------------------------------------------------------------- 
-- AOP_declare - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_declare(i_level       IN INTEGER );
--------------------------------------------------------------------------------- 
-- AOP_is_as - Forward Declaration
---------------------------------------------------------------------------------
PROCEDURE AOP_is_as(i_level       IN INTEGER
                ,i_inject_node IN VARCHAR2 DEFAULT NULL);

--------------------------------------------------------------------------------- 
-- AOP_block_body
---------------------------------------------------------------------------------
PROCEDURE AOP_block_body(i_level          IN INTEGER
                        ,i_params         IN CLOB    DEFAULT NULL)  IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_block_body');
  l_keyword VARCHAR2(50);
BEGIN
 
  go_past('\sBEGIN\s');
  
  --Add the params (if any)
  inject_here( i_new_code  => i_params
              ,i_level     => i_level);
 
  loop
    l_keyword := get_next_upper('\sDECLARE\s|\sBEGIN\s|\sEND;\s');
	            --UPPER(TRIM(REGEXP_SUBSTR(g_code,'\sDECLARE\s|\sBEGIN\s|\sEND;\s',g_current_pos,1,'i')));
	ms_logger.note(l_node, 'l_keyword',l_keyword);
	ms_logger.note_length(l_node, 'l_keyword',l_keyword);
    CASE 
	  WHEN l_keyword = 'END;'    THEN EXIT;
      WHEN l_keyword = 'DECLARE' THEN
        AOP_declare(i_level => i_level + 1);
        AOP_block_body(i_level => i_level + 1);
      WHEN l_keyword = 'BEGIN' THEN
        AOP_block_body(i_level => i_level + 1);
      ELSE
        RAISE x_invalid_keyword;
    END CASE;
 
  END LOOP;
  
  go_past('\sEND;\s');
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END;

--------------------------------------------------------------------------------- 
-- AOP_prog_unit_body
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_unit_body(i_prog_unit_name IN VARCHAR2
                            ,i_params         IN CLOB
                            ,i_level          IN INTEGER ) IS
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_prog_unit_body');
  --l_keyword VARCHAR2(50);
BEGIN

/*
  l_keyword := get_next_upper('\sBEGIN\s|\sLANGUAGE\s.*?;');
  ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
  IF l_keyword <> 'BEGIN' THEN
	ms_logger.comment(l_node, 'Found a LANGUAGE prog unit - skipping'); 
    go_past('\sLANGUAGE\s.*?;');
	RETURN;
  END IF;
*/

  --Add extra begin
  go_prior('\sBEGIN\s');
  
  --go_prior('\n\s*BEGIN\s|\sBEGIN\s');
  --g_current_pos := g_current_pos - 1; -- needed in order to match on next BEGIN		
  
  inject_here( i_new_code  => 'begin --'||i_prog_unit_name
              ,i_level     => i_level);
 
  --Body 
  AOP_block_body(i_level  => i_level
                ,i_params => i_params);
  --Add extra exception handler
  --add the terminating exception handler of the new surrounding block
  inject_here( i_new_code  => 'exception'
  	               ||chr(10)||'  when others then'
  			       ||chr(10)||'    ms_logger.warn_error(l_node);'
  			       ||chr(10)||'    raise;'
  			       ||chr(10)||'end; --'||i_prog_unit_name
              ,i_level     => i_level);
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END;

--------------------------------------------------------------------------------- 
-- AOP_pu_name
---------------------------------------------------------------------------------
--FUNCTION AOP_pu_name return varchar2 is
--  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_pu_name'); 
--BEGIN  
--  go_past('\sPROCEDURE\s|\sFUNCTION\s');
--  RETURN UPPER(TRIM(REGEXP_SUBSTR(g_code,g_word_search,g_current_pos,1,'i')));
--  
--END;

 
--------------------------------------------------------------------------------- 
-- AOP_pu_params
---------------------------------------------------------------------------------
FUNCTION AOP_pu_params return CLOB is
  l_node   ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_pu_params'); 
  l_param_injection      CLOB;
  l_param_line           CLOB;
  l_param_name           VARCHAR2(30);
  l_param_type           VARCHAR2(50);
  l_keyword              VARCHAR2(50);
  x_out_param            EXCEPTION;
  x_unhandled_param_type EXCEPTION;

 
BEGIN  
 
  loop
    BEGIN
      --Find first: "(" "," "AS" "IS"
      l_keyword := get_next_upper('\(|,|IS\s|AS\s');   
      ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
	  
      CASE 
	    WHEN l_keyword IN ('IS','AS') THEN EXIT;
        WHEN l_keyword IN ('(',',') THEN 
	    --find the parameter
	  	
		--MUCKING AROUND
		--select REGEXP_SUBSTR(',l_var IN VARCHAR2,l_var IN VARCHAR2,','(\(|,).+(,|\))',1,1) from dual;
		
		--select REGEXP_SUBSTR(',l_var IN VARCHAR2,l_var IN VARCHAR2,','(\(|,).+(IN|IN\s+OUT|OUT)?.+(,|\))',1,1) from dual;
		
		--select REGEXP_SUBSTR(',l_var IN VARCHAR2,l_var IN VARCHAR2,','(\(|,)\s*\w+\s+(IN|IN\s+OUT|OUT)?.+(,|\))',1,1) from dual;
		
		--select REGEXP_SUBSTR(',l_var1 IN VARCHAR2,l_var2 IN VARCHAR2,','(\(|,)\s*\w+\s+(IN|IN\s+OUT|OUT)?\s+\w+\s*(,|\))',1,1) from dual;
 
	  	--l_param_line := get_next('(\(|,)\s*\S+\s+(IN|IN\s+OUT|OUT)(,|\))','in');
		
		
		--Search for Eg
		--( varname IN OUT vartype ,
		--, varname IN vartype)
		--, varname vartype,
		--( varname OUT vartype)
		l_param_line := get_next('(\(|,)\s*\w+\s+((IN|IN\s+OUT|OUT)\s+)?\w+\s*(,|\))');  
	 
	  	ms_logger.note(l_node, 'l_param_line',l_param_line);
 
		IF UPPER(REGEXP_SUBSTR(l_param_line,g_word_search,1,2,'i')) = 'OUT' THEN
		  RAISE x_out_param;
		END IF;
		
		--l_param_line := REGEXP_REPLACE(l_param_line,'(\sIN\s|\sOUT\s)',' ',1,null,'i');
      
	    --Remove remaining IN and OUT
	  	l_param_line := REGEXP_REPLACE(l_param_line,'(\sIN\s)',' ',1,1,'i');
		l_param_line := REGEXP_REPLACE(l_param_line,'(\sOUT\s)',' ',1,1,'i');
		ms_logger.note(l_node, 'l_param_line',l_param_line);		
		
	  	l_param_name := LOWER(REGEXP_SUBSTR(l_param_line,g_word_search,1,1,'i')); 
	  	ms_logger.note(l_node, 'l_param_name',l_param_name);
	  	l_param_type := UPPER(REGEXP_SUBSTR(l_param_line,g_word_search,1,2,'i'));  
	  	ms_logger.note(l_node, 'l_param_type',l_param_type);
	  	IF  l_param_type NOT IN ('NUMBER'
	  	                        ,'INTEGER'
	  						    ,'BINARY_INTEGER'
	  						    ,'PLS_INTEGER'
	  						    ,'DATE'
	  						    ,'VARCHAR2'
	  						    ,'BOOLEAN') then
		  RAISE x_unhandled_param_type;
        END IF;		  
							
	  	l_param_injection := l_param_injection||chr(10)||'  ms_logger.param(l_node,'''||l_param_name||''','||l_param_name||');';
 
        ELSE
          RAISE x_invalid_keyword;
      END CASE;
    EXCEPTION
	  WHEN x_out_param THEN  
	    ms_logger.comment(l_node, 'Skipped OUT param');
	  WHEN x_unhandled_param_type THEN
	    ms_logger.comment(l_node, 'Unsupported param type');
	END;
	
	--Move onto next param
	go_past('\(|,');
  END LOOP; 
  
  
  --NB g_current_pos is still behind next keyword 'IS'
  return l_param_injection;
   
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END;
 
--------------------------------------------------------------------------------- 
-- AOP_prog_unit
---------------------------------------------------------------------------------
PROCEDURE AOP_prog_unit(i_level IN INTEGER) IS
  l_node    ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_prog_unit'); 
  l_inject_params   CLOB;
  l_keyword         VARCHAR2(50);
  l_node_type       VARCHAR2(50);
  l_inject_node     VARCHAR2(200);
  l_prog_unit_name  VARCHAR2(30);
  
BEGIN

  --Find node type
  l_keyword := get_next_upper('\sPROCEDURE\s|\sFUNCTION\s'); 
  ms_logger.note(l_node, 'l_keyword' ,l_keyword);   
  CASE 
    WHEN l_keyword = 'PROCEDURE' THEN
      l_node_type := 'new_proc';
    WHEN l_keyword = 'FUNCTION' THEN
      l_node_type := 'new_func';
    ELSE
      RAISE x_invalid_keyword;
  END CASE;	 
  ms_logger.note(l_node, 'l_node_type' ,l_node_type);  
  
  --Get program unit name
  go_past('\sPROCEDURE\s|\sFUNCTION\s');
  
  --Check for LANGUAGE JAVA NAME
  l_keyword := get_next_upper('\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s|\sLANGUAGE\s','in');
  ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
  IF l_keyword LIKE '%LANGUAGE%' THEN
	ms_logger.comment(l_node, 'Found a LANGUAGE prog unit - skipping AOP_prog_unit'); 
	go_past('\sLANGUAGE\s.*?;','in');
	RETURN;
  END IF;
 
  
  l_prog_unit_name := get_next_lower(g_word_search);
  ms_logger.note(l_node, 'l_prog_unit_name' ,l_prog_unit_name);
  
  l_inject_node    := '  l_node ms_logger.node_typ := ms_logger.'||l_node_type||'($$plsql_unit ,'''||l_prog_unit_name||''');';
 
  l_inject_params := AOP_pu_params;
  
  AOP_is_as(i_level       => i_level
           ,i_inject_node => l_inject_node);
			 
  AOP_prog_unit_body(i_prog_unit_name  => l_prog_unit_name
                    ,i_params          => l_inject_params
                    ,i_level           => i_level);
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END;

--------------------------------------------------------------------------------- 
-- AOP_is_as
---------------------------------------------------------------------------------
PROCEDURE AOP_is_as(i_level       IN INTEGER
                ,i_inject_node IN VARCHAR2 DEFAULT NULL) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_is_as'); 
  --l_keyword              VARCHAR2(50);
BEGIN
   
  go_past('\sIS\s|\sAS\s');

/*  
  l_keyword := get_next_upper('\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s|\sLANGUAGE\s.*?;');
  ms_logger.note(l_node, 'l_keyword' ,l_keyword); 
  IF l_keyword LIKE '%LANGUAGE%' THEN
	ms_logger.comment(l_node, 'Found a LANGUAGE prog unit - skipping AOP_is_as'); 
	RETURN;
  END IF;
*/ 
 
  inject_here( i_new_code  => i_inject_node
              ,i_level     => i_level);
 
  WHILE get_next_upper('\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s') IN ('PROCEDURE','FUNCTION') LOOP
    AOP_prog_unit(i_level => i_level + 1);
  END LOOP;
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END;

--------------------------------------------------------------------------------- 
-- AOP_declare
---------------------------------------------------------------------------------
PROCEDURE AOP_declare(i_level       IN INTEGER ) IS
  l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'AOP_declare'); 
BEGIN

  go_past('\sDECLARE\s');
  
  WHILE get_next_upper('\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s') IN ('PROCEDURE','FUNCTION') LOOP
    AOP_prog_unit(i_level => i_level + 1);
  END LOOP;
 
exception
  when others then
    ms_logger.warn_error(l_node);
    raise; 
 
END;

 
--------------------------------------------------------------------------------- 
-- weave
---------------------------------------------------------------------------------
  function weave
  ( p_code in out clob
  , p_package_name in varchar2
  , p_for_html in boolean default false
  ) return boolean
  is

    l_node ms_logger.node_typ := ms_logger.new_func(g_package_name,'weave'); 
 
    l_advised            boolean := false;
	l_current_pos        integer := 1;
    l_count              NUMBER  := 0;
    l_end_pos            integer;  
	
	l_end_value          varchar2(50);
	l_mystery_word       varchar2(50);

    l_package_name       varchar2(50);
  
  begin
 
    ms_logger.param(l_node, 'p_package_name'      ,p_package_name);
	ms_logger.param(l_node, 'p_for_html'          ,p_for_html);
	
	g_for_aop_html := p_for_html;
	
	g_weave_start_time := SYSDATE;
	
	--First task will be to remove all comments or 
	--somehow identify and remember all sections that can be ignored because they are comments
	
	g_code := chr(10)||p_code||chr(10); --add a trailing CR to help with searching
 
    g_code := REPLACE(g_code,g_aop_directive,'Logging by AOP_PROCESSOR on '||to_char(systimestamp,'DD-MM-YYYY HH24:MI:SS'));
 
    --LATER WHEN WE WANT TO SUPPORT THE BEGIN SECTION OF A PACKAGE
	--WE WOULD REPLACE parse_prog_unit below with parse_anon_block
 
	--Change any program unit ending of form "end program_unit_name;" to just "end;" for simplicity
	--Preprocess p_code cleaning up block end statements.
    --IE Translate "END prog_unit_name;" -> "END;"	
	declare
	  l_keyword varchar2(50);
	  L_END_MASK  varchar2(50) := '\sEND\s+\w+\s*;'; --'\sEND\s(.*);';
	  
	begin  
	  --Reset the processing pointer.
      g_current_pos := 1;
 
      loop
	    l_end_value := get_next_upper( L_END_MASK);  --IS NOT NULL LOOP
		EXIT WHEN l_end_value IS NULL;
	    ms_logger.note(l_node, 'l_end_value'      ,l_end_value);
 
		l_mystery_word := UPPER(REGEXP_SUBSTR(l_end_value,g_word_search,1,2,'i')); 
	    if l_mystery_word in ('IF'
	                         ,'LOOP'
	    					 ,'CASE') then
		  go_past(l_end_value);						 
		ELSE						 
	      ms_logger.info(l_node, 'Replacing '||l_end_value);
	      g_code := REGEXP_REPLACE(g_code,'(\s)END\s+\w+\s*;','\1END;',g_current_pos,1,'i');
		  go_past('END;');
	    end if;
 
	  END LOOP;
    END;
  ms_logger.comment(l_node, 'Finised cleaning ENDs');

  --Replace all remaining occurances like "END ;" with "END;"
  g_code := REGEXP_REPLACE(g_code,'(\sEND)\s+?;','\1;',1,0,'i'); 
 
 
    --Need to determine what sort of code we have - at the top level.

	--Anonymous Block             - look for DECLARE or BEGIN
	--Progam Units                - look for PROCEDURE or FUNCTION 
	--PACKAGE BODY                - look for PACKAGE BODY
	
	--Each of these can have prog units embedded in the declaration section (if any).
	--and each may have additional Anonymous blocks embedded in the body section (if any).
	
	
    --  A package body which would be similar to procedure or function but with no parameters.

	declare
	  l_keyword varchar2(50);
	
	begin
	  g_current_pos := 1;
	  l_keyword := get_next_upper('\sDECLARE\s|\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s|\sPACKAGE BODY\s');
	    --UPPER(TRIM(REGEXP_SUBSTR(g_code,'\sDECLARE\s|\sBEGIN\s|\sPROCEDURE\s|\sFUNCTION\s|\sPACKAGE BODY\s',g_current_pos,1,'i')));
	  ms_logger.note(l_node, 'l_keyword' ,l_keyword);
	  ms_logger.note_length(l_node, 'l_keyword' ,l_keyword);
 
	  CASE 
	    WHEN l_keyword = 'DECLARE' THEN
		  AOP_declare(i_level => g_initial_level);
		  AOP_block_body(i_level => g_initial_level);
		WHEN l_keyword = 'BEGIN' THEN
		  AOP_block_body(i_level => g_initial_level);
		WHEN l_keyword IN ('PROCEDURE','FUNCTION') THEN
		  AOP_prog_unit(i_level => g_initial_level);
		WHEN l_keyword = 'PACKAGE BODY' THEN
		  go_past('PACKAGE BODY');
 
          --l_package_name :=  get_next_lower('\.{0,1}\"{0,1}\w+');
		  --l_package_name :=  get_next_lower('[\.\"]{0,2}\w+');
 
		  --Match on combinatsion like owner.package_name, "owner"."package_name",package_name,"package_name"
		  --Remove "
		  l_package_name := REPLACE(get_next_lower('\w+\.\w+|\w+\"?\.\"?\w+|\w+'),'"','');
		  --Remove owner.
		  l_package_name := REGEXP_REPLACE(l_package_name,'\w+\.','');
 
          --declaration of package body
          AOP_is_as(i_level => g_initial_level);	
		  --initialisation of package body (optional)
          l_keyword := get_next_upper('\sBEGIN\s|\sEND;\s');
		  IF l_keyword = 'BEGIN' THEN
		     AOP_prog_unit_body(i_prog_unit_name => l_package_name
		                       ,i_params         => NULL   
		                       ,i_level          => 1);
		  ELSIF l_keyword IS NULL THEN
		    RAISE x_invalid_keyword;
		  END IF;
		ELSE
		  RAISE x_invalid_keyword;
	  end case;	  
	end;
 
    l_advised:= true;

	--Translate SIMPLE ms_feedback syntax to MORE COMPLEX ms_logger syntax
	--EG ms_feedback.x(           ->  ms_logger.x(l_node,
	g_code := REGEXP_REPLACE(g_code,'(ms_feedback)(\.)(.+)(\()','ms_logger.\3(l_node,');

	--Replace routines with no params 
	--EG ms_feedback.oracle_error -> ms_logger.oracle_error(l_node)
	g_code := REGEXP_REPLACE(g_code,'(ms_feedback)(\.)(.+)(;)','ms_logger.\3(l_node);');

    p_code := g_code;
	
    return l_advised;
	
  exception 
    when x_invalid_keyword then
	  splice_here( i_new_code => '<span style="background-color:#FF6600;">INVALID KEYWORD</span>');
	  p_code := g_code;
      return false;
    when x_weave_timeout then
	  splice_here( i_new_code => '<span style="background-color:#FF6600;">WEAVE TIMED OUT</span>');
	  p_code := g_code;
      return false;
    when x_string_not_found then
	  splice_here( i_new_code => '<span style="background-color:#FF6600;">STRING NOT FOUND</span>');
	  p_code := g_code;
      return false;
    when others then
      ms_logger.oracle_error(l_node);	
	  raise;
	
  end weave;
  
  procedure advise_package
  ( p_object_name   in varchar2
  , p_object_type   in varchar2
  , p_object_owner  in varchar2
  ) is
    l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'advise_package');
  
	l_orig_body clob;
	l_woven_body clob;
	l_html_body clob;
    l_advised boolean := false;
  begin	
  begin
    ms_logger.param(l_node, 'p_object_name'  ,p_object_name  );
    ms_logger.param(l_node, 'p_object_type'  ,p_object_type  );
    ms_logger.param(l_node, 'p_object_owner' ,p_object_owner );
    g_during_advise:= true;
    -- test for state of package; no sense in trying to post-process an invalid package
    
    -- if valid then retrieve source
    l_orig_body:= get_body( p_object_name, p_object_owner);
    -- check if perhaps the AOP_NEVER string is included that indicates that no AOP should be applied to a program unit
    -- (this bail-out is primarily used for this package itself, riddled as it is with AOP instructions)
	-- Conversely it also checks for @AOP_LOG, which must be present or AOP will also exit.
	--This ensure that a routine is not logged unless explicitly requested.
	--Also AOP will remove AOP_LOG in the AOP Source, so that logging cannot be doubled-up.
    if instr(l_orig_body, '@AOP_NEVER') > 0 or instr(l_orig_body, g_aop_directive) = 0 
    then
	  g_during_advise:= false; 
      return;
    end if;
	
	IF NOT  validate_source(i_name  => p_object_name
	                      , i_type  => p_object_type
	                      , i_text  => l_orig_body
	                      , i_aop_ver => 'ORIG') THEN
	  g_during_advise:= false; 
	  return; -- Don't bother with AOP since the original source is invalid anyway.			
	end if;		  
 
	l_woven_body := l_orig_body;
    -- manipulate source by weaving in aspects as required; only weave if the key logging not yet applied.
    l_advised := weave( p_code         => l_woven_body
                      , p_package_name => lower(p_object_name)  );
 
    -- (re)compile the source if any advises have been applied
    if l_advised then
	
	  IF NOT validate_source(i_name  => p_object_name
	                       , i_type  => p_object_type
	                       , i_text  => l_woven_body
	                       , i_aop_ver => 'AOP') THEN
 
	    --reexecute the original so that we at least end up with a valid package.
	    IF NOT  validate_source(i_name  => p_object_name
	                          , i_type  => p_object_type
	                          , i_text  => l_orig_body
	                          , i_aop_ver => 'ORIG') THEN
		  --unlikely that we'd get an error in the original if it worked last time
		  --but trap it incase we do	
          ms_logger.fatal(l_node,'Original Source is invalid on second try.');		  
		end if;
	  end if;
	  --else	
	    --Reweave with html
		ms_logger.comment(l_node,'Reweave with html');	
	    l_html_body := l_orig_body;
        l_advised := weave( p_code         => l_html_body
                          , p_package_name => lower(p_object_name)
                          , p_for_html     => true );
		--l_html_body := l_woven_body;
		IF NOT validate_source(i_name  => p_object_name
	                         , i_type  => p_object_type
	                         , i_text  => l_html_body
	                         , i_aop_ver => 'AOP_HTML') THEN
		  ms_logger.fatal(l_node,'Oops problem with AOP_HTML on second try.');						 
		
		END IF;
 
	  --end if;	
 
    end if;
    g_during_advise:= false; 

  exception 
    when others then
      ms_logger.oracle_error(l_node);	
	  g_during_advise:= false; 
  end;	  
  exception 
    when others then
	  --I think we need to ensure the routine does not fail, or it will re-submit job.
      g_during_advise:= false; 
  end advise_package;
  
  procedure reapply_aspect(i_object_name IN VARCHAR2 DEFAULT NULL) is
  begin
    for l_object in (select object_name 
	                      , object_type
						  , owner 
				     from all_objects 
					 where object_type ='PACKAGE BODY'
					 and   object_name = NVL(i_object_name,object_name)) loop
        advise_package( p_object_name  => l_object.object_name
                      , p_object_type  => l_object.object_type
                      , p_object_owner => l_object.owner);

    end loop;
  end reapply_aspect;
  
  
  
  --------------------------------------------------------------------
  -- remove_comments
  -- www.orafaq.com/forum/t/99722/2/ discussion of alternative methods.
  --------------------------------------------------------------------
  
    procedure remove_comments( io_code     in out clob ) IS
     --function remove_comments( i_code in clob ) return clob is                
      l_node ms_logger.node_typ := ms_logger.new_proc(g_package_name,'remove_comments');  
	  l_new_code varchar2(32000);
	  
	  --NB This will not work if comment -- /* */ markers are embedded within quotes.
	  
	  
    l_old_clob clob;
    l_line varchar2(4000);
    l_line_count number;
    v_from number;
    l_eol number;
	l_count number;
	l_new_clob clob;
	
	l_comment_block boolean := false;
	l_quoted_text   boolean := false;
	
 
	
	l_single_comment_pos      number;
 		    
	l_block_comment_open_pos  number;
	
	l_block_comment_close_pos number;
 				
	l_quote_pos               number;
	l_next                    number;
 
	  
    BEGIN
 
    --  return i_code;
    
	  --REMOVE SINGLE LINE COMMENTS 
	  --Find "--" and remove chars upto EOL or "* /"
	  
	  --REMOVE MULTI-LINE COMMENTS 
	  --Find "/*" and remove upto "* /" 
      null;
	  
	/*  
	l_old_clob := io_code||chr(10);
	
    --l_line_count := length(l_old_clob) - nvl(length(replace(l_old_clob,chr(10))),0) + 1;
    --v_from := 1;
    --l_eol := instr(l_old_clob || chr(10),chr(10),v_from,1) - v_from;
	
	l_count := 0;
	loop
	  l_eol := instr(l_old_clob,chr(10),1);
	  exit when l_eol = 0 or l_count = 100;
	  l_count := l_count + 1;
	  l_line := substr(l_old_clob,1,l_eol-1);
	  ms_logger.note(l_node,'l_line',l_line);
	   
	  if l_comment_block then
	  
	    l_block_comment_close_pos :=   get_pos_end(i_code        => l_line   
		                                          ,i_current_pos => 1
		    	                                  ,i_search      => '\*'||'\/'
		    		                              ,i_whitespace  => false
	        		                              ,i_raise_error => false);
	 									  
	    l_next := l_block_comment_close_pos;
	    
		if l_next < 1000000 then
		
		  if l_next = l_block_comment_close_pos  then
		    splice( p_code     => l_line
		           ,p_new_code => '</p>'
		           ,p_pos      => l_next);
 
            --l_line := substr(l_line,l_next);
			l_comment_block := false;
		  
		  end if;
		  
		else
		  NULL;
          --l_line := NULL;		
 						  
	    end if;
 
	  
	  else --NOT l_comment_block
	    l_single_comment_pos      :=   get_pos_start(i_code        => l_line   
		                                          ,i_current_pos => 1
		    	                                  ,i_search      => '--'
		    		                              ,i_whitespace  => false
	        		                              ,i_raise_error => false);
							      		  
	    l_block_comment_open_pos  :=   get_pos_start(i_code        => l_line   
		                                            ,i_current_pos => 1
		    	                                    ,i_search      => '\/\*'
		    		                                ,i_whitespace  => false
	        		                                ,i_raise_error => false);
								  	  
		l_quote_pos               := 	get_pos_start(i_code        => l_line 						  
					              	           ,i_current_pos => 1			  
					              	           ,i_search      => ''''			  
					              	           ,i_whitespace  => false			  
					              	           ,i_raise_error => false);
        l_next := least(l_single_comment_pos,l_block_comment_open_pos,l_quote_pos);
		if l_next < 1000000 then
		
		  if l_next = l_single_comment_pos then
		    --l_line := substr(l_line,1,l_next);
			--l_next := l_single_comment_pos - 1;
		    splice( p_code     => l_line
		           ,p_new_code => '<p style="background-color:#FFFF99;">'
		           ,p_pos      => l_next);
			l_line := l_line || '</p>';
			
			
		  elsif l_next = l_block_comment_open_pos then
		    splice( p_code     => l_line
		           ,p_new_code => '<p style="background-color:#FFFF99;">'
		           ,p_pos      => l_next);
 
            --l_line := substr(l_line,1,l_next);
			l_comment_block := true;
		  
		  end if;
							
	    end if;
		
	  end if;
	  
	   
 
	  --dbms_output.put_line('line '||lpad(l_count,4)||l_line);
	  
	  l_new_clob := l_new_clob ||l_line||chr(10);
	  
	  l_old_clob := substr(l_old_clob,l_eol+1,LENGTH(l_old_clob));
	  
	  
	end loop;  
	
	io_code := l_new_clob;
 
*/	
    exception
      when others then
        ms_logger.warn_error(l_node);
        raise;
     
    END remove_comments;
  
  
 
end aop_processor;
/
show error;

alter trigger aop_processor_trg enable;