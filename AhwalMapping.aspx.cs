using DevExpress.Web;
using DevExpress.XtraPrinting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Data;

namespace PatrolWebApp
{
    public partial class AhwalMapping1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {


            if (Session["User"] == null)
                Response.Redirect("Login.aspx");
            var user = (User)Session["User"];
            Session["UserID"] = user.UserID;
            Session["UserRoleID"] = Core.Handler_User.User_Role_Ahwal;
            
           ScriptManager1.RegisterPostBackControl(AhwalMappingGrid.FindTitleTemplateControl("GenerateReportButton"));
            //load user default layout prefernce

            if (Page.IsPostBack)
                return;
            AhwalMapping_States_PopUp.Width = 400;
            AhwalMapping_States_PopUp.Height = 400;
            AhwalMapping_States_PopUp.ShowCloseButton = true;
            AhwalMapping_States_PopUp.HeaderText = "آخر كمن حاله";
            AhwalMapping_Add_PopUp.Width = 400;
            AhwalMapping_Add_PopUp.Height = 400;
            AhwalMapping_Add_PopUp.ShowCloseButton = true;
            AhwalMapping_CheckInOut_PopUp.Width = 400;
            AhwalMapping_CheckInOut_PopUp.Height = 400;
            AhwalMapping_CheckInOut_PopUp.ShowCloseButton = true;


            //LiveCaller_PopUp.Width = 300;
            //LiveCaller_PopUp.Height = 200;
            //LiveCaller_PopUp.ShowCloseButton = true;
            //LiveCaller_PopUp.HeaderText = "المتحدث الآن...";
        }

        protected void AhwalMappingGrid_ContextMenuItemClick(object sender, DevExpress.Web.ASPxGridViewContextMenuItemClickEventArgs e)
        {
            var user = (User)Session["User"];
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);

            switch (e.Item.Name)
            {
                case "جديد":
                    break;
                case "حفظ عرض المجموعات":
                    break;
                case "فتح كل المجموعات":
                   
                    break;
                case "اغلاق كل المجموعات":
                    break;
                case "حذف":

                    if (user == null)
                        return;
                    var row = AhwalMappingGrid.GetDataRow(AhwalMappingGrid.FocusedRowIndex);
                    if (row != null)
                    {
                        var mappingid = Convert.ToInt64(row["AhwalMappingID"].ToString());
                        if (mappingid > 0)
                        {
                            var result = Core.Handler_AhwalMapping.DeleteMapping(user, mappingid);
                            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                            {
                                AhwalMappingGrid.DataBind();
                            }
                        }
                    }
                    break;
                case "غياب":
                case "مرضيه":
                case "اجازه":
                    if (user == null)
                        return;
                    var rowState = AhwalMappingGrid.GetDataRow(AhwalMappingGrid.FocusedRowIndex);
                    if (rowState != null)
                    {
                        var mappingid = Convert.ToInt64(rowState["AhwalMappingID"].ToString());
                        if (mappingid > 0)
                        {
                            var personState = new PatrolPersonState();
                            if (e.Item.Name == "غياب")
                            {
                                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Absent;
                            }
                            else if (e.Item.Name == "مرضيه")
                            {
                                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Sick;
                            }
                            else if (e.Item.Name == "اجازه")
                            {
                                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Off;
                            }
                            var result = Core.Handler_AhwalMapping.Ahwal_ChangePersonState(user, mappingid, personState);
                            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                            {
                                AhwalMappingGrid.DataBind();
                            }
                        }
                    }
                    break;
                case "آخر كمن حاله":
                        
                      
                    break;
                case "كشف PDF":
                    
                    break;
            }
        }
        //public static void WriteResponse(HttpResponse response, byte[] filearray, string type)
        //{
        //    response.ClearContent();
        //    response.Buffer = true;
        //    response.Cache.SetCacheability(HttpCacheability.Private);
        //    response.ContentType = "application/pdf";
        //    ContentDisposition contentDisposition = new ContentDisposition();
        //    contentDisposition.FileName = "AhwalMapping.pdf";
        //    contentDisposition.DispositionType = type;
        //    response.AddHeader("Content-Disposition", contentDisposition.ToString());
        //    response.BinaryWrite(filearray);
        //    HttpContext.Current.ApplicationInstance.CompleteRequest();
        //    try
        //    {
        //        response.End();
        //    }
        //    catch (System.Threading.ThreadAbortException)
        //    {
        //    }

        //}

        protected void AhwalMappingGrid_FillContextMenuItems(object sender, DevExpress.Web.ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                //e.Items.Add("جديد", "جديد");
                //var itemGroup = e.CreateItem("المجموعات", "المجموعات");
                //itemGroup.Items.Add("حفظ عرض المجموعات", "حفظ عرض المجموعات");
                //itemGroup.Items.Add("فتح كل المجموعات", "فتح كل المجموعات");
                //itemGroup.Items.Add("اغلاق كل المجموعات", "اغلاق كل المجموعات");
                //e.Items.Add(itemGroup);
                e.Items.Add("حذف", "حذف");
                e.Items.Add("آخر كمن حاله", "آخر كمن حاله");
                var itemState = e.CreateItem("حاله", "حاله");
                itemState.BeginGroup = true;
                itemState.Items.Add("غياب", "غياب");
                itemState.Items.Add("اجازه", "اجازه");
                itemState.Items.Add("مرضيه", "مرضيه");
                e.Items.Add(itemState);
                //var itemPDF = e.CreateItem("كشف PDF", "كشف PDF");
                //itemPDF.Image.Url = @"~/Content/ExportToPdf.png";
                //e.Items.Add(itemPDF);
            }
        }
        //private static void MappingGridrid_AddMenuSubItem(GridViewContextMenuItem parentItem, string text, string name, string imageUrl, bool isPostBack)
        //{
        //    var exportToXlsItem = parentItem.Items.Add(text, name);
        //    exportToXlsItem.Image.Url = imageUrl;
        //}

        protected void AhwalMapping_Add_SubmitButton_Click(object sender, EventArgs e)
        {

            var selectedRole = AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem;
            if (selectedRole == null)
            {
                AhwalMapping_Add_status_label.Text = "يرجى اختيار المسؤولية";
                return;
            }
            var personSelection = AhwalMapping_Add_Person_GridLookup.GridView.GetRowValues(AhwalMapping_Add_Person_GridLookup.GridView.FocusedRowIndex, new string[] { "MilNumber" });
            if (personSelection == null)
            {
                AhwalMapping_Add_status_label.Text = "يرجى اختيار الفرد";
                return;
            }
            var user = (User)Session["User"];
            var personMilNumber = Convert.ToInt64(personSelection.ToString());
            // var personID = AhwalMapping_Add_Person_GridLookup.GridView.GetSelectedFieldValues(new string[] { "MilNumber" });
            var person = Core.Handler_Person.GetPersonForUserForRole(user, personMilNumber, Core.Handler_User.User_Role_Ahwal);
            if (person == null)
            {
                AhwalMapping_Add_status_label.Text = "لم يتم العثور على الفرد";
                return;
            }

            var m = new AhwalMapping();
            if (Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_CaptainAllSectors ||
               Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_CaptainShift)
            {

                var shiftSelection = AhwalMapping_Add_Shift_CombobBox.SelectedItem;
                if (shiftSelection == null)
                {
                    AhwalMapping_Add_status_label.Text = "يرجى اختيار الشفت";
                    return;
                }
                var personID = person.PersonID;
                m.AhwalID = person.AhwalID;
                m.SectorID = Core.Handler_AhwalMapping.Sector_Public;
                //the first result of an ahwal will alway be the generic public sector
                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
                var cityID = db.CityGroups.FirstOrDefault<CityGroup>(ec => ec.AhwalID == person.AhwalID);
                m.CityGroupID = cityID.CityGroupID;// Core.Handler_AhwalMapping.CityGroup_Sector_Public_CityGroupNone;
                m.ShiftID = Convert.ToInt16(shiftSelection.Value.ToString());
                m.PatrolRoleID = Convert.ToInt16(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString());
                m.PersonID = personID;
                OperationLog result;
                if (Request.Form["AhwalMappingAddMethod"] == "UPDATE")
                {
                    m.AhwalMappingID = Convert.ToInt64(Request.Form["AhwalMappingID"]);
                    result = Core.Handler_AhwalMapping.UpDateMapping(user, m);
                }
                else
                {
                    result = Core.Handler_AhwalMapping.AddNewMapping(user, m);
                }
                AhwalMapping_Add_status_label.Text = result.Text;
                AhwalMapping_Add_Person_GridLookup.Text = "";
                AhwalMapping_Add_Person_GridLookup.Focus();

            }
            else if (Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_CaptainSector
               || Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_SubCaptainSector)
            {
                var shiftSelection = AhwalMapping_Add_Shift_CombobBox.SelectedItem;
                if (shiftSelection == null)
                {
                    AhwalMapping_Add_status_label.Text = "يرجى اختيار الشفت";
                    return;
                }
                var personID = person.PersonID;
                m.AhwalID = person.AhwalID;
                var sectorSelection = AhwalMapping_Add_Sector_CombobBox.SelectedItem;
                if (sectorSelection == null)
                {
                    AhwalMapping_Add_status_label.Text = "يرجى اختيار القطاع";
                    return;
                }

                m.SectorID = Convert.ToInt16(AhwalMapping_Add_Sector_CombobBox.SelectedItem.Value.ToString());
                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
                //the first result of an ahwal and sector, will alwayy be considered as the public sector
                var cityID = db.CityGroups.FirstOrDefault<CityGroup>(ec => ec.AhwalID == person.AhwalID && ec.SectorID == m.SectorID);
                m.CityGroupID = cityID.CityGroupID;// Core.Handler_AhwalMapping.CityGroup_Sector_Public_CityGroupNone;
                m.ShiftID = Convert.ToInt16(AhwalMapping_Add_Shift_CombobBox.SelectedItem.Value.ToString());
                m.PatrolRoleID = Convert.ToInt16(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString());
                m.PersonID = personID;
                OperationLog result;
                if (Request.Form["AhwalMappingAddMethod"] == "UPDATE")
                {
                    m.AhwalMappingID = Convert.ToInt64(Request.Form["AhwalMappingID"]);
                    result = Core.Handler_AhwalMapping.UpDateMapping(user, m);
                }
                else
                {
                    result = Core.Handler_AhwalMapping.AddNewMapping(user, m);
                    AhwalMapping_Add_Person_GridLookup.Text = "";
                }
                AhwalMapping_Add_status_label.Text = result.Text;

                AhwalMapping_Add_Person_GridLookup.Focus();
            }
            else if (Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_Associate)
            {

                var associateSelectionmappingID = AhwalMapping_Add_AssociateTo_GridLookup.GridView.GetRowValues(AhwalMapping_Add_AssociateTo_GridLookup.GridView.FocusedRowIndex, new string[] { "AhwalMappingID" });
                if (associateSelectionmappingID == null)
                {
                    AhwalMapping_Add_status_label.Text = "يرجى اختيار المرافق";
                    return;
                }

                var ahwalMappingForAssociate = Core.Handler_AhwalMapping.GetMappingByID(user, Convert.ToInt64(associateSelectionmappingID.ToString()), Core.Handler_User.User_Role_Ahwal);
                if (ahwalMappingForAssociate != null)
                {
                    var personID = person.PersonID;
                    if (personID == ahwalMappingForAssociate.PersonID)
                    {
                        AhwalMapping_Add_status_label.Text = "المرافق نفس الفرد، ماهذا ؟؟؟؟";
                        return;
                    }

                    m.AhwalID = ahwalMappingForAssociate.AhwalID;
                    m.PersonID = personID;
                    m.AssocitatePersonID = ahwalMappingForAssociate.PersonID;
                    m.SectorID = ahwalMappingForAssociate.SectorID;
                    m.CityGroupID = ahwalMappingForAssociate.CityGroupID;
                    m.ShiftID = ahwalMappingForAssociate.ShiftID;
                    m.PatrolRoleID = Convert.ToInt16(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString());
                    OperationLog result;
                    if (Request.Form["AhwalMappingAddMethod"] == "UPDATE")
                    {
                        m.AhwalMappingID = Convert.ToInt64(Request.Form["AhwalMappingID"]);
                        result = Core.Handler_AhwalMapping.UpDateMapping(user, m);
                    }
                    else
                    {
                        result = Core.Handler_AhwalMapping.AddNewMapping(user, m);
                        AhwalMapping_Add_Person_GridLookup.Text = "";
                        AhwalMapping_Add_AssociateTo_GridLookup.Text = "";
                    }
                    AhwalMapping_Add_status_label.Text = result.Text;

                    AhwalMapping_Add_Person_GridLookup.Focus();
                }

            }
            else
            {
                var shiftSelection = AhwalMapping_Add_Shift_CombobBox.SelectedItem;
                if (shiftSelection == null)
                {
                    AhwalMapping_Add_status_label.Text = "يرجى اختيار الشفت";
                    return;
                }
                var personID = person.PersonID;
                m.AhwalID = person.AhwalID;
                var sectorSelection = AhwalMapping_Add_Sector_CombobBox.SelectedItem.Value;
                if (sectorSelection == null)
                {
                    AhwalMapping_Add_status_label.Text = "يرجى اختيار القطاع";
                    return;
                }
                var citySelection = AhwalMapping_Add_CityGroup_CombobBox.SelectedItem.Value;
                if (citySelection == null)
                {
                    AhwalMapping_Add_status_label.Text = "يرجى اختيار المنطقة";
                    return;
                }
                m.SectorID = Convert.ToInt16(AhwalMapping_Add_Sector_CombobBox.SelectedItem.Value.ToString());
                m.CityGroupID = Convert.ToInt16(AhwalMapping_Add_CityGroup_CombobBox.SelectedItem.Value.ToString());
                m.ShiftID = Convert.ToInt16(AhwalMapping_Add_Shift_CombobBox.SelectedItem.Value.ToString());
                m.PatrolRoleID = Convert.ToInt16(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString());
                m.PersonID = personID;
                OperationLog result;
                if (Request.Form["AhwalMappingAddMethod"] == "UPDATE")
                {
                    m.AhwalMappingID = Convert.ToInt64(Request.Form["AhwalMappingID"]);
                    result = Core.Handler_AhwalMapping.UpDateMapping(user, m);
                }
                else
                {
                    result = Core.Handler_AhwalMapping.AddNewMapping(user, m);
                    AhwalMapping_Add_Person_GridLookup.Text = "";
                }

                AhwalMapping_Add_status_label.Text = result.Text;

                AhwalMapping_Add_Person_GridLookup.Focus();
            }
            AhwalMapping_Add_Person_GridLookup.GridView.Selection.UnselectAll();
            AhwalMappingGrid.DataBind();
            //Core.Handler_AhwalMapping.AddNewMapping(user, m);
        }

        protected void AhwalMapping_Add_PatrolRole_ComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_CaptainAllSectors ||
                Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_CaptainShift)
            {
                AhwalMapping_Add_Shift_Label.Visible = true;
                AhwalMapping_Add_Sector_Label.Visible = false;
                AhwalMapping_Add_CityGroup_Label.Visible = false;
                AhwalMapping_Add_AssociateTo_Label.Visible = false;


                AhwalMapping_Add_Shift_CombobBox.Visible = true;
                AhwalMapping_Add_Sector_CombobBox.Visible = false;
                AhwalMapping_Add_CityGroup_CombobBox.Visible = false;
                AhwalMapping_Add_AssociateTo_GridLookup.Visible = false;
            }
            else if (Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_CaptainSector
               || Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_SubCaptainSector)
            {
                AhwalMapping_Add_Shift_Label.Visible = true;
                AhwalMapping_Add_Sector_Label.Visible = true;
                AhwalMapping_Add_CityGroup_Label.Visible = false;
                AhwalMapping_Add_AssociateTo_Label.Visible = false;


                AhwalMapping_Add_Shift_CombobBox.Visible = true;
                AhwalMapping_Add_Sector_CombobBox.Visible = true;
                AhwalMapping_Add_CityGroup_CombobBox.Visible = false;
                AhwalMapping_Add_AssociateTo_GridLookup.Visible = false;
            }
            else if (Convert.ToInt64(AhwalMapping_Add_PatrolRole_ComboBox.SelectedItem.Value.ToString()) == Core.Handler_AhwalMapping.PatrolRole_Associate)
            {
                AhwalMapping_Add_Shift_Label.Visible = false;
                AhwalMapping_Add_Sector_Label.Visible = false;
                AhwalMapping_Add_CityGroup_Label.Visible = false;
                AhwalMapping_Add_AssociateTo_Label.Visible = true;


                AhwalMapping_Add_Shift_CombobBox.Visible = false;
                AhwalMapping_Add_Sector_CombobBox.Visible = false;
                AhwalMapping_Add_CityGroup_CombobBox.Visible = false;
                AhwalMapping_Add_AssociateTo_GridLookup.Visible = true;
            }
            else
            {
                AhwalMapping_Add_Shift_Label.Visible = true;
                AhwalMapping_Add_Sector_Label.Visible = true;
                AhwalMapping_Add_CityGroup_Label.Visible = true;
                AhwalMapping_Add_AssociateTo_Label.Visible = false;


                AhwalMapping_Add_Shift_CombobBox.Visible = true;
                AhwalMapping_Add_Sector_CombobBox.Visible = true;
                AhwalMapping_Add_CityGroup_CombobBox.Visible = true;
                AhwalMapping_Add_AssociateTo_GridLookup.Visible = false;
            }
        }

        protected void AhwalMapping_CheckInOut_SubmitButton_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];

            var selectedPerson = AhwalMapping_CheckInOut_MappingPerson.GridView.GetRowValues(AhwalMapping_CheckInOut_MappingPerson.GridView.FocusedRowIndex, new string[] { "MilNumber" });
            if (selectedPerson == null)
            {
                AhwalMapping_CheckInOut_StatusLabel.Text = "يرجى اختيار الفرد";
                return;
            }
            var person = Core.Handler_Person.GetPersonForUserForRole(user, Convert.ToInt64(selectedPerson), Core.Handler_User.User_Role_Ahwal);
            if (person == null)
            {
                AhwalMapping_CheckInOut_StatusLabel.Text = "لم يتم العثور على الفرد";
                return;
            }

            var selectedPatrol = AhwalMapping_CheckInOut_PatrolCar.GridView.GetRowValues(AhwalMapping_CheckInOut_PatrolCar.GridView.FocusedRowIndex, new string[] { "PlateNumber" });
            if (selectedPatrol == null)
            {
                AhwalMapping_CheckInOut_StatusLabel.Text = "يرجى اختيار الدورية";
                return;
            }
            var patrol = Core.Handler_PatrolCars.GetPatrolCarByPlateNumberForUserForRole(user, selectedPatrol.ToString().Trim(), Core.Handler_User.User_Role_Ahwal);
            if (patrol == null)
            {
                AhwalMapping_CheckInOut_StatusLabel.Text = "لم يتم العثور على الدورية";
                return;
            }


            var selectedHandHeld = AhwalMapping_CheckInOut_HandHeld.GridView.GetRowValues(AhwalMapping_CheckInOut_HandHeld.GridView.FocusedRowIndex, new string[] { "Serial" });
            if (selectedHandHeld == null)
            {
                AhwalMapping_CheckInOut_StatusLabel.Text = "يرجى اختيار الجهاز";
                return;
            }
            var handheld = Core.Handler_HandHelds.GetHandHeldBySerialForUserForRole(user, selectedHandHeld.ToString().Trim(), Core.Handler_User.User_Role_Ahwal);



            var personMapping = Core.Handler_AhwalMapping.GetMappingByPersonID(user, person);
            if (personMapping == null)
            {
                AhwalMapping_CheckInOut_StatusLabel.Text = "لم يتم العثور على الفرد في الكشف";
                return;
            }
            //lets see if this person already has devices, if he does, then its checkout, if not, then its checkin
            if (Convert.ToBoolean(personMapping.HasDevices)) //checkout
            {
                if (personMapping.PatrolID != patrol.PatrolID)
                {

                    var getPatrol = new PatrolCar();
                    getPatrol.PatrolID = (int)personMapping.PatrolID;
                    getPatrol.AhwalID = personMapping.AhwalID;
                    var patrolexists = Core.Handler_PatrolCars.GetPatrolCardByID(user, getPatrol);
                    if (patrolexists != null)
                    {
                        AhwalMapping_CheckInOut_StatusLabel.Text = "يجب تسليم نفس الدورية المستلمه رقم: " + patrolexists.PlateNumber;
                        return;
                    }

                }
                if (personMapping.HandHeldID != handheld.HandHeldID)
                {
                    var getHandHeld = new HandHeld();
                    getHandHeld.HandHeldID = (int)personMapping.HandHeldID;
                    getHandHeld.AhwalID = personMapping.AhwalID;
                    var handHeldExist = Core.Handler_HandHelds.GetHandHeldByID(user, getHandHeld);
                    if (handHeldExist != null)
                    {
                        AhwalMapping_CheckInOut_StatusLabel.Text = "يجب تسليم نفس الجهاز المستلم رقم: " + handHeldExist.Serial;
                        return;
                    }
                }
                var result = Core.Handler_AhwalMapping.CheckOutPatrolAndHandHeld(user, personMapping, patrol, handheld);
                AhwalMapping_CheckInOut_StatusLabel.Text = result.Text;
                AhwalMappingGrid.DataBind();
                AhwalMapping_CheckInOut_MappingPerson.Text = "";
                AhwalMapping_CheckInOut_MappingPerson.Focus();
                AhwalMapping_CheckInOut_PatrolCar.Text = "";
                AhwalMapping_CheckInOut_HandHeld.Text = "";

            }
            else
            {//check in
                if (Core.Handler_AhwalMapping.PatrolCarWithSomeOneElse(user, person.PersonID, patrol.PatrolID))
                {
                    AhwalMapping_CheckInOut_StatusLabel.Text = "الدورية بحوزة شخص اخر";
                    return;
                }
                if (Core.Handler_AhwalMapping.HandHeldWithSomeOneElse(user, person.PersonID, handheld.HandHeldID))
                {
                    AhwalMapping_CheckInOut_StatusLabel.Text = "الجهاز بحوزة شخص اخر";
                    return;
                }
                if (Convert.ToBoolean(patrol.Defective))
                {
                    AhwalMapping_CheckInOut_StatusLabel.Text = "هذه الدورية غير صالحه";
                    return;
                }
                if (Convert.ToBoolean(handheld.Defective))
                {
                    AhwalMapping_CheckInOut_StatusLabel.Text = "هذه الجهاز غير صالح";
                    return;
                }
                //ok no body else has, the devices are good and not defected
                var result = Core.Handler_AhwalMapping.CheckInPatrolAndHandHeld(user, personMapping, patrol, handheld);
                AhwalMapping_CheckInOut_StatusLabel.Text = result.Text;
                AhwalMappingGrid.DataBind();
                AhwalMapping_CheckInOut_MappingPerson.Text = "";
                AhwalMapping_CheckInOut_MappingPerson.Focus();

                AhwalMapping_CheckInOut_PatrolCar.Text = "";
                AhwalMapping_CheckInOut_HandHeld.Text = "";
            }
        }

        protected void ASPxTimer1_Tick(object sender, EventArgs e)
        {

            //AhwalMappingGrid.DataBind();
            //ASPxTimer1.Interval = 30000;
        }

        protected void AhwalMapping_Add_Sector_CombobBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            AhwalMapping_Add_CityGroup_CombobBox.DataBind();
        }

        protected void AhwalMappingGrid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            e.Row.BackColor = System.Drawing.Color.White;//set default to white first
            e.Row.ForeColor = System.Drawing.Color.Black;
            e.Row.Font.Bold = false;
            long personState = Convert.ToInt32(e.GetValue("PatrolPersonStateID"));
            var LastStateTimeStamp = e.GetValue("LastStateChangeTimeStamp");
            var incident = e.GetValue("IncidentID");

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_SunRise ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Sea ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Back||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking)
                e.Row.BackColor = System.Drawing.Color.LightGreen;

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Land)
                e.Row.BackColor = System.Drawing.Color.LightGray;

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Away)
                e.Row.BackColor = System.Drawing.Color.Yellow;

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Sick ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Absent ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Off)
                e.Row.BackColor = System.Drawing.Color.PaleVioletRed;

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_WalkingPatrol)
            {
                e.Row.BackColor = System.Drawing.Color.CadetBlue;
            }

            //change associate color
            long patrolRoleID = Convert.ToInt32(e.GetValue("PatrolRoleID"));

            if (patrolRoleID == Core.Handler_AhwalMapping.PatrolRole_Associate)
            {
                e.Row.BackColor = System.Drawing.Color.SandyBrown;
            }

            //if he has incident, this color will override
            if (incident != null && !incident.Equals(DBNull.Value))
            {
                //  e.Row.BackColor = System.Drawing.Color.CadetBlue; //I  love this color, I'll use it for walking patrol
                e.Row.BackColor = System.Drawing.Color.Red;
                e.Row.Font.Bold = true;
                e.Row.ForeColor = System.Drawing.Color.White;
            }
            //late logger
            if (LastStateTimeStamp != null && !LastStateTimeStamp.Equals(DBNull.Value))
            {
                var lastTimeStamp = Convert.ToDateTime(LastStateTimeStamp);
                if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Land) //max 1 hour
                {
                    var hours = (DateTime.Now - lastTimeStamp).TotalHours;
                    if (hours >= 1)
                    {
                        e.Row.ForeColor = System.Drawing.Color.PaleVioletRed;
                        e.Row.Font.Bold = true;
                    }
                }
                else if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Away) //max 10 minues
                {
                    var minutes = (DateTime.Now - lastTimeStamp).TotalMinutes;
                    if (minutes >= 11)
                    {
                        e.Row.ForeColor = System.Drawing.Color.PaleVioletRed;
                        e.Row.Font.Bold = true;
                    }
                }


            }
        }

        protected void LoadLayout()
        {
            var user = (User)Session["User"];
            if (user == null)
                return;
            //load user default layout prefernce
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            var user_saved_layout = db.Users.First<User>(eu => eu.UserID == user.UserID);
            if (user_saved_layout != null)
            {
                var lay = user_saved_layout.Layout_AhwalMapping;
                if (lay != null)
                {
                    AhwalMappingGrid.LoadClientLayout(lay);// AhwalMappingGrid.LoadClientLayout(lay);
                }
                var group = user_saved_layout.Layout_Groups_AhawalMapping;
                if (group != null)
                {
                    if (group != "" && !group.Equals(DBNull.Value))
                    {
                        var splittedstring = group.Split(';');
                        if (splittedstring.Length > 0)
                        {
                            AhwalMappingGrid.CollapseAll();
                            try
                            {
                                foreach (var s in splittedstring)
                                {
                                    if (s != "")
                                        AhwalMappingGrid.ExpandRow(Convert.ToInt16(s.ToString()));
                                }
                            }
                            catch (Exception)
                            {

                            }
                        }

                    }
                }
                else
                {
                    AhwalMappingGrid.ExpandAll();
                }


            }
        }
        protected void AhwalMappingGrid_ClientLayout(object sender, ASPxClientLayoutArgs e)
        {
           // LoadLayout();
        }

        protected void AhwalMappingGrid_AfterPerformCallback(object sender, ASPxGridViewAfterPerformCallbackEventArgs e)
        {
            //if (e.CallbackName=="APPLYCOLUMNFILTER")
            //{
            //    if (e.Args.ElementAt<string>(1)=="") //nothing typed there, so load default layout
            //    {
            //        LoadLayout();
            //    }
            //    else //something typed there, so exapnd all groups
            //    {
            //        AhwalMappingGrid.ExpandAll();
            //    }
            //}
            
        }

        protected void AhwalMapping_States_Grid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            e.Row.BackColor = System.Drawing.Color.White;//set default to white first
            e.Row.ForeColor = System.Drawing.Color.Black;
            e.Row.Font.Bold = false;
            long personState = Convert.ToInt32(e.GetValue("PatrolPersonStateID"));

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_SunRise ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Sea ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Back ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking)
                e.Row.BackColor = System.Drawing.Color.LightGreen;

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Land)
                e.Row.BackColor = System.Drawing.Color.LightGray;

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Away)
                e.Row.BackColor = System.Drawing.Color.Yellow;

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Sick ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Absent ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Off)
                e.Row.BackColor = System.Drawing.Color.PaleVioletRed;


            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_WalkingPatrol)
            {
                e.Row.BackColor = System.Drawing.Color.CadetBlue;
            }
           

        }

        protected void GenerateReportButton_Click(object sender, EventArgs e)
        {
            //we have to generate the datatable first
            var ahwaluser = (User)Session["User"];
            if (ahwaluser == null)
                return;
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);

            var MappingList = db.AhwalMappings.OrderBy(es => es.SortingIndex).ToList<AhwalMapping>();
            var PersonsList = db.Persons.ToList<Person>();
            var RanksList = db.Ranks.ToList<Rank>();
            var PatrolCarList = db.PatrolCars.ToList<PatrolCar>();
            var HandHeldsList = db.HandHelds.ToList<HandHeld>();
            var ShiftsList = db.Shifts.ToList<Shift>();
            var SectorsList = db.Sectors.ToList<Sector>();
            var CityGroupList = db.CityGroups.ToList<CityGroup>();
            var AhwalsList = db.Ahwals.ToList<Ahwal>();
            var PatrolRoleList = db.PatrolRoles.ToList<PatrolRole>();
            var PersonStateList = db.PatrolPersonStates.ToList<PatrolPersonState>();
            var totalNumberOfColumns = 9;

            iTextSharp.text.Document document = new iTextSharp.text.Document(PageSize.A4);
            //document.AddHeader("test", "test");
            document.SetMargins(50, 50, 50, 50);
            var dir = Server.MapPath("~\\");
            //var file = Path.Combine(dir, "sample.pdf");//we are now storing the file in memory
            var fontFile = Path.Combine(dir, "simpo.ttf");
            var output = new MemoryStream();

            //PdfWriter writer = PdfWriter.GetInstance(document, new FileStream(file, FileMode.Create));
            PdfWriter writer = PdfWriter.GetInstance(document, output);
            document.Open();
            iTextSharp.text.Font font5 = iTextSharp.text.FontFactory.GetFont(FontFactory.HELVETICA, 5);


            BaseFont bf = BaseFont.CreateFont(fontFile, BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            //font styles
            Font arabicFont = new Font(bf, 9);
            var arabicFont_Red = new Font(bf, 9);
            arabicFont_Red.Color = BaseColor.RED;

            long LastAhwalIDProcessed = 0;
            var LastShiftProcessed = 0;
            long LastSectorProcessed = 0;
            long LastCityGroupProcessed = 0;

            var index = 0;
            foreach (var f in MappingList)
            {
                var ahwalTempName = AhwalsList.Find(a => a.AhwalID == f.AhwalID).Name;

                var shiftTempName = ShiftsList.Find(a => a.ShiftID == f.ShiftID).Name;

                var sectorTempName = SectorsList.Find(a => a.SectorID == f.SectorID).ShortName;
                var cityName = CityGroupList.Find(a => a.CityGroupID == f.CityGroupID).Text;
                if (cityName != "")
                {
                    cityName = "المناطق: " + cityName;
                }
                var Serial = "";
                var SerialObj = HandHeldsList.Find(a => a.HandHeldID == f.HandHeldID);
                if (SerialObj != null)
                {
                    Serial = SerialObj.Serial;
                }
                var PlateNumber = "";
                var PlateNumberObj = PatrolCarList.Find(a => a.PatrolID == f.PatrolID);
                if (PlateNumberObj != null)
                {
                    PlateNumber = PlateNumberObj.PlateNumber;
                }
                var personObj = PersonsList.Find(a => a.PersonID == f.PersonID);
                var MilNumber = personObj.MilNumber;
                var RankID = personObj.RankID;
                var RankName = RanksList.Find(a => a.RankID == personObj.RankID).Name;
                var PatrolRoleName = PatrolRoleList.Find(a => a.PatrolRoleID == f.PatrolRoleID).Name;
                var PersonStateName = PersonStateList.Find(a => a.PatrolPersonStateID == f.PatrolPersonStateID).Name;
                var Name = personObj.Name;
                var Mobile = personObj.Mobile;


                //if this happens, its the first page for an ahwal
                if (f.AhwalID != LastAhwalIDProcessed) //once AhwalID changes, reset all values
                {

                }

                //if this happens, its the first page of a shift
                if (f.ShiftID != LastShiftProcessed) //once Shift changes, reset all values
                {



                    document.NewPage();
                    //create printed by top
                    PdfPTable printedByTable = new PdfPTable(4);
                    printedByTable.WidthPercentage = 100;
                    printedByTable.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                    //we should create new page here,and print main header
                    PdfPCell PrintedByCell = new PdfPCell(new Phrase("طبع من حساب: " + ahwaluser.Name, arabicFont_Red)); //chceck it later to ahwal name
                    PrintedByCell.HorizontalAlignment = PdfPCell.ALIGN_LEFT; //it work opposite way
                    PrintedByCell.BackgroundColor = BaseColor.LIGHT_GRAY;
                    PrintedByCell.Colspan = 4;
                    PrintedByCell.FixedHeight = 20;
                    printedByTable.AddCell(PrintedByCell);
                    document.Add(printedByTable);
                    document.Add(Chunk.NEWLINE);
                    document.Add(Chunk.NEWLINE);
                    // ok we got into new Shift, time to create nice header
                    PdfPTable NewShiftTable = new PdfPTable(4);
                    //  float[] widths = new float[] { 4f, 4f, 4f, 4f  };
                    // NewShiftTable.SetWidths(widths);
                    NewShiftTable.WidthPercentage = 100;
                    NewShiftTable.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                    //we should create new page here,and print main header
                    PdfPCell ahwalcell = new PdfPCell(new Phrase("الأحوال: " + ahwalTempName, arabicFont)); //chceck it later to ahwal name
                    ahwalcell.HorizontalAlignment = PdfPCell.ALIGN_LEFT; //it work opposite way
                    ahwalcell.BackgroundColor = BaseColor.LIGHT_GRAY;

                    //ahwalcell.Colspan = 4;
                    //ahwalcell.BorderWidthRight = 0;
                    ahwalcell.BorderWidthLeft = 0;
                    ahwalcell.FixedHeight = 20;
                    ahwalcell.Border = 0;
                    NewShiftTable.AddCell(ahwalcell);


                    PdfPCell shiftCell = new PdfPCell(new Phrase("الشفت: " + shiftTempName, arabicFont_Red));
                    shiftCell.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
                    shiftCell.BackgroundColor = BaseColor.LIGHT_GRAY;

                    //shiftCell.Colspan = 4;
                    shiftCell.BorderWidthRight = 0;
                    shiftCell.BorderWidthLeft = 0;
                    shiftCell.Border = 0;
                    shiftCell.FixedHeight = 20;
                    NewShiftTable.AddCell(shiftCell);


                    PdfPCell daycell = new PdfPCell(new Phrase("اليوم: " + DateTime.Now.ToString("dddd", new System.Globalization.CultureInfo("ar-QA")), arabicFont_Red));
                    daycell.HorizontalAlignment = PdfPCell.ALIGN_CENTER;
                    daycell.BackgroundColor = BaseColor.LIGHT_GRAY;

                    //ahwalcell.Colspan = 4;
                    daycell.BorderWidthRight = 0;
                    daycell.BorderWidthLeft = 0;
                    daycell.Border = 0;
                    daycell.FixedHeight = 20;
                    NewShiftTable.AddCell(daycell);



                    PdfPCell dateCell = new PdfPCell(new Phrase(DateTime.Now.ToString("dd/MM/yyyy"), arabicFont));
                    dateCell.HorizontalAlignment = PdfPCell.ALIGN_RIGHT;
                    dateCell.BackgroundColor = BaseColor.LIGHT_GRAY;

                    // dateCell.Colspan = 4;
                    dateCell.BorderWidthRight = 0;
                    //dateCell.BorderWidthLeft = 0;
                    dateCell.Border = 0;
                    dateCell.FixedHeight = 20;
                    NewShiftTable.AddCell(dateCell);

                    //no need to print public sector word, but we do need to set it as last sector
                    ////public sector
                    LastAhwalIDProcessed = f.AhwalID;
                    LastShiftProcessed = f.ShiftID;
                    //LastSectorProcessed = f.SectorID;

                    document.Add(NewShiftTable);
                    //add blank line
                    document.Add(Chunk.NEWLINE);
                    //document.Add(new Phrase("\n"));



                }

                //if this happens, its new sector 

                if (f.SectorID != LastSectorProcessed) //once Shift changes, reset all values
                {
                    //add new page, show nice 
                    PdfPTable SectorTable = new PdfPTable(8);
                    SectorTable.HorizontalAlignment = Element.ALIGN_CENTER;
                    //  float[] widths = new float[] { 4f, 4f, 4f, 4f, 4f, 4f, 4f };
                    //   SectorTable.SetWidths(widths);
                    SectorTable.WidthPercentage = 100;
                    SectorTable.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                    if (f.SectorID != Core.Handler_AhwalMapping.Sector_Public && f.SectorID != Core.Handler_AhwalMapping.Sector_First)
                    {//new page for any sector except public one
                        document.NewPage();
                        //create printed by top
                        PdfPTable printedByTable = new PdfPTable(4);
                        printedByTable.WidthPercentage = 100;
                        printedByTable.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                        //we should create new page here,and print main header
                        PdfPCell PrintedByCell = new PdfPCell(new Phrase("طبع من حساب: " + ahwaluser.Name, arabicFont_Red)); //chceck it later to ahwal name
                        PrintedByCell.HorizontalAlignment = PdfPCell.ALIGN_LEFT; //it work opposite way
                        PrintedByCell.BackgroundColor = BaseColor.LIGHT_GRAY;
                        PrintedByCell.Colspan = 4;
                        PrintedByCell.FixedHeight = 20;
                        printedByTable.AddCell(PrintedByCell);
                        document.Add(printedByTable);
                        document.Add(Chunk.NEWLINE);
                        document.Add(Chunk.NEWLINE);
                    }
                    if (f.SectorID == Core.Handler_AhwalMapping.Sector_First)
                    {
                        document.Add(Chunk.NEWLINE);
                    }


                    PdfPCell sectorTopHeaderCell = new PdfPCell(new Phrase(sectorTempName, arabicFont_Red));
                    sectorTopHeaderCell.HorizontalAlignment = 1;
                    sectorTopHeaderCell.Colspan = totalNumberOfColumns;
                    sectorTopHeaderCell.FixedHeight = 20;
                    sectorTopHeaderCell.BackgroundColor = BaseColor.LIGHT_GRAY;
                    SectorTable.AddCell(sectorTopHeaderCell);
                    string[] hedaerStringList = { "م", "الرقم العسكري", "الرتبه", "الاسم", "المسؤوليه", "الحاله", "النداء", "الهاتف" };
                    for (int i = 0; i < 8; i++)
                    {
                        PdfPCell headercell = new PdfPCell(new Phrase(hedaerStringList[i], arabicFont));
                        headercell.HorizontalAlignment = Element.ALIGN_CENTER;
                        headercell.BackgroundColor = BaseColor.LIGHT_GRAY;
                        headercell.FixedHeight = 20;
                        SectorTable.AddCell(headercell);
                    }

                    index = 1;
                    LastSectorProcessed = f.SectorID;
                    LastCityGroupProcessed = 0;
                    document.Add(SectorTable);
                }

                //add new page, show nice 
                PdfPTable PersonDetailTable = new PdfPTable(8);
                PersonDetailTable.HorizontalAlignment = Element.ALIGN_CENTER;
                // float[] widths = new float[] { 4f, 4f, 4f, 4f, 4f, 4f, 4f };
                // PersonDetailTable.SetWidths(widths);
                PersonDetailTable.WidthPercentage = 100;
                PersonDetailTable.RunDirection = PdfWriter.RUN_DIRECTION_RTL;

                if (f.CityGroupID != LastCityGroupProcessed)
                {//add city header
                 //if (f.CityGroupID != Core.Handler_AhwalMapping.CityGroup_None)
                 //{
                    PdfPCell cityHeaderCell = new PdfPCell(new Phrase(cityName, arabicFont_Red));
                    cityHeaderCell.HorizontalAlignment = Element.ALIGN_LEFT;
                    cityHeaderCell.Colspan = 8;
                    cityHeaderCell.FixedHeight = 20;
                    cityHeaderCell.BackgroundColor = BaseColor.LIGHT_GRAY;
                    PersonDetailTable.AddCell(cityHeaderCell);

                    //}
                    LastCityGroupProcessed = f.CityGroupID;
                }


                //index
                PdfPCell indexCell = new PdfPCell(new Phrase(index.ToString(), arabicFont));
                indexCell.HorizontalAlignment = Element.ALIGN_CENTER;
                indexCell.FixedHeight = 20;
                PersonDetailTable.AddCell(indexCell);
                index++;
                //milnumber
                PdfPCell milNumberCell = new PdfPCell(new Phrase(MilNumber.ToString(), arabicFont));
                milNumberCell.HorizontalAlignment = Element.ALIGN_CENTER;
                milNumberCell.FixedHeight = 20;
                PersonDetailTable.AddCell(milNumberCell);

                //rank
                PdfPCell rankCell = new PdfPCell(new Phrase(RankName, arabicFont));
                rankCell.HorizontalAlignment = Element.ALIGN_CENTER;
                rankCell.FixedHeight = 20;
                PersonDetailTable.AddCell(rankCell);

                //name
                PdfPCell nameCell = new PdfPCell(new Phrase(Name, arabicFont));
                nameCell.HorizontalAlignment = Element.ALIGN_CENTER;
                nameCell.FixedHeight = 20;
                PersonDetailTable.AddCell(nameCell);

                //PatrolRole
                PdfPCell roleCell = new PdfPCell(new Phrase(PatrolRoleName, arabicFont));
                roleCell.HorizontalAlignment = Element.ALIGN_CENTER;
                roleCell.FixedHeight = 20;
                PersonDetailTable.AddCell(roleCell);

                //PatrolPersonState
                PdfPCell stateCell;
                if (f.PatrolPersonStateID == Core.Handler_AhwalMapping.PatrolPersonState_Sick ||
                    f.PatrolPersonStateID == Core.Handler_AhwalMapping.PatrolPersonState_Off ||
                    f.PatrolPersonStateID == Core.Handler_AhwalMapping.PatrolPersonState_Absent)
                {
                    stateCell = new PdfPCell(new Phrase(PersonStateName, arabicFont_Red));
                }
                else
                {
                    stateCell = new PdfPCell(new Phrase(PersonStateName, arabicFont));

                }
                stateCell.HorizontalAlignment = Element.ALIGN_CENTER;
                stateCell.FixedHeight = 20;
                PersonDetailTable.AddCell(stateCell);

                //CallerID
                var caller = "";
                if (f.CallerID != null)
                    caller = f.CallerID;
                PdfPCell callerCell = new PdfPCell(new Phrase(caller, arabicFont));
                callerCell.HorizontalAlignment = Element.ALIGN_CENTER;
                callerCell.FixedHeight = 20;
                PersonDetailTable.AddCell(callerCell);

                //Mobile
                PdfPCell mobileCell = new PdfPCell(new Phrase(Mobile, arabicFont));
                mobileCell.HorizontalAlignment = Element.ALIGN_CENTER;
                mobileCell.FixedHeight = 20;
                PersonDetailTable.AddCell(mobileCell);

                document.Add(PersonDetailTable);
            }



            document.Close();
            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("Content-Disposition", string.Format("attachment;filename={0}.pdf", "AhwalMapping"));

            Response.BinaryWrite(output.ToArray());
            Response.Flush();
            Response.Close();
            //AhwalMappingGridExporter.WriteXlsToResponse();
        }

        protected void SaveGroups_Click(object sender, EventArgs e)
        {

            //var user = (User)Session["User"];
            //if (user == null)
            //    return;
            //DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);

            //var user_saved_layout = db.Users.First<User>(eu => eu.UserID == user.UserID);
            //if (user_saved_layout == null)
            //{
            //    return;
            //}
            //var layoutString = AhwalMappingGrid.SaveClientLayout();
            //user_saved_layout.Layout_AhwalMapping = layoutString;
            ////that was only the layout and columns orders
            ////we need to save as well the state of colapsed and exapnded columns
            ////List<int> states = new List<int>();
            //var groupsString = "";
            //for (Int32 i = 0; i < AhwalMappingGrid.VisibleRowCount; i++)
            //{
            //    if (AhwalMappingGrid.IsGroupRow(i) && AhwalMappingGrid.IsRowExpanded(i))
            //        groupsString += i.ToString() + ";";
            //}
            //if (groupsString != "")
            //{
            //    user_saved_layout.Layout_Groups_AhawalMapping = groupsString;
            //}
            //db.SubmitChanges();
        }

        protected void CloseAllGroups_Click(object sender, EventArgs e)
        {
            AhwalMappingGrid.CollapseAll();
        }

        protected void OpenAllGroups_Click(object sender, EventArgs e)
        {
            AhwalMappingGrid.ExpandAll();
        }

        protected void AhwalMappingGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters == "LatestStates")
            {
                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
                var mappingID = AhwalMappingGrid.GetRowValues(AhwalMappingGrid.FocusedRowIndex, "AhwalMappingID");
                if (mappingID != null)
                {
                    var personmapping = db.AhwalMappings.FirstOrDefault(em => em.AhwalMappingID == Convert.ToInt64(mappingID));
                    Session["StatePersonID"] = personmapping.PersonID;

                    //AhwalMapping_States_Grid.DataBind();
                }
            }

        }
    }
}