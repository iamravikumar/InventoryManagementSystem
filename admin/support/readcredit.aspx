<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("supplier", true, InputRule.DIGITS);
        if (validator.Validate())
        {
            decimal bal = 0;
            string baltype = "None";
            Hashtable dues = new InventoryCore(Request, Response).getSupDue(Request["supplier"].ToString(), DateTime.Now.ToString("yyyy-MM-dd"));
            if (dues.Count > 0)
            {
                bal = Convert.ToDecimal(dues["bal"].ToString());
                baltype = dues["bal_type"].ToString();
            }
            string json_string = "{\"bal\":\"" + bal.ToString("0.00") + "\",\"baltype\":\"" + baltype + "\"}";

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