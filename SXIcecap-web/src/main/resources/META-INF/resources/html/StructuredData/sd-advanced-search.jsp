
<%@page import="com.liferay.portal.kernel.json.JSONException"%>
<%@page import="com.liferay.portal.util.Constants"%>
<%@page import="javax.portlet.ActionRequest"%>
<%@page import="com.liferay.frontend.taglib.clay.servlet.taglib.util.DropdownItemList"%>
<%@page import="com.sx.icecap.web.command.render.sd.EditStructuredDataRenderCommand"%>
<%@page import="com.sx.icecap.constant.IcecapWebPortletKeys"%>
<%@page import="com.sx.icecap.constant.IcecapWebKeys"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayPortletMode"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="java.util.List"%>
<%@page import="com.liferay.portal.kernel.util.HtmlUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.sx.icecap.model.StructuredData"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.sx.icecap.model.DataType"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.sx.icecap.constant.IcecapMVCCommands"%>
<%@page import="com.sx.constant.StationXConstants"%>
<%@page import="com.liferay.portal.kernel.util.DateUtil"%>
<%@page import="com.sx.icecap.web.taglib.clay.sd.StructuredDataVerticalCard"%>
<%@page import="com.liferay.portal.kernel.dao.search.RowChecker"%>
<%@page import="javax.portlet.PortletURL"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.sx.icecap.constant.IcecapMVCCommands"%>
<%@page import="com.sx.icecap.constant.IcecapConstants"%>
<%@page import="com.sx.constant.StationXWebKeys"%>
<%@page import="com.sx.icecap.web.display.context.sd.StructuredDataManagementToolbarDisplayContext"%>
<%@ include file="../init.jsp" %>

<style type="text/css">
	.id-width {
		width: 10% !important;
		text-align:center;
	}
	.abstract-width {
		width: 60% !important;
	}
	.status-width {
		width: 10% !important;
		text-align:center;
	}
	.actions-width {
		width: 10% !important;
		text-align:center;
	}
	
	.form-section {
		background-color: rgba(230, 230, 230, 0.777) !important;
	}
	
	.ztree span{
		font-size: 0.875rem;
	}
</style>

<%

	DataType dataType = (DataType)renderRequest.getAttribute(StationXWebKeys.DATATYPE);
	JSONArray abstractFields  = (JSONArray)renderRequest.getAttribute(StationXWebKeys.ABSTRACT_FIELDS);
	JSONObject dataStructure = (JSONObject)renderRequest.getAttribute(IcecapWebKeys.DATA_STRUCTURE);
	JSONArray structuredDataList =(JSONArray)renderRequest.getAttribute("structuredDataList");
%>

<portlet:renderURL var="editStructuredDataURL">
    <portlet:param 
    		name="<%= StationXWebKeys.MVC_RENDER_COMMAND_NAME %>" 
    		value="<%= IcecapMVCCommands.RENDER_STRUCTURED_DATA_EDIT %>"/>
    <portlet:param 
    		name="<%= StationXWebKeys.BACK_URL %>" 
    		value="<%= currentURL %>"/>
    <portlet:param 
    		name="<%= StationXWebKeys.DATATYPE_ID %>" 
    		value="<%= String.valueOf(dataType.getDataTypeId()) %>"/>
</portlet:renderURL>

<input type="hidden" id="<portlet:namespace/>searchResults" id="<portlet:namespace/>searchResults"/> 

<aui:container cssClass="station-x">
		<aui:row>
			<aui:col md="12">
				<aui:a id="backURL" href="<%= backURL %>" label="previous-page" style="width:20%;"></aui:a>
				<hr style="height:1px;background-color:#ddd;border-top: solid #aaa 2px;border-bottom:solid #eee;margin-top:5px;">
			</aui:col>
		</aui:row>
		<aui:row cssClass="form-section datatype-section">
			<aui:col md="12">
					<aui:fieldset-group markupView="lexicon">
						<aui:fieldset label="datatype">
							<span style="display:inline-block; width:10%;">
								<aui:input name="datatype-id" disabled="true" value="<%= dataType.getPrimaryKey() %>"></aui:input>
							</span>
							<span style="display:inline-block; width:40%;">
								<aui:input name="datatype-name" disabled="true" value="<%= dataType.getDataTypeName() %>"></aui:input>
							</span>
							<span style="display:inline-block; width:10%;">
								<aui:input name="datatype-version" disabled="true" value="<%= dataType.getDataTypeVersion() %>"></aui:input>
							</span>
							<span style="display:inline-block; width:10%;">
								<aui:input name="datatype-extension" disabled="true" value="<%= dataType.getExtension() %>"></aui:input>
							</span>
							<span style="display: inline-block;width:20%;float:right;">
								<a class="btn" href="<%= backURL %>" style="float:right;"><liferay-ui:message key="view-datatype-list"/></a>
							</span>
						</aui:fieldset>
					</aui:fieldset-group>
			</aui:col>
		</aui:row>
		<aui:button-row>
			<aui:button name="btnAddSearchTerm" value="add-search-term"></aui:button>
		</aui:button-row>
</aui:container>
 
<aui:container  cssClass="station-x">
	<aui:row >
		<aui:col md="5"   cssClass="show-border">
			<ul class="ztree" id="<portlet:namespace/>queryTree"></ul>
		</aui:col>
		<aui:col md="7"   cssClass="show-border">
			<div id="<portlet:namespace/>resultSection"></div>
		</aui:col>
	</aui:row>
</aui:container>

<div id="<portlet:namespace/>selectSearchTerm" style="display:none;">
	<div class="container">
		<div class="row">
			<div class="col-md-4">
				<aui:select name="fieldOperator" label="field-operator" inlineLabel="left" inlineField="true">
					<aui:option label="OR" value="OR"></aui:option>
					<aui:option label="AND" value="AND" selected="true"></aui:option>
				</aui:select>
			</div>
			<div class="col-md-4">
				<aui:select name="infieldOperator" label="infield-operator" inlineLabel="left" inlineField="true">
					<aui:option label="OR" value="OR"></aui:option>
					<aui:option label="AND" value="AND"></aui:option>
				</aui:select>
			</div>
		</div>
	</div>
	<div id="<portlet:namespace/>searchItemSection" class="station-x"></div>
</div>

<div id="<portlet:namespace/>historyDialog" class="pagination" style="width:100%; display:none;" ></div>
<div id="<portlet:namespace/>itemResultDialog" class="container" style="width:100%; display:none;" >
	<div id="<portlet:namespace/>itemTable" class="container" style="width:100%;"></div>
	<div id="<portlet:namespace/>itemPagination" class="pagination" style="margin-top:30px; width:100%; display:flex; justify-content:center;"></div>
</div>

<aui:script use="liferay-util-window, liferay-portlet-url">
$(document).ready(function(){
	let SX = StationX(  '<portlet:namespace/>', 
			'<%= defaultLocale.toString() %>',
			'<%= locale.toString() %>',
			<%= jsonLocales.toJSONString() %> );
			
	let dataStructure = SX.newDataStructure(
												<%= dataStructure.toString() %>, 
												new Object(),
												SX.Constants.FOR_SEARCH, 
												$('#<portlet:namespace/>searchItemSection') );
	dataStructure.render(); 
	
	let advancedSearch = new SX.AdvancedSearch(
						<%= structuredDataList.toJSONString() %>,
						$('#<portlet:namespace/>queryTree'),
						$('#<portlet:namespace/>resultSection'),
						'<%= editStructuredDataURL.toString() %>' );
	<portlet:namespace/>openSearchTermSelector();
	
	$('#<portlet:namespace/>btnAddSearchTerm').click( function(event){
		<portlet:namespace/>openSearchTermSelector();
	});
	
	function <portlet:namespace/>openSearchTermSelector(){
		$('#<portlet:namespace/>selectSearchTerm').dialog({
				title: '<liferay-ui:message key="select-search-field"/>',
				width:800,
				buttons:[{
					text: Liferay.Language.get('ok'),
					click: function( event ){
						if( advancedSearch.writingQuery.length > 0 ){
							advancedSearch.addWritingQueryToHistory();
							advancedSearch.retrieve();
							advancedSearch.loadQueryEditor($('#<portlet:namespace/>queryTree'));
						}
						//advancedSearch.showSearchResults();
						$(this).dialog('destroy');
						
						dataStructure.render();
					}
				},{
					text: Liferay.Language.get('cancel'),
					click: function( event ){
						if( advancedSearch.writingQuery.length > 0 ){
							advancedSearch.writingQuery = new Array();
							dataStructure.render();
						}
						
						$(this).dialog('destroy');
					}
				}],
				close: function( event, ui ){
					<portlet:namespace/>clearSearchTermSelector();
					$(this).dialog('destroy');
				}
		});
	}
	
	function <portlet:namespace/>clearSearchTermSelector() {
		// what gonna do here?
	}
	
	$('#<portlet:namespace/>btnSearchHistories').click(function(event){
		advancedSearch.selectSearchHistory( $('#<portlet:namespace/>mainPagination' ) );
	});
	
	Liferay.on(SX.Events.SEARCH_QUERY_DELIVER, function(evt){
		let dataPacket = evt.dataPacket;
		
		if( !dataPacket.isTargetPortlet( '<portlet:namespace/>' ) ){
			return;
		}
		console.log( 'SEARCH_QUERY_DELIVER' , dataPacket );
		
		$('#<portlet:namespace/>searchResults').val( JSON.stringify(dataPacket.deliverObj));
		
		console.log( 'DELIVER: ' + $('#<portlet:namespace/>searchResults').val());
	});
	
	Liferay.on(SX.Events.OPEN_QUERY_EDITOR, function(evt){
		let dataPacket = evt.dataPacket;
		
		if( !dataPacket.isTargetPortlet( '<portlet:namespace/>' ) ){
			return;
		}
		console.log( 'OPEN_QUERY_EDITOR' , dataPacket );
		
		$.ajax({
				url: '<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_CREATE_PORTLET_INSTANCE %>"></portlet:resourceURL>',
				type:'post',
				dataType: 'json',
				data:{
					<portlet:namespace/>portletName: '<%= IcecapWebPortletKeys.QUERY_EDITOR_PORTLET %>',
				},
				success: function(portletInfo){
					let searchHistory = dataPacket.history;
					let query = dataPacket.query;
					
					let params = new Object();
					params[portletInfo.namespace+'query'] = 
								searchHistory.query ? JSON.stringify(searchHistory.query.toZTreeJSON()) : '';
					params[portletInfo.namespace+'subquery'] = JSON.stringify(query.toZTreeJSON());
					
					advancedSearch.openQueryEditor( dataPacket.history, dataPacket.query, portletInfo.url, params );
				},
				error: function(jqXHR, a, b){
					console.log('Fail to create a portlet namespace: com_sx_visualizers_sde_StructuredDataEditorPortlet'  );
				}
		});
	});
	
	Liferay.on(SX.Events.QUERY_CHANGED, function( event ){
		let dataPacket = event.dataPacket;
		
		if( !dataPacket.isTargetPortlet( '<portlet:namespace/>' ) ){
			return;
		}
		console.log( 'OPEN_QUERY_EDITOR' , dataPacket );
	});
	});
</aui:script>
