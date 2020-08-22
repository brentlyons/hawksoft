<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="contacts.aspx.cs" Inherits="hawksoft.contacts" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Hawksoft Code Test - Contacts</title>
    <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css" />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Josefin+Sans:300,400|Roboto:300,400,500" />
    <link rel="stylesheet" href="assets/css/style.css" />
    <script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-1.8.0.js"></script>
    <script src="https://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.22/jquery-ui.js"></script>
    <script src="assets/js/jquery.mask.min.js"></script>
    <link href="https://ajax.aspnetcdn.com/ajax/jquery.ui/1.8.10/themes/redmond/jquery-ui.css" rel="stylesheet" />

    <link href="css/style.css" rel="stylesheet" />
    <style>
        .tbl 
        {
            border: 1px solid #cccccc !important;
            border-radius: 10px 10px !important;
            background-color: #ffffff !important;
            padding: 5px !important;
            margin-bottom: 10px;
        }
    </style>

    <script>
        function saveContact(id) {
            document.getElementById('txtHdnSave').value = id;
            document.forms[0].submit();
        }

        function delContact(id) {
            if (confirm('Are you sure you want to PERMANENTLY delete this contact?') == 1) {
                document.getElementById('txtHdnDel').value = id;
                document.forms[0].submit();
            }
        }

        function addContact() {
            document.getElementById('txtHdnAdd').value = '1';
            document.forms[0].submit();
        }

        function changePage(pgLtr, pgNum) {
            window.location = "contacts.aspx?pgLtr=" + pgLtr + "&page=" + pgNum;
        }
    </script>
</head>
<body>
    <form id="frmContacts" method="post" action="contacts.aspx">
        <nav aria-label="Letter navigation" style="padding: 0px !important; margin: 0px !important; vertical-align: text-bottom">
            <ul class="pagination pagination-sm" style="padding: 0px !important; margin: 0px !important; vertical-align: bottom">
                <%
                for (char letter = 'A'; letter <= 'Z'; letter++)
                { %>
                <li class="page-item" onclick="changePage('<%=letter %>','1')"><a href="#" onclick="" ><%=letter %></a></li>
                <% } %>
            </ul>
        </nav>
        <nav aria-label="Page navigation" style="padding: 0px !important; margin: 0px !important; vertical-align: text-bottom">Page:
            <ul class="pagination pagination-sm" style="padding: 0px !important; margin: 0px !important; vertical-align: bottom">
                <%
                    var pgLtr = Request.QueryString["pgLtr"];
                    var pgNum = Request.QueryString["pgNum"];
                    if (pgLtr == null) pgLtr = "A";
                    if (pgNum == null) pgNum = "1";

                    var iPages = getPages(pgLtr)+1;
                    for (var i=0; i<iPages; i++)
                    { %>
                    <li class="page-item" onclick="changePage('<%=pgLtr %>','<%=i %>')"><a href="#" onclick="" ><%=i+1 %></a></li>
                    <% } %>
            </ul>
        </nav>

            <label id="lblStatus" runat="server" class="frm-text-red"></label>
            <table class="tbl" style="background-color: #eeeeee !important">
                <tr>
                    <td colspan="2">Add New Contact</td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">First Name:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtFNameNew" name="txtFNameNew" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Last Name:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtLNameNew" name="txtFNameNew" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">EMail:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtEMailNew" name="txtEMailNew" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Address Line 1:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtAddr1" name="txtAddr1New" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Address Line 2:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtAddr2" name="txtAddr2New" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">City:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtCity" name="txtCityNew" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">State:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtState" name="txtStateNew" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Zip:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtZip" name="txtZipNew" maxlength="50" /></div></td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: left">
                        <input type="button" class="gridbtn" id="cmdAdd" name="cmdAdd" value="add contact" onclick="addContact()" />
                    </td>
                </tr>
            </table>
            <%
                DataSet ds = new DataSet();

                ds = loadContacts(pgLtr, Convert.ToInt32(pgNum));

                StringBuilder sb = new StringBuilder();


                for (var i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    sb.Clear();
                    sb.Append(ds.Tables[0].Rows[i]["contact_id"].ToString());
            %>
            <table class="tbl">
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">First Name:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" name="txtFName<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["first_name"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Last Name:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" id="txtLName<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["last_name"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">EMail:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" name="txtEMail<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["email_addr"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Address Line 1:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" name="txtAddr1<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["addr_street1"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Address Line 2:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" name="txtAddr2<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["addr_street2"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">City:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" name="txtCity<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["addr_city"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">State:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" name="txtState<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["addr_state"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td class="form-inline text-right"><label class="frm-text-bold">Zip:</label></td>
                    <td class="form-inline"><div class="col"><input type="text" class="form-control" name="txtZip<%=sb.ToString() %>" maxlength="50" value="<%=ds.Tables[0].Rows[i]["addr_zip"].ToString() %>" /></div></td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: left">
                        <input type="button" class="gridbtn" id="cmdSave" value="save" onclick="saveContact('<%=ds.Tables[0].Rows[i]["contact_id"].ToString()%>')" />
                        <input type="button" class="gridbtn" value="delete" onclick="delContact('<%=ds.Tables[0].Rows[i]["contact_id"].ToString()%>')" />
                    </td>
                </tr>
            </table>
            <%
            }
            %>
        <input type="hidden" id="txtHdnSave" name="txtHdnSave" runat="server" />
        <input type="hidden" id="txtHdnDel" name="txtHdnDel" runat="server" />
        <input type="hidden" id="txtHdnAdd" name="txtHdnAdd" runat="server" />
    </form>
</body>
</html>
