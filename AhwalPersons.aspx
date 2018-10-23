<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="AhwalPersons.aspx.cs" Inherits="PatrolWebApp.Ahwal1" %>

<asp:Content ID="AhwalPersonsContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function closing_PopUp(sender, arg) {
            var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            ASPxTimer1.SetEnabled(true);
        }
        function show_Add_Person_PopUp() {
            Person_Add_PopUp.SetHeaderText("اضافة فرد");
            var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
            ASPxTimer1.SetEnabled(false);
            Person_Add_PopUp.Show();

        }
        function AhwalPeronsGrid_OnContextMenu(s, e) {
            s.SetFocusedRowIndex(e.index);
            e.showBrowserMenu = false;
        }
        function Person_UpdatePopUpControl(values) {
            var Persons_Add_MilNumber_txt_Casted = ASPxClientTextBox.Cast("Persons_Add_MilNumber_txt");
            var Persons_Add_Name_txt_Casted = ASPxClientTextBox.Cast("Persons_Add_Name_txt");
            var Persons_Add_Mobile_txt_Casted = ASPxClientTextBox.Cast("Persons_Add_Mobile_txt");
            var Persons_Add_FixedCaller_Casted = ASPxClientTextBox.Cast("Persons_Add_FixedCaller");
            var Persons_Add_Ahwal_CombobBox_Casted = ASPxClientComboBox.Cast("Persons_Add_Ahwal_CombobBox");
            var Persons_Add_Rank_ComboBox_Casted = ASPxClientComboBox.Cast("Persons_Add_Rank_ComboBox");
            var AhwalPersonsGrid = ASPxClientGridView.Cast("AhwalPersonsGrid");
            var ahwaldID = values[0];
            var personID = values[1];
            Persons_Add_Ahwal_CombobBox_Casted.SetValue(ahwaldID)
            document.getElementById('PersonID').value = personID

            Persons_Add_MilNumber_txt_Casted.SetText(values[2]);
            Persons_Add_Rank_ComboBox_Casted.SetValue(values[3]);
            Persons_Add_Name_txt_Casted.SetValue(values[4]);
            Persons_Add_Mobile_txt_Casted.SetText(values[5]);
            Persons_Add_FixedCaller_Casted.SetText(values[6]);
            Persons_Add_MilNumber_txt_Casted.Focus();


        }
        function AhwalPeronsGrid_OnContextMenuItemClick(sender, args) {
            var Persons_Add_SubmitButton_Casted = ASPxClientButton.Cast("Persons_Add_SubmitButton");
            if (args.item.name == "تقرير PDF" || args.item.name == "تقرير Excel") {
                args.processOnServer = true;
                args.usePostBack = true;
            } else if (args.item.name == "جديد") {
                document.getElementById('PersonAddMethod').value = 'NEW'
                document.getElementById('PersonID').value = ''
                args.processOnServer = false;
               // args.usePostBack = false;
                Persons_Add_SubmitButton_Casted.SetText("اضافه");
                show_Add_Person_PopUp();
                var Persons_Add_MilNumber_txt_Casted  = ASPxClientTextBox.Cast("Persons_Add_MilNumber_txt");
                var Persons_Add_Name_txt_Casted  = ASPxClientTextBox.Cast("Persons_Add_Name_txt");
                var Persons_Add_Mobile_txt_Casted = ASPxClientTextBox.Cast("Persons_Add_Mobile_txt");
                var Persons_Add_FixedCaller_Casted = ASPxClientTextBox.Cast("Persons_Add_FixedCaller");
                var Persons_Add_Ahwal_CombobBox_Casted= ASPxClientComboBox.Cast("Persons_Add_Ahwal_CombobBox");
                var Persons_Add_Rank_ComboBox_Casted = ASPxClientComboBox.Cast("Persons_Add_Rank_ComboBox");
                Persons_Add_MilNumber_txt_Casted.SetText("");
                Persons_Add_Name_txt_Casted.SetText("");
                Persons_Add_FixedCaller_Casted.SetText("");
                Persons_Add_Mobile_txt_Casted.SetText("");
                Persons_Add_MilNumber_txt_Casted.Focus();
                
            }
            else if (args.item.name == "تعديل") {
                document.getElementById('PersonAddMethod').value = 'UPDATE'
                args.processOnServer = false;
               // args.usePostBack = false;
                Persons_Add_SubmitButton_Casted.SetText("تعديل");
                var AhwalPersonsGrid = ASPxClientGridView.Cast("AhwalsPersonsGrid");

                show_Add_Person_PopUp();
                AhwalPersonsGrid.GetRowValues(AhwalPersonsGrid.GetFocusedRowIndex(), "AhwalID;PersonID;MilNumber;RankID;Name;Mobile;FixedCaller", Person_UpdatePopUpControl)

                //Person_Add_MilNumber_txt_Casted.Focus();

            }
        }

    </script>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Always" >
        <ContentTemplate>
    <dx:ASPxGridView ID="AhwalsPersonsGrid" runat="server" ClientInstanceName="AhwalsPersonsGrid"
        OnContextMenuItemClick="AhwalsPersonsGrid_ContextMenuItemClick"
        OnFillContextMenuItems="AhwalsPersonsGrid_FillContextMenuItems"
        AutoGenerateColumns="False" DataSourceID="AhwalPersonsDataSource"
        EnableTheming="True" KeyFieldName="PersonID" Width="100%" Theme="DevEx" Font-Size="Medium">
        <Settings ShowFilterRow="True" />
        <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
        <Columns>
            <dx:GridViewDataTextColumn FieldName="PersonID" ReadOnly="True" VisibleIndex="0" Visible="false">
                <EditFormSettings Visible="False" />
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataComboBoxColumn FieldName="AhwalID" VisibleIndex="1" Caption="الأحوال">
                <PropertiesComboBox TextField="Name" ValueField="AhwalID" DataSourceID="AhwalDataSroucce"></PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="MilNumber" VisibleIndex="2" Caption="الرقم العسكري">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataComboBoxColumn FieldName="RankID" VisibleIndex="3" Caption="الرتبه">
                <PropertiesComboBox TextField="Name" ValueField="RankID" DataSourceID="RanksDataSource"></PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="4" Caption="الاسم">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="Mobile" VisibleIndex="5" Caption="الجوال">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="FixedCallerID" VisibleIndex="6" Caption="نداء ثابت">
            </dx:GridViewDataTextColumn>
        </Columns>
        <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="true" />
        <SettingsContextMenu Enabled="true" RowMenuItemVisibility-Refresh="false" />
        <SettingsPager PageSize="80" />
        <ClientSideEvents ContextMenu="AhwalPeronsGrid_OnContextMenu" ContextMenuItemClick="function(s,e) { AhwalPeronsGrid_OnContextMenuItemClick(s, e); }" />

    </dx:ASPxGridView>
    <dx:ASPxPopupControl ID="Person_Add_PopUp" ClientInstanceName="Person_Add_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
        <ContentCollection>
            <dx:PopupControlContentControl runat="server">
                <asp:Panel ID="Person_Add_PopUpPanel" runat="server">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="الأحوال"></dx:ASPxLabel>

                            </td>
                            <td>
                                <dx:ASPxComboBox ID="Persons_Add_Ahwal_CombobBox" runat="server" DataSourceID="AhwalDataSroucce" ValueField="AhwalID" TextField="Name" Theme="DevEx" ClientInstanceName="Persons_Add_Ahwal_CombobBox"></dx:ASPxComboBox>
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
                                <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="الرقم العسكري"></dx:ASPxLabel>

                            </td>
                            <td>
                                <dx:ASPxTextBox ID="Persons_Add_MilNumber_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Persons_Add_MilNumber_txt"></dx:ASPxTextBox>
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
                                <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="الرتبه"></dx:ASPxLabel>

                            </td>
                            <td>
                                <dx:ASPxComboBox ID="Persons_Add_Rank_ComboBox" runat="server" DataSourceID="RanksDataSource" ValueField="RankID" TextField="Name" Theme="DevEx" ClientInstanceName="Persons_Add_Rank_ComboBox"></dx:ASPxComboBox>
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
                                <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="الاسم"></dx:ASPxLabel>

                            </td>
                            <td>
                                <dx:ASPxTextBox ID="Persons_Add_Name_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Persons_Add_Name_txt"></dx:ASPxTextBox>
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
                                <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="رقم الجوال"></dx:ASPxLabel>

                            </td>
                            <td>
                                <dx:ASPxTextBox ID="Persons_Add_Mobile_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Persons_Add_Mobile_txt"></dx:ASPxTextBox>
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
                                <dx:ASPxLabel ID="ASPxLabel8" runat="server" Text="نداء ثابت"></dx:ASPxLabel>

                            </td>
                            <td>
                                <dx:ASPxTextBox ID="Persons_Add_FixedCaller" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Persons_Add_FixedCaller"></dx:ASPxTextBox>
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
                                <dx:ASPxLabel ID="Persons_Add_status_label" runat="server" Text="" Theme="DevEx"></dx:ASPxLabel>

                            </td>
                            <td>
                                <dx:ASPxButton ID="Persons_Add_SubmitButton" runat="server" Text="أضافه" Theme="DevEx" OnClick="Persons_Add_SubmitButton_Click" ClientInstanceName="Persons_Add_SubmitButton"></dx:ASPxButton>
                            </td>
                        </tr>
                    </table>
                    <input type="hidden" id="PersonID" name="PersonID" />
                    <input type="hidden" id="PersonAddMethod" name="PersonAddMethod" />
                </asp:Panel>
            </dx:PopupControlContentControl>
        </ContentCollection>
                <ClientSideEvents Closing="closing_PopUp" />
    </dx:ASPxPopupControl>
    <dx:ASPxGridViewExporter ID="AhwalPersonsGridExporter" runat="server" GridViewID="AhwalsPersonsGrid"></dx:ASPxGridViewExporter>
    <asp:SqlDataSource ID="RanksDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [RankID], [Name] FROM [Ranks]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="AhwalPersonsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT PersonID, AhwalID, MilNumber, RankID, Name, Mobile, FixedCallerID FROM Persons WHERE (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID)))">
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
             </ContentTemplate>
        <Triggers>
    <asp:AsyncPostBackTrigger ControlID="ASPxTimer1" EventName="Tick" />
</Triggers>

    </asp:UpdatePanel>
                    <dx:ASPxTimer ID="ASPxTimer1" ClientInstanceName="ASPxTimer1" runat="server" OnTick="ASPxTimer1_Tick" Interval="30000"></dx:ASPxTimer>

</asp:Content>
