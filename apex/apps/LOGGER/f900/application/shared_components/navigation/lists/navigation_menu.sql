prompt --application/shared_components/navigation/lists/navigation_menu
begin
wwv_flow_api.create_list(
 p_id=>wwv_flow_api.id(35627105929318927)
,p_name=>'Navigation Menu'
,p_list_status=>'PUBLIC'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(35627253137318928)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Dashboard'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'1,'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(25645974049487723)
,p_list_item_display_sequence=>12
,p_list_item_link_text=>'Log Browsers'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(26683985950153878)
,p_list_item_display_sequence=>1
,p_list_item_link_text=>'Apex Sessions'
,p_list_item_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.::SM_APP_SESSION,SM_APP_USER::'
,p_parent_list_item_id=>wwv_flow_api.id(25645974049487723)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'5'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(35627438043318929)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Logger Sessions'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
,p_list_item_disp_cond_type=>'NEVER'
,p_parent_list_item_id=>wwv_flow_api.id(25645974049487723)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'8,'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(57805430192223138)
,p_list_item_display_sequence=>100
,p_list_item_link_text=>'Logger Session Messages'
,p_list_item_link_target=>'f?p=&APP_ID.:45:&SESSION.::&DEBUG.'
,p_parent_list_item_id=>wwv_flow_api.id(35627438043318929)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'45'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(25794152472917912)
,p_list_item_display_sequence=>25
,p_list_item_link_text=>'Logger Sessions'
,p_list_item_link_target=>'f?p=&APP_ID.:35:&SESSION.::&DEBUG.::SM_DB_SESSION,SM_DB_USER::'
,p_parent_list_item_id=>wwv_flow_api.id(25645974049487723)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'35'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(26194471736583041)
,p_list_item_display_sequence=>27
,p_list_item_link_text=>'Just Messages'
,p_list_item_link_target=>'f?p=&APP_ID.:50:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(25645974049487723)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(36058449663607339)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Apex Errors'
,p_list_item_link_target=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(25645974049487723)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'6'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(25646638745493793)
,p_list_item_display_sequence=>80
,p_list_item_link_text=>'Weaver'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(35627486857318929)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Source Library'
,p_list_item_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(25646638745493793)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'2,'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(35627656072318929)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Quick Weave'
,p_list_item_link_target=>'f?p=&APP_ID.:21:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(25646638745493793)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'21,22,25'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(25648165652515094)
,p_list_item_display_sequence=>90
,p_list_item_link_text=>'Configuration'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(35627304323318929)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Logger Registry'
,p_list_item_link_target=>'f?p=&APP_ID.:9:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(25648165652515094)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'9,10'
);
wwv_flow_api.create_list_item(
 p_id=>wwv_flow_api.id(25041794330869439)
,p_list_item_display_sequence=>70
,p_list_item_link_text=>'Settings'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::::'
,p_parent_list_item_id=>wwv_flow_api.id(25648165652515094)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'3,4'
);
end;
/
