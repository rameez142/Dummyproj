<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="MaintenanceHandHelds.aspx.cs" Inherits="PatrolWebApp.MaintenanceHandHelds" %>
<asp:Content ID="MaintenanceHandheldsContent" ContentPlaceHolderID="MainContent" runat="server">
               <script type="text/javascript">
                   function closing_PopUp(sender, arg) {
                       var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
                       ASPxTimer1.SetEnabled(true);
                   }

               function show_Add_HandHeld_PopUp() {
                   HandHeld_Add_PopUp.SetHeaderText("أضافة جهاز جديدة");
                   var ASPxTimer1 = ASPxClientTimer.Cast("ASPxTimer1");
                   ASPxTimer1.SetEnabled(false);
                   HandHeld_Add_PopUp.Show();

               }
               function HandHeldsGrid_OnContextMenu(s, e) {
                   //alert(e.index);
                   s.SetFocusedRowIndex(e.index);
                   e.showBrowserMenu = false;
               }
               function HandHelds_UpdatePopUpControl(values) {
                   var HandHeldsGrid = ASPxClientGridView.Cast("HandHeldsGrid");
                   var ahwaldID = values[0];
                   var HandHeldID = values[1];
                   var HandHeld_Add_Ahwal_ComboBox_Casted = ASPxClientComboBox.Cast("HandHeld_Add_Ahwal_ComboBox");
                   var HandHeld_Add_Serial_txt_Casted = ASPxClientTextBox.Cast("HandHeld_Add_Serial_txt");
                   var HandHeld_Add_Defective_checkbox_Casted = ASPxClientCheckBox.Cast("HandHeld_Add_Defective_checkbox");
                   document.getElementById('HandHeldID').value = HandHeldID
                   HandHeld_Add_Ahwal_ComboBox_Casted.SetValue(ahwaldID);
                   HandHeld_Add_Serial_txt_Casted.SetText(values[2]);
                   if (values[3] == 1) {
                       HandHeld_Add_Defective_checkbox_Casted.SetChecked(true);
                   } else {
                       HandHeld_Add_Defective_checkbox_Casted.SetChecked(false);
                   }
                   HandHeld_Add_Serial_txt_Casted.Focus();


                   //console.dir(values);
               }
               function HandHeldsGrid_OnContextMenuItemClick(sender, args) {
                   var HandHeld_Add_SubmitBtn_Casted = ASPxClientButton.Cast("HandHeld_Add_SubmitBtn");
                   if (args.item.name == "تقرير PDF" || args.item.name == "تقرير Excel") {
                       args.processOnServer = true;
                       args.usePostBack = true;
                   } else if (args.item.name == "جديد") {
                       document.getElementById('HandHeldAddMethod').value = 'NEW'
                       document.getElementById('HandHeldID').value = ''
                       args.processOnServer = false;
                      // args.usePostBack = false;
                       HandHeld_Add_SubmitBtn_Casted.SetText("اضافه");
                       var HandHeld_Add_Serial_txt_Casted = ASPxClientTextBox.Cast("HandHeld_Add_Serial_txt");
                       var HandHeld_Add_Defective_checkbox_Casted = ASPxClientCheckBox.Cast("HandHeld_Add_Defective_checkbox");
                       HandHeld_Add_Serial_txt_Casted.SetText("");
                       HandHeld_Add_Defective_checkbox_Casted.SetChecked(false);
                       show_Add_HandHeld_PopUp();
                       HandHeld_Add_Serial_txt_Casted.Focus();
                   } else if (args.item.name == "تعديل") {
                       document.getElementById('HandHeldAddMethod').value = 'UPDATE'
                       args.processOnServer = false;
                     //  args.usePostBack = false;
                       HandHeld_Add_SubmitBtn_Casted.SetText("تعديل");
                       var HandHeldsGrid = ASPxClientGridView.Cast("HandHeldsGrid");
                       show_Add_HandHeld_PopUp();
                       HandHeldsGrid.GetRowValues(HandHeldsGrid.GetFocusedRowIndex(), "AhwalID;HandHeldID;Serial;Defective", HandHelds_UpdatePopUpControl)

                   }
               }
        </script>
         <br />
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Always" >
        <ContentTemplate>
        <dx:ASPxGridView ID="HandHeldsGrid" ClientInstanceName="HandHeldsGrid" runat="server"
            KeyFieldName="HandHeldID"
            AutoGenerateColumns="False" Width="100%" Theme="DevEx" Font-Size="Medium"
            OnContextMenuItemClick="HandHeldsGrid_ContextMenuItemClick"
            OnFillContextMenuItems="HandHeldsGrid_FillContextMenuItems" DataSourceID="HandHeldsDataSource">
            <Settings ShowFilterRow="True" />
                        <SettingsBehavior AllowSort="false" />

            <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />

            <Columns>
  
                <dx:GridViewDataTextColumn Caption="HandHeldID" Name="HandHeldID" Visible="False" VisibleIndex="0" FieldName="PatrolID">
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataComboBoxColumn Caption="الأحوال" Name="AhwalID" VisibleIndex="1" FieldName="AhwalID">
                    <PropertiesComboBox TextField="Name" ValueField="AhwalID" DataSourceID="AhwalDataSroucce">
                    </PropertiesComboBox>
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataComboBoxColumn>
                <dx:GridViewDataTextColumn Caption="رقم الجهاز" Name="Serial" Visible="True" VisibleIndex="2" FieldName="Serial">
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataTextColumn>
               
                <dx:GridViewDataTextColumn Caption="رقم الباركود" Name="BarCode" Visible="True" VisibleIndex="3" FieldName="BarCode">
                    <Settings AllowAutoFilter="False" />
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataCheckColumn Caption="غير صالح؟" Name="Defective" VisibleIndex="4" FieldName="Defective">
                    <Settings AllowAutoFilter="False" />
                    <CellStyle Font-Size="Medium">
                    </CellStyle>
                </dx:GridViewDataCheckColumn>


            </Columns>
            <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="true" />
            <SettingsContextMenu Enabled="true" RowMenuItemVisibility-Refresh="false" />
            <SettingsPager PageSize="80"/>
            <ClientSideEvents ContextMenu="HandHeldsGrid_OnContextMenu" ContextMenuItemClick="function(s,e) { HandHeldsGrid_OnContextMenuItemClick(s, e); }" />

        </dx:ASPxGridView>
        <dx:ASPxGridViewExporter runat="server" ID="HandHeldsGrid_GridExporter" GridViewID="HandHeldsGrid" />
        <dx:ASPxPopupControl ID="HandHeld_Add_PopUp" ClientInstanceName="HandHeld_Add_PopUp" runat="server" Theme="DevEx" PopupVerticalAlign="WindowCenter" PopupHorizontalAlign="WindowCenter" CloseOnEscape="True">
            <ContentCollection>
                <dx:PopupControlContentControl runat="server">
                    <asp:Panel ID="HandHeld_Add_Panel" runat="server">
                        <table style="width: 100%">
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="ASPxLabel6" runat="server" Text="الأحوال"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxComboBox ID="HandHeld_Add_Ahwal_ComboBox" runat="server" DataSourceID="AhwalDataSroucce" ValueField="AhwalID" TextField="Name" ValueType="System.String" Theme="DevEx" ClientInstanceName="HandHeld_Add_Ahwal_ComboBox"></dx:ASPxComboBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel9" runat="server" Text="رقم الجهاز"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxTextBox ID="HandHeld_Add_Serial_txt" runat="server" Width="170px" Theme="DevEx" ClientInstanceName="HandHeld_Add_Serial_txt"></dx:ASPxTextBox>
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
                                    <dx:ASPxLabel ID="ASPxLabel13" runat="server" Text="غير صالح؟" Theme="DevEx"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxCheckBox ID="HandHeld_Add_Defective_checkbox" runat="server" Theme="DevEx" ClientInstanceName="HandHeld_Add_Defective_checkbox"></dx:ASPxCheckBox>
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
                                    <br />
                                </td>
                                <td>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <dx:ASPxLabel ID="HandHeld_Add_StatusLabel" runat="server" Text="" Theme="DevEx"></dx:ASPxLabel>

                                </td>
                                <td>
                                    <dx:ASPxButton ID="HandHeld_Add_SubmitBtn" runat="server" Text="أضافه" Theme="DevEx" OnClick="HandHeld_Add_SubmitBtn_Click" ClientInstanceName="HandHeld_Add_SubmitBtn"></dx:ASPxButton>
                                </td>
                            </tr>
                        </table>
                        <input type="hidden" id="HandHeldID" name="HandHeldID" />
                        <input type="hidden" id="HandHeldAddMethod" name="HandHeldAddMethod" />
                    </asp:Panel>
                </dx:PopupControlContentControl>
            </ContentCollection>
                    <ClientSideEvents Closing="closing_PopUp" />

        </dx:ASPxPopupControl>
    <asp:SqlDataSource ID="HandHeldsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT HandHeldID, AhwalID, Serial, BarCode, Defective FROM HandHelds WHERE (Serial &lt;&gt; 'NONE') AND (AhwalID IN (SELECT AhwalID FROM UsersRolesMap WHERE (UserID = @UserID) AND (UserRoleID = @UserRoleID)))">
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
