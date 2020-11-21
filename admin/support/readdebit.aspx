<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
    try
    {
        InventoryCore ic = new InventoryCore(Request, Response);
        InputValidator validator = new InputValidator(Request);
        validator.Add("supplier", true, InputRule.DIGITS);
        if (validator.Validate())
        {
            string details = "";
            decimal bal = 0;
            string baltype = "None";
            Hashtable dues = ic.getCustDue(Request["supplier"].ToString(), DateTime.Now.ToString("yyyy-MM-dd"));
            if (dues.Count > 0)
            {
                bal = Convert.ToDecimal(dues["bal"].ToString());
                baltype = dues["bal_type"].ToString();
            }

            Hashtable data = ic.GetRecords("tbl_ledger_master", "*", "company_id='" + ic.COMPANY["id"] + "' and id='" + Request["supplier"].ToString() + "'");
            if(data.Count > 0)
            {
                details += "<address><strong>";
                details += "" + data["name"] + " (" + data["code"] + ")</strong><br>";
                if (data["address_1"] != "")
                {
                    details += "" + data["address_1"] + " ";
                    details += "" + data["address_2"] + " ";
                    details += "" + data["city"] + "<br>";
                    details += "Pin Code:- " + data["pincode"] + "<br>";
                }
                details += "Phone: (91) " + data["mobile_no"] + "<br>";
                details += "GSTIN No.: " + data["gstin_no"] + "<br /> ";
                details += "<b>" + baltype + " : &#8377; " + bal + "</b><br />";
                details += "</address>";
            }
            else
            {
                details = "None";
            }

            string json_string = "{\"details\":\"" + details + "\"}";

            Response.Clear();
            Response.ContentType = "application/json;charset=UTF-8";
            Response.Write(json_string);
        }
        else
        {
            string json_string = "{";
            json_string += "\"type\":\"error\",";
            Hashtable tbl = validator.GetErrors();
            foreach (string s in tbl.Keys)
            {
                json_string += "\"" + s + "\":\"" + s + "\",";
            }
            json_string = json_string.Substring(0, json_string.Length - 1);
            json_string += "}";
            Response.Clear();
            Response.ContentType = "application/json;charset=UTF-8";
            Response.Write(json_string);
        }
    }
    catch (Exception ex)
    {
        Response.Write(ex.ToString());
    }

%>