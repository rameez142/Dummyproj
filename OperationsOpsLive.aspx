<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="OperationsOpsLive.aspx.cs" Inherits="PatrolWebApp.Operations" %>

<asp:Content ID="OperationsContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript" src="Content/jquery-3.2.1.min.js"></script>
    <script type="text/javascript" src="Content/robust-websocket.js"></script>
    <script type="text/javascript">
        //var StopUpdateTimer;
        var LiveUpDaterTimer = null
        setInterval(function () {
            var OpsLiveGrid = ASPxClientGridView.Cast("OpsLiveGrid");
            var IncidentsGrid = ASPxClientGridView.Cast("IncidentsGrid");
            var CommentsGrid = ASPxClientGridView.Cast("CommentsGrid");
            OpsLiveGrid.Refresh();
            IncidentsGrid.Refresh();
            CommentsGrid.Refresh();
        }, 10000);
        //$(document).keydown(function (e) {
        //    var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
        //    if (StopUpdateTimer != null)
        //        clearTimeout(StopUpdateTimer);//clear old timer
        //    ASPxTimer1.SetEnabled(false); //we will stop live update with any key press for 7 seconds
        //    StopUpdateTimer = setTimeout(function () {
        //        ASPxTimer1.SetEnabled(true);
        //    }, 5000);
        //});
        var ShowPopUpOnEndCallBack = false;
        function show_States_PopUp() {
            var OpsLive_States_PopUp = ASPxClientPopupControl.Cast("OpsLive_States_PopUp");
            //  var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //  ASPxTimer1.SetEnabled(false);
            OpsLive_States_PopUp.SetHeaderText("آخر الحالات");
            OpsLive_States_PopUp.Show();


        }
        function show_AttachIncident_PopUp() {
            var OpsLive_IncidentAttach_PopUp = ASPxClientPopupControl.Cast("OpsLive_IncidentAttach_PopUp");
            // var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //  ASPxTimer1.SetEnabled(false);
            OpsLive_IncidentAttach_PopUp.SetHeaderText("تسليم بلاغ");
            OpsLive_IncidentAttach_PopUp.Show();

        }
        function OpsLive_OnEndCallback(sender, args) {
            if (ShowPopUpOnEndCallBack) {
                var OpsLive_States_Grid = ASPxClientGridView.Cast("OpsLive_States_Grid");
                OpsLive_States_Grid.Refresh();
                ShowPopUpOnEndCallBack = false;
                show_States_PopUp();
            }

        }

        function OpsLiveGrid_RowDBClick(sender, args) {//we will utlize this to check for there is incident to be removed
            var OpsLiveGrid = ASPxClientGridView.Cast("OpsLiveGrid");

            //we need to hide, if exists, the label and button attached incident 
            OpsLiveGrid.GetRowValues(args.visibleIndex, "AhwalMappingID;IncidentID", function (values) {
                var AttachedIncident_Label = ASPxClientLabel.Cast("AttachedIncident_Label");
                var AttachedIncident_Release_Button = ASPxClientButton.Cast("AttachedIncident_Release_Button");
                if (values[1] != "" && values[1] != null) {
                    document.getElementById("AttachIncidentMappingID").value = values[0];
                    AttachedIncident_Label.SetText("الدورية مستلمه بلاغ رقم: " + values[1]);
                    AttachedIncident_Label.SetVisible(true);
                    AttachedIncident_Release_Button.SetVisible(true);
                } else {
                    document.getElementById("AttachIncidentMappingID").value = "";
                    AttachedIncident_Label.SetText("");
                    AttachedIncident_Label.SetVisible(false);
                    AttachedIncident_Release_Button.SetVisible(false);
                }
                ShowPopUpOnEndCallBack = true;
                OpsLiveGrid.PerformCallback("LatestStates" + ";" + values[0]);
            });

        }

        function closing_StatesPopUp(sender, arg) {
            // var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            // ASPxTimer1.SetEnabled(true);
        }


        function OpsLiveGrid_OnContextMenuItemClick(sender, args) {
            var OpsLiveGrid = ASPxClientGridView.Cast("OpsLiveGrid");
            if (args.item.name == "تسليم بلاغ") {
                var AttachIncident_GridLookUp = ASPxClientGridLookup.Cast("AttachIncident_GridLookUp");
                OpsLiveGrid.GetRowValues(args.elementIndex, "AhwalMappingID", function (value) {
                    document.getElementById("AttachIncidentMappingID").value = value;
                    AttachIncident_GridLookUp.GetGridView().Refresh();
                    AttachIncident_GridLookUp.SetText(""); //clear old selection
                    show_AttachIncident_PopUp();
                });

            }
        }

    </script>




    <script type="text/javascript"> //websock live caller id stuff
        var LiveCallerTimeOut = null;
         //var ws = new RobustWebSocket('ws://' + "localhost" + ':8080/CallerServer', null, {
         var ws = new RobustWebSocket('ws://' + window.location.origin.replace("http://", "") + ':8080/CallerServer', null, {
            // The number of milliseconds to wait before a connection is considered to have timed out. Defaults to 4 seconds.
            timeout: 20000,
            // A function that given a CloseEvent or an online event (https://developer.mozilla.org/en-US/docs/Online_and_offline_events) and the `RobustWebSocket`,
            // will return the number of milliseconds to wait to reconnect, or a non-Number to not reconnect.
            // see below for more examples; below is the default functionality.
            shouldReconnect: function (event, ws) {
                if (event.code === 1008 || event.code === 1011) return
                return ws.reconnects <= 200000 && 0//return [0, 3000, 3000, 3000, 3000][ws.attempts]//
            },
            // A boolean indicating whether or not to open the connection automatically. Defaults to true, matching native [WebSocket] behavior.
            // You can open the websocket by calling `open()` when you are ready. You can close and re-open the RobustWebSocket instance as much as you wish.
            automaticOpen: true
        })
        ws.addEventListener('open', function (event) {
            // ws.send('Hello!')
        })

        ws.addEventListener('message', function (event) {
            // console.log('we got: ' + event.data)
            var received_msg = event.data;

            var LiveCaller_PopUp = ASPxClientPopupControl.Cast("LiveCaller_PopUp");

            //LiveCaller_AwahlMappingID 
            var LiveCaller_AhwalShiftSectorCity_Label = ASPxClientLabel.Cast("LiveCaller_AhwalShiftSectorCity_Label");
            var LiveCaller_CallerID_Label = ASPxClientLabel.Cast("LiveCaller_CallerID_Label");
            var LiveCaller_MilNumberRankName_Label = ASPxClientLabel.Cast("LiveCaller_MilNumberRankName_Label");
            var LiveCaller_HandHeld_Label = ASPxClientLabel.Cast("LiveCaller_HandHeld_Label");
            var LiveCaller_Patrol_Label = ASPxClientLabel.Cast("LiveCaller_Patrol_Label");
            var LiveCaller_Mobile_Label = ASPxClientLabel.Cast("LiveCaller_Mobile_Label");
            var LiveCaller_Away_Button = ASPxClientButton.Cast("LiveCaller_Away_Button");
            var LiveCaller_Land_Button = ASPxClientButton.Cast("LiveCaller_Land_Button");
            var LiveCaller_BackFromAway_Button = ASPxClientButton.Cast("LiveCaller_BackFromAway_Button");
            var LiveCaller_BackFromLand_Button = ASPxClientButton.Cast("LiveCaller_BackFromLand_Button");
            var LiveCaller_Walking_Button = ASPxClientButton.Cast("LiveCaller_Walking_Button");
            var LiveCaller_BackFromWalking_Button = ASPxClientButton.Cast("LiveCaller_BackFromWalking_Button");

            if (!received_msg.includes("#")) {
                return;
            }
            //hide all buttons
            LiveCaller_Away_Button.SetVisible(false);
            LiveCaller_Land_Button.SetVisible(false);
            LiveCaller_BackFromAway_Button.SetVisible(false);
            LiveCaller_BackFromLand_Button.SetVisible(false);
            LiveCaller_Walking_Button.SetVisible(false);
            LiveCaller_BackFromWalking_Button.SetVisible(false);

            var msgsplitted = received_msg.split('#');
            var OpsLiveGrid = ASPxClientGridView.Cast("OpsLiveGrid");
            if (msgsplitted[2].includes("$")) { //this is for someone not in our opslive grid list

            } else { //someone in our list
                var index = OpsLiveGrid.cpIndices[msgsplitted[2]]; //we are to do this because of onCustomJSProerties added to opslivegrid
                if (index == null)
                    return;
                OpsLiveGrid.GetRowValues(index,"AhwalMappingID;AhwalName;ShiftName;SectorName;CityGroupName;MilNumber;RankName;PersonName;PersonMobile;CallerID;Serial;PlateNumber;PatrolPersonStateID", function (values) {
                    var AhwalMappingID = values[0];
                    var AhwalName = values[1];
                    var ShiftName = values[2];
                    var SectorName = values[3];
                    var CityGroupName = values[4];
                    var MilNumber = values[5];
                    var RankName = values[6];
                    var PersonName = values[7];
                    var PersonMobile = values[8];
                    var CallerID = values[9];
                    var Serial = values[10];
                    var PlateNumber = values[11];
                    var PatrolPersonStateID = values[12];
                    //LiveCaller_CallerID_Label
                    //LiveCaller_AhwalShiftSectorCity_Label
                    //LiveCaller_MilNumberRankName_Label
                    //LiveCaller_HandHeld_Label
                    //LiveCaller_Patrol_Label
                    //LiveCaller_Mobile_Label  
                    document.getElementById("LiveCaller_AwahlMappingID").value = AhwalMappingID;
                    LiveCaller_AhwalShiftSectorCity_Label.SetText(AhwalName + " - " + ShiftName + " - " + SectorName + " " + CityGroupName);
                    LiveCaller_CallerID_Label.SetText(CallerID);
                    LiveCaller_MilNumberRankName_Label.SetText(MilNumber + " " + RankName + "/ " + PersonName);
                    LiveCaller_HandHeld_Label.SetText(Serial);
                    LiveCaller_Patrol_Label.SetText(PlateNumber);
                    LiveCaller_Mobile_Label.SetText(PersonMobile);
                    var patrolStateID = PatrolPersonStateID;
                   
                    if (patrolStateID == "20" || patrolStateID == "30" || patrolStateID == "40" || patrolStateID == "74") {
                        LiveCaller_Away_Button.SetVisible(true);
                        LiveCaller_Land_Button.SetVisible(true);
                        LiveCaller_Walking_Button.SetVisible(true);
                    } else if (patrolStateID == "60") { //awway
                        LiveCaller_BackFromAway_Button.SetVisible(true);
                    } else if (patrolStateID == "70") { //land
                        LiveCaller_BackFromLand_Button.SetVisible(true);
                    } else if (patrolStateID == "72") { //walking
                        LiveCaller_BackFromWalking_Button.SetVisible(true);
                    }

                    LiveCaller_PopUp.Show();
                    //  var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
                    //   ASPxTimer1.SetEnabled(false);
                    if (LiveCallerTimeOut != null) {
                        clearTimeout(LiveCallerTimeOut);
                    }
                    LiveCallerTimeOut = setTimeout(function () { //auto close popup after 5 seconds
                        // document.getElementById('log').innerHTML = "";
                        LiveCaller_PopUp.Hide();
                    }, 15000);
                });
            }
            //console.log(msgsplitted);

        });

        function closing_LiveCallerPopUp(sender, arg) {
            //    var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //    ASPxTimer1.SetEnabled(true);
        }

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
            <table>
                <tr>
                    <td style="width: 65%; vertical-align: top;">
                        <dx:ASPxGridView ID="OpsLiveGrid" runat="server" ClientInstanceName="OpsLiveGrid"
                            AutoGenerateColumns="False" DataSourceID="OpsLiveDataSource"
                            OnCustomButtonInitialize="OpsLiveGrid_CustomButtonInitialize"
                            OnCustomButtonCallback="OpsLiveGrid_CustomButtonCallback"
                            OnFillContextMenuItems="OpsLiveGrid_FillContextMenuItems"
                            OnContextMenuItemClick="OpsLiveGrid_ContextMenuItemClick"
                            OnCustomJSProperties="OpsLiveGrid_CustomJSProperties"
                            OnClientLayout="OpsLiveGrid_ClientLayout"
                            OnCustomCallback="OpsLiveGrid_CustomCallback"
                            OnAfterPerformCallback="OpsLiveGrid_AfterPerformCallback"
                            EnableTheming="True" KeyFieldName="AhwalMappingID" Width="99%" Theme="DevEx" Font-Size="Small" OnHtmlRowPrepared="OpsLiveGrid_HtmlRowPrepared">
                            <Settings ShowFilterRow="True" ShowTitlePanel="true" />
                            <SettingsLoadingPanel Mode="Disabled" />
                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                            <Templates>
                                <TitlePanel>
                                    <dx:ASPxButton ID="OpenAllGroupsButton" ClientInstanceName="OpenAllGroupsButton" runat="server" Image-AlternateText="فتح المجموعات" OnClick="OpenAllGroupsButton_Click" Image-Url="~/Content/ExpandGroups.png"></dx:ASPxButton>
                                    <dx:ASPxButton ID="CloseAllGroupsButton" ClientInstanceName="CloseAllGroupsButton" runat="server" Image-AlternateText="اغلاق المجموعات" OnClick="CloseAllGroupsButton_Click" Image-Url="~/Content/CollapseGroups.png"></dx:ASPxButton>
                                    <dx:ASPxButton ID="SaveGroupsButton" ClientInstanceName="SaveGroupsButton" runat="server" Image-AlternateText="حفظ المجموعات" OnClick="SaveGroupsButton_Click" Image-Url="~/Content/SaveGroups.png"></dx:ASPxButton>
                                </TitlePanel>
                            </Templates>
                            <Columns>
                                <dx:GridViewCommandColumn ShowNewButton="false" ShowEditButton="false" VisibleIndex="0" ButtonRenderMode="Image">
                                    <CustomButtons>
                                        <dx:GridViewCommandColumnCustomButton ID="Away">
                                            <Image ToolTip="بعيد عن الجهاز" Url="~/Content/Away.png" />
                                        </dx:GridViewCommandColumnCustomButton>
                                        <dx:GridViewCommandColumnCustomButton ID="Land">
                                            <Image ToolTip="بر" Url="~/Content/Land.png" />
                                        </dx:GridViewCommandColumnCustomButton>
                                        <dx:GridViewCommandColumnCustomButton ID="BackFromAway">
                                            <Image ToolTip="معاك على الخط" Url="~/Content/Back.png" />
                                        </dx:GridViewCommandColumnCustomButton>
                                        <dx:GridViewCommandColumnCustomButton ID="BackFromLand">
                                            <Image ToolTip="بحر" Url="~/Content/Back.png" />
                                        </dx:GridViewCommandColumnCustomButton>
                                        <dx:GridViewCommandColumnCustomButton ID="WalkingPatrol">
                                            <Image ToolTip="مترجله" Url="~/Content/WalkingPatrol.png" />
                                        </dx:GridViewCommandColumnCustomButton>
                                        <dx:GridViewCommandColumnCustomButton ID="BackFromWalking">
                                            <Image ToolTip="عودة من مترجله" Url="~/Content/Back.png" />
                                        </dx:GridViewCommandColumnCustomButton>
                                    </CustomButtons>
                                </dx:GridViewCommandColumn>
                                <dx:GridViewDataTextColumn FieldName="AhwalMappingID" Visible="false" ReadOnly="True" VisibleIndex="1">
                                    <EditFormSettings Visible="False" />
                                </dx:GridViewDataTextColumn>
                                 <dx:GridViewDataComboBoxColumn FieldName="AhwalID" VisibleIndex="2" Caption="الأحوال" GroupIndex="0">
                                    <PropertiesComboBox TextField="Name" ValueField="AhwalID" DataSourceID="AhwalDataSroucce"></PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="ShiftID" VisibleIndex="3" Caption="الشفت" GroupIndex="1">
                                    <PropertiesComboBox TextField="Name" ValueField="ShiftID" DataSourceID="OpsShiftDataSource"></PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="SectorID" VisibleIndex="4" Caption="القطاع" GroupIndex="2">
                                    <PropertiesComboBox TextField="ShortName" ValueField="SectorID" DataSourceID="OpsSectorDataSource"></PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataTextColumn FieldName="AhwalName"  Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="ShiftName" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="SectorName" Visible="false">
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="MilNumber" VisibleIndex="5" Caption="الرقم العسكري">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="RankName" VisibleIndex="6" Caption="الرتبه" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                                    <Settings AllowAutoFilter="False" />
                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PersonName" VisibleIndex="7" Caption="الاسم">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PatrolRoleID" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PatrolRoleName" VisibleIndex="8" Caption="المسؤولية" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                                    <Settings AllowAutoFilter="False" />
                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="CityGroupName" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="CityGroupID" VisibleIndex="9" Caption="المنطقة" GroupIndex="4" Settings-AllowFilterBySearchPanel="False">
                                    <PropertiesComboBox TextFormatString="{0}: {1}" ValueField="CityGroupID" DataSourceID="OpsCityGroupDataSource">
                                        <Columns>
                                            <dx:ListBoxColumn FieldName="ShortName" Name="ShortName">
                                            </dx:ListBoxColumn>
                                            <dx:ListBoxColumn FieldName="Text" Name="Text">
                                            </dx:ListBoxColumn>
                                        </Columns>
                                    </PropertiesComboBox>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataTextColumn FieldName="CallerID" Caption="النداء" VisibleIndex="10" Settings-AllowFilterBySearchPanel="False">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="HasDevices" Visible="False" VisibleIndex="11">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PlateNumber" VisibleIndex="12" Caption="الدورية">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="Serial" VisibleIndex="13" Caption="الجهاز">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PatrolPersonStateID" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PatrolPersonStateName" VisibleIndex="14" Caption="الحالة" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                                    <Settings AllowAutoFilter="False" />
                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataDateColumn FieldName="LastStateChangeTimeStamp" Caption="وقت الحالة" Visible="true" Settings-AllowFilterBySearchPanel="False" VisibleIndex="15" PropertiesDateEdit-DisplayFormatString="G">
                                    <Settings AllowAutoFilter="False" />
                                </dx:GridViewDataDateColumn>
                                <dx:GridViewDataTextColumn FieldName="SortingIndex" Visible="false" VisibleIndex="16" Settings-AllowFilterBySearchPanel="False">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="PersonMobile" Caption="الجوال" Visible="true" VisibleIndex="17">
                                </dx:GridViewDataTextColumn>

                            </Columns>
                            <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="false" AllowSort="false" AutoExpandAllGroups="true" />
                            <SettingsContextMenu Enabled="true"
                                RowMenuItemVisibility-Refresh="false"
                                RowMenuItemVisibility-CollapseRow="false"
                                RowMenuItemVisibility-ExpandDetailRow="false"
                                RowMenuItemVisibility-CollapseDetailRow="false"
                                RowMenuItemVisibility-GroupSummaryMenu-SummaryAverage="false"
                                RowMenuItemVisibility-GroupSummaryMenu-Visible="false"
                                RowMenuItemVisibility-ExpandRow="false" />
                            <ClientSideEvents ContextMenuItemClick="function(s,e) { OpsLiveGrid_OnContextMenuItemClick(s, e); }" RowDblClick="OpsLiveGrid_RowDBClick" EndCallback="OpsLive_OnEndCallback" />

                            <SettingsPager PageSize="300" />
                            <SettingsText HeaderFilterSelectAll="الكل" HeaderFilterCancelButton="الغاء" HeaderFilterOkButton="موافق" />
                            <SettingsBehavior AllowFixedGroups="true" />
                            <GroupSummary>
                                <dx:ASPxSummaryItem SummaryType="Count" DisplayFormat=" - المجموع: {0}" />
                            </GroupSummary>
                            <Styles>
                                <GroupRow Font-Bold="true"></GroupRow>
                            </Styles>
                        </dx:ASPxGridView>
                    </td>
                    <%--INCIDENTS--%>
                    <td style="width: 35%; vertical-align: top;">
                        <dx:ASPxGridView ID="IncidentsGrid" runat="server" ClientInstanceName="IncidentsGrid"
                            AutoGenerateColumns="False" DataSourceID="IncidentsDataSource"
                            OnHtmlRowPrepared="IncidentsGrid_HtmlRowPrepared"
                            OnContextMenuItemClick="IncidentsGrid_ContextMenuItemClick"
                            OnFillContextMenuItems="IncidentsGrid_FillContextMenuItems"
                            OnCustomCallback="IncidentsGrid_CustomCallback"
                            EnableTheming="True" KeyFieldName="IncidentID" Width="100%" Theme="DevEx" Font-Size="Small">
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
                                <dx:GridViewDataTextColumn FieldName="IncidentID" Caption=" " ReadOnly="True" VisibleIndex="0" Visible="true">
                                    <EditFormSettings Visible="False" />
                                    <Settings AllowAutoFilter="False" />
                                </dx:GridViewDataTextColumn>
                                <%--                                <dx:GridViewDataComboBoxColumn FieldName="IncidentStateID" VisibleIndex="1" Caption="الحالة" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                                    <PropertiesComboBox TextField="Name" ValueField="IncidentStateID" DataSourceID="IncidentStateDataSource"></PropertiesComboBox>
                                    <Settings AllowAutoFilter="False" />
                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                </dx:GridViewDataComboBoxColumn>--%>
                                <dx:GridViewDataTextColumn FieldName="IncidentStateID" Caption="البلاغ" VisibleIndex="1" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataComboBoxColumn FieldName="IncidentSourceID" VisibleIndex="2" Caption="جهة البلاغ" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                                    <PropertiesComboBox TextField="Name" ValueField="IncidentSourceID" DataSourceID="IncidentSourceDataSource"></PropertiesComboBox>
                                    <Settings AllowAutoFilter="False" />
                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                </dx:GridViewDataComboBoxColumn>
                                <dx:GridViewDataTextColumn FieldName="IncidentsTypeName" Caption="البلاغ" VisibleIndex="3">
                                </dx:GridViewDataTextColumn>

                                <dx:GridViewDataTextColumn FieldName="Place" Caption="المكان" VisibleIndex="4">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="UserName" Caption="مسجل البلاغ" VisibleIndex="5" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataDateColumn FieldName="TimeStamp" Caption="وقت البلاغ" VisibleIndex="6" Settings-AllowHeaderFilter="True" PropertiesDateEdit-DisplayFormatString="G">
                                    <Settings AllowAutoFilter="False" />
                                    <SettingsHeaderFilter Mode="DateRangePicker" DateRangeCalendarSettings-FirstDayOfWeek="Sunday"></SettingsHeaderFilter>
                                </dx:GridViewDataDateColumn>
                                <dx:GridViewDataDateColumn FieldName="LastUpdate" Caption="آخر تحديث" VisibleIndex="7" Settings-AllowHeaderFilter="True" PropertiesDateEdit-DisplayFormatString="G">
                                    <Settings AllowAutoFilter="False" />
                                    <SettingsHeaderFilter Mode="DateRangePicker" DateRangeCalendarSettings-FirstDayOfWeek="Sunday"></SettingsHeaderFilter>
                                </dx:GridViewDataDateColumn>
                                <dx:GridViewDataColumn FieldName="IncidentID" Caption=" " VisibleIndex="8">
                                    <Settings AllowAutoFilter="False" />
                                    <DataItemTemplate>
                                        <img id="img" runat="server" alt='Eval("Value")' src='<%# IncidentGrid_GetImageName(Eval("IncidentID")) %>' />
                                    </DataItemTemplate>
                                </dx:GridViewDataColumn>
                                <dx:GridViewDataTextColumn FieldName="ExtraInfo1" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="ExtraInfo2" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="ExtraInfo3" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="IncidentSourceName" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="IncidentSourceExtraInfo1" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="IncidentSourceExtraInfo2" Visible="false">
                                </dx:GridViewDataTextColumn>
                                <dx:GridViewDataTextColumn FieldName="IncidentSourceExtraInfo3" Visible="false">
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

                            <SettingsPager PageSize="50" />
                            <SettingsText HeaderFilterSelectAll="الكل" HeaderFilterCancelButton="الغاء" HeaderFilterOkButton="موافق" />
                            <SettingsBehavior AllowFixedGroups="true" />
                            <GroupSummary>
                                <dx:ASPxSummaryItem SummaryType="Count" DisplayFormat=" - المجموع: {0}" />
                            </GroupSummary>
                            <Styles>
                                <GroupRow Font-Bold="true"></GroupRow>
                            </Styles>
                        </dx:ASPxGridView>
                    </td>
                </tr>
            </table>
            <%--Attach Incident to Person PopUp--%>

            <dx:ASPxPopupControl ID="OpsLive_IncidentAttach_PopUp" ClientInstanceName="OpsLive_IncidentAttach_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <asp:Panel ID="OpsLive_IncidentAttach_Panel" runat="server">
                        </asp:Panel>
                        <input type="hidden" id="AttachIncidentMappingID" name="AttachIncidentMappingID" />
                        <table>
                            <tr>
                                <td>البلاغ
                                </td>
                                <td>
                                    <dx:ASPxGridLookup ID="AttachIncident_GridLookUp" ClientInstanceName="AttachIncident_GridLookUp" runat="server" DataSourceID="IncidentsDataSource" AutoGenerateColumns="False" KeyFieldName="IncidentID" TextFormatString="{0} - {3}">

                                        <GridViewProperties>
                                            <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                        </GridViewProperties>
                                        <Columns>
                                            <dx:GridViewDataTextColumn FieldName="IncidentID" ReadOnly="True" Caption="رقم البلاغ" ShowInCustomizationForm="false" Visible="True" VisibleIndex="0">
                                                <EditFormSettings Visible="False" />
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="كاتب البلاغ" FieldName="UserName" ShowInCustomizationForm="false" Visible="True" VisibleIndex="1">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn FieldName="IncidentSourceID" VisibleIndex="2" Caption="جهة البلاغ">
                                                <PropertiesComboBox TextField="Name" ValueField="IncidentSourceID" DataSourceID="IncidentSourceDataSource"></PropertiesComboBox>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn Caption="البلاغ" FieldName="IncidentsTypeName" ShowInCustomizationForm="True" VisibleIndex="3">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="المكان" FieldName="Place" ShowInCustomizationForm="True" VisibleIndex="4">
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="تاريخ البلاغ" FieldName="TimeStamp" ShowInCustomizationForm="True" VisibleIndex="5">
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <GridViewProperties>
                                            <SettingsPager PageSize="10"></SettingsPager>
                                        </GridViewProperties>
                                    </dx:ASPxGridLookup>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxButton ID="AttahcIncidentSubmitButton" ClientInstanceName="AttahcIncidentSubmitButton" runat="server" Text="تسليم" OnClick="AttahcIncidentSubmitButton_Click" />
                                </td>
                            </tr>
                        </table>
                    </dx:PopupControlContentControl>
                </ContentCollection>
            </dx:ASPxPopupControl>
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

            <%--Latest States PopUp--%>
            <dx:ASPxPopupControl ID="OpsLive_States_PopUp" ClientInstanceName="OpsLive_States_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <asp:Panel ID="OpsLive_States_Panel" runat="server">
                            <table style="width: 100%">
                                <tr>
                                    <td style="text-align: right; width: 80%">
                                        <dx:ASPxLabel ID="AttachedIncident_Label" ClientInstanceName="AttachedIncident_Label" runat="server" Visible="true" />
                                    </td>
                                    <td style="text-align: left; width: 20%">
                                        <dx:ASPxButton ID="AttachedIncident_Release_Button" ClientInstanceName="AttachedIncident_Release_Button" runat="server" Visible="true" OnClick="AttachedIncident_Release_Button_Click" Text="الغاء تسليم البلاغ" />
                                    </td>
                                </tr>
                                <td>
                                    <td colspan="2">
                                        <br />
                                    </td>
                                </td>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxGridView ID="OpsLive_States_Grid" ClientInstanceName="OpsLive_States_Grid" runat="server" Width="100%" AutoGenerateColumns="False"
                                            OnHtmlRowPrepared="OpsLive_States_Grid_HtmlRowPrepared"
                                            DataSourceID="OpsLive_State_DataSource" KeyFieldName="PatrolPersonStateLogID">
                                            <Settings ShowFilterRow="True" />
                                            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                            <Columns>
                                                <dx:GridViewDataComboBoxColumn FieldName="PatrolPersonStateID" VisibleIndex="1" Caption="الحالة" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                                                    <PropertiesComboBox TextField="Name" ValueField="PatrolPersonStateID" DataSourceID="OpsPersonStateDataSource"></PropertiesComboBox>
                                                    <Settings AllowAutoFilter="False" />

                                                    <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                                </dx:GridViewDataComboBoxColumn>
                                                <dx:GridViewDataDateColumn FieldName="TimeStamp" Caption="الوقت" ShowInCustomizationForm="True" VisibleIndex="6" Settings-AllowHeaderFilter="True">
                                                    <Settings AllowAutoFilter="False" />
                                                    <PropertiesDateEdit DisplayFormatString="G"></PropertiesDateEdit>
                                                    <SettingsHeaderFilter Mode="DateRangePicker"></SettingsHeaderFilter>
                                                </dx:GridViewDataDateColumn>
                                            </Columns>
                                            <SettingsPager PageSize="15" />
                                            <ClientSideEvents EndCallback="OpsLive_OnEndCallback" />
                                            <SettingsText HeaderFilterSelectAll="الكل" HeaderFilterCancelButton="الغاء" HeaderFilterOkButton="موافق" />
                                        </dx:ASPxGridView>
                                    </td>
                                </tr>
                            </table>

                            <input type="hidden" id="StatesPersonID" name="StatesPersonID" />
                        </asp:Panel>

                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents Closing="closing_StatesPopUp" />
            </dx:ASPxPopupControl>
            <%--Live Caller PopUp--%>
            <dx:ASPxPopupControl ID="LiveCaller_PopUp" AllowDragging="true" AutoUpdatePosition="true" ClientInstanceName="LiveCaller_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="TopSides" PopupHorizontalAlign="LeftSides" CloseAnimationType="Slide" PopupAnimationType="Slide" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server" Width="100%">
                        <asp:Panel ID="LiveCaller_Panel" runat="server" Width="100%">
                            <input type="hidden" id="LiveCaller_AwahlMappingID" name="LiveCaller_AwahlMappingID" />
                            <table style="width: 100%; font-size: medium">

                                <tr>
                                    <td>النداء</td>
                                    <td>
                                        <dx:ASPxLabel ID="LiveCaller_CallerID_Label" ClientInstanceName="LiveCaller_CallerID_Label" runat="server" Theme="DevEx" Text="" Font-Size="Medium" />
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <br />
                                    </td>
                                </tr>
                                 <tr>
                                    <td colspan="2">
                                        <dx:ASPxLabel ID="LiveCaller_AhwalShiftSectorCity_Label" ClientInstanceName="LiveCaller_AhwalShiftSectorCity_Label" runat="server" Theme="DevEx" Text="" Font-Size="Medium" />
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <dx:ASPxLabel ID="LiveCaller_MilNumberRankName_Label" ClientInstanceName="LiveCaller_MilNumberRankName_Label" runat="server" Theme="DevEx" Text="" Font-Size="Medium" />
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <br />
                                    </td>
                                </tr>

                                <tr>
                                    <td>الجهاز</td>
                                    <td>
                                        <dx:ASPxLabel ID="LiveCaller_HandHeld_Label" ClientInstanceName="LiveCaller_HandHeld_Label" runat="server" Theme="DevEx" Text="" Font-Size="Medium" />
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>الدوريه</td>
                                    <td>
                                        <dx:ASPxLabel ID="LiveCaller_Patrol_Label" ClientInstanceName="LiveCaller_Patrol_Label" runat="server" Theme="DevEx" Text="" Font-Size="Medium" />
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>الجوال</td>
                                    <td>
                                        <dx:ASPxLabel ID="LiveCaller_Mobile_Label" ClientInstanceName="LiveCaller_Mobile_Label" runat="server" Theme="DevEx" Text="" Font-Size="Medium" />
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2">
                                        <br />
                                        <br />
                                    </td>
                                </tr>

                                <tr>
                                    <td colspan="2" style="align-content: center">
                                        <dx:ASPxButton ID="LiveCaller_Away_Button" ClientInstanceName="LiveCaller_Away_Button" runat="server" Image-AlternateText="بعيد عن الجهاز" OnClick="LiveCaller_Away_Button_Click" Image-Url="~/Content/Away.png"></dx:ASPxButton>
                                        <dx:ASPxButton ID="LiveCaller_Land_Button" ClientInstanceName="LiveCaller_Land_Button" runat="server" Image-AlternateText="بر" OnClick="LiveCaller_Land_Button_Click" Image-Url="~/Content/Land.png"></dx:ASPxButton>
                                        <dx:ASPxButton ID="LiveCaller_BackFromAway_Button" ClientInstanceName="LiveCaller_BackFromAway_Button" runat="server" Image-AlternateText="معاك على الخط" OnClick="LiveCaller_BackFromAway_Button_Click" Image-Url="~/Content/Back.png"></dx:ASPxButton>
                                        <dx:ASPxButton ID="LiveCaller_BackFromLand_Button" ClientInstanceName="LiveCaller_BackFromLand_Button" runat="server" Image-AlternateText="بحر" OnClick="LiveCaller_BackFromLand_Button_Click" Image-Url="~/Content/Back.png"></dx:ASPxButton>
                                        <dx:ASPxButton ID="LiveCaller_Walking_Button" ClientInstanceName="LiveCaller_Walking_Button" runat="server" Image-AlternateText="مترجله" OnClick="LiveCaller_Walking_Button_Click" Image-Url="~/Content/WalkingPatrol.png"></dx:ASPxButton>
                                        <dx:ASPxButton ID="LiveCaller_BackFromWalking_Button" ClientInstanceName="LiveCaller_BackFromWalking_Button" runat="server" Image-AlternateText="عوده من مترجله" OnClick="LiveCaller_BackFromWalking_Button_Click" Image-Url="~/Content/Back.png"></dx:ASPxButton>

                                    </td>
                                </tr>
                            </table>

                        </asp:Panel>

                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents Closing="closing_LiveCallerPopUp" />
            </dx:ASPxPopupControl>
            <asp:SqlDataSource ID="OpsLiveDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT        AhwalMapping.AhwalMappingID, AhwalMapping.AhwalID, AhwalMapping.ShiftID, AhwalMapping.SectorID, AhwalMapping.PatrolRoleID, AhwalMapping.CityGroupID, AhwalMapping.PersonID, AhwalMapping.CallerID, 
                         AhwalMapping.HasDevices, AhwalMapping.IncidentID, AhwalMapping.PatrolPersonStateID, AhwalMapping.LastStateChangeTimeStamp, Ranks.Name AS RankName, Ahwal.Name AS AhwalName, 
                         Sectors.ShortName AS SectorName, Shifts.Name AS ShiftName, Persons.MilNumber, Persons.Name AS PersonName, Persons.Mobile AS PersonMobile, HandHelds.Serial, PatrolCars.PlateNumber, 
                         PatrolRoles.Name AS PatrolRoleName, CityGroups.ShortName AS CityGroupName, PatrolPersonStates.Name as PatrolPersonStateName
                         FROM AhwalMapping LEFT JOIN
                         Persons ON AhwalMapping.PersonID = Persons.PersonID LEFT JOIN
                         Ahwal ON Persons.AhwalID = Ahwal.AhwalID LEFT JOIN
                         Ranks ON Persons.RankID = Ranks.RankID LEFT JOIN
                         Sectors ON AhwalMapping.SectorID = Sectors.SectorID AND Ahwal.AhwalID = Sectors.AhwalID LEFT JOIN
                         Shifts ON AhwalMapping.ShiftID = Shifts.ShiftID LEFT JOIN
                         HandHelds ON AhwalMapping.HandHeldID = HandHelds.HandHeldID AND Ahwal.AhwalID = HandHelds.AhwalID LEFT JOIN
                         PatrolCars ON AhwalMapping.PatrolID = PatrolCars.PatrolID AND Ahwal.AhwalID = PatrolCars.AhwalID LEFT JOIN
                         PatrolRoles ON AhwalMapping.PatrolRoleID = PatrolRoles.PatrolRoleID LEFT JOIN
                         CityGroups ON AhwalMapping.CityGroupID = CityGroups.CityGroupID AND Ahwal.AhwalID = CityGroups.AhwalID AND Sectors.SectorID = CityGroups.SectorID LEFT JOIN
                         PatrolPersonStates ON AhwalMapping.PatrolPersonStateID = PatrolPersonStates.PatrolPersonStateID                     
                         WHERE (AhwalMapping.AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID))) Order by SortingIndex asc">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
                        <asp:SqlDataSource ID="OpsShiftDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [ShiftID], [Name], [StartingHour], [NumberOfHours] FROM [Shifts]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="OpsSectorDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [SectorID], [ShortName], [CallerPrefix], [Disabled] FROM [Sectors] where Disabled<>1  and (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="OpsCityGroupDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [CityGroupID],[SectorID],[ShortName],[CallerPrefix],[Text],[Disabled] FROM [Patrols].[dbo].[CityGroups] where Disabled<>1 and (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
             <asp:SqlDataSource ID="AhwalDataSroucce" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT AhwalID, Name FROM Ahwal WHERE (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="OpsPersonStateDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [PatrolPersonStateID], [Name] FROM [PatrolPersonStates]"></asp:SqlDataSource>

            <asp:SqlDataSource ID="OpsLive_State_DataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT top (100) [PatrolPersonStateLogID],[UserID],(select [AhwalID] from AhwalMapping where PersonID=[PatrolPersonStateLog].PersonID) as AhwalID,[PersonID],[PatrolPersonStateID],[TimeStamp] FROM [Patrols].[dbo].[PatrolPersonStateLog] WHERE PersonID=@PersonID order by [TimeStamp] desc">
                <SelectParameters>
                    <asp:SessionParameter DefaultValue="" Name="PersonID" SessionField="OpsLiveStatePersonID" />
                </SelectParameters>
            </asp:SqlDataSource>



            <%--INCIDENTS--%>
            <asp:SqlDataSource ID="IncidentsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT    Top(50)     Incidents.IncidentID, Incidents.IncidentStateID,Users.Name as UserName, Incidents.Place, Incidents.IncidentSourceExtraInfo1 as ExtraInfo1, Incidents.IncidentSourceExtraInfo2 as ExtraInfo2, Incidents.IncidentSourceExtraInfo3  as ExtraInfo3, Incidents.TimeStamp, Incidents.LastUpdate, Incidents.IncidentSourceID, IncidentsTypes.Name AS IncidentsTypeName, IncidentSources.Name AS IncidentSourceName, IncidentSources.ExtraInfo1 as IncidentSourceExtraInfo1, IncidentSources.ExtraInfo2 as IncidentSourceExtraInfo2, IncidentSources.ExtraInfo3 as IncidentSourceExtraInfo3 FROM   Incidents INNER JOIN IncidentSources ON Incidents.IncidentSourceID = IncidentSources.IncidentSourceID INNER JOIN IncidentStates ON Incidents.IncidentStateID = IncidentStates.IncidentStateID INNER JOIN IncidentsTypes ON Incidents.IncidentTypeID = IncidentsTypes.IncidentTypeID  INNER JOIN Users ON Incidents.UserID = Users.UserID where Incidents.IncidentStateID!=30 Order by TimeStamp desc"></asp:SqlDataSource>
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
