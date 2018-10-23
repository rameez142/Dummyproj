<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="IncidentsTypes.aspx.cs" Inherits="PatrolWebApp.IncidentsTypes" %>
<asp:Content ID="IncidentTypesContent" ContentPlaceHolderID="MainContent" runat="server">
    <dx:ASPxGridView ID="IncidentTypesGrid" runat="server" Theme="DevEx" Width="100%" AutoGenerateColumns="False" Font-Size="Larger" 
         OnRowInserting="IncidentTypesGrid_RowInserting"
         OnRowUpdating="IncidentTypesGrid_RowUpdating"
        DataSourceID="SqlDataSource1" KeyFieldName="IncidentTypeID">
        <Settings ShowFilterRow="True" />
        <SettingsDataSecurity AllowDelete="False" />
        <Columns>
            <dx:GridViewCommandColumn ShowClearFilterButton="True" ShowEditButton="True" ShowNewButtonInHeader="True" VisibleIndex="0">
            </dx:GridViewCommandColumn>
            <dx:GridViewDataTextColumn FieldName="IncidentTypeID" Visible="false" ReadOnly="True" VisibleIndex="1">
            </dx:GridViewDataTextColumn>
            <dx:GridViewDataTextColumn FieldName="Name" Width="90%" Caption="نوع البلاغ" VisibleIndex="2">
            </dx:GridViewDataTextColumn>
        </Columns>
        <Settings UseFixedTableLayout="true" />
        <SettingsEditing Mode="Inline" />
        <SettingsBehavior AllowGroup="false" AllowSelectByRowClick="false" AllowFocusedRow="false"  />
        <SettingsPager PageSize="100" />
        <SettingsText CommandNew="جديد" CommandEdit="تحرير" CommandCancel="الغاء" CommandUpdate="موافق" />
    </dx:ASPxGridView>
   
        
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PatrolsConnectionString %>" SelectCommand="SELECT * FROM [IncidentsTypes]"></asp:SqlDataSource>
   
        
</asp:Content>
