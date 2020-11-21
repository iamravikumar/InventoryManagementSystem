<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("value", true, InputRule.DIGITS);
        validator.Add("itemval", true, InputRule.DIGITS);
        if (validator.Validate())
        {
            ClassDB db = new ClassDB(Request, Response);
            Hashtable hsItem = db.GetRecords("select * from view_item_qty_master where other_unit_id='" + Request["value"] + "' and item_id='" + Request["itemval"] + "'");

            if (hsItem.Count == 0)
            {
                hsItem = db.GetRecords("select * from view_item_master where id='" + Request["itemval"] + "'");
            }
                
            string json_string = "{";
            foreach (String key in hsItem.Keys)
            {
                String k = key.Trim();
                string val = "";
                if (hsItem[k] == null)
                    val = null;
                else if (hsItem[k].GetType() == typeof(DateTime))
                    val = ((DateTime)hsItem[k]).ToString("dd-MM-yyyy");
                else
                    val = Convert.ToString(hsItem[k]).Replace("'", "''").Trim();

                json_string += "\"" + k + "\":\"" + val + "\",";
            }
            json_string = json_string.Substring(0, json_string.Length - 1);
            json_string += "}";

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