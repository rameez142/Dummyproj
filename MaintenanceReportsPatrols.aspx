<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="MaintenanceReportsPatrols.aspx.cs" Inherits="PatrolWebApp.MaintenanceReports" %>

<%@ Register Assembly="DevExpress.Web.ASPxPivotGrid.v18.1, Version=18.1.6.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxPivotGrid" TagPrefix="dx" %>

<asp:Content ID="MaintenanceReportsPatrolsContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">

        function MRPatrolsGrid_OnContextMenu(s, e) {
                s.SetFocusedRowIndex(e.index);
                e.showBrowserMenu = false;
            }
           
        function MRPatrolsGrid_OnContextMenuItemClick(sender, args) {
                if (args.item.name == "تقرير PDF" || args.item.name == "تقرير Excel") {
                    args.processOnServer = true;
                    args.usePostBack = true;
                } 
            }
            </script>
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel" runat="server" UpdateMode="Always" >
        <ContentTemplate>
    <dx:ASPxGridView ID="MRPatrolsGrid" ClientInstanceName="MRPatrolsGrid" runat="server"
        AutoGenerateColumns="False" Width="100%" Theme="DevEx" Font-Size="Medium" KeyFieldName="PatrolCheckInOutID"
        OnContextMenuItemClick="MRPatrolsGrid_ContextMenuItemClick"
        OnFillContextMenuItems="MRPatrolsGrid_FillContextMenuItems" DataSourceID="PatrolsReportsDataSource">
        <SettingsBehavior AllowSort="false" />
        <Settings ShowFilterRow="True" />
        <SettingsDataSecurity AllowDelete="False" AllowEdit="False" AllowInsert="False" />
        <Columns>
            <dx:GridViewDataTextColumn FieldName="PatrolCheckInOutID" VisibleIndex="0" Visible="false" ReadOnly="True">
                <EditFormSettings Visible="False" />
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataDateColumn FieldName="TimeStamp" Caption="الوقت والتاريخ" VisibleIndex="1" Settings-AllowHeaderFilter="True" PropertiesDateEdit-DisplayFormatString="G">
                 <Settings AllowAutoFilter="False" />
                <SettingsHeaderFilter Mode="DateRangePicker" ></SettingsHeaderFilter>
                </dx:GridViewDataDateColumn>
            <dx:GridViewDataComboBoxColumn FieldName="CheckInOutStateID" Caption="الحالة" VisibleIndex="2">
                <PropertiesComboBox TextField="Name" ValueField="CheckInOutStateID" DataSourceID="CheckInOutDataSource"></PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataComboBoxColumn FieldName="AhwalID" Caption="الأحوال" VisibleIndex="3">
                <PropertiesComboBox TextField="Name" ValueField="AhwalID" DataSourceID="AhwalDataSroucce"></PropertiesComboBox>
            </dx:GridViewDataComboBoxColumn>
            <dx:GridViewDataTextColumn FieldName="PlateNumber" Caption="رقم اللوحة" VisibleIndex="4">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="Type" Caption="النوع" VisibleIndex="5">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="Model" Caption="الموديل" VisibleIndex="6">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="MilNumber" Caption="الرقم العسكري" VisibleIndex="7">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="PersonRank" Caption="الرتبه" VisibleIndex="8">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="PersonName" Caption="الاسم" VisibleIndex="9">
            </dx:GridViewDataTextColumn>
            




        </Columns>
            <SettingsBehavior AllowSelectByRowClick="false" AllowFocusedRow="true" />
            <SettingsContextMenu Enabled="true"  RowMenuItemVisibility-Refresh="false" />
            <SettingsPager PageSize="80"/>
        <ClientSideEvents ContextMenu="MRPatrolsGrid_OnContextMenu" ContextMenuItemClick="function(s,e) { MRPatrolsGrid_OnContextMenuItemClick(s, e); }" />

    </dx:ASPxGridView>
    <dx:ASPxGridViewExporter ID="MRPatrolReport_Exporter" runat="server" GridViewID="MRPatrolsGrid"></dx:ASPxGridViewExporter>
    <asp:SqlDataSource ID="CheckInOutDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT [CheckInOutStateID], [Name] FROM [CheckInOutStates] WHERE ([Name] &lt;&gt; @Name)">
        <SelectParameters>
            <asp:Parameter DefaultValue="NONE" Name="Name" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="PatrolsReportsDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT        PatrolCheckInOut.PatrolCheckInOutID, CheckInOutStates.Name AS StateName, Ahwal.AhwalID, Ahwal.Name AS AhwalName, PatrolCars.PlateNumber, PatrolCars.Model, PatrolCars.Type, Persons.MilNumber, 
                         Ranks.Name AS PersonRank, Persons.Name AS PersonName, PatrolCheckInOut.TimeStamp, CheckInOutStates.CheckInOutStateID
FROM            Ahwal INNER JOIN
                         PatrolCars ON Ahwal.AhwalID = PatrolCars.AhwalID INNER JOIN
                         PatrolCheckInOut ON PatrolCars.PatrolID = PatrolCheckInOut.PatrolID INNER JOIN
                         CheckInOutStates ON PatrolCheckInOut.CheckInOutStateID = CheckInOutStates.CheckInOutStateID INNER JOIN
                         Persons ON Ahwal.AhwalID = Persons.AhwalID AND PatrolCheckInOut.PersonID = Persons.PersonID INNER JOIN
                         Ranks ON Persons.RankID = Ranks.RankID
WHERE        (Ahwal.AhwalID IN
                             (SELECT        AhwalID
                               FROM            UsersRolesMap
                               WHERE        (UserID = @UserID) AND (UserRoleID = @UserRoleID)))
ORDER BY PatrolCheckInOut.TimeStamp">
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
