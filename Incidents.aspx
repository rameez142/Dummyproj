<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Incidents.aspx.cs" Inherits="PatrolWebApp.Incidents" %>

<asp:Content ID="IncidentsContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="Content/jquery-3.2.1.min.js"></script>
    <script type="text/javascript">
        //var StopUpdateTimer;
        var LiveUpDaterTimer = null
        setInterval(function () {
            var IncidentsGrid = ASPxClientGridView.Cast("IncidentsGrid");
            var CommentsGrid = ASPxClientGridView.Cast("CommentsGrid");
            IncidentsGrid.Refresh();
            CommentsGrid.Refresh();
        }, 10000);


    </script>
    <script type="text/javascript"> //Incident stuff
        var mustRefreeshOpsLive = false;
        function IncidentsGrid_EndCallBack(sender, args) { //this is to force refreshing opsgrid when closing incidents
            if (mustRefreeshOpsLive) {
                mustRefreeshOpsLive = false;
                var OpsLiveGrid = ASPxClientGridView.Cast("OpsLiveGrid");
                OpsLiveGrid.Refresh();
            }
        }
        function IncidentsGrid_OnContextMenuItemClick(sender, args) {
            if (args.item.name == "اغلاق البلاغ") {
                if (confirm("متأكد تبي تغلق البلاغ؟ أكيد؟") == true) {
                    var IncidentsGrid = ASPxClientGridView.Cast("IncidentsGrid");
                    args.processOnServer = false;
                    args.usePostBack = false;
                    mustRefreeshOpsLive = true;
                    IncidentsGrid.PerformCallback("Closeincident" + ";" + args.elementIndex.toString());
                }
            }
        }
        function showIncidentPopUp() {
            var Incidents_Add_Popup = ASPxClientPopupControl.Cast("Incidents_Add_Popup");
            //  var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //  ASPxTimer1.SetEnabled(false);
            //update_AwalPeron_AddMappng_Visiblity(null, null);
            Incidents_Add_Popup.SetHeaderText("اضافه بلاغ جديد");
            Incidents_Add_Popup.Show();

            //clear old
            var Incidents_AddIncident_Source_ComboBox = ASPxClientComboBox.Cast("Incidents_AddIncident_Source_ComboBox");
            Incidents_AddIncident_Source_ComboBox.SetSelectedIndex(-1);

            var Incidents_AddIncident_Type_ComboBox = ASPxClientComboBox.Cast("Incidents_AddIncident_Type_ComboBox");
            Incidents_AddIncident_Type_ComboBox.SetSelectedIndex(-1);


            var Incidents_AddIncident_Place_TextBox = ASPxClientTextBox.Cast("Incidents_AddIncident_Place_TextBox");
            Incidents_AddIncident_Place_TextBox.SetText("");

            var Incidents_AddIncident_Extrainfo1_Label = ASPxClientLabel.Cast("Incidents_AddIncident_Extrainfo1_Label");
            var Incidents_AddIncident_Extrainfo2_Label = ASPxClientLabel.Cast("Incidents_AddIncident_Extrainfo2_Label");
            var Incidents_AddIncident_Extrainfo3_Label = ASPxClientLabel.Cast("Incidents_AddIncident_Extrainfo3_Label");


            var Incidents_AddIncident_Extrainfo1_TextBox = ASPxClientTextBox.Cast("Incidents_AddIncident_Extrainfo1_TextBox");
            var Incidents_AddIncident_Extrainfo2_TextBox = ASPxClientTextBox.Cast("Incidents_AddIncident_Extrainfo2_TextBox");
            var Incidents_AddIncident_Extrainfo3_TextBox = ASPxClientTextBox.Cast("Incidents_AddIncident_Extrainfo3_TextBox");

            if (Incidents_AddIncident_Extrainfo1_Label != null) {
                Incidents_AddIncident_Extrainfo1_Label.SetVisible(false);

            }
            if (Incidents_AddIncident_Extrainfo2_Label != null) {
                Incidents_AddIncident_Extrainfo2_Label.SetVisible(false);

            }
            if (Incidents_AddIncident_Extrainfo3_Label != null) {
                Incidents_AddIncident_Extrainfo3_Label.SetVisible(false);

            }

            if (Incidents_AddIncident_Extrainfo1_TextBox != null) {
                Incidents_AddIncident_Extrainfo1_TextBox.SetVisible(false);
                Incidents_AddIncident_Extrainfo1_TextBox.SetText("");

            }
            if (Incidents_AddIncident_Extrainfo2_TextBox != null) {
                Incidents_AddIncident_Extrainfo2_TextBox.SetVisible(false);
                Incidents_AddIncident_Extrainfo2_TextBox.SetText("");

            }
            if (Incidents_AddIncident_Extrainfo3_TextBox != null) {
                Incidents_AddIncident_Extrainfo3_TextBox.SetVisible(false);
                Incidents_AddIncident_Extrainfo3_TextBox.SetText("");

            }

        }
        function IncidentsGrid_closing_PopUp(sender, arg) {
            // var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            // ASPxTimer1.SetEnabled(true);
        }


        //comments
        var showCommentsPopUpEndCallback = false;
        function comments_closing_PopUp(sender, arg) {
            //  var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //  ASPxTimer1.SetEnabled(true);
            //  var IncidentsGrid = ASPxClientGridView.Cast("IncidentsGrid");

        }
        function showComments_PopUp() {
            //  var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //   ASPxTimer1.SetEnabled(false);
            var Incident_Comments_PopUp = ASPxClientPopupControl.Cast("Incident_Comments_PopUp");

            Incident_Comments_PopUp.Show();
            Incident_Comments_PopUp.SetHeaderText("التعليقات");
            //var CommentsCreateNew_TextBox = ASPxClientTextBox.Cast("CommentsCreateNew_TextBox");

            //CommentsCreateNew_TextBox.Focus(); //this is not working, no idea why...

        }
        function InidentsGrid_RowDblClick(sender, args) {
            var IncidentsGrid = ASPxClientGridView.Cast("IncidentsGrid");
            showCommentsPopUpEndCallback = true;
            IncidentsGrid.GetRowValues(args.visibleIndex, "IncidentID;UserName;IncidentsTypeName;IncidentSourceName;Place;ExtraInfo1;ExtraInfo2;ExtraInfo3;IncidentSourceExtraInfo1;IncidentSourceExtraInfo2;IncidentSourceExtraInfo3", function (values) {
                CommentsGrid.PerformCallback("IncidentComments" + ";" + values[0].toString());
                var Comments_IncidentUserName = ASPxClientLabel.Cast("Comments_IncidentUserName")
                var Comments_IncidentTypeName = ASPxClientLabel.Cast("Comments_IncidentTypeName")
                var Comments_IncidentSourceName = ASPxClientLabel.Cast("Comments_IncidentSourceName")
                var Comments_Place = ASPxClientLabel.Cast("Comments_Place")
                var Comments_Extra1_Name = ASPxClientLabel.Cast("Comments_Extra1_Name")
                var Comments_Extra1_Value = ASPxClientLabel.Cast("Comments_Extra1_Value")
                var Comments_Extra2_Name = ASPxClientLabel.Cast("Comments_Extra2_Name")
                var Comments_Extra2_Value = ASPxClientLabel.Cast("Comments_Extra2_Value")
                var Comments_Extra3_Name = ASPxClientLabel.Cast("Comments_Extra3_Name")
                var Comments_Extra3_Value = ASPxClientLabel.Cast("Comments_Extra3_Value")
                Comments_IncidentUserName.SetText(values[1]);
                Comments_IncidentTypeName.SetText(values[2]);
                Comments_IncidentSourceName.SetText(values[3]);
                Comments_Place.SetText(values[4]);
                Comments_Extra1_Value.SetText(values[5]);
                Comments_Extra2_Value.SetText(values[6]);
                Comments_Extra3_Value.SetText(values[7]);
                Comments_Extra1_Name.SetText(values[8]);
                Comments_Extra2_Name.SetText(values[9]);
                Comments_Extra3_Name.SetText(values[10]);
            });
        }
        function CommentsGrid_OnEndCallback(sender, args) {
            if (showCommentsPopUpEndCallback) {
                var CommentsGrid = ASPxClientGridView.Cast("CommentsGrid");
                CommentsGrid.Refresh();
                showCommentsPopUpEndCallback = false;
                showComments_PopUp();
            }
            //var Incident_Comments_PopUp = ASPxClientPopupControl.Cast("Incident_Comments_PopUp");
            //if (Incident_Comments_PopUp.GetVisible()) {
            //    var CommentsCreateNew_TextBox = ASPxClientTextBox.Cast("CommentsCreateNew_TextBox");
            //    CommentsCreateNew_TextBox.Focus();
            //}
        }
        function InidentsGrid_OnContextMenu(sender, args) {

        }


    </script>
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <dx:ASPxGridView ID="IncidentsGrid" runat="server" ClientInstanceName="IncidentsGrid"
                AutoGenerateColumns="False" DataSourceID="IncidentsDataSource"
                OnHtmlRowPrepared="IncidentsGrid_HtmlRowPrepared"
                OnContextMenuItemClick="IncidentsGrid_ContextMenuItemClick"
                OnFillContextMenuItems="IncidentsGrid_FillContextMenuItems"
                OnCustomCallback="IncidentsGrid_CustomCallback"
                EnableTheming="True" KeyFieldName="IncidentID" Width="100%" Theme="DevEx" Font-Size="Medium">
                <Settings ShowFilterRow="True" ShowTitlePanel="true" />
                <SettingsLoadingPanel Mode="Disabled" />
                <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                <Templates>
                    <TitlePanel>
                        <dx:ASPxButton ID="IncidentsCreateNew" ClientInstanceName="IncidentsCreateNew" runat="server" Image-AlternateText="بلاغ جديد" ClientSideEvents-Click="showIncidentPopUp" AutoPostBack="false" Image-Url="~/Content/NewIncident.png"></dx:ASPxButton>
                        <dx:ASPxButton ID="IncidentsRefresh" ClientInstanceName="IncidentsRefresh" runat="server" Image-AlternateText="بلاغ جديد" OnClick="IncidentsRefresh_Click" Image-Url="~/Content/Refresh.png"></dx:ASPxButton>
                    </TitlePanel>
                </Templates>
                <Columns>
                    <dx:GridViewDataTextColumn FieldName="IncidentID" Caption="رقم البلاغ" ReadOnly="True" VisibleIndex="0" Visible="true">
                    </dx:GridViewDataTextColumn>
                     <dx:GridViewDataTextColumn FieldName="UserName" Caption="كاتب البلاغ"  VisibleIndex="1" Visible="true">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="IncidentStateID" VisibleIndex="2" Caption="الحالة" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                        <PropertiesComboBox TextField="Name" ValueField="IncidentStateID" DataSourceID="IncidentStateDataSource"></PropertiesComboBox>
                        <Settings AllowAutoFilter="False" />
                        <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataTextColumn FieldName="IncidentStateID" Caption="البلاغ" VisibleIndex="3" Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="IncidentSourceID" VisibleIndex="4" Caption="جهة البلاغ" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                        <PropertiesComboBox TextField="Name" ValueField="IncidentSourceID" DataSourceID="IncidentSourceDataSource"></PropertiesComboBox>
                        <Settings AllowAutoFilter="False" />
                        <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataTextColumn FieldName="IncidentsTypeName" Caption="البلاغ" VisibleIndex="5">
                    </dx:GridViewDataTextColumn>

                    <dx:GridViewDataTextColumn FieldName="Place" Caption="المكان" VisibleIndex="6">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="UserName" Caption="مسجل البلاغ" VisibleIndex="7" Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataDateColumn FieldName="TimeStamp" Caption="وقت البلاغ" VisibleIndex="8" Settings-AllowHeaderFilter="True" PropertiesDateEdit-DisplayFormatString="G">
                        <Settings AllowAutoFilter="False" />
                        <SettingsHeaderFilter Mode="DateRangePicker" DateRangeCalendarSettings-FirstDayOfWeek="Sunday"></SettingsHeaderFilter>
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataDateColumn FieldName="LastUpdate" Caption="آخر تحديث" VisibleIndex="9" Settings-AllowHeaderFilter="True" PropertiesDateEdit-DisplayFormatString="G">
                        <Settings AllowAutoFilter="False" />
                        <SettingsHeaderFilter Mode="DateRangePicker" DateRangeCalendarSettings-FirstDayOfWeek="Sunday"></SettingsHeaderFilter>
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataColumn FieldName="IncidentID" Caption=" " VisibleIndex="10">
                        <Settings AllowAutoFilter="False" />
                        <DataItemTemplate>
                            <img id="img" runat="server" alt='Eval("Value")' src='<%# IncidentGrid_GetImageName(Eval("IncidentID")) %>' />
                        </DataItemTemplate>
                    </dx:GridViewDataColumn>
                    <dx:GridViewDataTextColumn FieldName="IncidentSourceExtraInfo1" Caption=" " Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="ExtraInfo1" Caption=" " Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="IncidentSourceExtraInfo2" Caption=" " Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="ExtraInfo2" Caption=" " Visible="false">
                    </dx:GridViewDataTextColumn>
                     <dx:GridViewDataTextColumn FieldName="IncidentSourceExtraInfo3" Caption=" " Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="ExtraInfo3" Visible="false">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="IncidentSourceName" Visible="false">
                    </dx:GridViewDataTextColumn>
                    
                   
                    <%--            <dx:GridViewDataTextColumn FieldName="IncidentSourceRequiresExtraInfo1"  Visible="false">
                                </dx:GridViewDataTextColumn>
                                 <dx:GridViewDataTextColumn FieldName="IncidentSourceRequiresExtraInfo2"  Visible="false">
                                </dx:GridViewDataTextColumn>
                                 <dx:GridViewDataTextColumn FieldName="IncidentSourceRequiresExtraInfo3"  Visible="false">
                                </dx:GridViewDataTextColumn>--%>
                </Columns>
                <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="false" AllowSort="false" />
                <SettingsContextMenu Enabled="true"
                    RowMenuItemVisibility-Refresh="false"
                    RowMenuItemVisibility-CollapseRow="false"
                    RowMenuItemVisibility-ExpandDetailRow="false"
                    RowMenuItemVisibility-CollapseDetailRow="false"
                    RowMenuItemVisibility-GroupSummaryMenu-SummaryAverage="false"
                    RowMenuItemVisibility-GroupSummaryMenu-Visible="false"
                    RowMenuItemVisibility-ExpandRow="false">
                    <RowMenuItemVisibility CollapseDetailRow="False" CollapseRow="False" ExpandDetailRow="False" ExpandRow="False" Refresh="False">
                        <GroupSummaryMenu SummaryAverage="False" Visible="False" />
                    </RowMenuItemVisibility>
                </SettingsContextMenu>
                <ClientSideEvents ContextMenu="InidentsGrid_OnContextMenu" RowDblClick="InidentsGrid_RowDblClick" EndCallback="IncidentsGrid_EndCallBack" ContextMenuItemClick="function(s,e) { IncidentsGrid_OnContextMenuItemClick(s, e); }" />

                <SettingsPager PageSize="100" />
                <SettingsText HeaderFilterSelectAll="الكل" HeaderFilterCancelButton="الغاء" HeaderFilterOkButton="موافق" />
                <SettingsBehavior AllowFixedGroups="true" />
                <GroupSummary>
                    <dx:ASPxSummaryItem SummaryType="Count" DisplayFormat=" - المجموع: {0}" />
                </GroupSummary>
                <Styles>
                    <GroupRow Font-Bold="true"></GroupRow>
                </Styles>
            </dx:ASPxGridView>

            <%--Incident Add PopUp--%>

            <dx:ASPxPopupControl ID="Incidents_Add_Popup" ClientInstanceName="Incidents_Add_Popup" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <asp:Panel ID="Incidents_Add_Panel" runat="server">
                            <table style="width: 100%">
                                <tr>
                                    <td style="width: 20%">
                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="جهة البلاغ" Font-Size="Medium"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="Incidents_AddIncident_Source_ComboBox" runat="server" Font-Size="Medium" DataSourceID="IncidentSourceDataSource" ValueField="IncidentSourceID" TextField="Name" Theme="DevEx" ClientInstanceName="Incidents_AddIncident_Source_ComboBox" AutoPostBack="true" OnSelectedIndexChanged="Incidents_AddIncident_Source_ComboBox_SelectedIndexChanged">
                                        </dx:ASPxComboBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%">
                                        <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="نوع البلاغ" Font-Size="Medium"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="Incidents_AddIncident_Type_ComboBox" runat="server" Font-Size="Medium" DataSourceID="IncidentTypeDataSource" ValueField="IncidentTypeID" TextField="Name" Theme="DevEx" ClientInstanceName="Incidents_AddIncident_Type_ComboBox">
                                        </dx:ASPxComboBox>

                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%">
                                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="المكان" Font-Size="Medium"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="Incidents_AddIncident_Place_TextBox" ClientInstanceName="Incidents_AddIncident_Place_TextBox" runat="server" Text="" Font-Size="Medium" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%">
                                        <dx:ASPxLabel ID="Incidents_AddIncident_Extrainfo1_Label" runat="server" Text="" Font-Size="Medium" Visible="false" ClientInstanceName="Incidents_AddIncident_Extrainfo1_Label"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="Incidents_AddIncident_Extrainfo1_TextBox" runat="server" Text="" Font-Size="Medium" Visible="false" ClientInstanceName="Incidents_AddIncident_Extrainfo1_TextBox" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%">
                                        <dx:ASPxLabel ID="Incidents_AddIncident_Extrainfo2_Label" runat="server" Text="" Font-Size="Medium" Visible="false" ClientInstanceName="Incidents_AddIncident_Extrainfo2_Label"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="Incidents_AddIncident_Extrainfo2_TextBox" runat="server" Text="" Font-Size="Medium" Visible="false" ClientInstanceName="Incidents_AddIncident_Extrainfo2_TextBox" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%">
                                        <dx:ASPxLabel ID="Incidents_AddIncident_Extrainfo3_Label" runat="server" Text="" Font-Size="Medium" Visible="false" ClientInstanceName="Incidents_AddIncident_Extrainfo3_Label"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="Incidents_AddIncident_Extrainfo3_TextBox" runat="server" Text="" Font-Size="Medium" Visible="false" ClientInstanceName="Incidents_AddIncident_Extrainfo3_TextBox" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 20%">
                                        <dx:ASPxLabel ID="Incidents_AddIncident_status_label" runat="server" Text="" Font-Size="Medium" Visible="false" ClientInstanceName="Incidents_AddIncident_status_label"></dx:ASPxLabel>

                                    </td>
                                    <td style="align-items: center">
                                        <dx:ASPxButton ID="Incidents_AddIncident_SubmitButton" runat="server" ClientInstanceName="Incidents_AddIncident_SubmitButton" Text="اضافه" OnClick="Incidents_AddIncident_SubmitButton_Click"></dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents Closing="IncidentsGrid_closing_PopUp" />
            </dx:ASPxPopupControl>
            <%--Comments PopUp--%>
            <dx:ASPxPopupControl ID="Incident_Comments_PopUp" ClientInstanceName="Incident_Comments_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <asp:Panel ID="Incident_Comments_Panel" runat="server">
                            <table style="width: 100%; text-align: right">
                                <tr style="text-align: right">
                                    <td colspan="2">
                                        <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="كاتب البلاغ" Font-Size="Medium" />
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="Comments_IncidentUserName" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_IncidentUserName" />
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="نوع البلاغ" Font-Size="Medium" />
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="Comments_IncidentTypeName" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_IncidentTypeName" />
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="جهة البلاغ" Font-Size="Medium" />
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="Comments_IncidentSourceName" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_IncidentSourceName" />
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="المكان" Font-Size="Medium" />
                                    </td>
                                    <td>
                                        <dx:ASPxLabel ID="Comments_Place" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_Place" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="9">
                                        <br />
                                    </td>
                                </tr>
                                <tr style="text-align: right">
                                    <td colspan="2" style="text-align: right">
                                        <dx:ASPxLabel ID="Comments_Extra1_Name" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_Extra1_Name" />
                                    </td>
                                    <td colspan="2" style="text-align: right">
                                        <dx:ASPxLabel ID="Comments_Extra1_Value" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_Extra1_Value" />
                                    </td>
                                    <td style="text-align: right">
                                        <dx:ASPxLabel ID="Comments_Extra2_Name" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_Extra2_Name" />
                                    </td>
                                    <td style="text-align: right">
                                        <dx:ASPxLabel ID="Comments_Extra2_Value" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_Extra2_Value" />
                                    </td>
                                    <td style="text-align: right">
                                        <dx:ASPxLabel ID="Comments_Extra3_Name" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_Extra3_Name" />
                                    </td>
                                    <td style="text-align: right">
                                        <dx:ASPxLabel ID="Comments_Extra3_Value" runat="server" Text="" Font-Size="Medium" ClientInstanceName="Comments_Extra3_Value" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="9">
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <dx:ASPxTextBox ID="CommentsCreateNew_TextBox" runat="server" NullText="اكتب تعليق جديد" Width="100%" Font-Size="Medium" ClientInstanceName="CommentsCreateNew_TextBox" Height="30" ClientSideEvents-KeyDown="function(s, e) {if (e.htmlEvent.keyCode == 13) {CommentsCreateNew.DoClick(); ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);}}">
                                        </dx:ASPxTextBox>
                                    </td>
                                    <td style="text-align: center">
                                        <dx:ASPxButton ID="CommentsCreateNew" runat="server" Text="اضافه" Height="30" ClientInstanceName="CommentsCreateNew" Width="50%" OnClick="CommentsCreateNew_Click" />
                                    </td>

                                    <td colspan="2" style="text-align: left">
                                        <dx:ASPxButton ID="CommentsRefresh" ClientInstanceName="CommentsRefresh" runat="server" Font-Size="Medium" Image-AlternateText="اعادة تحميل" OnClick="CommentsRefresh_Click" Image-Url="~/Content/Refresh.png"></dx:ASPxButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="9">
                                        <dx:ASPxGridView ID="CommentsGrid" ClientInstanceName="CommentsGrid" runat="server" Width="100%" AutoGenerateColumns="False"
                                            OnHtmlRowPrepared="CommentsGrid_HtmlRowPrepared"
                                            OnCustomCallback="CommentsGrid_CustomCallback"
                                            OnDataBound="CommentsGrid_DataBound"
                                            OnPageIndexChanged="CommentsGrid_PageIndexChanged"
                                            DataSourceID="CommentsDataSource" Font-Size="Medium">
                                            <Settings ShowTitlePanel="true" />
                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="false" />
                                            <SettingsBehavior AllowSort="false" />
                                            <SettingsLoadingPanel Mode="Disabled" />
                                            <Templates>
                                                <TitlePanel>
                                                </TitlePanel>
                                            </Templates>
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="IncidentCommentID" ReadOnly="True" Visible="false" ShowInCustomizationForm="false" VisibleIndex="0">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="IncidentID" ShowInCustomizationForm="false" Visible="false" VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="UserID" Visible="false" ShowInCustomizationForm="false" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="UserName" Caption="الكاتب" ShowInCustomizationForm="True" VisibleIndex="2">
                                                    <Settings AllowAutoFilter="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Text" Caption="التعليق" ShowInCustomizationForm="True" VisibleIndex="3">
                                                    <Settings AllowAutoFilter="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataDateColumn FieldName="TimeStamp" Caption="الوقت والتاريخ" ShowInCustomizationForm="True" VisibleIndex="4" Settings-AllowHeaderFilter="True">
                                                    <Settings AllowAutoFilter="False" />
                                                    <EditFormSettings Visible="False" />
                                                    <PropertiesDateEdit DisplayFormatString="G"></PropertiesDateEdit>
                                                    <SettingsHeaderFilter Mode="DateRangePicker"></SettingsHeaderFilter>
                                                </dx:GridViewDataDateColumn>

                                            </Columns>
                                            <SettingsPager PageSize="20" />
                                            <ClientSideEvents EndCallback="CommentsGrid_OnEndCallback" />
                                            <SettingsText HeaderFilterSelectAll="الكل" HeaderFilterCancelButton="الغاء" HeaderFilterOkButton="موافق" CommandUpdate="اضافة" CommandCancel="الغاء" PopupEditFormCaption="اضافة تعليق" />
                                        </dx:ASPxGridView>
                                    </td>
                                </tr>
                            </table>


                        </asp:Panel>
                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents Closing="comments_closing_PopUp" />
            </dx:ASPxPopupControl>

            <%--INCIDENTS--%>
            <asp:SqlDataSource ID="IncidentsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT  Incidents.IncidentID, Incidents.IncidentStateID,Users.Name as UserName, Incidents.Place, Incidents.IncidentSourceExtraInfo1 as ExtraInfo1, Incidents.IncidentSourceExtraInfo2 as ExtraInfo2, Incidents.IncidentSourceExtraInfo3  as ExtraInfo3, Incidents.TimeStamp, Incidents.LastUpdate, Incidents.IncidentSourceID, IncidentsTypes.Name AS IncidentsTypeName, IncidentSources.Name AS IncidentSourceName, IncidentSources.ExtraInfo1 as IncidentSourceExtraInfo1, IncidentSources.ExtraInfo2 as IncidentSourceExtraInfo2, IncidentSources.ExtraInfo3 as IncidentSourceExtraInfo3 FROM   Incidents INNER JOIN IncidentSources ON Incidents.IncidentSourceID = IncidentSources.IncidentSourceID INNER JOIN IncidentStates ON Incidents.IncidentStateID = IncidentStates.IncidentStateID INNER JOIN IncidentsTypes ON Incidents.IncidentTypeID = IncidentsTypes.IncidentTypeID  INNER JOIN Users ON Incidents.UserID = Users.UserID Order by TimeStamp desc"></asp:SqlDataSource>
            <asp:SqlDataSource ID="IncidentCommentDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [IncidentCommentID], [IncidentID], [Text], [UserID], [TimeStamp] FROM [IncidentsComments]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="IncidentSourceDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [IncidentSourceID], [Name], [MainExtraInfoNumber], [ExtraInfo1], [ExtraInfo2], [ExtraInfo3], [RequiresExtraInfo1], [RequiresExtraInfo2], [RequiresExtraInfo3] FROM [IncidentSources]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="IncidentStateDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [IncidentStateID], [Name] FROM [IncidentStates]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="IncidentTypeDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [IncidentTypeID], [Name], [Priority] FROM [IncidentsTypes]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="UsersDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [UserID],[UserName], [Name] FROM [Users]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="CommentsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [IncidentCommentID],[IncidentID],[Text],[UserID],(SELECT Name from Users where UserID=IncidentsComments.UserID) as UserName,[TimeStamp] from IncidentsComments WHERE IncidentID=@IncidentID order by [TimeStamp] desc">
                <SelectParameters>
                    <asp:SessionParameter DefaultValue="" Name="IncidentID" SessionField="CommentsIncidentID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
        <Triggers>
            <%--            <asp:AsyncPostBackTrigger ControlID="ASPxTimer1" EventName="Tick" />--%>
        </Triggers>

    </asp:UpdatePanel>
    <%--    <dx:ASPxTimer ID="ASPxTimer1" ClientInstanceName="ASPxTimer1" runat="server" OnTick="ASPxTimer1_Tick" Interval="30000"></dx:ASPxTimer>--%>
</asp:Content>
