using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PatrolWebApp
{
    public partial class IncidentsTypes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
                Response.Redirect("Login.aspx");
            var user = (User)Session["User"];
            Session["UserID"] = user.UserID;
            Session["UserRoleID"] = Core.Handler_User.User_Role_Ops;
            if (Page.IsPostBack)
                return;
        }

        protected void IncidentTypesGrid_RowInserting(object sender, DevExpress.Web.Data.ASPxDataInsertingEventArgs e)
        {
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            var incidentType = db.IncidentsTypes.ToList().OrderByDescending(a => a.IncidentTypeID);
            if (incidentType != null)
            {
                var lastIncident = incidentType.First();
                var newIncident = new IncidentsType();
                newIncident.IncidentTypeID = lastIncident.IncidentTypeID + 10;
                newIncident.Name = e.NewValues["Name"].ToString();
                db.IncidentsTypes.InsertOnSubmit(newIncident);
                var user = (User)Session["User"];
                db.SubmitChanges();
                OperationLog ol = new OperationLog();
                ol.UserID = user.UserID;
                ol.OperationID = Core.Handler_Operations.Opeartion_IncidentsTypes_AddNew;
                ol.StatusID = Core.Handler_Operations.Opeartion_Status_Success;
                ol.Text = "قام باضافة نوع البلاغ: " + newIncident.Name + " بالرقم: " +newIncident.IncidentTypeID;
                Core.Handler_Operations.Add_New_Operation_Log(ol);
                db.SubmitChanges();
                IncidentTypesGrid.DataBind();

            }
            IncidentTypesGrid.CancelEdit();
            e.Cancel = true;


        }

        protected void IncidentTypesGrid_RowUpdating(object sender, DevExpress.Web.Data.ASPxDataUpdatingEventArgs e)
        {
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            var incident = db.IncidentsTypes.FirstOrDefault<IncidentsType>(a => a.IncidentTypeID == Convert.ToInt16(e.Keys["IncidentTypeID"]));
            if (incident != null)
            {
                incident.Name = e.NewValues["Name"].ToString();
                var user = (User)Session["User"];
                db.SubmitChanges();
                OperationLog ol = new OperationLog();
                ol.UserID = user.UserID;
                ol.OperationID = Core.Handler_Operations.Opeartion_IncidentsTypes_Edit;
                ol.StatusID = Core.Handler_Operations.Opeartion_Status_Success;
                ol.Text = "قام بتغيير نص نوع البلاغ: " + e.OldValues["Name"].ToString() + " بالرقم: " + e.Keys["IncidentTypeID"].ToString() + " الى النص: " + e.NewValues["Name"].ToString() ;
                Core.Handler_Operations.Add_New_Operation_Log(ol);
                db.SubmitChanges();

            }
            IncidentTypesGrid.CancelEdit();
            e.Cancel = true;
           

        }
    }
}