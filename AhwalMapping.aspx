<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="AhwalMapping.aspx.cs" Inherits="PatrolWebApp.AhwalMapping1" %>

<asp:Content ID="AhwalMappingContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="Content/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="Content/robust-websocket.js"></script>

    <script type="text/javascript">
        var LiveUpDaterTimer = null
        setInterval(function () {
            var AhwalMappingGrid = ASPxClientGridView.Cast("AhwalMappingGrid");
            AhwalMappingGrid.Refresh();
        }, 20000);
        var StopUpdateTimer;
        var keyboardMap = [
            "", // [0]
            "", // [1]
            "", // [2]
            "CANCEL", // [3]
            "", // [4]
            "", // [5]
            "HELP", // [6]
            "", // [7]
            "BACK_SPACE", // [8]
            "TAB", // [9]
            "", // [10]
            "", // [11]
            "CLEAR", // [12]
            "ENTER", // [13]
            "ENTER_SPECIAL", // [14]
            "", // [15]
            "SHIFT", // [16]
            "CONTROL", // [17]
            "ALT", // [18]
            "PAUSE", // [19]
            "CAPS_LOCK", // [20]
            "KANA", // [21]
            "EISU", // [22]
            "JUNJA", // [23]
            "FINAL", // [24]
            "HANJA", // [25]
            "", // [26]
            "ESCAPE", // [27]
            "CONVERT", // [28]
            "NONCONVERT", // [29]
            "ACCEPT", // [30]
            "MODECHANGE", // [31]
            "SPACE", // [32]
            "PAGE_UP", // [33]
            "PAGE_DOWN", // [34]
            "END", // [35]
            "HOME", // [36]
            "LEFT", // [37]
            "UP", // [38]
            "RIGHT", // [39]
            "DOWN", // [40]
            "SELECT", // [41]
            "PRINT", // [42]
            "EXECUTE", // [43]
            "PRINTSCREEN", // [44]
            "INSERT", // [45]
            "DELETE", // [46]
            "", // [47]
            "0", // [48]
            "1", // [49]
            "2", // [50]
            "3", // [51]
            "4", // [52]
            "5", // [53]
            "6", // [54]
            "7", // [55]
            "8", // [56]
            "9", // [57]
            "COLON", // [58]
            "SEMICOLON", // [59]
            "LESS_THAN", // [60]
            "EQUALS", // [61]
            "GREATER_THAN", // [62]
            "QUESTION_MARK", // [63]
            "AT", // [64]
            "A", // [65]
            "B", // [66]
            "C", // [67]
            "D", // [68]
            "E", // [69]
            "F", // [70]
            "G", // [71]
            "H", // [72]
            "I", // [73]
            "J", // [74]
            "K", // [75]
            "L", // [76]
            "M", // [77]
            "N", // [78]
            "O", // [79]
            "P", // [80]
            "Q", // [81]
            "R", // [82]
            "S", // [83]
            "T", // [84]
            "U", // [85]
            "V", // [86]
            "W", // [87]
            "X", // [88]
            "Y", // [89]
            "Z", // [90]
            "OS_KEY", // [91] Windows Key (Windows) or Command Key (Mac)
            "", // [92]
            "CONTEXT_MENU", // [93]
            "", // [94]
            "SLEEP", // [95]
            "NUMPAD0", // [96]
            "NUMPAD1", // [97]
            "NUMPAD2", // [98]
            "NUMPAD3", // [99]
            "NUMPAD4", // [100]
            "NUMPAD5", // [101]
            "NUMPAD6", // [102]
            "NUMPAD7", // [103]
            "NUMPAD8", // [104]
            "NUMPAD9", // [105]
            "MULTIPLY", // [106]
            "ADD", // [107]
            "SEPARATOR", // [108]
            "SUBTRACT", // [109]
            "DECIMAL", // [110]
            "DIVIDE", // [111]
            "F1", // [112]
            "F2", // [113]
            "F3", // [114]
            "F4", // [115]
            "F5", // [116]
            "F6", // [117]
            "F7", // [118]
            "F8", // [119]
            "F9", // [120]
            "F10", // [121]
            "F11", // [122]
            "F12", // [123]
            "F13", // [124]
            "F14", // [125]
            "F15", // [126]
            "F16", // [127]
            "F17", // [128]
            "F18", // [129]
            "F19", // [130]
            "F20", // [131]
            "F21", // [132]
            "F22", // [133]
            "F23", // [134]
            "F24", // [135]
            "", // [136]
            "", // [137]
            "", // [138]
            "", // [139]
            "", // [140]
            "", // [141]
            "", // [142]
            "", // [143]
            "NUM_LOCK", // [144]
            "SCROLL_LOCK", // [145]
            "WIN_OEM_FJ_JISHO", // [146]
            "WIN_OEM_FJ_MASSHOU", // [147]
            "WIN_OEM_FJ_TOUROKU", // [148]
            "WIN_OEM_FJ_LOYA", // [149]
            "WIN_OEM_FJ_ROYA", // [150]
            "", // [151]
            "", // [152]
            "", // [153]
            "", // [154]
            "", // [155]
            "", // [156]
            "", // [157]
            "", // [158]
            "", // [159]
            "CIRCUMFLEX", // [160]
            "EXCLAMATION", // [161]
            "DOUBLE_QUOTE", // [162]
            "HASH", // [163]
            "DOLLAR", // [164]
            "PERCENT", // [165]
            "AMPERSAND", // [166]
            "UNDERSCORE", // [167]
            "OPEN_PAREN", // [168]
            "CLOSE_PAREN", // [169]
            "ASTERISK", // [170]
            "PLUS", // [171]
            "PIPE", // [172]
            "HYPHEN_MINUS", // [173]
            "OPEN_CURLY_BRACKET", // [174]
            "CLOSE_CURLY_BRACKET", // [175]
            "TILDE", // [176]
            "", // [177]
            "", // [178]
            "", // [179]
            "", // [180]
            "VOLUME_MUTE", // [181]
            "VOLUME_DOWN", // [182]
            "VOLUME_UP", // [183]
            "", // [184]
            "", // [185]
            "SEMICOLON", // [186]
            "EQUALS", // [187]
            "COMMA", // [188]
            "MINUS", // [189]
            "PERIOD", // [190]
            "SLASH", // [191]
            "BACK_QUOTE", // [192]
            "", // [193]
            "", // [194]
            "", // [195]
            "", // [196]
            "", // [197]
            "", // [198]
            "", // [199]
            "", // [200]
            "", // [201]
            "", // [202]
            "", // [203]
            "", // [204]
            "", // [205]
            "", // [206]
            "", // [207]
            "", // [208]
            "", // [209]
            "", // [210]
            "", // [211]
            "", // [212]
            "", // [213]
            "", // [214]
            "", // [215]
            "", // [216]
            "", // [217]
            "", // [218]
            "OPEN_BRACKET", // [219]
            "BACK_SLASH", // [220]
            "CLOSE_BRACKET", // [221]
            "QUOTE", // [222]
            "", // [223]
            "META", // [224]
            "ALTGR", // [225]
            "", // [226]
            "WIN_ICO_HELP", // [227]
            "WIN_ICO_00", // [228]
            "", // [229]
            "WIN_ICO_CLEAR", // [230]
            "", // [231]
            "", // [232]
            "WIN_OEM_RESET", // [233]
            "WIN_OEM_JUMP", // [234]
            "WIN_OEM_PA1", // [235]
            "WIN_OEM_PA2", // [236]
            "WIN_OEM_PA3", // [237]
            "WIN_OEM_WSCTRL", // [238]
            "WIN_OEM_CUSEL", // [239]
            "WIN_OEM_ATTN", // [240]
            "WIN_OEM_FINISH", // [241]
            "WIN_OEM_COPY", // [242]
            "WIN_OEM_AUTO", // [243]
            "WIN_OEM_ENLW", // [244]
            "WIN_OEM_BACKTAB", // [245]
            "ATTN", // [246]
            "CRSEL", // [247]
            "EXSEL", // [248]
            "EREOF", // [249]
            "PLAY", // [250]
            "ZOOM", // [251]
            "", // [252]
            "PA1", // [253]
            "WIN_OEM_CLEAR", // [254]
            "" // [255]
        ];
        var FirstKeyTimeStamp = 0;
        var SecondKeyTimeStamp = 0;
        var ThirdKeyTimeStamp = 0;
        var keyStrokes = new Array();
        var LastChar = null;
        $(document).keydown(function (e) {
            var d = new Date();
            //var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //if (StopUpdateTimer != null)
            //    clearTimeout(StopUpdateTimer);//clear old timer
            //ASPxTimer1.SetEnabled(false); //we will stop live update with any key press for 7 seconds
            //StopUpdateTimer = setTimeout(function () {
            //    ASPxTimer1.SetEnabled(true);
            //}, 5000);
            var AhwalMapping_CheckInOut_PopUp = ASPxClientPopupControl.Cast("AhwalMapping_CheckInOut_PopUp"); //we are only intersted if the popup is open
            var AhwalMapping_CheckInOut_SubmitButton = ASPxClientButton.Cast("AhwalMapping_CheckInOut_SubmitButton");

            if (AhwalMapping_CheckInOut_PopUp.IsVisible()) {
                var timeBetweenNowAndFirst = d.getTime() - FirstKeyTimeStamp;
                if (e.keyCode == 72 || e.keyCode == 80) { //H=72,A=65,N=78 ... P=80;A=65,T=84
                    FirstKeyTimeStamp = d.getTime();
                    SecondKeyTimeStamp = 0;
                    ThirdKeyTimeStamp = 0;
                    keyStrokes = new Array();
                    LastChar = null;
                    // $("body").append("<p>ctrl+z detected!</p>");
                }
                else if (e.keyCode == 65 && (d.getTime() - FirstKeyTimeStamp < 300)) {
                    SecondKeyTimeStamp = d.getTime();
                    ThirdKeyTimeStamp = 0;
                }
                else if (e.keyCode == 78 && (d.getTime() - SecondKeyTimeStamp < 300) && SecondKeyTimeStamp > 0) { //start capture for handheld
                    ThirdKeyTimeStamp = d.getTime();
                    LastChar = e.keyCode;
                } else if (e.keyCode == 84 && (d.getTime() - SecondKeyTimeStamp < 300) && SecondKeyTimeStamp > 0) { //start capture for Patrol
                    ThirdKeyTimeStamp = d.getTime();
                    LastChar = e.keyCode;
                } else if (d.getTime() - ThirdKeyTimeStamp < 300 && ThirdKeyTimeStamp > 0) {
                    keyStrokes.push(keyboardMap[e.keyCode]);
                }

                if (keyStrokes[keyStrokes.length - 1] == "ENTER") {
                    var AhwalMapping_CheckInOut_MappingPerson = ASPxClientGridLookup.Cast("AhwalMapping_CheckInOut_MappingPerson");
                    var AhwalMapping_CheckInOut_PatrolCar = ASPxClientGridLookup.Cast("AhwalMapping_CheckInOut_PatrolCar");
                    var AhwalMapping_CheckInOut_HandHeld = ASPxClientGridLookup.Cast("AhwalMapping_CheckInOut_HandHeld");

                    if (LastChar == 78) {
                        // alert("Got HandHeld Code with Value" + keyStrokes.toString());
                        AhwalMapping_CheckInOut_SubmitButton.Focus();
                        var handHeldCode = keyStrokes.slice(0, -1).toString();
                        handHeldCode = handHeldCode.replace(/,/g, "");
                        //alert(handHeldCode);
                        //AhwalMapping_CheckInOut_HandHeld.Focus();
                        AhwalMapping_CheckInOut_HandHeld.SetText(handHeldCode);
                        AhwalMapping_CheckInOut_HandHeld.ConfirmCurrentSelection();
                        AhwalMapping_CheckInOut_HandHeld.HideDropDown();
                        
                        //AhwalMapping_CheckInOut_MappingPerson.Focus();

                    } else if (LastChar == 84) {
                        // alert("Got Patrol Code with Value" + keyStrokes.toString());
                        AhwalMapping_CheckInOut_SubmitButton.Focus();
                        var patrolCode = keyStrokes.slice(0, -1).toString();
                        patrolCode = patrolCode.replace(/,/g, "");
                        //alert(patrolCode);
                        //AhwalMapping_CheckInOut_PatrolCar.Focus();
                        AhwalMapping_CheckInOut_PatrolCar.SetText(patrolCode);
                        AhwalMapping_CheckInOut_PatrolCar.ConfirmCurrentSelection();
                        AhwalMapping_CheckInOut_PatrolCar.HideDropDown();
                        
                        //AhwalMapping_CheckInOut_MappingPerson.Focus();
                        

                    }
                    e.preventDefault();//cancel the event
                    //reset all
                    FirstKeyTimeStamp = d.getTime();
                    SecondKeyTimeStamp = 0;
                    ThirdKeyTimeStamp = 0;
                    keyStrokes = new Array();
                    LastChar = null;

                }
                if (d.getTime() - FirstKeyTimeStamp > 1500) {//too much time passed
                    FirstKeyTimeStamp = d.getTime();
                    SecondKeyTimeStamp = 0;
                    ThirdKeyTimeStamp = 0;
                    keyStrokes = new Array();
                    LastChar = null;
                }
            }

        });
    </script>
    <script type="text/javascript">

        function closing_PopUp(sender, arg) {
            //var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //ASPxTimer1.SetEnabled(true);
        }
        function show_Add_Mapping_PopUp() {
            //var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //ASPxTimer1.SetEnabled(false);
            //update_AwalPeron_AddMappng_Visiblity(null, null);
            AhwalMapping_Add_PopUp.Show();

        }
        function closing_StatesPopUp(sender, arg) {
            //var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //ASPxTimer1.SetEnabled(true);
        }
        function show_States_PopUp() {
            var AhwalMapping_States_PopUp = ASPxClientPopupControl.Cast("AhwalMapping_States_PopUp");
            //var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //ASPxTimer1.SetEnabled(false);
            //update_AwalPeron_AddMappng_Visiblity(null, null);
            AhwalMapping_States_PopUp.SetHeaderText("اخر الحالات");
            AhwalMapping_States_PopUp.Show();

        }
        function AhwalMappingGrid_OnContextMenu(s, e) {
            s.SetFocusedRowIndex(e.index);
            e.showBrowserMenu = false;
        }
        function AddNewMapptionBtnClick(sender, args) {
            document.getElementById('AhwalMappingAddMethod').value = 'NEW';
            document.getElementById('AhwalMappingID').value = '';
            var AhwalMapping_Add_Person_GridLookup = ASPxClientGridLookup.Cast("AhwalMapping_Add_Person_GridLookup");
            var AhwalMapping_Add_PatrolRole_ComboBox = ASPxClientComboBox.Cast("AhwalMapping_Add_PatrolRole_ComboBox");
            AhwalMapping_Add_Person_GridLookup.SetText("");
            args.processOnServer = false;
            show_Add_Mapping_PopUp();
        }
        var ShowPopUpOnEndCallBack = false;
        function AhwalMappingGrid_OnEndCallback(sender, args) {
            if (ShowPopUpOnEndCallBack) {
                var AhwalMapping_States_Grid = ASPxClientGridView.Cast("AhwalMapping_States_Grid");
                AhwalMapping_States_Grid.Refresh();
                show_States_PopUp();
                ShowPopUpOnEndCallBack = false;
            }

        }
        function AhwalMappingGrid_OnContextMenuItemClick(sender, args) {
            var AhwalMapping_Add_SubmitButton_Casted = ASPxClientButton.Cast("AhwalMapping_Add_SubmitButton");
            if (args.item.name == "آخر كمن حاله") {
                args.processOnServer = false;
                args.usePostBack = false;
                ShowPopUpOnEndCallBack = true;
                var AhwalMappingGrid = ASPxClientGridView.Cast("AhwalMappingGrid");
                AhwalMappingGrid.PerformCallback("LatestStates");
            }
            else if (args.item.name == "حذف") {
                if (confirm("متأكد تبي تمسح؟ أكيد؟") == true) {
                    args.processOnServer = true;
                    args.usePostBack = false;
                }
            } else if (args.item.name == "غياب") {
                if (confirm("متأكد تبي تغير الحالة لغياب؟ أكيد؟") == true) {
                    args.processOnServer = true;
                    args.usePostBack = false;
                }

            } else if (args.item.name == "اجازه") {
                if (confirm("متأكد تبي تغير الحالة لاجازه؟ أكيد؟") == true) {
                    args.processOnServer = true;
                    args.usePostBack = false;
                }
            } else if (args.item.name == "مرضيه") {
                if (confirm("متأكد تبي تغير الحالة مرضيه؟ أكيد؟") == true) {
                    args.processOnServer = true;
                    args.usePostBack = false;
                }
            }
        }

        function AhwalMapping_UpdatePopUpControl(values) {
            var AhwalMapping_CheckInOut_MappingPerson = ASPxClientGridLookup.Cast("AhwalMapping_CheckInOut_MappingPerson");
            var AhwalMapping_CheckInOut_PatrolCar = ASPxClientGridLookup.Cast("AhwalMapping_CheckInOut_PatrolCar");
            var AhwalMapping_CheckInOut_HandHeld = ASPxClientGridLookup.Cast("AhwalMapping_CheckInOut_HandHeld");
            var AhwalMappingGrid = ASPxClientGridView.Cast("AhwalMappingGrid");
            AhwalMapping_CheckInOut_MappingPerson.SetText(values[0] + " " + values[1]); //we are doing exactly as the format we specified, otherwise it will be blank
            //var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            //ASPxTimer1.SetEnabled(false);
            AhwalMapping_CheckInOut_PopUp.Show();
            AhwalMapping_CheckInOut_PatrolCar.Focus();
        }
        function AhwalMappingGrid_RowDBClick(sender, args) {
            var AhwalMappingGrid = ASPxClientGridView.Cast("AhwalMappingGrid");
            AhwalMappingGrid.GetRowValues(AhwalMappingGrid.GetFocusedRowIndex(), "MilNumber;PersonName", AhwalMapping_UpdatePopUpControl)


        }

    </script>

    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <dx:ASPxGridView ID="AhwalMappingGrid" runat="server" ClientInstanceName="AhwalMappingGrid"
                OnContextMenuItemClick="AhwalMappingGrid_ContextMenuItemClick"
                OnFillContextMenuItems="AhwalMappingGrid_FillContextMenuItems"
                AutoGenerateColumns="False" DataSourceID="AhwalMappingDataSource"
                OnAfterPerformCallback="AhwalMappingGrid_AfterPerformCallback"
                OnCustomCallback="AhwalMappingGrid_CustomCallback"
                OnClientLayout="AhwalMappingGrid_ClientLayout"
                EnableTheming="True" KeyFieldName="AhwalMappingID" Width="100%" Theme="DevEx" Font-Size="Small" OnHtmlRowPrepared="AhwalMappingGrid_HtmlRowPrepared">
                <Settings ShowFilterRow="True" />
                <SettingsLoadingPanel Mode="Disabled" />
                <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                <Templates>
                    <TitlePanel>
                        <dx:ASPxButton ID="NewPersonButton" ClientInstanceName="GenerateReportButton" runat="server" Image-AlternateText="اضافة توزيع جديد" ClientSideEvents-Click="AddNewMapptionBtnClick" AutoPostBack="false" Image-Url="~/Content/NewPerson.png"></dx:ASPxButton>
                        <dx:ASPxButton ID="GenerateReportButton" ClientInstanceName="GenerateReportButton" runat="server" Image-AlternateText="طباعة الكشف" OnClick="GenerateReportButton_Click" Image-Url="~/Content/ExportPDF.png"></dx:ASPxButton>
                        <dx:ASPxButton ID="OpenAllGroupsButton" ClientInstanceName="OpenAllGroupsButton" runat="server" Image-AlternateText="فتح المجموعات" OnClick="OpenAllGroups_Click" Image-Url="~/Content/ExpandGroups.png"></dx:ASPxButton>
                        <dx:ASPxButton ID="CloseAllGroupsButton" ClientInstanceName="CloseAllGroupsButton" runat="server" Image-AlternateText="اغلاق المجموعات" OnClick="CloseAllGroups_Click" Image-Url="~/Content/CollapseGroups.png"></dx:ASPxButton>
                        <dx:ASPxButton ID="SaveGroupsButton" ClientInstanceName="SaveGroupsButton" runat="server" Image-AlternateText="حفظ المجموعات" OnClick="SaveGroups_Click" Image-Url="~/Content/SaveGroups.png"></dx:ASPxButton>
                    </TitlePanel>
                </Templates>
                <Columns>

                    <dx:GridViewDataTextColumn FieldName="AhwalMappingID" Visible="false" ReadOnly="True" VisibleIndex="0">
                        <EditFormSettings Visible="False" />
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="AhwalID" VisibleIndex="1" Caption="الأحوال" GroupIndex="0">
                        <PropertiesComboBox TextField="Name" ValueField="AhwalID" DataSourceID="AhwalDataSroucce"></PropertiesComboBox>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="ShiftID" VisibleIndex="2" Caption="الشفت" GroupIndex="1">
                        <PropertiesComboBox TextField="Name" ValueField="ShiftID" DataSourceID="AhwalShiftDataSource"></PropertiesComboBox>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="SectorID" VisibleIndex="3" Caption="القطاع" GroupIndex="2">
                        <PropertiesComboBox TextField="ShortName" ValueField="SectorID" DataSourceID="AhwalSectorDataSource"></PropertiesComboBox>
                    </dx:GridViewDataComboBoxColumn>

                    <dx:GridViewDataTextColumn FieldName="MilNumber" VisibleIndex="4" Caption="الرقم العسكري">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="RankID" VisibleIndex="5" Caption="الرتبه" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                        <PropertiesComboBox TextField="Name" ValueField="RankID" DataSourceID="AhwalRanksDataSource"></PropertiesComboBox>
                        <Settings AllowAutoFilter="False" />
                        <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataTextColumn FieldName="PersonName" VisibleIndex="6" Caption="الاسم">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="PatrolRoleID" VisibleIndex="7" Caption="المسؤولية" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                        <PropertiesComboBox TextField="Name" ValueField="PatrolRoleID" DataSourceID="AhwalPatrolRoleDataSource"></PropertiesComboBox>
                        <Settings AllowAutoFilter="False" />
                        <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="CityGroupID" VisibleIndex="8" Caption="المنطقة" GroupIndex="4" Settings-AllowFilterBySearchPanel="False">
                        <PropertiesComboBox TextFormatString="{0}: {1}" ValueField="CityGroupID" DataSourceID="AhwalCityGroupDataSource">
                            <Columns>
                                <dx:ListBoxColumn FieldName="ShortName" Name="ShortName">
                                </dx:ListBoxColumn>
                                <dx:ListBoxColumn FieldName="Text" Name="Text">
                                </dx:ListBoxColumn>
                            </Columns>

                        </PropertiesComboBox>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataTextColumn FieldName="CallerID" Caption="النداء" VisibleIndex="9" Settings-AllowFilterBySearchPanel="False">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="HasDevices" Visible="False" VisibleIndex="10">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PlateNumber" VisibleIndex="11" Caption="الدورية">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="Serial" VisibleIndex="12" Caption="الجهاز">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataDateColumn FieldName="SunRiseTimeStamp" Caption="شروق" VisibleIndex="13" Settings-AllowFilterBySearchPanel="False" PropertiesDateEdit-DisplayFormatString="G">
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataDateColumn FieldName="SunSetTimeStamp" Caption="غروب" VisibleIndex="14" Settings-AllowFilterBySearchPanel="False" PropertiesDateEdit-DisplayFormatString="G">
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataComboBoxColumn FieldName="PatrolPersonStateID" VisibleIndex="15" Caption="الحالة" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                        <PropertiesComboBox TextField="Name" ValueField="PatrolPersonStateID" DataSourceID="AhwalPersonStateDataSource"></PropertiesComboBox>
                        <Settings AllowAutoFilter="False" />

                        <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                    </dx:GridViewDataComboBoxColumn>
                    <dx:GridViewDataDateColumn FieldName="LastStateChangeTimeStamp" Caption="وقت الحالة" Visible="true" Settings-AllowFilterBySearchPanel="False" VisibleIndex="16" PropertiesDateEdit-DisplayFormatString="G">
                        <Settings AllowAutoFilter="False" />
                    </dx:GridViewDataDateColumn>
                    <dx:GridViewDataTextColumn FieldName="SortingIndex" Visible="false" VisibleIndex="17" Settings-AllowFilterBySearchPanel="False">
                    </dx:GridViewDataTextColumn>
                    <dx:GridViewDataTextColumn FieldName="PersonMobile" Caption="الجوال" Visible="true" VisibleIndex="18">
                    </dx:GridViewDataTextColumn>

                </Columns>
                <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="true" AllowSort="false" AutoExpandAllGroups="true" />
                <SettingsContextMenu Enabled="true"
                    RowMenuItemVisibility-Refresh="false"
                    RowMenuItemVisibility-CollapseRow="false"
                    RowMenuItemVisibility-ExpandDetailRow="false"
                    RowMenuItemVisibility-CollapseDetailRow="false"
                    RowMenuItemVisibility-GroupSummaryMenu-SummaryAverage="false"
                    RowMenuItemVisibility-GroupSummaryMenu-Visible="false"
                    RowMenuItemVisibility-ExpandRow="false" />
                <SettingsPager PageSize="300" />
                <SettingsText HeaderFilterSelectAll="الكل" HeaderFilterCancelButton="الغاء" HeaderFilterOkButton="موافق" />
                <SettingsBehavior AllowFixedGroups="true" />
                <Settings ShowTitlePanel="true" />
                <ClientSideEvents ContextMenu="AhwalMappingGrid_OnContextMenu" RowDblClick="AhwalMappingGrid_RowDBClick" EndCallback="AhwalMappingGrid_OnEndCallback" ContextMenuItemClick="function(s,e) { AhwalMappingGrid_OnContextMenuItemClick(s, e); }" />
                <GroupSummary>
                    <dx:ASPxSummaryItem SummaryType="Count" DisplayFormat=" - المجموع: {0}" />
                </GroupSummary>
                <Styles>
                    <GroupRow Font-Bold="true"></GroupRow>
                </Styles>
            </dx:ASPxGridView>

            <%--AddNewMappingPopUp--%>
            <dx:ASPxPopupControl ID="AhwalMapping_Add_PopUp" AllowDragging="true" ClientInstanceName="AhwalMapping_Add_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <asp:Panel ID="AhwalMapping_Add_PopUpPanel" runat="server">
                            <table style="width: 100%">
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="الفرد"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxGridLookup ID="AhwalMapping_Add_Person_GridLookup" ClientInstanceName="AhwalMapping_Add_Person_GridLookup" runat="server" DataSourceID="AhwalPersonDataSource" AutoGenerateColumns="False" KeyFieldName="PersonID" TextFormatString="{3} {2}">

                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="PersonID" ReadOnly="True" ShowInCustomizationForm="false" Visible="False" VisibleIndex="0">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="الأحوال" FieldName="AhwalID" ShowInCustomizationForm="false" Visible="False" VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="الاسم" FieldName="Name" ShowInCustomizationForm="True" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn Caption="الرقم العسكري" FieldName="MilNumber" ShowInCustomizationForm="True" SortIndex="0" SortOrder="Ascending" VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>

                                        </dx:ASPxGridLookup>

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
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="المسؤولية"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="AhwalMapping_Add_PatrolRole_ComboBox" runat="server" DataSourceID="AhwalPatrolRoleDataSource" ValueField="PatrolRoleID" TextField="Name" Theme="DevEx" AutoPostBack="true" OnSelectedIndexChanged="AhwalMapping_Add_PatrolRole_ComboBox_SelectedIndexChanged" ClientInstanceName="AhwalMapping_Add_PatrolRole_ComboBox">
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
                                    <td>
                                        <dx:ASPxLabel ID="AhwalMapping_Add_Shift_Label" ClientInstanceName="AhwalMapping_Add_Shift_Label" runat="server" Text="الشفت" Visible="false"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="AhwalMapping_Add_Shift_CombobBox" runat="server" DataSourceID="AhwalShiftDataSource" ValueField="ShiftID" TextField="Name" Theme="DevEx" ClientInstanceName="AhwalMapping_Add_Shift_CombobBox" Visible="false"></dx:ASPxComboBox>
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
                                    <td>
                                        <dx:ASPxLabel ID="AhwalMapping_Add_Sector_Label" ClientInstanceName="AhwalMapping_Add_Sector_Label" runat="server" Text="القطاع" Visible="false"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="AhwalMapping_Add_Sector_CombobBox" runat="server" DataSourceID="AhwalSectorDataSourceWithOutPublic" ValueField="SectorID" TextField="ShortName" Theme="DevEx" ClientInstanceName="AhwalMapping_Add_Sector_CombobBox" AutoPostBack="true" OnSelectedIndexChanged="AhwalMapping_Add_Sector_CombobBox_SelectedIndexChanged" Visible="false"></dx:ASPxComboBox>
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
                                    <td>
                                        <dx:ASPxLabel ID="AhwalMapping_Add_CityGroup_Label" ClientInstanceName="AhwalMapping_Add_CityGroup_Label" runat="server" Text="المنطقة" Visible="false"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxComboBox ID="AhwalMapping_Add_CityGroup_CombobBox" runat="server" DataSourceID="AhwalCityGroupDataSourceWithOutNone" ValueField="CityGroupID" TextField="ShortName" Theme="DevEx" ClientInstanceName="AhwalMapping_Add_CityGroup_CombobBox" Visible="false"></dx:ASPxComboBox>
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
                                    <td>
                                        <dx:ASPxLabel ID="AhwalMapping_Add_AssociateTo_Label" ClientInstanceName="AhwalMapping_Add_AssociateTo_Label" runat="server" Text="مرافق ل" Visible="false"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxGridLookup ID="AhwalMapping_Add_AssociateTo_GridLookup" runat="server" ClientInstanceName="AhwalMapping_Add_AssociateTo_GridLookup" DataSourceID="AhwalMappingAssociateDataSource" AutoGenerateColumns="False" Visible="false" KeyFieldName="AhwalMappingID" TextFormatString="{2} {3}">
                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="AhwalMappingID" ReadOnly="True" ShowInCustomizationForm="false" VisibleIndex="0" Visible="false">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PersonID" ReadOnly="True" ShowInCustomizationForm="false" VisibleIndex="1" Visible="false">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="MilNumber" Caption="الرقم العسكري" ShowInCustomizationForm="True" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Name" Caption="الاسم" ShowInCustomizationForm="True" VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                        </dx:ASPxGridLookup>
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
                                    <td>
                                        <dx:ASPxLabel ID="AhwalMapping_Add_status_label" runat="server" Text="" Theme="DevEx"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="AhwalMapping_Add_SubmitButton" runat="server" Text="أضافه" Theme="DevEx" OnClick="AhwalMapping_Add_SubmitButton_Click" ClientInstanceName="AhwalMapping_Add_SubmitButton"></dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                            <input type="hidden" id="AhwalMappingID" name="AhwalMappingID" />
                            <input type="hidden" id="AhwalMappingAddMethod" name="AhwalMappingAddMethod" />
                        </asp:Panel>

                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents Closing="closing_PopUp" />
            </dx:ASPxPopupControl>
            <%--CheckInOutDevicesMappingPopUp--%>
            <dx:ASPxPopupControl ID="AhwalMapping_CheckInOut_PopUp" AllowDragging="true" ClientInstanceName="AhwalMapping_CheckInOut_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <asp:Panel ID="AhwalMapping_CheckInOut_Panel" runat="server">
                            <table style="width: 100%">
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="الفرد"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxGridLookup ID="AhwalMapping_CheckInOut_MappingPerson" runat="server" ClientInstanceName="AhwalMapping_CheckInOut_MappingPerson" DataSourceID="AhwalMappingAssociateDataSource" AutoGenerateColumns="False" Visible="true" KeyFieldName="AhwalMappingID" TextFormatString="{2} {3}">
                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="AhwalMappingID" ReadOnly="True" ShowInCustomizationForm="false" VisibleIndex="0" Visible="false">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PersonID" ReadOnly="True" ShowInCustomizationForm="false" VisibleIndex="1" Visible="false">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="MilNumber" Caption="الرقم العسكري" ShowInCustomizationForm="True" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Name" Caption="الاسم" ShowInCustomizationForm="True" VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                        </dx:ASPxGridLookup>

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
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="الدورية"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxGridLookup ID="AhwalMapping_CheckInOut_PatrolCar" runat="server" ClientInstanceName="AhwalMapping_CheckInOut_PatrolCar" DataSourceID="AhwalPatrolCarDataSource" Visible="true" AutoGenerateColumns="False" KeyFieldName="PatrolID" TextFormatString="{1}">
                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="PatrolID" ReadOnly="True" ShowInCustomizationForm="false" Visible="false" VisibleIndex="0">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PlateNumber" Caption="رقم اللوحة" ShowInCustomizationForm="false" VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Model" Caption="الموديل" ShowInCustomizationForm="false" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Type" Caption="النوع" ShowInCustomizationForm="false" VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="BarCode" Caption="باركود" ShowInCustomizationForm="false" VisibleIndex="4">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Defective" Visible="false" ShowInCustomizationForm="false" VisibleIndex="5">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Rental" Caption="ايجار؟" ShowInCustomizationForm="false" VisibleIndex="6">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                        </dx:ASPxGridLookup>

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
                                    <td>
                                        <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="الجهاز" Visible="true"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxGridLookup ID="AhwalMapping_CheckInOut_HandHeld" runat="server" ClientInstanceName="AhwalMapping_CheckInOut_HandHeld" DataSourceID="AhwalHandHeldDataSource" Visible="true" AutoGenerateColumns="False" KeyFieldName="HandHeldID" TextFormatString="{1}">
                                            <GridViewProperties>
                                                <SettingsBehavior AllowFocusedRow="True" AllowSelectSingleRowOnly="True"></SettingsBehavior>
                                            </GridViewProperties>
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="HandHeldID" ReadOnly="True" ShowInCustomizationForm="false" Visible="false" VisibleIndex="0">
                                                    <EditFormSettings Visible="False" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Serial" Caption="رقم الجهاز" ShowInCustomizationForm="True" VisibleIndex="1">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="BarCode" Caption="باركود" ShowInCustomizationForm="True" VisibleIndex="2">
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="Defective" ShowInCustomizationForm="True" Visible="false" VisibleIndex="3">
                                                </dx:GridViewDataTextColumn>
                                            </Columns>
                                        </dx:ASPxGridLookup>
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
                                    <td>
                                        <dx:ASPxLabel ID="AhwalMapping_CheckInOut_StatusLabel" runat="server" Text="" Theme="DevEx"></dx:ASPxLabel>

                                    </td>
                                    <td>
                                        <dx:ASPxButton ID="AhwalMapping_CheckInOut_SubmitButton" runat="server" Text="أضافه" Theme="DevEx" OnClick="AhwalMapping_CheckInOut_SubmitButton_Click" ClientInstanceName="AhwalMapping_CheckInOut_SubmitButton"></dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                            <input type="hidden" id="AhwalMapping_CheckInOut_ID" name="AhwalMapping_CheckInOut_ID" />
                            <input type="hidden" id="AhwalMapping_CheckInOut_Method" name="AhwalMapping_CheckInOut_Method" />
                        </asp:Panel>
                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents Closing="closing_PopUp" />
            </dx:ASPxPopupControl>
            <%--Latest States PopUp--%>
            <dx:ASPxPopupControl ID="AhwalMapping_States_PopUp" ClientInstanceName="AhwalMapping_States_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
                <ContentCollection>
                    <dx:PopupControlContentControl runat="server">
                        <asp:Panel ID="AhwalMapping_States_Panel" runat="server">
                            <dx:ASPxGridView ID="AhwalMapping_States_Grid" ClientInstanceName="AhwalMapping_States_Grid" runat="server" Width="100%" AutoGenerateColumns="False"
                                OnHtmlRowPrepared="AhwalMapping_States_Grid_HtmlRowPrepared"
                                DataSourceID="AhwalMapping_State_DataSource" KeyFieldName="PatrolPersonStateLogID">
                                <Settings ShowFilterRow="True" />
                                <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
                                <Columns>

                                    <dx:GridViewDataComboBoxColumn FieldName="PatrolPersonStateID" VisibleIndex="1" Caption="الحالة" Settings-AllowFilterBySearchPanel="False" Settings-AllowHeaderFilter="True">
                                        <PropertiesComboBox TextField="Name" ValueField="PatrolPersonStateID" DataSourceID="AhwalPersonStateDataSource"></PropertiesComboBox>
                                        <Settings AllowAutoFilter="False" />

                                        <SettingsHeaderFilter Mode="CheckedList"></SettingsHeaderFilter>
                                    </dx:GridViewDataComboBoxColumn>
                                    <%--  <dx:GridViewDataTextColumn FieldName="UserID" ShowInCustomizationForm="True" VisibleIndex="2">
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="AhwalID" ReadOnly="True" ShowInCustomizationForm="True" VisibleIndex="3">
                                        <EditFormSettings Visible="False" />
                                    </dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="PersonID" ShowInCustomizationForm="True" VisibleIndex="4">
                                    </dx:GridViewDataTextColumn>--%>

                                    <dx:GridViewDataDateColumn FieldName="TimeStamp" Caption="الوقت" ShowInCustomizationForm="True" VisibleIndex="6" Settings-AllowHeaderFilter="True">
                                        <Settings AllowAutoFilter="False" />
                                        <PropertiesDateEdit DisplayFormatString="G"></PropertiesDateEdit>
                                        <SettingsHeaderFilter Mode="DateRangePicker"></SettingsHeaderFilter>
                                    </dx:GridViewDataDateColumn>
                                </Columns>
                                <SettingsPager PageSize="15" />
                                <SettingsText HeaderFilterSelectAll="الكل" HeaderFilterCancelButton="الغاء" HeaderFilterOkButton="موافق" />
                            </dx:ASPxGridView>
                            <input type="hidden" id="StatesPersonID" name="StatesPersonID" />
                        </asp:Panel>

                    </dx:PopupControlContentControl>
                </ContentCollection>
                <ClientSideEvents Closing="closing_StatesPopUp" />
            </dx:ASPxPopupControl>
         
            <dx:ASPxGridViewExporter ID="AhwalMappingGridExporter" runat="server" Landscape="true" GridViewID="AhwalMappingGrid"></dx:ASPxGridViewExporter>
            <asp:SqlDataSource ID="AhwalMappingDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT AhwalMappingID, AhwalID, ShiftID, SectorID, PatrolRoleID, CityGroupID,(Select MilNumber From Persons where PersonID=AhwalMapping.PersonID) as MilNumber,(Select RankID From Persons where PersonID=AhwalMapping.PersonID) as RankID, (Select Name From Persons where PersonID=AhwalMapping.PersonID) as PersonName, CallerID, HasDevices, (Select Serial From HandHelds where HandHeldID=AhwalMapping.HandHeldID) as Serial,  (Select PlateNumber From PatrolCars where PatrolID=AhwalMapping.PatrolID) as PlateNumber, PatrolPersonStateID, SunRiseTimeStamp, SunSetTimeStamp, SortingIndex,(Select Mobile From Persons where PersonID=AhwalMapping.PersonID) as PersonMobile,IncidentID,LastStateChangeTimeStamp FROM AhwalMapping WHERE (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID))) Order by SortingIndex">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalRanksDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [RankID], [Name] FROM [Ranks]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalPersonDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [PersonID], [AhwalID], [Name], [MilNumber] FROM [Persons] WHERE (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalPatrolCarDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT PatrolID, PlateNumber,Model,Type, BarCode, Defective, Rental FROM PatrolCars where (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalHandHeldDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT HandHeldID, Serial, BarCode, Defective FROM HandHelds WHERE (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalPatrolRoleDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [PatrolRoleID], [Name] FROM [PatrolRoles]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalShiftDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [ShiftID], [Name], [StartingHour], [NumberOfHours] FROM [Shifts]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalSectorDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [SectorID], [ShortName], [CallerPrefix], [Disabled] FROM [Sectors] where Disabled<>1  and (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalSectorDataSourceWithOutPublic" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [SectorID], [ShortName], [CallerPrefix], [Disabled] FROM [Sectors] where SectorID<>1 and Disabled<>1  and (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="AhwalCityGroupDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [CityGroupID],[SectorID],[ShortName],[CallerPrefix],[Text],[Disabled] FROM [Patrols].[dbo].[CityGroups] where Disabled<>1 and (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalCityGroupDataSourceWithOutNone" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [CityGroupID], [ShortName], [CallerPrefix], [Disabled] FROM [CityGroups] where Disabled<>1 and CallerPreFix<>'0' and SectorID=@SectorID and  (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:ControlParameter ControlID="MainContent$UpdatePanel$AhwalMapping_Add_PopUp$AhwalMapping_Add_Sector_CombobBox" Name="SectorID" PropertyName="Value" />
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>

            <asp:SqlDataSource ID="AhwalPersonStateDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [PatrolPersonStateID], [Name] FROM [PatrolPersonStates]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalDataSroucce" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT AhwalID, Name FROM Ahwal WHERE (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalMappingAssociateDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT AhwalMapping.AhwalMappingID, Persons.PersonID, Persons.MilNumber, Persons.Name FROM AhwalMapping INNER JOIN Persons ON AhwalMapping.PersonID = Persons.PersonID WHERE (AhwalMapping.PatrolRoleID &lt;&gt; 70) AND (AhwalMapping.AhwalID IN (SELECT AhwalMapping.AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID)))">
                <SelectParameters>
                    <asp:SessionParameter DefaultValue="" Name="UserID" SessionField="UserID" />
                    <asp:SessionParameter DefaultValue="" Name="UserRoleID" SessionField="UserRoleID" />
                </SelectParameters>
            </asp:SqlDataSource>
            <asp:SqlDataSource ID="AhwalMapping_State_DataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT top (100) [PatrolPersonStateLogID],[UserID],(select [AhwalID] from AhwalMapping where PersonID=[PatrolPersonStateLog].PersonID) as AhwalID,[PersonID],[PatrolPersonStateID],[TimeStamp] FROM [Patrols].[dbo].[PatrolPersonStateLog] WHERE PersonID=@PersonID order by [TimeStamp] desc">
                <SelectParameters>
                    <asp:SessionParameter DefaultValue="" Name="PersonID" SessionField="StatePersonID" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
        <Triggers>
<%--            <asp:AsyncPostBackTrigger ControlID="ASPxTimer1" EventName="Tick" />--%>
        </Triggers>

    </asp:UpdatePanel>
<%--    <dx:ASPxTimer ID="ASPxTimer1" ClientInstanceName="ASPxTimer1" runat="server" OnTick="ASPxTimer1_Tick" Interval="30000"></dx:ASPxTimer>--%>

</asp:Content>
