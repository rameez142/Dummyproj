using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PatrolWebApp
{
    public partial class MaintenanceHandHelds : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            var user = (User)Session["User"];
            HandHeld_Add_PopUp.Width = 400;
            HandHeld_Add_PopUp.Height = 400;
            HandHeld_Add_PopUp.ShowCloseButton = true;
            Session["UserID"] = user.UserID;
            Session["UserRoleID"] = Core.Handler_User.User_Role_Maintenance;
            if (!Page.IsPostBack)
            {
                if (HandHeld_Add_Ahwal_ComboBox.Items.Count > 0)
                {
                    HandHeld_Add_Ahwal_ComboBox.SelectedIndex = 0;
                }
                HandHeldsGrid.DataBind();
            }
            
            ScriptManager1.RegisterPostBackControl(HandHeldsGrid);

        }
        protected void HandHeld_Add_SubmitBtn_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            HandHeld h = new HandHeld();
            h.AhwalID = Convert.ToInt64(HandHeld_Add_Ahwal_ComboBox.SelectedItem.Value.ToString());
            h.Serial = HandHeld_Add_Serial_txt.Text.Trim();

            h.Defective = HandHeld_Add_Defective_checkbox.Checked ? Convert.ToByte(1) : Convert.ToByte(0);
            OperationLog result;
            if (Request.Form["HandHeldAddMethod"] == "UPDATE")
            {
                h.HandHeldID = Convert.ToInt64(Request.Form["HandHeldID"]);
                result = Core.Handler_HandHelds.Update_HandHeld(user, h);
                HandHeld_Add_PopUp.ShowOnPageLoad = false; //we need to hide popup after updating
            }
            else
            {
                result = Core.Handler_HandHelds.Add_HandHeldr(user, h);
                HandHeld_Add_PopUp.ShowOnPageLoad = true;
            }

            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                HandHeld_Add_Serial_txt.Text = "";
                // Patrol_Add_Model_txt.Text = "";

                HandHeld_Add_Defective_checkbox.Checked = false;
                HandHeld_Add_StatusLabel.Text = result.Text;
                HandHeldsGrid.DataBind();
            }
            else
            {
                HandHeld_Add_StatusLabel.Text = result.Text;
            }
        }

        protected void HandHeldsGrid_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            switch (e.Item.Name)
            {
                case "جديد":
                    break;
                case "تعديل":
                    break;
                case "حذف":
                    break;
                case "تقرير PDF":
                    HandHeldsGrid_GridExporter.WritePdfToResponse();
                    break;
                case "تقرير Excel":
                    HandHeldsGrid_GridExporter.WriteXlsToResponse();
                    break;
            }
        }

        protected void HandHeldsGrid_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {

                e.Items.Add("جديد", "جديد");
                e.Items.Add("تعديل", "تعديل");
                e.Items.Add("حذف", "حذف");
                var item = e.CreateItem("تقرير", "تقرير");
                item.BeginGroup = true;
                HanhHeldsGrid_AddMenuSubItem(item, "PDF", "تقرير PDF", @"~/Content/ExportToPdf.png", true);
                HanhHeldsGrid_AddMenuSubItem(item, "XLS", "تقرير Excel", @"~/Content/ExportToXls.png", true);
                e.Items.Add(item);
            }
        }
        private static void HanhHeldsGrid_AddMenuSubItem(GridViewContextMenuItem parentItem, string text, string name, string imageUrl, bool isPostBack)
        {
            var exportToXlsItem = parentItem.Items.Add(text, name);
            exportToXlsItem.Image.Url = imageUrl;
        }

        protected void ASPxTimer1_Tick(object sender, EventArgs e)
        {
            HandHeldsGrid.DataBind();
            ASPxTimer1.Interval = 30000;
        }
    }
}