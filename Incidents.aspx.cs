using DevExpress.Utils;
using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace PatrolWebApp
{
    public partial class Incidents : System.Web.UI.Page
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

          

            Incidents_Add_Popup.Width = 400;
            Incidents_Add_Popup.Height = 400;
            Incidents_Add_Popup.ShowCloseButton = true;

            Incident_Comments_PopUp.Width = 900;
            Incident_Comments_PopUp.Height = 600;
            Incident_Comments_PopUp.ShowCloseButton = true;
            Incident_Comments_PopUp.HeaderText = "التعليقات";

            CommentsGrid.Styles.AlternatingRow.Enabled = DefaultBoolean.True;
            CommentsGrid.Styles.AlternatingRow.BackColor = System.Drawing.Color.LightYellow;
            CommentsGrid.Styles.Row.BackColor = System.Drawing.Color.LightGreen;


        }
        protected void IncidentsGrid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {
            if (e.RowType != GridViewRowType.Data) return;
            e.Row.BackColor = System.Drawing.Color.White;//set default to white first
            e.Row.ForeColor = System.Drawing.Color.Black;
            e.Row.Font.Bold = false;
            long state = Convert.ToInt32(e.GetValue("IncidentStateID"));

            if (state == Core.Handler_Incidents.Incident_State_New)
            {
                e.Row.BackColor = System.Drawing.Color.Red;
                e.Row.ForeColor = System.Drawing.Color.White;
                e.Row.Font.Bold = true;
            }
            else if (state == Core.Handler_Incidents.Incident_State_Closed)
            {
                e.Row.BackColor = System.Drawing.Color.LightGray;
            }
            else if (state == Core.Handler_Incidents.Incident_State_HasComments)
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }
        }

        protected void IncidentsRefresh_Click(object sender, EventArgs e)
        {
            IncidentsGrid.DataBind();
        }

        protected void Incidents_AddIncident_Source_ComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            Incidents_Add_Popup.HeaderText = "اضافة بلاغ جديد";
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            //get the source 
            var source = db.IncidentSources.FirstOrDefault<IncidentSource>(a => a.IncidentSourceID == Convert.ToInt16(Incidents_AddIncident_Source_ComboBox.Value));
            if (source == null)
                return;

            Incidents_AddIncident_Place_TextBox.Text = "";
            Incidents_AddIncident_Extrainfo1_TextBox.Text = "";
            Incidents_AddIncident_Extrainfo2_TextBox.Text = "";
            Incidents_AddIncident_Extrainfo3_TextBox.Text = "";
            Incidents_AddIncident_Extrainfo3_Label.Visible = false;
            Incidents_AddIncident_Extrainfo3_TextBox.Visible = false;
            Incidents_AddIncident_Extrainfo1_Label.Visible = false;
            Incidents_AddIncident_Extrainfo1_TextBox.Visible = false;
            Incidents_AddIncident_Extrainfo3_Label.Visible = false;
            Incidents_AddIncident_Extrainfo3_TextBox.Visible = false;
            if (source.RequiresExtraInfo1 == 1)
            {
                Incidents_AddIncident_Extrainfo1_Label.Visible = true;
                Incidents_AddIncident_Extrainfo1_TextBox.Visible = true;
                Incidents_AddIncident_Extrainfo1_Label.Text = source.ExtraInfo1;

            }
            if (source.RequiresExtraInfo2 == 1)
            {
                Incidents_AddIncident_Extrainfo2_Label.Visible = true;
                Incidents_AddIncident_Extrainfo2_TextBox.Visible = true;
                Incidents_AddIncident_Extrainfo2_Label.Text = source.ExtraInfo2;

            }
            if (source.RequiresExtraInfo3 == 1)
            {
                Incidents_AddIncident_Extrainfo3_Label.Visible = true;
                Incidents_AddIncident_Extrainfo3_TextBox.Visible = true;
                Incidents_AddIncident_Extrainfo3_Label.Text = source.ExtraInfo3;

            }
        }

        protected void Incidents_AddIncident_SubmitButton_Click(object sender, EventArgs e)
        {
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            var incidentTypeID = Convert.ToInt16(Incidents_AddIncident_Type_ComboBox.Value);
            var incidentSourceID = Convert.ToInt16(Incidents_AddIncident_Source_ComboBox.Value);
            var source = db.IncidentSources.FirstOrDefault<IncidentSource>(a => a.IncidentSourceID == Convert.ToInt16(incidentSourceID));
            if (source == null)
                return;
            var user = (User)Session["User"];
            if (user == null)
                return;
            var newIncident = new Incident();
            newIncident.IncidentTypeID = incidentTypeID;
            newIncident.IncidentStateID = Core.Handler_Incidents.Incident_State_New;
            newIncident.IncidentSourceID = source.IncidentSourceID;
            newIncident.Place = Incidents_AddIncident_Place_TextBox.Text;
            if (source.RequiresExtraInfo1 == 1)
            {
                newIncident.IncidentSourceExtraInfo1 = Incidents_AddIncident_Extrainfo1_TextBox.Text;

            }
            if (source.RequiresExtraInfo2 == 1)
            {
                newIncident.IncidentSourceExtraInfo2 = Incidents_AddIncident_Extrainfo2_TextBox.Text;

            }
            if (source.RequiresExtraInfo3 == 1)
            {
                newIncident.IncidentSourceExtraInfo3 = Incidents_AddIncident_Extrainfo3_TextBox.Text;
            }
            var result = Core.Handler_Incidents.Add_Incident(user, newIncident);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                IncidentsGrid.DataBind();
                Incidents_Add_Popup.ShowOnPageLoad = false;
                return;
            }
            Incidents_Add_Popup.HeaderText = "اضافة بلاغ جديد";
            Incidents_AddIncident_status_label.Text = result.Text;
            Incidents_Add_Popup.ShowOnPageLoad = true;

        }

        protected void IncidentsGrid_ContextMenuItemClick(object sender, ASPxGridViewContextMenuItemClickEventArgs e)
        {
            //nothing used here so far
            switch (e.Item.Name) //later
            {
                case "اغلاق البلاغ":
                    break;
            }
        }

        protected void IncidentsGrid_FillContextMenuItems(object sender, ASPxGridViewContextMenuEventArgs e)
        {
            if (e.MenuType == GridViewContextMenuType.Rows)
            {
                // e.Items.Add("تعديل", "تعديل");
                e.Items.Add("اغلاق البلاغ", "اغلاق البلاغ");

            }
        }
        protected void IncidentsGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters.StartsWith("Closeincident"))
            {
                var splitted = e.Parameters.Split(';');

                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
                var incidentID = IncidentsGrid.GetRowValues(Convert.ToInt32(splitted[1]), "IncidentID");
                if (incidentID != null)
                {

                    var incident = db.Incidents.FirstOrDefault(em => em.IncidentID == Convert.ToInt64(incidentID));
                    //Session["CommentsIncidentID"] = incident.IncidentID;
                    //if incident already closed, just ignore this stupid user
                    if (incident.IncidentStateID == Core.Handler_Incidents.Incident_State_Closed)
                        return;
                    var usersession = Session["User"];
                    if (usersession == null)
                        return;
                    var user = (User)usersession;
                    Core.Handler_Incidents.Close_Incident(user, incident);
                    IncidentsGrid.DataBind();
                }
            }
        }
        protected string IncidentGrid_GetImageName(object dataValue)
        {

            var incidentID = (long)dataValue;
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            var usersession = Session["User"];
            if (usersession == null)
                return "~/Content/NoUpdate.png";
            var user = (User)usersession;
            var isInIncidentview = db.IncidentsViews.FirstOrDefault<IncidentsView>(a => a.UserID == user.UserID && a.IncidentID == incidentID);
            if (isInIncidentview != null)
            {
                return "~/Content/NewUpdate.png";
            }
            return "~/Content/NoUpdate.png";

        }
        protected void CommentsGrid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
        {

        }

        protected void CommentsGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters.StartsWith("IncidentComments"))
            {
                var splitted = e.Parameters.Split(';');

                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
                // var incidentID = IncidentsGrid.GetRowValues(Convert.ToInt32(splitted[1]), "IncidentID");
                //if (incidentID != null)
                //{

                var incident = db.Incidents.FirstOrDefault(em => em.IncidentID == Convert.ToInt64(splitted[1]));
                if (incident == null)
                    return;
                var usersession = Session["User"];
                if (usersession == null)
                    return;
                var user = (User)usersession;
                Session["CommentsIncidentID"] = incident.IncidentID;

                //now we will clear the flag for new for this incident
                var clearIncidentView = db.IncidentsViews.FirstOrDefault<IncidentsView>(a => a.UserID == user.UserID && a.IncidentID == incident.IncidentID);
                if (clearIncidentView != null)
                {
                    db.IncidentsViews.DeleteOnSubmit(clearIncidentView);
                    db.SubmitChanges();
                    //IncidentsGrid.DataBind();
                }
            }

        }
        protected void CommentsRefresh_Click(object sender, EventArgs e)
        {
            CommentsGrid.DataBind();
        }
        protected void CommentsGrid_DataBound(object sender, EventArgs e)
        {
            PopulateCommentPopUp();
        }
        protected void CommentsCreateNew_Click(object sender, EventArgs e)
        {
            // Response.Write("hahahahhahahahahahahah");
            PopulateCommentPopUp();
            Incident_Comments_PopUp.ShowOnPageLoad = true;
            Incident_Comments_PopUp.HeaderText = "التعليقات";
            // var Comments_CommentsCreateNew_TextBox = (ASPxTextBox)(CommentsGrid.FindTitleTemplateControl("CommentsCreateNew_TextBox"));
            CommentsCreateNew_TextBox.Focus();
            if (CommentsCreateNew_TextBox == null)
            {

                return;
            }
            if (CommentsCreateNew_TextBox.Text == "")
            {

                return;
            }
            var IncidentID = Session["CommentsIncidentID"];
            if (IncidentID == null)
            {

                return;
            }
            var sessionuser = Session["User"];
            if (sessionuser == null)
            {

                return;
            }
            var user = (User)sessionuser;
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);

            var newComment = new IncidentsComment();
            newComment.IncidentID = Convert.ToInt64(IncidentID.ToString());
            newComment.Text = CommentsCreateNew_TextBox.Text;

            var result = Core.Handler_Incidents.Add_New_Comment(user, newComment);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                CommentsGrid.DataBind();
                IncidentsGrid.DataBind();
                CommentsCreateNew_TextBox.Text = "";
            }


        }
        protected void PopulateCommentPopUp()
        {
            var IncidentID = Session["CommentsIncidentID"];
            if (IncidentID == null)
            {

                return;
            }
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);

            var incident = db.Incidents.FirstOrDefault(em => em.IncidentID == Convert.ToInt64(IncidentID));

            var user = db.Users.FirstOrDefault<User>(a => a.UserID == incident.UserID);
            //var Comments_IncidentUserName = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_IncidentUserName"));
            Comments_IncidentUserName.Text = user.Name;

            var incidentType = db.IncidentsTypes.FirstOrDefault<IncidentsType>(a => a.IncidentTypeID == incident.IncidentTypeID);
            //var Comments_IncidentTypeName = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_IncidentTypeName"));
            Comments_IncidentTypeName.Text = incidentType.Name;



            var incidentSource = db.IncidentSources.FirstOrDefault<IncidentSource>(a => a.IncidentSourceID == incident.IncidentSourceID);
            // var Comments_IncidentSourceName = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_IncidentSourceName"));
            Comments_IncidentSourceName.Text = incidentSource.Name;

            // var Comments_Place = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_Place"));
            Comments_Place.Text = incident.Place;

          
            Comments_Extra1_Name.Text = incidentSource.ExtraInfo1;// + ":";
            Comments_Extra1_Value.Text = incident.IncidentSourceExtraInfo1;


            Comments_Extra2_Name.Text = incidentSource.ExtraInfo2;// + ":";
            Comments_Extra2_Value.Text = incident.IncidentSourceExtraInfo2;


            Comments_Extra3_Name.Text = incidentSource.ExtraInfo3;// + ":";
            Comments_Extra3_Value.Text = incident.IncidentSourceExtraInfo3;

        }


        protected void CommentsGrid_PageIndexChanged(object sender, EventArgs e)
        {
            PopulateCommentPopUp();//refresh these when requested
        }
    }
}