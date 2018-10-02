prompt --application/pages/page_00011
begin
wwv_flow_api.create_page(
 p_id=>11
,p_user_interface_id=>wwv_flow_api.id(37981134484256182)
,p_name=>'User Preferences'
,p_alias=>'USER_PREFS'
,p_page_mode=>'MODAL'
,p_step_title=>'User Preferences'
,p_step_sub_title_type=>'TEXT_WITH_SUBSTITUTIONS'
,p_first_item=>'NO_FIRST_ITEM'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_chained=>'Y'
,p_overwrite_navigation_list=>'N'
,p_page_is_public_y_n=>'N'
,p_cache_mode=>'NOCACHE'
,p_last_updated_by=>'PETER'
,p_last_upd_yyyymmddhh24miss=>'20180930030700'
);
wwv_flow_api.create_page_plug(
 p_id=>wwv_flow_api.id(27236484577775020)
,p_plug_name=>'User Prefs'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_api.id(35560371291315922)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'BODY'
,p_plug_query_options=>'DERIVED_REPORT_COLUMNS'
,p_attribute_01=>'N'
,p_attribute_02=>'HTML'
);
wwv_flow_api.create_page_button(
 p_id=>wwv_flow_api.id(27236765882775023)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_api.id(27236484577775020)
,p_button_name=>'DONE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_api.id(35605892992315953)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Done'
,p_button_position=>'BELOW_BOX'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27236504645775021)
,p_name=>'P11_LONG_NAMES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_api.id(27236484577775020)
,p_prompt=>'Show Names as'
,p_source=>'LONG_NAMES'
,p_source_type=>'PREFERENCE'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Long;Y,Short;N'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(27236637498775022)
,p_name=>'P11_CLONE_AS_SIBLING'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_api.id(27236484577775020)
,p_prompt=>'Show Clone as'
,p_source=>'CLONE_AS_SIBLING'
,p_source_type=>'PREFERENCE'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Sibling;Y,Child;N'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_item(
 p_id=>wwv_flow_api.id(28078087162555228)
,p_name=>'P11_FLAT_VIEW'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_api.id(27236484577775020)
,p_prompt=>'Show Apex Sessions'
,p_source=>'FLAT_VIEW'
,p_source_type=>'PREFERENCE'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Flat;Y,Master Detail;N'
,p_cHeight=>1
,p_field_template=>wwv_flow_api.id(35605363241315950)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attribute_01=>'NONE'
,p_attribute_02=>'N'
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(27237032421775026)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_USER_PREFERENCES'
,p_process_name=>'Set Pref LONG_NAMES'
,p_attribute_01=>'SET_PREFERENCE_TO_ITEM_VALUE'
,p_attribute_02=>'LONG_NAMES'
,p_attribute_03=>'P11_LONG_NAMES'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(27236765882775023)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(27237195749775027)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_USER_PREFERENCES'
,p_process_name=>'Set Pref CLONE_AS_SIBLING'
,p_attribute_01=>'SET_PREFERENCE_TO_ITEM_VALUE'
,p_attribute_02=>'CLONE_AS_SIBLING'
,p_attribute_03=>'P11_CLONE_AS_SIBLING'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(27236765882775023)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(28078185510555229)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_USER_PREFERENCES'
,p_process_name=>'Set Pref FLAT_VIEW'
,p_attribute_01=>'SET_PREFERENCE_TO_ITEM_VALUE'
,p_attribute_02=>'FLAT_VIEW'
,p_attribute_03=>'P11_FLAT_VIEW'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(27236765882775023)
);
wwv_flow_api.create_page_process(
 p_id=>wwv_flow_api.id(27236961910775025)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_api.id(27236765882775023)
);
end;
/
