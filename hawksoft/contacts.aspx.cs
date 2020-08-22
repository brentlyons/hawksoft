using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace hawksoft
{
    public partial class contacts : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if ((Request.Form["txtHdnSave"]!=null) && (Request.Form["txtHdnSave"] != ""))
            {
                saveContact();
            }
            else if ((Request.Form["txtHdnDel"]!=null) && (Request.Form["txtHdnDel"] != ""))
            {
                delContact();
            }
            else if ((Request.Form["txtHdnAdd"]!=null) && (Request.Form["txtHdnAdd"] != ""))
            {
                addContact();
            }
        }


        public int getPages(string letter)
        {
            var myWS = new localhost.ws();

            var i = myWS.getPages(letter);

            return Convert.ToInt32(i);
        }

        public DataSet loadContacts(string pgLtr, int pgNum)
        {
            var myWS = new localhost.ws();

            DataSet ds = new DataSet();
            ds = myWS.getContacts(pgLtr, pgNum);

            return ds;            
        }

        public void addContact()
        {

            try
            {
                var myWS = new localhost.ws();
                var i = txtHdnSave.Value;

                var result = myWS.addContact(Request.Form["txtFName" + i], Request.Form["txtLName" + i], Request.Form["txtEMail" + i], Request.Form["txtAddr1" + i], Request.Form["txtAddr2" + i], Request.Form["txtCity" + i], Request.Form["txtState" + i], Request.Form["txtZip" + i]);
                lblStatus.InnerHtml = "Successfully added new contact.";
            }
            catch (Exception ex)
            {
                lblStatus.InnerHtml = "Error adding contact: " + ex.ToString();
            }

        }

        public void saveContact()
        {

            try
            {
                var myWS = new localhost.ws();
                var i = txtHdnSave.Value;

                myWS.saveContact(Request.Form["txtHdnSave"], Request.Form["txtFName" + i], Request.Form["txtLName" + i], Request.Form["txtEMail" + i], Request.Form["txtAddr1" + i], Request.Form["txtAddr2" + i], Request.Form["txtCity" + i], Request.Form["txtState" + i], Request.Form["txtZip" + i]);
                lblStatus.InnerHtml = "Successfully updated contact information.";
            }
            catch (Exception ex)
            {
                lblStatus.InnerHtml = "Error updating contact: " + ex.ToString();
            }

        }

        public void delContact()
        {
            try
            {
                var myWS = new localhost.ws();
                var i = txtHdnDel.Value;

                myWS.delContact(i);
                lblStatus.InnerHtml = "Successfully removed contact.";
            }
            catch (Exception ex)
            {
                lblStatus.InnerHtml = ex.ToString();
            }
        }
    }
}