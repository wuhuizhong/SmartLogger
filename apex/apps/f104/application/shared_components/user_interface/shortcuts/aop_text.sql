--application/shared_components/user_interface/shortcuts/aop_text
 
begin
 
declare
  c1 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'DECLARE'||unistr('\000a')||
'  CURSOR cu_source IS'||unistr('\000a')||
'  select aop_text'||unistr('\000a')||
'  from aop_source_v'||unistr('\000a')||
'  where name = :P4_name and type = :P4_type;'||unistr('\000a')||
' '||unistr('\000a')||
'  l_body CLOB;'||unistr('\000a')||
''||unistr('\000a')||
'BEGIN'||unistr('\000a')||
'  OPEN cu_source;'||unistr('\000a')||
'  FETCH cu_source INTO l_body;'||unistr('\000a')||
'  CLOSE cu_source;'||unistr('\000a')||
''||unistr('\000a')||
'  l_body := REPLACE(REPLACE(l_body,''<<'',''&lt;&lt;''),''>>'',''&gt;&gt;'');'||unistr('\000a')||
'  l_body := REGEXP_REPLACE(l_body,''(ms_logger)(.+)(;)'',''<B>\1\2\3</B>'');'||unistr('\000a')||
''||unistr('\000a')||
'  return ''<PRE>''||l_body||''</PRE>'';'||unistr('\000a')||
' '||unistr('\000a')||
'end;';

wwv_flow_api.create_shortcut (
 p_id=> 2627919906929546 + wwv_flow_api.g_id_offset,
 p_flow_id=> wwv_flow.g_flow_id,
 p_shortcut_name=> 'AOP_TEXT',
 p_shortcut_type=> 'FUNCTION_BODY',
 p_shortcut=> c1);
end;
null;
 
end;
/
