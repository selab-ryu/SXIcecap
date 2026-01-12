<%@page import="com.liferay.portal.kernel.json.JSONException"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="com.sx.icecap.constant.IcecapMVCCommands"%>
<%@page import="com.liferay.document.library.kernel.model.DLFolderConstants"%>
<%@page import="com.liferay.petra.string.StringPool"%>
<%@page import="com.liferay.portal.kernel.util.PropsKeys"%>
<%@page import="com.liferay.portal.kernel.util.PrefsPropsUtil"%>
<%@page import="com.liferay.petra.string.StringUtil"%>
<%@page import="com.liferay.document.library.kernel.model.DLFileEntryConstants"%>
<%@page import="com.liferay.portal.kernel.util.Constants"%>
<%@page import="com.liferay.portal.kernel.service.ServiceContext"%>
<%@page import="com.liferay.portal.kernel.model.TicketConstants"%>
<%@page import="com.liferay.portal.kernel.model.User"%>
<%@page import="com.liferay.portal.kernel.service.TicketLocalServiceUtil"%>
<%@page import="com.liferay.portal.kernel.model.Ticket"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.sx.constant.StationXConstants"%>
<%@page import="com.sx.icecap.constant.IcecapDataTypeAttributes"%>
<%@page import="com.liferay.portal.kernel.json.JSONArray"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="com.sx.icecap.constant.IcecapWebKeys"%>
<%@page import="com.sx.icecap.model.DataType"%>
<%@ include file="../init.jsp" %>

<%
	DataType dataType = (DataType)renderRequest.getAttribute(DataType.class.getName());
	String dataStructure = (String)renderRequest.getAttribute(IcecapWebKeys.DATA_STRUCTURE);
	String structuredData = (String)renderRequest.getAttribute(IcecapWebKeys.STRUCTURED_DATA);
	
	String command = (String)renderRequest.getAttribute(StationXWebKeys.CMD);
	long structuredDataId = ParamUtil.getLong(renderRequest, IcecapWebKeys.STRUCTURED_DATA_ID, 0);
	
	Ticket ticket = TicketLocalServiceUtil.addTicket(user.getCompanyId(), User.class.getName(), user.getUserId(), TicketConstants.TYPE_IMPERSONATE, null, null, new ServiceContext());
	
	long subjectId =  ParamUtil.getLong(renderRequest, "subjectId", 0);
	String baseURL = (String)renderRequest.getAttribute("baseURL");
	
	Calendar today = Calendar.getInstance(locale);
%>

<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_STRUCTURED_DATA_DELETE_FILE %>" var="deleteFileURL">
</portlet:resourceURL>

<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_VISUALIZER_COMMON %>" var="resourceURL">
</portlet:resourceURL>


<%
/*
	JSONArray terms = structuredData.getJSONArray("terms");
	for( int i=0; i<terms.length(); i++ ){
		JSONObject termData = terms.getJSONObject(i);
		if( termData.getString("termType").equalsIgnoreCase("File")){
			termData.put( "deleteFileURL", deleteFileURL.toString() );
			
		}
	}
	*/
%>

<portlet:actionURL name="<%= IcecapMVCCommands.ACTION_STRUCTURED_DATA_ADD %>" var="saveActionURL">
	<portlet:param name="<%= StationXWebKeys.CMD %>" value="<%= command %>"/>
</portlet:actionURL>

<portlet:actionURL name="/temp/saveCRF" var="tempSaveActionURL">
	<portlet:param name="subjectId" value="<%= String.valueOf(subjectId) %>"/>
	<portlet:param name="baseURL" value="<%= baseURL %>"/>
	<portlet:param name="<%= StationXWebKeys.CMD %>" value="<%= command %>"/>
</portlet:actionURL>

<portlet:actionURL name="<%= IcecapMVCCommands.ACTION_STRUCTURED_DATA_DELETE %>" var="deleteActionURL">
	<portlet:param name="<%= StationXWebKeys.DATATYPE_ID %>" value="<%=String.valueOf(dataType.getDataTypeId()) %>"/>
	<portlet:param name="<%= StationXWebKeys.STRUCTURED_DATA_ID %>" value="<%= String.valueOf(structuredDataId) %>"/>
</portlet:actionURL>

<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_STRUCTURED_DATA_ADD_SAMPLE %>" var="addSampleData">
	<portlet:param name="<%= StationXWebKeys.DATATYPE_ID %>" value="<%=String.valueOf(dataType.getDataTypeId()) %>"/>
</portlet:resourceURL>

<aui:container cssClass="station-x">
	<aui:row cssClass="form-section">
		<aui:col md="12" >
				<aui:fieldset-group markupView="lexicon">
					<aui:fieldset label="datatype">
						<span style="display:table-cell; width:40%;">
						<aui:input name="dataTypeName" label="datatype-name" disabled="true" value="<%= dataType.getDataTypeName() %>"></aui:input>
						</span>
						<span style="display:table-cell; width:10%;">
						<aui:input name="dataTypeVersion" label="datatype-version" disabled="true" value="<%= dataType.getDataTypeVersion() %>"></aui:input>
						</span>
						<span style="display:table-cell; width:10%;">
						<aui:input name="dataTypeExtension" label="datatype-extention" disabled="true" value="<%= dataType.getExtension() %>"></aui:input>
						</span>
					</aui:fieldset>
				</aui:fieldset-group>
				<div>
					<span><%= dataType.getTooltip(locale) %></span>
				</div>
				<hr class=""></hr>
				
				<div id="<portlet:namespace/>editorPanel"></div>
				
				<form action="<%= tempSaveActionURL.toString() %>" name="<portlet:namespace/>fm" id="<portlet:namespace/>fm" method="post">
					<input type="hidden" id="<portlet:namespace/>dataTypeId" name="<portlet:namespace/>dataTypeId" value="<%= dataType.getDataTypeId() %>" >
					<input type="hidden" id="<portlet:namespace/>structuredDataId" name="<portlet:namespace/>structuredDataId" value="<%= structuredDataId %>" >
					<input type="hidden" id="<portlet:namespace/>dataContent" name="<portlet:namespace/>dataContent" >
					<aui:button-row>
						<aui:button type="button" id="btnSave" value="save"></aui:button>
						<aui:button type="button" id="btnDelete" value="delete" href="<%= deleteActionURL %>"></aui:button>
					</aui:button-row>
				</form>
		</aui:col>
	</aui:row>
</aui:container>

<aui:script use="aui-base, liferay-form, liferay-menu, liferay-portlet-url">


$(document).ready(function(){
	let SX =  StationX(  '<portlet:namespace/>', 
			'<%= defaultLocale.toString() %>',
			'<%= locale.toString() %>',
			<%= jsonLocales.toJSONString() %> );

	let dataStructure = <%= dataStructure %>;
	
	let sdJsonStr = '<%= structuredData %>';
	// for new line character
	let escapedString = sdJsonStr.replace(/\n/g, "\\n").replace(/\r/g, "\\r");
	//console.log("escaped", escapedString);
	let structuredData = <%= Validator.isNotNull(structuredData) %> ? JSON.parse(escapedString) : null;
	
	let sdeInfo;
	
	$.ajax({
		url: '<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_CREATE_PORTLET_INSTANCE %>"></portlet:resourceURL>',
		type:'post',
		dataType: 'json',
		data:{
			<portlet:namespace/>portletName: 'com_sx_visualizers_sde_StructuredDataEditorPortlet',
		},
		success: function(portletInfo){
			sdeInfo = portletInfo;
			
			$.ajax({
				url: portletInfo.url,
				success: function(data) {
					$('#<portlet:namespace/>editorPanel').html(data);
				},
				error: function(jqXHR, a, b){
					console.log('Loading Visualizer FAILED: ', a, b);
				}
			});
		},
		error: function(jqXHR, a, b){
			console.log('Fail to create a portlet namespace: com_sx_visualizers_sde_StructuredDataEditorPortlet'  );
		}
	});
	
	Liferay.on( 'SX_VISUALIZER_WAITING', function(event){
		console.log('Received SX_VISUALIZER_WAITING: ', event );
		if( event.dataPacket.sourcePortlet !== sdeInfo.namespace ){
			console.log('It\'s not my employee', event.dataPacket );
			return;
		}
		
		let dataPacket = event.dataPacket;
		
		if( !dataPacket.initialized ){
			let packet = SX.Util.createEventDataPacket( '<portlet:namespace/>',  dataPacket.sourcePortlet );
			
			SX.Util.fire( 'SX_HANDSHAKE', packet);			
		}
	});

	Liferay.on( SX.Events.SX_VISUALIZER_READY, function(evt){
		let rcvdPacket = evt.dataPacket;
		if( !rcvdPacket.isTargetPortlet( '<portlet:namespace/>') )	return;
		
		console.log( 'SX_VISUALIZER_READY received: ',  rcvdPacket );
		
		$.ajax({
			url: '<%=  resourceURL.toString() %>',
			type: 'post',
			data: {
				<portlet:namespace/>command: 'GET_STRUCTURED_DATA',
				<portlet:namespace/>dataTypeId: '<%= String.valueOf( dataType.getDataTypeId() ) %>',
				<portlet:namespace/>structuredDataId: '<%= String.valueOf( structuredDataId ) %>'
			},
			dataType: 'json',
			success: function(result){
				console.log('Read structuredData: ', result);
				let structuedData = !!result.structuredData ? JSON.parse( result.structuredData ) : null;
				
				let dataPacket = SX.Util.createEventDataPacket( '<portlet:namespace/>', rcvdPacket.sourcePortlet );
				dataPacket.payloadType = SX.Constants.PayloadType.DATA_STRUCTURE;
				dataPacket.dataStructure = dataStructure; 
				dataPacket.structuredData = structuredData; 
				console.log( 'Call editor: ', dataStructure, structuredData );
		
				dataPacket.profile = {
						dataTypeId: '<%= dataType.getDataTypeId() %>',
						dataTypeName:  '<%= dataType.getDataTypeName() %>',
						dataTypeVersion:  '<%= dataType.getDataTypeVersion() %>',
						dataTypeDisplayName:  '<%= dataType.getDisplayName(locale) %>',
						structuredDataId: '<%= structuredDataId %>'
				};
				
				SX.Util.fire( SX.Events.SX_LOAD_DATA, dataPacket );
			},
			error:function(jqXHR, a, b){
				console.log('Fail to get data: ', a, b);
			}
		});
	} );
	
	Liferay.on( SX.Events.SX_VISUALIZER_DATA_CHANGED, function(evt){
		let recvPacket = evt.dataPacket;
		if( !recvPacket.isTargetPortlet( '<portlet:namespace/>') )	return;
		
		//console.log( 'SX_VISUALIZER_DATA_CHANGED: ',  recvPacket );
		
		$('#<portlet:namespace/>dataTypeId').val(  recvPacket.payload.dataTypeId );
		$('#<portlet:namespace/>structuredDataId').val( recvPacket.payload.structuredDataId );
		$('#<portlet:namespace/>dataContent').val( recvPacket.payload.content );
		//console.log( 'dataContent: ', $('#<portlet:namespace/>dataContent').val() );
	});

	$('#<portlet:namespace/>btnSave').on( 'click', function(event){
		
		$('#<portlet:namespace/>fm').submit();
	});
	/*
	$('#<portlet:namespace/>addSamples').click( function(event){
		crfSampleData.forEach( data =>{
				$.ajax({
					url: '<%=  addSampleData.toString() %>',
					method: 'post',
					dataType: 'text',
					data: {
						<portlet:namespace/>sampleData: JSON.stringify(data)
					},
					success: function( result ){
						console.log( result );
					}
				});
		});
		crfSampleData.forEach( data =>{
			Object.keys( data ).forEach( key =>{
				if( !data[key] ){
					delete data[key];
				}
				else{
					let term = dataStructure.getTermByName( key );
					if( term.termType === "List" ){
						if( term.displayStyle === 'select'){
							data[key] = [data[key]];
						}
					}
					else if( term.termType === 'Numeric'){
						data[key] = Number(data[key]);
					}
					else if( term.termType === 'Date'){
						data[key] = new Date(data[key]).getTime();
					}
				}
			});
		});
	});
		*/
});


</aui:script>
