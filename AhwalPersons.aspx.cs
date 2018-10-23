using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PatrolWebApp
{
    public partial class Ahwal1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("Login.aspx");
            var user = (User)Session["User"];
            Session["UserID"] = user.UserID;
            Session["UserRoleID"] = Core.Handler_User.User_Role_Ahwal;
            Person_Add_PopUp.Width = 400;
            Person_Add_PopUp.Height = 400;
            Person_Add_PopUp.ShowCloseButton = true;
            if (!Page.IsPostBack)
            {
                if (Persons_Add_Ahwal_CombobBox.Items.Count > 0)
                {
                    Persons_Add_Ahwal_CombobBox.SelectedIndex = 0;
                }
                AhwalsPersonsGrid.DataBind();
            }
            ScriptManager1.RegisterPostBackControl(AhwalsPersonsGrid);

        }

        protected void AhwalsPersonsGrid_ContextMenuItemClick(object sender, DevExpress.Web.ASPxGridViewContextMenuItemClickEventArgs e)
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
                    AhwalPersonsGridExporter.WritePdfToResponse();
                    break;
                case "تقرير Excel":
                    AhwalPersonsGridExporter.WriteXlsToResponse();
                    break;
            }
        }

        protected void AhwalsPersonsGrid_FillContextMenuItems(object sender, DevExpress.Web.ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                e.Items.Add("جديد", "جديد");
                e.Items.Add("تعديل", "تعديل");
                e.Items.Add("حذف", "حذف");
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

        protected void Persons_Add_SubmitButton_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            Person p = new Person();
            Persons_Add_status_label.Text = "";
            var ahwalid = Persons_Add_Ahwal_CombobBox.SelectedItem;
            if (ahwalid == null)
            {
                Persons_Add_status_label.Text = "يرجى اختيار الاحوال";
                return;
            }
            var rankid = Persons_Add_Rank_ComboBox.SelectedItem;
            if (rankid == null)
            {
                Persons_Add_status_label.Text = "يرجى اختيار الرتبه";
                return;
            }
            var milnumber = Persons_Add_MilNumber_txt.Text.Trim();
            if (milnumber=="" || milnumber == null)
            {
                Persons_Add_status_label.Text = "يرجى ادخال الرقم العسكري";
                return;
            }
            p.AhwalID = Convert.ToInt64(Persons_Add_Ahwal_CombobBox.SelectedItem.Value.ToString());
            p.MilNumber = Convert.ToInt64(Persons_Add_MilNumber_txt.Text.Trim());
            p.RankID = Convert.ToInt16(Persons_Add_Rank_ComboBox.SelectedItem.Value.ToString());
            p.Name = Persons_Add_Name_txt.Text.Trim();
            p.Mobile = Persons_Add_Mobile_txt.Text.Trim();
            p.FixedCallerID = Persons_Add_FixedCaller.Text.Trim();
            OperationLog result;
            if (Request.Form["PersonAddMethod"] == "UPDATE")
            {
                p.PersonID = Convert.ToInt64(Request.Form["PersonID"]);
                result = Core.Handler_Person.Update_Person(user, p);
                Person_Add_PopUp.ShowOnPageLoad = false; //we need to hide popup after updating
            }
            else
            {
                result = Core.Handler_Person.Add_Person(user, p);
                Person_Add_PopUp.ShowOnPageLoad = true;
            }

            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                Persons_Add_Name_txt.Text = "";
                // Patrol_Add_Model_txt.Text = "";
                Persons_Add_MilNumber_txt.Text = "";
                Persons_Add_Mobile_txt.Text = "";
                Persons_Add_FixedCaller.Text = "";
                
                AhwalsPersonsGrid.DataBind();
            }
            else
            {
                Persons_Add_status_label.Text = result.Text;
            }

        }

        protected void ASPxTimer1_Tick(object sender, EventArgs e)
        {
            AhwalsPersonsGrid.DataBind();
            ASPxTimer1.Interval = 30000;
        }
    }
}