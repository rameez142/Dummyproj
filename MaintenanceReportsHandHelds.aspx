<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="MaintenanceReportsHandHelds.aspx.cs" Inherits="PatrolWebApp.MaintenanceReportsHandHelds" %>
<asp:Content ID="MaintenanceReportsHandHeldsContent" ContentPlaceHolderID="MainContent" runat="server">
     <script type="text/javascript">

        function MRHandHeldsGrid_OnContextMenu(s, e) {
                s.SetFocusedRowIndex(e.index);
                e.showBrowserMenu = false;
            }
           
        function MRHandHeldsGrid_OnContextMenuItemClick(sender, args) {
                if (args.item.name == "تقرير PDF" || args.item.name == "تقرير Excel") {
                    args.processOnServer = true;
                    args.usePostBack = true;
                } 
            }
            </script>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Always" >
        <ContentTemplate>
    <dx:ASPxGridView ID="MRHandHeldsGrid" ClientInstanceName="MRHandHeldsGrid" runat="server"
        AutoGenerateColumns="False" Width="100%" Theme="DevEx" Font-Size="Medium"
        OnContextMenuItemClick="MRHandHeldsGrid_ContextMenuItemClick"
        OnFillContextMenuItems="MRHandHeldsGrid_FillContextMenuItems" DataSourceID="HandHeldsReportsDataSource" KeyFieldName="HandHeldCheckInOutID">

        <SettingsBehavior AllowSort="false" />
        <Settings ShowFilterRow="True" />
        <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
            <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="true" />
            <SettingsContextMenu Enabled="true"  RowMenuItemVisibility-Refresh="false" >
<RowMenuItemVisibility Refresh="False"></RowMenuItemVisibility>
        </SettingsContextMenu>
            <SettingsPager PageSize="80"/>
        <ClientSideEvents ContextMenu="MRHandHeldsGrid_OnContextMenu" ContextMenuItemClick="function(s,e) { MRHandHeldsGrid_OnContextMenuItemClick(s, e); }" />

        <Columns>
          <dx:GridViewDataTextColumn FieldName="PatrolCheckInOutID" VisibleIndex="0" Visible="false" ReadOnly="True">
                <EditFormSettings Visible="False" />
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataDateColumn FieldName="TimeStamp" Caption="الوقت والتاريخ" VisibleIndex="1" Settings-AllowHeaderFilter="True" PropertiesDateEdit-DisplayFormatString="G">
<PropertiesDateEdit DisplayFormatString="G"></PropertiesDateEdit>

                 <Settings AllowAutoFilter="False" />
                <SettingsHeaderFilter Mode="DateRangePicker" ></SettingsHeaderFilter>
                </dx:GridViewDataDateColumn>
            <dx:GridViewDataComboBoxColumn FieldName="CheckInOutStateID" Caption="الحالة" VisibleIndex="2">
                <PropertiesComboBox TextField="Name" ValueField="CheckInOutStateID" DataSourceID="CheckInOutDataSource"></PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataComboBoxColumn FieldName="AhwalID" Caption="الأحوال" VisibleIndex="3">
                <PropertiesComboBox TextField="Name" ValueField="AhwalID" DataSourceID="AhwalDataSroucce"></PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="Serial" VisibleIndex="4" Caption="رقم الجهاز">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="PersonRank" VisibleIndex="6" Caption="الرتبه">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="MilNumber" VisibleIndex="5" Caption-="الرقم العسكري">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="PersonName" VisibleIndex="7" Caption="الاسم">
            </dx:GridViewDataTextColumn>
        </Columns>

    </dx:ASPxGridView>
    <dx:ASPxGridViewExporter ID="MRPatrolReport_Exporter" runat="server" GridViewID="MRHandHeldsGrid"></dx:ASPxGridViewExporter>
    <asp:SqlDataSource ID="CheckInOutDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [CheckInOutStateID], [Name] FROM [CheckInOutStates] WHERE ([Name] &lt;&gt; @Name)">
        <SelectParameters>
            <asp:Parameter DefaultValue="NONE" Name="Name" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="HandHeldsReportsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT        HandHeldsCheckInOut.HandHeldCheckInOutID,HandHeldsCheckInOut.TimeStamp, CheckInOutStates.CheckInOutStateID,CheckInOutStates.Name AS StateName, HandHelds.AhwalID, HandHelds.Serial, Ranks.Name as PersonRank, Persons.MilNumber, Persons.Name AS PersonName
                         
FROM            Ahwal INNER JOIN
                         HandHelds ON Ahwal.AhwalID = HandHelds.AhwalID INNER JOIN
                         HandHeldsCheckInOut ON HandHelds.HandHeldID = HandHeldsCheckInOut.HandHeldID INNER JOIN
                         CheckInOutStates ON HandHeldsCheckInOut.CheckInOutStateID = CheckInOutStates.CheckInOutStateID INNER JOIN
                         Persons ON Ahwal.AhwalID = Persons.AhwalID AND HandHeldsCheckInOut.PersonID = Persons.PersonID INNER JOIN
                         Ranks ON Persons.RankID = Ranks.RankID

WHERE        (Ahwal.AhwalID IN
                             (SELECT        AhwalID
                               FROM            UsersRolesMap
                               WHERE        (UserID = @UserID) AND (UserRoleID = @UserRoleID)))
ORDER BY HandHeldsCheckInOut.TimeStamp">
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
                    <dx:ASPxTimer ID="ASPxTimer1" runat="server" OnTick="ASPxTimer1_Tick" Interval="30000"></dx:ASPxTimer>

</asp:Content>
