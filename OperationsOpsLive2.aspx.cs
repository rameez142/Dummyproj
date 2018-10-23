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
    public partial class Operations2 : System.Web.UI.Page
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
            IncidentsGrid.SettingsPopup.HeaderFilter.Width = 300;
            IncidentsGrid.SettingsPopup.HeaderFilter.Height = 320;

            CommentsGrid.SettingsPopup.HeaderFilter.Width = 300;
            CommentsGrid.SettingsPopup.HeaderFilter.Height = 320;


            OpsLive_States_PopUp.Width = 400;
            OpsLive_States_PopUp.Height = 400;
            OpsLive_States_PopUp.ShowCloseButton = true;

            LiveCaller_PopUp.Width = 300;
            LiveCaller_PopUp.Height = 200;
            LiveCaller_PopUp.ShowCloseButton = true;
            LiveCaller_PopUp.HeaderText = "المتحدث الآن...";

            Incidents_Add_Popup.Width = 400;
            Incidents_Add_Popup.Height = 400;
            Incidents_Add_Popup.ShowCloseButton = true;

            Incident_Comments_PopUp.Width = 900;
            Incident_Comments_PopUp.Height = 600;
            Incident_Comments_PopUp.ShowCloseButton = true;
            Incident_Comments_PopUp.HeaderText = "التعليقات";


            OpsLive_IncidentAttach_PopUp.Width = 400;
            OpsLive_IncidentAttach_PopUp.Height = 200;
            OpsLive_IncidentAttach_PopUp.ShowCloseButton = true;
            OpsLive_IncidentAttach_PopUp.HeaderText = "لسليم بلاغ";
            //alternate row colors for comments
            CommentsGrid.Styles.AlternatingRow.Enabled = DefaultBoolean.True;
            CommentsGrid.Styles.AlternatingRow.BackColor = System.Drawing.Color.LightYellow;
            CommentsGrid.Styles.Row.BackColor = System.Drawing.Color.LightGreen;
        }

        protected void OpsLiveGrid_ContextMenuItemClick(object sender, DevExpress.Web.ASPxGridViewContextMenuItemClickEventArgs e)
        {

        }

        protected void OpsLiveGrid_FillContextMenuItems(object sender, DevExpress.Web.ASPxGridViewContextMenuEventArgs e)
        {

            e.Items.Add("تسليم بلاغ", "تسليم بلاغ");

        }

        protected void OpsLiveGrid_HtmlRowPrepared(object sender, DevExpress.Web.ASPxGridViewTableRowEventArgs e)
        {

            if (e.RowType != GridViewRowType.Data) return;

            e.Row.BackColor = System.Drawing.Color.White;//set default to white first
            e.Row.ForeColor = System.Drawing.Color.Black;
            e.Row.Font.Bold = false;
            long personState = Convert.ToInt32(e.GetValue("PatrolPersonStateID"));
            long patrolRoleID = Convert.ToInt32(e.GetValue("PatrolRoleID"));
            var incident = e.GetValue("IncidentID");
            var LastStateTimeStamp = e.GetValue("LastStateChangeTimeStamp");

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_SunRise ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Sea ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Back ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking)
            {
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            }
            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Land)
            {
                e.Row.BackColor = System.Drawing.Color.LightGray;

            }
            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Away)
            {
                e.Row.BackColor = System.Drawing.Color.Yellow;
            }

            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_Sick ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Absent ||
                personState == Core.Handler_AhwalMapping.PatrolPersonState_Off)
            {
                e.Row.BackColor = System.Drawing.Color.PaleVioletRed;
            }
            if (personState == Core.Handler_AhwalMapping.PatrolPersonState_WalkingPatrol)
            {
                e.Row.BackColor = System.Drawing.Color.CadetBlue;
            }
            //change associate color
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

        protected void ASPxTimer1_Tick(object sender, EventArgs e)
        {
            //OpsLiveGrid.DataBind();
            //IncidentsGrid.DataBind();
        }



        protected void OpsLiveGrid_CustomButtonInitialize(object sender, ASPxGridViewCustomButtonEventArgs e)
        {

            if (e.CellType != GridViewTableCommandCellType.Data) return;
            if (e.ButtonID == "Away")
            {
                if (OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_SunRise.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Sea.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Back.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking.ToString())
                {
                    e.Visible = DefaultBoolean.True;
                }
                else
                {
                    e.Visible = DefaultBoolean.False;
                }

            }

            if (e.ButtonID == "Land")
            {
                if (OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_SunRise.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Sea.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Back.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking.ToString())
                {
                    e.Visible = DefaultBoolean.True;
                }
                else
                {
                    e.Visible = DefaultBoolean.False;
                }
            }
            if (e.ButtonID == "WalkingPatrol")
            {
                if (OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_SunRise.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Sea.ToString() ||
                    OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Back.ToString() ||
                     OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking.ToString())
                {
                    e.Visible = DefaultBoolean.True;
                }
                else
                {
                    e.Visible = DefaultBoolean.False;
                }
            }
            if (e.ButtonID == "BackFromAway")
            {
                if (OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Away.ToString())
                {
                    e.Visible = DefaultBoolean.True;
                }
                else
                {
                    e.Visible = DefaultBoolean.False;
                }
            }
            if (e.ButtonID == "BackFromLand")
            {
                if (OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_Land.ToString())
                {
                    e.Visible = DefaultBoolean.True;
                }
                else
                {
                    e.Visible = DefaultBoolean.False;
                }
            }
            if (e.ButtonID == "BackFromWalking")
            {
                if (OpsLiveGrid.GetRowValues(e.VisibleIndex, "PatrolPersonStateID").ToString() == Core.Handler_AhwalMapping.PatrolPersonState_WalkingPatrol.ToString())
                {
                    e.Visible = DefaultBoolean.True;
                }
                else
                {
                    e.Visible = DefaultBoolean.False;
                }
            }

        }

        protected void OpsLiveGrid_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            var user = (User)Session["User"];
            if (user == null)
                return;
            var value = OpsLiveGrid.GetRowValues(e.VisibleIndex, "AhwalMappingID").ToString();
            var personState = new PatrolPersonState();
            if (e.ButtonID == "Away")
            {
                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Away;
                var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(value), personState);
                if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                {
                    OpsLiveGrid.DataBind();
                }
            }
            else if (e.ButtonID == "Land")
            {
                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Land;
                var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(value), personState);
                if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                {
                    OpsLiveGrid.DataBind();
                }
            }
            else if (e.ButtonID == "BackFromAway")
            {
                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Back;
                var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(value), personState);
                if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                {
                    OpsLiveGrid.DataBind();
                }
            }
            else if (e.ButtonID == "BackFromLand")
            {
                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Sea;
                var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(value), personState);
                if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                {
                    OpsLiveGrid.DataBind();
                }
            }
            else if (e.ButtonID == "WalkingPatrol")
            {
                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_WalkingPatrol;
                var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(value), personState);
                if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                {
                    OpsLiveGrid.DataBind();
                }
            }
            else if (e.ButtonID == "BackFromWalking")
            {
                personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking;
                var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(value), personState);
                if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
                {
                    OpsLiveGrid.DataBind();
                }
            }

        }
        protected void LoadLayout()
        {
            //var user = (User)Session["User"];
            //if (user == null)
            //    return;
            //OpsLiveGrid.CollapseAll();

            ////load user default layout prefernce
            //DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            //var user_saved_layout = db.Users.First<User>(eu => eu.UserID == user.UserID);
            //if (user_saved_layout != null)
            //{
            //    var lay = user_saved_layout.Layout_OpsLive;
            //    if (lay != null)
            //    {
            //        OpsLiveGrid.LoadClientLayout(lay);// this is for columns positions only
            //    }
            //    var group = user_saved_layout.Layout_Groups_OpsLiveGrid;
            //    if (group != null)
            //    {
            //        if (group != "" && !group.Equals(DBNull.Value))
            //        {
            //            var splittedstring = group.Split(';');
            //            if (splittedstring.Length > 0)
            //            {
            //                try
            //                {
            //                    foreach (var s in splittedstring)
            //                    {
            //                        if (s != "")
            //                            OpsLiveGrid.ExpandRow(Convert.ToInt16(s.ToString()));
            //                    }
            //                }
            //                catch (Exception)
            //                {

            //                }
            //            }

            //        }
            //    }
            //    else
            //    {
            //        OpsLiveGrid.ExpandAll();
            //    }

            //}
        }
        protected void OpsLiveGrid_ClientLayout(object sender, ASPxClientLayoutArgs e)
        {
            //   LoadLayout();
        }

        protected void OpsLiveGrid_AfterPerformCallback(object sender, ASPxGridViewAfterPerformCallbackEventArgs e)
        {
            //if (e.CallbackName == "APPLYCOLUMNFILTER")
            //{
            //    if (e.Args.ElementAt<string>(1) == "") //nothing typed there, so load default layout
            //    {
            //        LoadLayout();
            //    }
            //    else //something typed there, so exapnd all groups
            //    {
            //        OpsLiveGrid.ExpandAll();
            //    }
            //}
        }

        protected void OpenAllGroupsButton_Click(object sender, EventArgs e)
        {
            OpsLiveGrid.ExpandAll();
        }

        protected void CloseAllGroupsButton_Click(object sender, EventArgs e)
        {
            OpsLiveGrid.CollapseAll();
        }

        protected void SaveGroupsButton_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
            if (user == null)
                return;
            var user_saved_layout = db.Users.First<User>(eu => eu.UserID == user.UserID);
            if (user_saved_layout == null)
            {
                return;
            }
            var layoutString = OpsLiveGrid.SaveClientLayout();
            user_saved_layout.Layout_OpsLive = layoutString;
            var groupsString = "";
            for (Int32 i = 0; i < OpsLiveGrid.VisibleRowCount; i++)
            {
                if (OpsLiveGrid.IsGroupRow(i) && OpsLiveGrid.IsRowExpanded(i))
                    groupsString += i.ToString() + ";";
            }
            if (groupsString != "")
            {
                user_saved_layout.Layout_Groups_OpsLiveGrid = groupsString;
            }
            db.SubmitChanges();
        }

        protected void OpsLive_States_Grid_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
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

        protected void OpsLiveGrid_CustomCallback(object sender, ASPxGridViewCustomCallbackEventArgs e)
        {
            if (e.Parameters.StartsWith("LatestStates"))
            {
                var splitted = e.Parameters.Split(';');

                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);
                //var mappingID = OpsLiveGrid.GetRowValues(Convert.ToInt32(splitted[1]), "AhwalMappingID");
                //if (mappingID != null)
                //{

                var personmapping = db.AhwalMappings.FirstOrDefault(em => em.AhwalMappingID == Convert.ToInt64(splitted[1]));
                Session["OpsLiveStatePersonID"] = personmapping.PersonID;

                //OpsLive_States_Grid.DataBind();
                //}
            }

        }
        protected void AttahcIncidentSubmitButton_Click(object sender, EventArgs e)
        {
            if (AttachIncident_GridLookUp.Value == null)
            {
                return;
            }
            if (Request.Form["AttachIncidentMappingID"] != null)
            {
                if (Request.Form["AttachIncidentMappingID"].ToString().Equals(DBNull.Value) ||
                     Request.Form["AttachIncidentMappingID"].ToString() == "")
                {
                    return;
                }
                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);

                var mappingID = Convert.ToInt16(Request.Form["AttachIncidentMappingID"]);
                // var mappingID = OpsLiveGrid.GetRowValues(rowIndex, "AhwalMappingID");
                var personmapping = db.AhwalMappings.FirstOrDefault<AhwalMapping>(em => em.AhwalMappingID == Convert.ToInt64(mappingID));

                if (personmapping != null)
                {
                    //we have to check the current state of the person, if he is not in one of the allowed statees, we cannot handover the incident to him

                    var selectedIncidentID = AttachIncident_GridLookUp.Value;
                    if (selectedIncidentID != null)
                    {
                        var incidentObj = db.Incidents.FirstOrDefault<Incident>(a => a.IncidentID == Convert.ToInt64(selectedIncidentID));
                        if (incidentObj == null)
                        {
                            return;
                        }
                        var usersession = (User)Session["User"];
                        if (usersession == null)
                        {
                            return;
                        }
                        var user = (User)usersession;
                        Core.Handler_Incidents.HandOver_Incident_To_Person(user, personmapping, incidentObj);
                        OpsLiveGrid.DataBind();
                        IncidentsGrid.DataBind();
                        OpsLive_IncidentAttach_PopUp.ShowOnPageLoad = false;
                    }

                }
            }
        }

        protected void AttachedIncident_Release_Button_Click(object sender, EventArgs e)
        {
            if (Request.Form["AttachIncidentMappingID"] != null)
            {
                if (Request.Form["AttachIncidentMappingID"].ToString().Equals(DBNull.Value) ||
                     Request.Form["AttachIncidentMappingID"].ToString() == "")
                {
                    return;
                }
                DataClassesDataContext db = new DataClassesDataContext(Handler_Global.connectString);

                var mappingID = Convert.ToInt16(Request.Form["AttachIncidentMappingID"]);
                // var mappingID = OpsLiveGrid.GetRowValues(rowIndex, "AhwalMappingID");
                var personmapping = db.AhwalMappings.FirstOrDefault<AhwalMapping>(em => em.AhwalMappingID == Convert.ToInt64(mappingID));

                if (personmapping != null)
                {
                    if (personmapping.IncidentID != null && !personmapping.IncidentID.Equals(DBNull.Value))
                    {
                        var incidentObj = db.Incidents.FirstOrDefault<Incident>(a => a.IncidentID == personmapping.IncidentID);
                        if (incidentObj == null)
                        {
                            return;
                        }
                        var usersession = (User)Session["User"];
                        if (usersession == null)
                        {
                            return;
                        }
                        var user = (User)usersession;
                        Core.Handler_Incidents.UnHandOver_Incident_To_Person(user, personmapping, incidentObj);
                        OpsLiveGrid.DataBind();
                        IncidentsGrid.DataBind();


                    }
                }

            }
            OpsLive_States_PopUp.ShowOnPageLoad = false;
        }


        protected void LiveCaller_Away_Button_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            if (user == null)
                return;

            var AhwalMappingID = Request.Form["LiveCaller_AwahlMappingID"];
            if (AhwalMappingID == null)
                return;
            var personState = new PatrolPersonState();

            personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Away;
            var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(AhwalMappingID), personState);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                OpsLiveGrid.DataBind();
            }
            LiveCaller_PopUp.ShowOnPageLoad = false;
        }

        protected void LiveCaller_Land_Button_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            if (user == null)
                return;

            var AhwalMappingID = Request.Form["LiveCaller_AwahlMappingID"];
            if (AhwalMappingID == null)
                return;
            var personState = new PatrolPersonState();

            personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Land;
            var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(AhwalMappingID), personState);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                OpsLiveGrid.DataBind();
            }
            LiveCaller_PopUp.ShowOnPageLoad = false;
        }

        protected void LiveCaller_BackFromAway_Button_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            if (user == null)
                return;

            var AhwalMappingID = Request.Form["LiveCaller_AwahlMappingID"];
            if (AhwalMappingID == null)
                return;
            var personState = new PatrolPersonState();

            personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Back;
            var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(AhwalMappingID), personState);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                OpsLiveGrid.DataBind();
            }
            LiveCaller_PopUp.ShowOnPageLoad = false;
        }

        protected void LiveCaller_BackFromLand_Button_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            if (user == null)
                return;

            var AhwalMappingID = Request.Form["LiveCaller_AwahlMappingID"];
            if (AhwalMappingID == null)
                return;
            var personState = new PatrolPersonState();

            personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_Sea;
            var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(AhwalMappingID), personState);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                OpsLiveGrid.DataBind();
            }
            LiveCaller_PopUp.ShowOnPageLoad = false;
        }
        protected void LiveCaller_Walking_Button_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            if (user == null)
                return;

            var AhwalMappingID = Request.Form["LiveCaller_AwahlMappingID"];
            if (AhwalMappingID == null)
                return;
            var personState = new PatrolPersonState();

            personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_WalkingPatrol;
            var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(AhwalMappingID), personState);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                OpsLiveGrid.DataBind();
            }
            LiveCaller_PopUp.ShowOnPageLoad = false;
        }


        protected void LiveCaller_BackFromWalking_Button_Click(object sender, EventArgs e)
        {
            var user = (User)Session["User"];
            if (user == null)
                return;

            var AhwalMappingID = Request.Form["LiveCaller_AwahlMappingID"];
            if (AhwalMappingID == null)
                return;
            var personState = new PatrolPersonState();

            personState.PatrolPersonStateID = Core.Handler_AhwalMapping.PatrolPersonState_BackFromWalking;
            var result = Core.Handler_AhwalMapping.Ops_ChangePersonState(user, Convert.ToInt64(AhwalMappingID), personState);
            if (result.StatusID == Core.Handler_Operations.Opeartion_Status_Success)
            {
                OpsLiveGrid.DataBind();
            }
            LiveCaller_PopUp.ShowOnPageLoad = false;
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
                var clearIncidentView = db.IncidentsViews.FirstOrDefault<IncidentsView>(a => a.UserID==user.UserID && a.IncidentID == incident.IncidentID);
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

            //Comments_Extra1_Name
            //Comments_Extra1_Value
            //var Comments_Extra1_Name = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_Extra1_Name"));
            //var Comments_Extra1_Value = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_Extra1_Value"));
            //var Comments_Extra2_Name = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_Extra2_Name"));
            //var Comments_Extra2_Value = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_Extra2_Value"));
            //var Comments_Extra3_Name = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_Extra3_Name"));
            //var Comments_Extra3_Value = (ASPxLabel)(CommentsGrid.FindTitleTemplateControl("Comments_Extra3_Value"));

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