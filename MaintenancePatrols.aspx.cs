using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PatrolWebApp
{
    public partial class Maintenance : System.Web.UI.Page
    {
        //protected static DataTable Patrol_DataTable = new DataTable();

 
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            var user = (User)Session["User"];
            //MaintenancePanel_Patrols.Visible = true;
            Patrols_Add_Popup.Width = 400;
            Patrols_Add_Popup.Height = 400;
            Patrols_Add_Popup.ShowCloseButton = true;
            Session["UserID"] = user.UserID;
            Session["UserRoleID"] = Core.Handler_User.User_Role_Maintenance;

           
            if (!Page.IsPostBack)
            {
                if (Patrol_Add_Ahwal_ComboBox.Items.Count > 0)
                {
                    Patrol_Add_Ahwal_ComboBox.SelectedIndex = 0;
                }
                PatrolsGrid.DataBind();
            }
            ScriptManager1.RegisterPostBackControl(PatrolsGrid);


        }

        protected void Patrol_Add_SubmitBtn_Click(object sender, EventArgs e)
        {
            
            var user = (User)Session["User"];
            PatrolCar p = new PatrolCar();
            p.AhwalID =Convert.ToInt64(Patrol_Add_Ahwal_ComboBox.SelectedItem.Value.ToString());
            p.PlateNumber = Patrol_Add_PlateNumber_txt.Text.Trim();
            p.Model = Patrol_Add_Model_txt.Text.Trim();
            p.Type = Patrol_Add_Type_txt.Text;
            p.VINNumber = Patrol_Add_VINNumber_txt.Text.Trim();
            p.Rental = Patrol_Add_Rental_checkbox.Checked ? Convert.ToByte(1) : Convert.ToByte(0);
            p.Defective = Patrol_Add_Defective_checkbox.Checked ? Convert.ToByte(1) : Convert.ToByte(0);
            OperationLog result ;
            if (Request.Form["PatrolAddMethod"]=="UPDATE")
            {
                p.PatrolID = Convert.ToInt64(Request.Form["PatrolID"]);
                result = Core.Handler_PatrolCars.Update_PatrolCar(user, p);
                Patrols_Add_Popup.ShowOnPageLoad = false; //we need to hide popup after updating
            }
            else
            {
                 result = Core.Handler_PatrolCars.Add_PatrolCar(user, p);
                 Patrols_Add_Popup.ShowOnPageLoad = true;
            }
            
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                Patrol_Add_PlateNumber_txt.Text = "";
               // Patrol_Add_Model_txt.Text = "";
                Patrol_Add_VINNumber_txt.Text = "";
                Patrol_Add_Rental_checkbox.Checked = false;
                Patrol_Add_Defective_checkbox.Checked = false;
                Patrol_add_status_label.Text = result.Text;
                PatrolsGrid.DataBind();
            }
            else
            {
                Patrol_add_status_label.Text = result.Text;
            }
           
            
        }

        protected void PatrolsGrid_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
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
                    PatrolGrid_GridExporter.WritePdfToResponse();
                    break;
                case "تقرير Excel":
                    PatrolGrid_GridExporter.WriteXlsToResponse();
                    break;
            }
        }

        protected void PatrolsGrid_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                
                e.Items.Add("جديد", "جديد");
                e.Items.Add("تعديل", "تعديل");
                e.Items.Add("حذف", "حذف");
                var item = e.CreateItem("تقرير", "تقرير");
                item.BeginGroup = true;
                PatrolsGrid_AddMenuSubItem(item, "PDF", "تقرير PDF", @"~/Content/ExportToPdf.png", true);
                PatrolsGrid_AddMenuSubItem(item, "XLS", "تقرير Excel", @"~/Content/ExportToXls.png", true);
                e.Items.Add(item);
            }
        }
        private static void PatrolsGrid_AddMenuSubItem(GridViewContextMenuItem parentItem, string text, string name, string imageUrl, bool isPostBack)
        {
            var exportToXlsItem = parentItem.Items.Add(text, name);
            exportToXlsItem.Image.Url = imageUrl;
        }

        protected void ASPxTimer1_Tick(object sender, EventArgs e)
        {
            PatrolsGrid.DataBind();
            ASPxTimer1.Interval = 30000;
        }
    }
}