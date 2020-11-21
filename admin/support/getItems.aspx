<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("value", true, InputRule.DIGITS);
        validator.Add("supplier", true, InputRule.DIGITS);
        if (validator.Validate())
        {
            ClassDB db = new ClassDB(Request, Response);
            Hashtable hsItem = db.GetRecords("select * from view_item_master where id='" + Request["value"] + "'");

            string json_string = "{";
            if(hsItem.Count > 0)
            {
                json_string += "\"stockgrp_id\":\"" + hsItem["stockgrp_id"] + "\",";
                json_string += "\"stockgrp_name\":\"" + hsItem["stockgrp_name"] + "\",";
                json_string += "\"code\":\"" + hsItem["item_code"] + "\",";
                json_string += "\"name\":\"" + hsItem["item_name"] + "\",";
                json_string += "\"manufacture_name\":\"" + hsItem["manufacture_name"] + "\",";
                json_string += "\"per_unit_qty\":\"" + hsItem["per_unit_qty"] + "\",";
                json_string += "\"symbol\":\"" + hsItem["symbol"] + "\",";
                json_string += "\"purchase_rate\":\"" + hsItem["purchase_rate"] + "\",";
                json_string += "\"sale_rate\":\"" + hsItem["sale_rate"] + "\",";
                json_string += "\"mrp\":\"" + hsItem["mrp"] + "\",";
                string gstper = "0";
                if(String.IsNullOrWhiteSpace(Request["supplier"]))
                {
                    string cmpstate = db.GetText("tbl_company_master", "state_id", "id='" + db.COMPANY["id"] + "'");
                    string supstate = db.GetText("tbl_ledger_master", "state_id", "id='" + Request["supplier"] + "'");
                    if(cmpstate!=supstate)
                    {
                        gstper = hsItem["igst"].ToString();
                    }
                    else
                    {
                        gstper = (Convert.ToDecimal(hsItem["cgst"].ToString()) + Convert.ToDecimal(hsItem["sgst"].ToString())).ToString("0.00");
                    }
                }
                json_string += "\"gstper\":\"" + gstper + "\",";
                json_string += "\"store_id\":\"" + hsItem["store_id"] + "\",";
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
        //Response.Write(ex.ToString()); 
    }

%>