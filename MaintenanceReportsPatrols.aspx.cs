using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PatrolWebApp
{
    public partial class MaintenanceReports : System.Web.UI.Page
    {
             protected void Page_Load(object sender, EventArgs e)
        {

            MRPatrolsGrid.SettingsPopup.HeaderFilter.Width = 300;
            MRPatrolsGrid.SettingsPopup.HeaderFilter.Height =  320;
            if (Session["User"] == null)
                Response.Redirect("Login.aspx");
            var user = (User)Session["User"];
            Session["UserID"] = user.UserID;
            Session["UserRoleID"] = Core.Handler_User.User_Role_Maintenance;
            ScriptManager1.RegisterPostBackControl(MRPatrolsGrid);

        }

        protected void MRPatrolsGrid_ContextMenuItemClick(object sender, DevExpress.Web.ASPxGridViewContextMenuItemClickEventArgs e)
        {
            switch (e.Item.Name)
            {
                case "تقرير PDF":
                    MRPatrolReport_Exporter.WritePdfToResponse();
                    break;
                case "تقرير Excel":
                    MRPatrolReport_Exporter.WriteXlsToResponse();
                    break;
            }
        }

        protected void MRPatrolsGrid_FillContextMenuItems(object sender, DevExpress.Web.ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {

                var item = e.CreateItem("تقرير", "تقرير");
                item.BeginGroup = true;
                MRReportPatrolsGridrid_AddMenuSubItem(item, "PDF", "تقرير PDF", @"~/Content/ExportToPdf.png", true);
                MRReportPatrolsGridrid_AddMenuSubItem(item, "XLS", "تقرير Excel", @"~/Content/ExportToXls.png", true);
                e.Items.Add(item);
            }
        }
        private static void MRReportPatrolsGridrid_AddMenuSubItem(GridViewContextMenuItem parentItem, string text, string name, string imageUrl, bool isPostBack)
        {
            var exportToXlsItem = parentItem.Items.Add(text, name);
            exportToXlsItem.Image.Url = imageUrl;
        }

        protected void ASPxTimer1_Tick(object sender, EventArgs e)
        {
            MRPatrolsGrid.DataBind();
            ASPxTimer1.Interval = 30000;
        }
    }
} 