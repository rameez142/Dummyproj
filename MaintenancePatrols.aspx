<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="MaintenancePatrols.aspx.cs" Inherits="PatrolWebApp.Maintenance" %>

<asp:Content ID="MaintenanceContent" ContentPlaceHolderID="MainContent" runat="server">


        <script type="text/javascript">
            function closing_PopUp(sender, arg) {
                var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
                ASPxTimer1.SetEnabled(true);
            }
            function PatrolsMenu_Click(s, e) {
                if (e.item.index == 0) {
                    // alert("Add new patrol click");
                    // console.dir(Patrol_Add_PopUp);
                    show_Add_Patrol_PopUp();
                } else if (e.item.index == 1) {
                    // alert("Ptrint patrol click");
                }

            }
            function show_Add_Patrol_PopUp() {
                Patrol_Add_PopUp.SetHeaderText("أضافة دورية جديدة");
                var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
                ASPxTimer1.SetEnabled(false);
                Patrol_Add_PopUp.Show();
                
            }
            function PatrolGrid_OnContextMenu(s, e) {
                //alert(e.index);
                s.SetFocusedRowIndex(e.index);
                e.showBrowserMenu = false;
            }
            function Patrol_UpdatePopUpControl(values) {
                var PatrolGrid = ASPxClientGridView.Cast("PatrolsGrid");
                var ahwaldID = values[0];
                var patrolID = values[1];
                var Patrol_Add_Ahwal_ComboBox_Casted = ASPxClientComboBox.Cast("Patrol_Add_Ahwal_ComboBox");
                var Patrol_Add_PlateNumber_txt_Casted = ASPxClientTextBox.Cast("Patrol_Add_PlateNumber_txt");
                var Patrol_Add_Type_txt_Casted = ASPxClientTextBox.Cast("Patrol_Add_Type_txt");
                var Patrol_Add_Model_txt_Casted = ASPxClientTextBox.Cast("Patrol_Add_Model_txt");
                var Patrol_Add_VINNumber_txt_Casted = ASPxClientTextBox.Cast("Patrol_Add_VINNumber_txt");
                var Patrol_Add_Rental_checkbox_Casted = ASPxClientCheckBox.Cast("Patrol_Add_Rental_checkbox");
                var Patrol_Add_Defective_checkbox_Casted = ASPxClientCheckBox.Cast("Patrol_Add_Defective_checkbox");
                document.getElementById('PatrolID').value = patrolID
                Patrol_Add_Ahwal_ComboBox_Casted.SetValue(ahwaldID);
                
                Patrol_Add_PlateNumber_txt_Casted.SetText(values[2]);
                Patrol_Add_Type_txt_Casted.SetText(values[3]);
                Patrol_Add_Model_txt_Casted.SetText(values[4]);
                Patrol_Add_VINNumber_txt_Casted.SetText(values[5]);
                if (values[6] == 1 ) {
                    Patrol_Add_Rental_checkbox.SetChecked(true);
                } else {
                    Patrol_Add_Rental_checkbox.SetChecked(false);
                }
                if (values[7] == 1 ) {
                    Patrol_Add_Defective_checkbox.SetChecked(true);
                } else {
                    Patrol_Add_Defective_checkbox.SetChecked(false);
                }
               
                Patrol_Add_PlateNumber_txt_Casted.Focus();
               // console.dir(values);
            }
            function PatrolGrid_OnContextMenuItemClick(sender, args) {
                var Patrol_Add_SubmitBtn_Casted = ASPxClientButton.Cast("Patrol_Add_SubmitBtn");
                if (args.item.name == "تقرير PDF" || args.item.name == "تقرير Excel") {
                    args.processOnServer = true;
                    args.usePostBack = true;
                } else if (args.item.name == "جديد") {
                    document.getElementById('PatrolAddMethod').value = 'NEW'
                    document.getElementById('PatrolID').value = ''
                    args.processOnServer = false;
                    args.usePostBack = false;
                    Patrol_Add_SubmitBtn.SetText("اضافه");
                    var Patrol_Add_PlateNumber_txt_Casted = ASPxClientTextBox.Cast("Patrol_Add_PlateNumber_txt");
                    var Patrol_Add_VINNumber_txt_Casted = ASPxClientTextBox.Cast("Patrol_Add_VINNumber_txt");
                    var Patrol_Add_Rental_checkbox_Casted = ASPxClientCheckBox.Cast("Patrol_Add_Rental_checkbox");
                    var Patrol_Add_Defective_checkbox_Casted = ASPxClientCheckBox.Cast("Patrol_Add_Defective_checkbox");
                    
                    Patrol_Add_PlateNumber_txt_Casted.SetText("");
                    Patrol_Add_VINNumber_txt_Casted.SetText("");
                    Patrol_Add_Rental_checkbox_Casted.SetChecked(false);
                    Patrol_Add_Defective_checkbox_Casted.SetChecked(false);
                    show_Add_Patrol_PopUp();
                    Patrol_Add_PlateNumber_txt_Casted.Focus();
                } else if (args.item.name == "تعديل") {
                    document.getElementById('PatrolAddMethod').value = 'UPDATE'
                    args.processOnServer = false;
                   // args.usePostBack = false;
                    Patrol_Add_SubmitBtn_Casted.SetText("تعديل");
                    var PatrolGrid = ASPxClientGridView.Cast("PatrolsGrid");
                    show_Add_Patrol_PopUp();
                    PatrolGrid.GetRowValues(PatrolGrid.GetFocusedRowIndex(), "AhwalID;PatrolID;PlateNumber;Type;Model;VINNumber;Rental;Defective", Patrol_UpdatePopUpControl)
                    
                }
            }
            </script>
             
        <%-- <dx:ASPxMenu ID="PatrolsMenu" ClientInstanceName="PatrolsMenu" runat="server" Width="100%" EnableTheming="True" Theme="DevEx" Font-Size="Medium">
            <ClientSideEvents ItemClick="PatrolsMenu_Click" />
            <Items>
                <dx:MenuItem Text="اضافة دورية جديدة"></dx:MenuItem>
                <dx:MenuItem Text="طباعة"></dx:MenuItem>
            </Items>
        </dx:ASPxMenu>--%>
        <br />
            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Always" >
        <ContentTemplate>
        <dx:ASPxGridView ID="PatrolsGrid" ClientInstanceName="PatrolsGrid" runat="server"
            KeyFieldName="PatrolID"
            AutoGenerateColumns="False" Width="100%" Theme="DevEx" Font-Size="Medium"
            OnContextMenuItemClick="PatrolsGrid_ContextMenuItemClick"
            OnFillContextMenuItems="PatrolsGrid_FillContextMenuItems" DataSourceID="PatrolsDataSource">
            <Settings ShowFilterRow="True" />
                        <SettingsBehavior AllowSort="false" />

            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />

            <Columns>
               
                <dx:GridViewDataTextColumn Caption="PatrolID" Name="PatrolID" Visible="False" VisibleIndex="0" FieldName="PatrolID">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataComboBoxColumn Caption="الأحوال" Name="AhwalID" VisibleIndex="1" FieldName="AhwalID">
                    <PropertiesComboBox TextField="Name" ValueField="AhwalID" DataSourceID="AhwalDataSroucce"></PropertiesComboBox>
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataTextColumn Caption="رقم الدورية" Name="PlateNumber" Visible="True" VisibleIndex="2" FieldName="PlateNumber">
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="النوع" Name="Type" Visible="True" VisibleIndex="3" FieldName="Type">
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="موديل" Name="Model" Visible="True" VisibleIndex="4" FieldName="Model">
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="رقم الباركود" Name="BarCode" Visible="True" VisibleIndex="5" FieldName="BarCode">
                    <Settings AllowAutoFilter="False" />
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="رقم الشاصي" Name="VINNumber" Visible="True" VisibleIndex="6" FieldName="VINNumber">
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataCheckColumn Caption="غير صالحة؟" Name="Defective" VisibleIndex="7" FieldName="Defective">
                    <Settings AllowAutoFilter="False" />
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataCheckColumn>
                <dx:GridViewDataCheckColumn Caption="ايجار؟" Name="Rental" VisibleIndex="8" FieldName="Rental">
                    <Settings AllowAutoFilter="False" />
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataCheckColumn>

            </Columns>
            <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="true" />
            <SettingsContextMenu Enabled="true"  RowMenuItemVisibility-Refresh="false" />
            <SettingsPager PageSize="80"/>
            <ClientSideEvents ContextMenu="PatrolGrid_OnContextMenu" ContextMenuItemClick="function(s,e) { PatrolGrid_OnContextMenuItemClick(s, e); }" />

        </dx:ASPxGridView>
        <dx:ASPxGridViewExporter runat="server" ID="PatrolGrid_GridExporter" GridViewID="PatrolsGrid" />
        <dx:ASPxPopupControl ID="Patrols_Add_Popup" ClientInstanceName="Patrol_Add_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <asp:Panel ID="Patrols_Add_Popup_Panel" runat="server">
                        <table style="width: 100%">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="ASPxLabel7" runat="server" Text="الأحوال"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="Patrol_Add_Ahwal_ComboBox" runat="server" DataSourceID="AhwalDataSroucce" ValueField="AhwalID" TextField="Name" Theme="DevEx" ClientInstanceName="Patrol_Add_Ahwal_ComboBox"></dx:ASPxComboBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="رقم الدورية"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="Patrol_Add_PlateNumber_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Patrol_Add_PlateNumber_txt"></dx:ASPxTextBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel2" runat="server" Text="النوع"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="Patrol_Add_Type_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Patrol_Add_Type_txt"></dx:ASPxTextBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel3" runat="server" Text="موديل"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="Patrol_Add_Model_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Patrol_Add_Model_txt"></dx:ASPxTextBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel8" runat="server" Text="رقم الشاصي"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="Patrol_Add_VINNumber_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="Patrol_Add_VINNumber_txt"></dx:ASPxTextBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel4" runat="server" Text="غير صالحه؟" Theme="DevEx"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxCheckBox ID="Patrol_Add_Defective_checkbox" runat="server" Theme="DevEx" ClientInstanceName="Patrol_Add_Defective_checkbox"></dx:ASPxCheckBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel5" runat="server" Text="ايجار؟" Theme="DevEx"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxCheckBox ID="Patrol_Add_Rental_checkbox" runat="server" Theme="DevEx" ClientInstanceName="Patrol_Add_Rental_checkbox"></dx:ASPxCheckBox>
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
                                    <dx:ASPxLabel ID="Patrol_add_status_label" runat="server" Text="" Theme="DevEx"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxButton ID="Patrol_Add_SubmitBtn" runat="server" Text="أضافه" Theme="DevEx" OnClick="Patrol_Add_SubmitBtn_Click" ClientInstanceName="Patrol_Add_SubmitBtn"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" id="PatrolID" name="PatrolID" />
                        <input type="hidden" id="PatrolAddMethod" name="PatrolAddMethod" />
                    </asp:Panel>
                </dx:PopupControlContentControl>
            </ContentCollection>
                    <ClientSideEvents Closing="closing_PopUp" />

        </dx:ASPxPopupControl>
   
    <asp:SqlDataSource ID="PatrolsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT PatrolID,AhwalID, PlateNumber, BarCode, Model, Type, VINNumber, Defective, Rental
FROM  PatrolCars Where PlateNumber&lt;&gt; 'NONE' and AhwalID in (Select AhwalID from UsersRolesMap where UserID=@UserID and UserRoleID=@UserRoleID)">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" />
            <asp:SessionParameter Name="UserRoleID" SessionField="UserRoleID" />
        </SelectParameters>
    </asp:SqlDataSource>
     <asp:SqlDataSource ID="AhwalDataSroucce"  runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT AhwalID, Name FROM Ahwal WHERE (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID )))">
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

