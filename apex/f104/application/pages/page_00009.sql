--application/pages/page_00009
prompt  ...PAGE 9: Modules Registry
--
 
begin
 
wwv_flow_api.create_page (
  p_flow_id => wwv_flow.g_flow_id
 ,p_id => 9
 ,p_user_interface_id => 2512031460610037 + wwv_flow_api.g_id_offset
 ,p_tab_set => 'TS1'
 ,p_name => 'Modules Registry'
 ,p_step_title => 'Modules Registry'
 ,p_step_sub_title => 'Modules Registry'
 ,p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS'
 ,p_first_item => 'NO_FIRST_ITEM'
 ,p_include_apex_css_js_yn => 'Y'
 ,p_autocomplete_on_off => 'ON'
 ,p_javascript_code => 
'var htmldb_delete_message=''"DELETE_CONFIRM_MSG"'';'
 ,p_page_is_public_y_n => 'N'
 ,p_cache_page_yn => 'N'
 ,p_help_text => 
'No help is available for this page.'
 ,p_last_updated_by => 'PBURGESS'
 ,p_last_upd_yyyymmddhh24miss => '20140416163708'
  );
null;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select '||unistr('\000a')||
'"MODULE_ID",'||unistr('\000a')||
'"MODULE_ID" MODULE_ID_DISPLAY,'||unistr('\000a')||
'"MODULE_NAME",'||unistr('\000a')||
'"REVISION",'||unistr('\000a')||
'"MODULE_TYPE",'||unistr('\000a')||
'"MSG_MODE",'||unistr('\000a')||
'"OPEN_PROCESS"'||unistr('\000a')||
'from "#OWNER#"."MS_MODULE"'||unistr('\000a')||
'';

wwv_flow_api.create_report_region (
  p_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 9,
  p_name=> 'Tabular Form',
  p_region_name=>'',
  p_template=> 17756349234931434+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 15,
  p_new_grid         => false,
  p_new_grid_row     => false,
  p_new_grid_column  => false,
  p_display_column=> 1,
  p_display_point=> 'BODY_3',
  p_item_display_point=> 'ABOVE',
  p_source=> s,
  p_source_type=> 'UPDATABLE_SQL_QUERY',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'N',
  p_query_row_template=> 17758952883931438+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> '(null)',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No data found.',
  p_query_num_rows_type=> 'ROW_RANGES_IN_SELECT_LIST',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_query_asc_image=> 'apex/builder/dup.gif',
  p_query_asc_image_attr=> 'width="16" height="16" alt="" ',
  p_query_desc_image=> 'apex/builder/ddown.gif',
  p_query_desc_image_attr=> 'width="16" height="16" alt="" ',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797363988021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'CHECK$01',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'CHECKBOX',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_derived_column=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s:=s||'MS_MODULE_SEQ';

wwv_flow_api.create_report_columns (
  p_id=> 17797448030021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_ID',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Module Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'HIDDEN',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source_type=> 'S',
  p_pk_col_source=> s,
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_ID',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797557773021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_ID_DISPLAY',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Module Id',
  p_column_link=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.::P10_MODULE_ID:#MODULE_ID#',
  p_column_linktext=>'<img src="#IMAGE_PREFIX#magnifying_glass_white_bg.gif" alt="">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_ID_DISPLAY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797651652021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_NAME',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Module Name',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_NAME',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797738546021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'REVISION',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Revision',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'REVISION',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797856515021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'MODULE_TYPE',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Module Type',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'ESCAPE_SC',
  p_column_width=> '10',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MODULE_TYPE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17797939356021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'MSG_MODE',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Msg Mode',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'SELECT_LIST',
  p_inline_lov=> 'Quiet;4,Normal;2,Debug;1',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '16',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'MSG_MODE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 17798061923021547 + wwv_flow_api.g_id_offset,
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'OPEN_PROCESS',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Open Process',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'SELECT_LIST',
  p_inline_lov=> 'No;N,Yes;Y,If Closed;C',
  p_lov_show_nulls=> 'NO',
  p_column_width=> '12',
  p_is_required=> false,
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_ref_schema=> 'TPDS',
  p_ref_table_name=> 'MS_MODULE',
  p_ref_column_name=> 'OPEN_PROCESS',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 17828839680390260 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 9,
  p_plug_name=> 'Breadcrumb',
  p_region_name=>'',
  p_escape_on_http_output=>'N',
  p_plug_template=> 17755063450931434+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
  p_plug_new_grid         => false,
  p_plug_new_grid_row     => false,
  p_plug_new_grid_column  => false,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'REGION_POSITION_01',
  p_plug_item_display_point=> 'BELOW',
  p_plug_source=> s,
  p_plug_source_type=> 'M'|| to_char(17762344465931475 + wwv_flow_api.g_id_offset),
  p_menu_template_id=> 17759948703931450+ wwv_flow_api.g_id_offset,
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 17798145228021548 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 30,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'SUBMIT',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Submit',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17798346024021555 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 40,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'PURGE',
  p_button_action  => 'SUBMIT',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Purge Old Processes',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_execute_validations=>'Y',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17798549235021555 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 10,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_action  => 'REDIRECT_PAGE',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17798749286021556 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 9,
  p_button_sequence=> 20,
  p_button_plug_id => 17797158749021547+wwv_flow_api.g_id_offset,
  p_button_name    => 'MULTI_ROW_DELETE',
  p_button_action  => 'REDIRECT_URL',
  p_button_image   => 'template:'||to_char(17754457373931432+wwv_flow_api.g_id_offset),
  p_button_is_hot=>'N',
  p_button_image_alt=> 'Delete',
  p_button_position=> 'REGION_TEMPLATE_DELETE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:apex.confirm(htmldb_delete_message,''MULTI_ROW_DELETE'');',
  p_button_execute_validations=>'N',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>17799834795021560 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 9,
  p_branch_name=> '',
  p_branch_action=> 'f?p=&APP_ID.:9:&SESSION.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 1,
  p_save_state_before_branch_yn=>'Y',
  p_branch_comment=> '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 17799041238021557 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_tabular_form_region_id => 17797158749021547 + wwv_flow_api.g_id_offset,
  p_validation_name => 'MSG_MODE must be numeric',
  p_validation_sequence=> 60,
  p_validation => 'MSG_MODE',
  p_validation_type => 'ITEM_IS_NUMERIC',
  p_error_message => '#COLUMN_HEADER# must be numeric.',
  p_when_button_pressed=> 17798145228021548 + wwv_flow_api.g_id_offset,
  p_associated_column=> 'MSG_MODE',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:MS_MODULE:MODULE_ID';

wwv_flow_api.create_page_process(
  p_id     => 17799151935021559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_process_type=> 'MULTI_ROW_UPDATE',
  p_process_name=> 'ApplyMRU',
  p_process_sql_clob => p,
  p_process_error_message=> 'Unable to process update.',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when_button_id=>17798145228021548 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '#MRU_COUNT# row(s) updated, #MRI_COUNT# row(s) inserted.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:MS_MODULE:MODULE_ID';

wwv_flow_api.create_page_process(
  p_id     => 17799364204021559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_region_id=> 17797158749021547 + wwv_flow_api.g_id_offset,
  p_process_type=> 'MULTI_ROW_DELETE',
  p_process_name=> 'ApplyMRD',
  p_process_sql_clob => p,
  p_process_error_message=> 'Unable to process delete.',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when=>'MULTI_ROW_DELETE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '#MRD_COUNT# row(s) deleted.',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'ms_metacode.purge_old_processes(i_keep_day_count => 1);';

wwv_flow_api.create_page_process(
  p_id     => 17799549173021559 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 9,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'PurgeOldProcesses',
  p_process_sql_clob => p,
  p_process_error_message=> '',
  p_error_display_location=> 'ON_ERROR_PAGE',
  p_process_when_button_id=>17798346024021555 + wwv_flow_api.g_id_offset,
  p_process_success_message=> 'Purged old messages',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 9
--
 
begin
 
null;
end;
null;
 
end;
/

 
