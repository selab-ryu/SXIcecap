<%@page import="com.liferay.portal.kernel.portlet.LiferayPortletMode"%>
<%@page import="com.sx.icecap.constant.IcecapWebPortletKeys"%>
<%@page import="com.liferay.portal.kernel.util.Validator"%>
<%@page import="com.sx.constant.StationXConstants"%>
<%@page import="com.liferay.portal.kernel.util.PortalUtil"%>
<%@page import="com.liferay.portal.kernel.json.JSONObject"%>
<%@page import="java.util.Locale"%>
<%@page import="com.sx.constant.StationXWebKeys"%>
<%@page import="com.sx.icecap.constant.IcecapMVCCommands"%>
<%@page import="com.sx.icecap.model.DataType"%>
<%@page import="com.sx.util.SXPortalUtil"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@ include file="../init.jsp" %>

<%
	long dataTypeId = ParamUtil.getLong(renderRequest, StationXWebKeys.DATATYPE_ID, 0);

	DataType dataType = (DataType)renderRequest.getAttribute(StationXWebKeys.DATATYPE);
	JSONObject dataStructure = null;
	boolean hasDataStructure = dataType.getHasDataStructure();
	
	if( hasDataStructure ){
		System.out.println("Dropped here...");
		dataStructure = (JSONObject)renderRequest.getAttribute(StationXWebKeys.DATA_STRUCTURE);
	}
	
	System.out.println("BackURL: " + backURL.toString() );
%>

<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/main.css">

<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_DATATYPE_SAVE_STRUCTURE %>" var="saveDataStructureResourceCommandURL">
	<portlet:param name="cmd" value="<%= hasDataStructure?StationXConstants.CMD_UPDATE:StationXConstants.CMD_ADD %>"/>
</portlet:resourceURL>

<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_DATATYPE_STRUCTURE_DELETE %>" var="removeDataStructureResourceCommandURL">
	<portlet:param name="dataTypeId" value="<%= String.valueOf(dataType.getDataTypeId()) %>"/>
</portlet:resourceURL>


<portlet:renderURL var="dataTypeListURL">
	<portlet:param name="<%= StationXWebKeys.MVC_RENDER_COMMAND_NAME %>" value="<%= IcecapMVCCommands.RENDER_DATATYPE_LIST %>"></portlet:param>
</portlet:renderURL>

<portlet:renderURL var="dataTypeEditURL">
	<portlet:param name="<%= StationXWebKeys.MVC_RENDER_COMMAND_NAME %>" value="<%= IcecapMVCCommands.RENDER_DATATYPE_EDIT %>"></portlet:param>
	<portlet:param name="dataTypeId" value="<%= String.valueOf(dataType.getDataTypeId()) %>"/>
</portlet:renderURL>

<portlet:renderURL var="termTypeRenderURL"  windowState="<%= String.valueOf(LiferayWindowState.EXCLUSIVE) %>">
	<portlet:param name="<%= StationXWebKeys.MVC_RENDER_COMMAND_NAME %>" value="<%= IcecapMVCCommands.RENDER_TERM_TYPE_SPECIFIC_ATTRIBUTES %>"></portlet:param>
</portlet:renderURL>

<liferay-portlet:renderURL
		var="sdeURL"
		portletName="com_sx_visualizers_sde_StructuredDataEditorPortlet"
		windowState="<%= LiferayWindowState.POP_UP.toString() %>" >
		<liferay-portlet:param name="<%= StationXWebKeys.MVC_RENDER_COMMAND_NAME %>" value="<%= IcecapMVCCommands.RENDER_ROOT %>" />
		<liferay-portlet:param name="dataTypeId" value="<%= String.valueOf(dataTypeId) %>" />
		<liferay-portlet:param name="structuredDataId" value="<%= String.valueOf(0) %>" />
</liferay-portlet:renderURL>


<aui:form action="" name="defineFm">
<aui:container cssClass="station-x" id="dataTypeDefiner">

	<aui:row id="infoSection">
		<aui:col md="3" id="nameCol">
			<aui:input 
						type="text" 
						name="dataTypeName" 
						label="datatype-name"
						value="<%= dataType.getDataTypeName() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="2" id="versionCol">
			<aui:input 
						type="text" 
						name="dataTypeVersion"
						label="datatype-version" 
						value="<%= dataType.getDataTypeVersion() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="2" id="extensionCol">
			<aui:input 
						type="text" 
						name="dataTypeExtension"
						label="datatype-extension" 
						value="<%= dataType.getExtension() %>" 
						disabled="true">
			</aui:input>
		</aui:col>
		<aui:col md="5" id="naviCol">
			<div class="right">
				<liferay-ui:icon image="back" />
				<a href="<%= dataTypeEditURL.toString() %>"><liferay-ui:message key="back-to-datatype"/></a>
			</div>
		</aui:col>
	</aui:row>
	<aui:row>
		<aui:col>
			<hr class="title-horizontal-line">
		</aui:col>
	</aui:row>
	<aui:row id="headerSection">
		<aui:col md="4">
			<aui:input 
						type="text" 
						name="termDelimiter" 
						helpMessage="term-delimiter-help"
						value="<%= hasDataStructure ? dataStructure.get("termDelimiter") : ";" %>">
			</aui:input>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="termDelimiterPosition"
						helpMessage="term-delimiter-position-help">
				<aui:option label="start" value="start"></aui:option>
				<aui:option label="end" value="end" selected="true"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="termValueDelimiter"
						helpMessage="term-value-delimiter-help">
				<aui:option label="Equal" value="equal"  selected="true"></aui:option>
				<aui:option label="Space" value="space"></aui:option>
				<aui:option label="Colon" value="colon"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="matrixBracketType"
						helpMessage="matrix-bracket-type-help">
				<aui:option label="parenthesis-()" value="()"  selected="true"></aui:option>
				<aui:option label="curly-bracket-{}" value="{}"></aui:option>
				<aui:option label="square-bracket-[]" value="[]"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:select 
						name="matrixElementDelimiter"
						helpMessage="matrix-element-delimiter-help">
				<aui:option label="Space" value="space"  selected="true"></aui:option>
				<aui:option label="Comma" value="comma"></aui:option>
			</aui:select>
		</aui:col>
		<aui:col md="4">
			<aui:input 
						type="text" 
						name="commentChar" 
						helpMessage="comment-character-help"
						value="#">
			</aui:input>
		</aui:col>
	</aui:row>
	<aui:row>
		<aui:col md="12">
			<hr class="title-horizontal-line"><br>
		</aui:col>
	</aui:row>
	<aui:row>
		<aui:col md="2">
			<aui:input type="checkbox" name="inputStatusDisplay" label="input-status-display" inlineField="true" cssClass="display-inline-block"/>
		</aui:col>
		<aui:col md="2">
			<aui:input type="checkbox" name="goTo" label="use-goto" inlineField="true" cssClass="display-inline-block"/>
		</aui:col>
		<aui:col md="2">
			<aui:input type="checkbox" name="itemNoDisplay" label="display-item-no" inlineField="true" cssClass="display-inline-block"/>
		</aui:col>
		<aui:col md="6">
			<div id="<portlet:namespace/>inputStatusBar" style="display:flex;align-items:self-end;height:100%;margin-bottom:10px;margin-left:10px;font-size:0.9rem;font-weight:600;float:right;">
			</div>
		</aui:col>
	</aui:row>
	<aui:row id="editSection" cssClass="border">
		<aui:col md="5" id="termProperties" cssClass="bottom-margin">
			<aui:container>
				<aui:button-row>
					<aui:button name="btnNewTerm" value="new-term" cssClass="left"></aui:button>
					<aui:button name="btnCopyTerm" value="copy-term" cssClass="left"></aui:button>
					<aui:button name="btnClear" value="clear" cssClass="left"></aui:button>
					<aui:button name="btnImportTerm" value="import-term" cssClass="right"></aui:button>
				</aui:button-row>
				<aui:row>
				<aui:col>
				<div id="<portlet:namespace/>termTypeSelector">
					<aui:select name="termType" label="term-type" helpMessage="term-type-select-help">
						<aui:option label="String" value="String"/>
						<aui:option label="Numeric" value="Numeric"/>
						<aui:option label="List" value="List"/>
						<aui:option label="File" value="File"/>
						<aui:option label="Boolean" value="Boolean"/>
						<aui:option label="Date" value="Date"/>
						<aui:option label="Address" value="Address"/>
						<aui:option label="Phone" value="Phone"/>
						<aui:option label="EMail" value="EMail"/>
						<aui:option label="Matrix" value="Matrix"/>
						<aui:option label="Group" value="Group"/>
						<aui:option label="Grid" value="Grid"/>
					</aui:select>
				</div>
				
				<aui:input  
								name="termName" 
								label="term-name"  
								required="true" 
								placeholder="ex) termName"
								helpMessage="term-name-help">
				</aui:input>
				<aui:input  
								name="termVersion" 
								label="term-version" 
								required="true"
								helpMessage="term-version-help">
				</aui:input>
				<aui:field-wrapper name="termDisplayName" required="true" label="term-display-name" helpMessage="term-display-name-help">
						<liferay-ui:input-localized 
										name="termDisplayName"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:field-wrapper name="termDefinition" label="definition" helpMessage="definition-help">
						<liferay-ui:input-localized 
										type="textarea"
										name="termDefinition"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:input 
							type="checkbox"
							name="abstractKey" 
							label="abstract-key" 
							helpMessage="abstract-key-help">
				</aui:input>
				<aui:input 
							type="checkbox"
							name="disabled" 
							label="disabled" 
							helpMessage="disabled-help">
				</aui:input>
				<aui:input 
							type="checkbox"
							name="searchable" 
							label="searchable" 
							helpMessage="searchable-help">
				</aui:input>
				<aui:input 
							type="checkbox"
							name="downloadable" 
							label="downloadable" 
							helpMessage="downloadable-help">
				</aui:input>
				<aui:field-wrapper name="termTooltip" label="tooltip" helpMessage="term-tooltip-help">
						<liferay-ui:input-localized 
										name="termTooltip"
										xml="">
						</liferay-ui:input-localized>
				</aui:field-wrapper>
				<aui:input 
							type="text"
							name="synonyms" 
							label="synonyms" 
							helpMessage="term-synonyms-help">
				</aui:input>
				<aui:input 
							type="checkbox"
							name="mandatory" 
							label="mandatory" 
							helpMessage="term-mandatory-help">
				</aui:input>
				<aui:input 
							type="text"
							name="value" 
							label="default-value" 
							cssClass="display-inline-block"
							helpMessage="default-value-help">
				</aui:input>
	
				<hr class="content-horizontal-line">
				
				<aui:input
							type="text"
							name="cssWidth" 
							label="width" 
							cssClass="half-width"
							helpMessage="css-width-help"></aui:input>
				
				<aui:input
								type="text"
								name="customCss" 
								label="custom-css" 
								helpMessage="custom-css-help"></aui:input>
								
				<hr class="content-horizontal-line">
				
				<div id="<portlet:namespace/>typeSpecificSection">
				</div>
				<!--  %@include file="../templates/type-specific-attributes.jspf" % -->
				</aui:col>
				</aui:row>
			</aui:container>
		</aui:col>
		<aui:col md="1" id="buttonSection" cssClass="vertical-center-side-border">
			<div style="width:100%;">
				<aui:button id="btnUp" value="up" icon="icon-arrow-up" iconAlign="left" cssClass="center-button"></aui:button>
				<aui:button id="btnAdd" value="add" icon="icon-double-angle-right" iconAlign="right" cssClass="center-button"></aui:button>
				<aui:button id="btnDown" value="down" icon="icon-arrow-down" iconAlign="right" cssClass="center-button"></aui:button>
			</div>
		</aui:col>
		<aui:col md="6" id="previewSection">
				<!-- div id="templateString" cssClass="hide" -->
				<aui:button-row>
					<aui:button id="btnRefresh" value="refresh"></aui:button>
					<aui:button id="btnShowSDE" value="structured-data-editor"></aui:button>
					<img 
						id="<portlet:namespace/>btnPDF" name="<portlet:namespace/>btnPDF" 
						src="<%= request.getContextPath() %>/svg/pdf-svgrepo-com.svg"
						class="btn btn-default sxtooltip"
						style="width:50px;height:40px;float:right;margin-left:5px;margin-right:50px;padding:5px 0px;"
						title="<%= LanguageUtil.get(locale, "pdf")%>">
					<img 
						id="<portlet:namespace/>editor" name="<portlet:namespace/>editor" 
						src="<%= request.getContextPath() %>/svg/edit-table-svgrepo-com.svg"
						class="btn btn-default sxtooltip"
						style="display:none;width:50px;height:40px;float:right;margin-left:5px;margin-right:50px;padding:5px 0px;"
						title="<%= LanguageUtil.get(locale, "structure-editor")%>">
				</aui:button-row>
				
				<div class="container-fluid">
					<div class="row" id="<portlet:namespace/>goToBar" style="display:none;" >
						<div class="col-md-6">
							<aui:select name="goToCategory" label="go-to-category" inlineLabel="left" inlineField="true">
								<aui:option label="term-name" value="termName"></aui:option>
								<aui:option label="display-name" value="displayName"></aui:option>
							</aui:select>
						</div>
						<div class="col-md-6" class="ui-widget">
							<aui:input name="goToSelector" label="go-to" inlineLabel="left" inlineField="true"></aui:input>
						</div>
					</div>
					<div class="row" >
						<div class="col-md-12" id="<portlet:namespace/>previewPanel"></div>
					</div>
				</div>
		</aui:col>
	</aui:row>
	<aui:button-row>
		<aui:button id="btnSave" value="save"></aui:button>
		<aui:button id="btnSaveAndViewDataTypeList" value="save-and-view-datatype-list"></aui:button>
		<aui:button id="btnRemoveDataStructure" value="remove-data-structure"></aui:button>
	</aui:button-row>

</aui:container>
</aui:form>

<div id="<portlet:namespace/>pdf" style="display:none;width:640px;"></div>

<aui:script use="aui-base, liferay-form, liferay-menu">
$(document).ready(function(){
	
	let SX = StationX(  '<portlet:namespace/>', 
								'<%= defaultLocale.toString() %>',
								'<%= locale.toString() %>',
								<%= jsonLocales.toJSONString() %> );
								
	/**************************************************************
    * 	When a liferay-ui:input-localized tag is included in the dialog template section, then 
    *  Liferay.Menu.register() function makes critical trouble so that localized functions donot 
    *  work.
    *				
	let $listOptionManagementDlg = $('#<portlet:namespace/>manageListOptions')
				.dialog({
					autoOpen: true,
					width: 400,
					modal: true,
					title: '<liferay-ui:message key="edit-list-option"/>',
					buttons: {
						'<liferay-ui:message key="add-option"/>': function(){
						},
						'<liferay-ui:message key="cancel"/>': function(){
						}
					}
				});
	****************************************************************/
	
	let profile = {
		resourceCommandURL: '<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_VISUALIZER_COMMON%>"></portlet:resourceURL>',
		termTypeRenderURL: '<%= termTypeRenderURL.toString() %>',
		dataTypeId: '<%= dataType.getDataTypeId() %>',
		dataTypeName:  '<%= dataType.getDataTypeName() %>',
		dataTypeVersion:  '<%= dataType.getDataTypeVersion() %>',
		dataTypeDisplayName:  '<%= dataType.getDisplayName(locale) %>'
	};
	
	console.log( 'profile: ', profile);
	let createEmptyDataStructure = function(){
		$('#<portlet:namespace/>previewPanel').empty();
		
		dataStructure =  SX.newDataStructure(
												undefined,
												profile,
												SX.Constants.FOR_PREVIEW, 
												$('#<portlet:namespace/>previewPanel') );
		dataStructure.setCurrentTerm( dataStructure.createTerm( SX.FormUIUtil.getFormValue( 'termType' ) ) );
	}

	let dataStructure;
	let fileContent;
	
	let jsonDataStructure = <%= (Validator.isNull(dataStructure)) ? "{}" : dataStructure.toJSONString() %>;
	
	console.log( '-------------------', jsonDataStructure );
	if( $.isEmptyObject(jsonDataStructure) ){
		dataStructure =  SX.newDataStructure(
												undefined,
												profile,
												SX.Constants.FOR_PREVIEW, 
												$('#<portlet:namespace/>previewPanel'));
		
		dataStructure.render();										
	}
	else{
		dataStructure =  SX.newDataStructure( 
												jsonDataStructure,
												profile,
												SX.Constants.FOR_PREVIEW, 
												$('#<portlet:namespace/>previewPanel'));
												
		dataStructure.render();
	}
	
	$('#<portlet:namespace/>itemNoDisplay').on('change', function(event){
		
	});
	
	$('#<portlet:namespace/>btnRefresh').click(function(event){
		dataStructure.render();
		dataStructure.setCurrentTerm( dataStructure.getTermByOrder(dataStructure.getTopLevelTermId(), 1) );
	});
	
	$('#<portlet:namespace/>btnPDF').on('click',  function(event){
		//dataStructure.renderFormToPDF( $('#<portlet:namespace/>previewPanel'), null  );
		//$('#<portlet:namespace/>pdf').hide();
		//$('#<portlet:namespace/>editor').show();
		
		let $pdf = $('#<portlet:namespace/>pdf');
		$pdf.empty();
		$pdf.append($('<div style="margin:20px 0px;text-align:center;"><h3>'+dataStructure.dataTypeDisplayName+'</h3></div>'))
		
		dataStructure.renderFormToPDF( $pdf, null  );
		$pdf.show();
		
		window.jsPDF = window.jspdf.jsPDF;
		const pdf = new jsPDF('p', 'pt', 'a4');
		pdf.setProperties({
			title: '<%= dataType.getDisplayName(locale) %>'
		});

		const image = { type: 'png', quality: 0.98 };
		const paperWidth = 595;
		const paperHeight = 842;
		const margins = {
				top: 50,
				right: 20,
				bottom: 40,
				left: 30
		};
				
		html2canvas($pdf[0], {scrollY: 0}).then( canvas => {
			const innerPageWidth = paperWidth - (margins.left + margins.right);
			const innerPageHeight = paperHeight - (margins.top + margins.bottom);

			// Calculate the number of pages.
			const pxFullHeight = canvas.height;
			const pxPageHeight = Math.floor(canvas.width * (paperHeight / paperWidth));
			const nPages = Math.ceil(pxFullHeight / pxPageHeight);

			// Define pageHeight separately so it can be trimmed on the final page.
			let pageHeight = innerPageHeight;

			// Create a one-page canvas to split up the full image.
			const pageCanvas = document.createElement('canvas');
			const pageCtx = pageCanvas.getContext('2d');
			pageCanvas.width = canvas.width;
			pageCanvas.height = pxPageHeight;

			for( let page = 0; page < nPages; page++ ) {
				if (page === nPages - 1 && pxFullHeight % pxPageHeight !== 0) {
					pageCanvas.height = pxFullHeight % pxPageHeight;
					pageHeight = (pageCanvas.height * innerPageWidth) / pageCanvas.width;
				}

				const width = pageCanvas.width;
				const height = pageCanvas.height;
				pageCtx.fillStyle = 'white';
				pageCtx.fillRect( 0, 0, width, height);
				pageCtx.drawImage( canvas, 0, page * pxPageHeight, width, height, 0, 0, width, height );

				if( page > 0 ){
					pdf.addPage();
				}
				
				const imgData = pageCanvas.toDataURL( 'image/' + image.type, image.quality );
				pdf.addImage( imgData, image.type, margins.left, margins.top, innerPageWidth, pageHeight );

				const pageText = '- '+(page+1)+' -'; 
				pdf.setFontSize(10);
				pdf.text( pageText, (paperWidth+$('<span>'+pageText+'</span>').width())/2, 820 );
			}

			window.open(pdf.output('bloburl'));
			$pdf.empty();
			$pdf.hide();
		});
	});
	$('#<portlet:namespace/>editor').on('click',  function(event){
		$('#<portlet:namespace/>btnRefresh').trigger( 'click' );
		$('#<portlet:namespace/>editor').hide();
		$('#<portlet:namespace/>pdf').show();
	});
	
	$('#<portlet:namespace/>btnSave').click(function(event){
		if( !dataStructure.terms || dataStructure.terms.length < 1 ){
			return;
		}
		
		console.log( 'dataStructure: ', dataStructure );
		console.log( dataStructure.toDBContent() );
		
		$.ajax({
			url: '<%= saveDataStructureResourceCommandURL.toString() %>',
			method: 'post',
			dataType: 'text',
			data: {
				<portlet:namespace/>dataTypeId: '<%= String.valueOf(dataTypeId) %>',
				<portlet:namespace/>dataStructure: JSON.stringify(dataStructure)
			},
			success: function( result ){
				$.confirm({
					title: '<liferay-ui:message key="request-success"/>',
					content: '<liferay-ui:message key="data-structure-saved"/>',
					type: 'orange',
					typeAnimated: true,
					draggable: true,
					buttons:{
							ok: {
								text: 'OK',
								btnClass: 'btn-blue'
							}
					}
				});
				
				dataStructure.clearTermsDirty();
			},
			error: function(){
				console.log('error');
			}
		});
	});
	
	$('#<portlet:namespace/>btnSaveAndViewDataTypeList').click(function(event){
		if( !dataStructure.terms || dataStructure.terms.length < 1 ){
			return;
		}
		
		$.ajax({
			url: '<%= saveDataStructureResourceCommandURL.toString() %>',
			method: 'post',
			dataType: 'text',
			data: {
				<portlet:namespace/>dataTypeId: '<%= String.valueOf(dataTypeId) %>',
				<portlet:namespace/>dataStructure: JSON.stringify(dataStructure)
			},
			success: function( result ){
				// console.log( result );
				// redirect to datatype list view
				window.location.href='<%= dataTypeListURL %>';
			},
			error: function(){
				console.log('error');
			}
		});
	});
	
	$('#<portlet:namespace/>btnRemoveDataStructure').click( function(event){
		$.confirm({
			title: '<liferay-ui:message key="confirm-remove-data-structure" />',
			content: '<p><liferay-ui:message key="are-you-sure-to-remove-this-data-structure-if-you-click-ok-then-it-is-impossible-to-get-back"/></p>',
			type: 'orange',
			typeAnimated: true,
			columnClass: 'medium',
			buttons:{
				ok: {
					text: '<liferay-ui:message key="ok"/>',
					btnClass: 'btn-blue',
					action: function(){
						$.ajax({
							url: '<%= removeDataStructureResourceCommandURL.toString() %>',
							method: 'post',
							dataType: 'text',
							success: function( result ){
								$.alert( '<liferay-ui:message key="data-structure-successfully-deleted-from-database"/>' );
								createEmptyDataStructure();
							},
							error: function(){
								$.alert( '<liferay-ui:message key="failed-to-delete-data-structure-from-database"/>' );
							}
						});
					}
				}
			},
			draggable: true
		});
	});
	
	<%
		JSONObject sdePortletInfo = SXPortalUtil.createPortletInstanceId( renderRequest, "com_sx_visualizers_sde_StructuredDataEditorPortlet" );
	%>
	
	$('#<portlet:namespace/>btnShowSDE').click( function(event){
		$.ajax({
				url: '<portlet:resourceURL id="<%= IcecapMVCCommands.RESOURCE_CREATE_PORTLET_INSTANCE %>"></portlet:resourceURL>',
				type:'post',
				dataType: 'json',
				data:{
					'<portlet:namespace/>portletName': 'com_sx_visualizers_sde_StructuredDataEditorPortlet'
				},
				success: function(result){
					console.log('Result: ', result);
					
					let data = new Object();
					data[result.namespace + 'dataPacket'] = 
											JSON.stringify(SX.Util.createEventDataPacket('<portlet:namespace/>', result.namespace) );
					data[result.namespace + 'employer'] = '<portlet:namespace/>';
					
					$.ajax({
						url: result.url,
						type:'post',
						data: data,
						success: function(renderImage) {
							let $dialog = $('<div></div>')
								.html(renderImage)
								.dialog({
									autoOpen: true,                          
									modal: false,
									width:800,
									maxHeight:800,
									title: Liferay.Language.get('structured-data-editor'),
									close: function(event, ui){
										$dialog.dialog('destroy');
									},
									buttons:[
										{
											text: 'Ok',
											icon: 'ui-icon-heart',
											click: ()=>{
												console.log( 'Editted Data: ', dataStructure.toDBContent() );
												$dialog.dialog('destroy');
											}
										}
									]
								});
						},
						error: function(jqXHR, a, b){
							console.log('Bad request....', a, b);
						}
			  		});
				},
				error: function(jqXHR, a, b){
					console.log('Fail to create a portlet namespace: com_sx_visualizers_sde_StructuredDataEditorPortlet'  );
				}
		});
	
		/* Why I cannot render a portlet with this url????
		*	- creates authorization failed!!!
		let sdeURL = Liferay.PortletURL.createURL('<portlet:renderURL></portlet:renderURL>');
		sdeURL.setPortletId( 'com_sx_visualizers_sde_StructuredDataEditorPortlet');
		sdeURL.setLifecycle(Liferay.PortletURL.RENDER_PHASE);
		sdeURL.setWindowState('<%= LiferayWindowState.EXCLUSIVE %>');
		sdeURL.setPortletMode('<%= LiferayPortletMode.VIEW %>');
		sdeURL.setParameter('p_auth', Liferay.authToken);
		*/
	});
	
	Liferay.on( SX.Events.SX_VISUALIZER_READY, function(event){
		let dataPacket = event.dataPacket;
		
		if( dataPacket.targetPortlet !== '<portlet:namespace/>' )	return;
		
		console.log('Portlet SX_VISUALIZER_READY: ', dataPacket );
		
		let packet = SX.createEventDataPacket( '<portlet:namespace/>', dataPacket.sourcePortlet );
		packet.dataStructure = dataStructure.toJSON();
		console.log( 'Last Data Structure: ', packet.dataStructure );
		packet.structuredData = fileContent;
		packet.payloadType = SX.Constants.PayloadType.DATA_STRUCTURE;

		SX.Util.fire( SX.Events.SX_LOAD_DATA, packet );
	});
	
	Liferay.on( SX.Events.SX_VISUALIZER_DATA_CHANGED, function(event){
		let dataPacket = event.dataPacket;
		
		if( dataPacket.targetPortlet !== '<portlet:namespace/>' )	return;
		console.log('SX_VISUALIZER_DATA_CHANGED: ', dataPacket );
		
		fileContent = dataPacket.payload;
		console.log('fileContent: ', fileContent);
	});
	
	Liferay.on( SX.Events.SX_STRUCTURED_DATA_CHANGED, function(event){
		let dataPacket = event.dataPacket;
		
		if( dataPacket.targetPortlet !== '<portlet:namespace/>' )	return;
		console.log('SX_STRUCTURED_DATA_CHANGED: ', dataPacket );
		
		fileContent = dataPacket.payload;
		
		console.log('fileContent: ', fileContent);
	});
	
	
	Liferay.on('jquery_alert', function(e){
		alert('JQuery Alert');
	});
});
</aui:script>


