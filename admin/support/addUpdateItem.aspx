<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>

<%
    try
    {
        InputValidator validate = new InputValidator(Request);
        validate.Add("nwstockgrp", true, InputRule.DIGITS);
        validate.Add("nwitem_name", true, InputRule.ALL, 100, 0);
        validate.Add("nwprint_name", true, InputRule.ALL, 100, 0);
        validate.Add("nwitem_manufacture", true, InputRule.ALL);
        validate.Add("nwbarcode", false, InputRule.ALPHA_NUMERIC_NO_SPACE, 100, 0);
        validate.Add("nwqty_type", true, InputRule.DIGITS);
        validate.Add("nwpurchase_rate", true, InputRule.DECIMAL);
        validate.Add("nwsale_rate", true, InputRule.DECIMAL);
        validate.Add("nwmrp", true, InputRule.DECIMAL);
        validate.Add("nwcgst", true, InputRule.DECIMAL);
        validate.Add("nwsgst", true, InputRule.DECIMAL);
        validate.Add("nwigst", true, InputRule.DECIMAL);
        validate.Add("nwhsn_code", false, InputRule.ALL);
        validate.Add("nwopening_quantity", false, InputRule.DECIMAL);
        validate.Add("nwopening_rate", false, InputRule.DECIMAL);
        validate.Add("nwtotal_value", false, InputRule.DECIMAL);
        validate.Add("nwstoreid", false, InputRule.DIGITS);
        if (validate.Validate())
        {
            string table_name = "tbl_item_master";
            string json_string = "";
            ClassDB db = new ClassDB(Request, Response);
            Hashtable inst_data = new Hashtable();
            inst_data.Add("stockgrp_id", Request["nwstockgrp"].ToUpper());
            inst_data.Add("item_name", Request["nwitem_name"].ToUpper());
            inst_data.Add("print_name", Request["nwprint_name"].ToUpper());
            inst_data.Add("manufacture_name", Request["nwmanufacture_name"].ToUpper());
            if (Request["nwbarcode"] != null && Request["nwbarcode"] != "")
                inst_data.Add("barcode", Request["nwbarcode"].ToUpper());
            inst_data.Add("per_unit_qty", Request["nwqty_type"].ToUpper());
            inst_data.Add("purchase_rate", Request["nwpurchase_rate"].ToUpper());
            inst_data.Add("sale_rate", Request["nwsale_rate"].ToUpper());
            inst_data.Add("mrp", Request["nwmrp"].ToUpper());
            inst_data.Add("cgst", Request["nwcgst"].ToUpper());
            inst_data.Add("sgst", Request["nwsgst"].ToUpper());
            inst_data.Add("igst", Request["nwigst"].ToUpper());
            if (Request["nwhsn_code"] != null && Request["nwhsn_code"] != "")
                inst_data.Add("hsn_code", Request["nwhsn_code"].ToUpper());
            if (Request["nwopening_quantity"] != null && Request["nwopening_quantity"] != "")
                inst_data.Add("opening_quantity", Request["nwopening_quantity"].ToUpper());
            if (Request["nwopening_rate"] != null && Request["nwopening_rate"] != "")
                inst_data.Add("opening_rate", Request["nwopening_rate"].ToUpper());
            if (Request["nwtotal_value"] != null && Request["nwtotal_value"] != "")
                inst_data.Add("total_value", Request["nwtotal_value"].ToUpper());
            inst_data.Add("company_id", db.COMPANY["id"]);
            if (Request["nwstoreid"] != null && Request["nwstoreid"] != "")
                inst_data.Add("store_id", Request["nwstoreid"].ToUpper());
            inst_data.Add("status", 1);
            int count = Convert.ToInt32(db.GetCount("*", table_name, "id='" + Request["select_item"] + "'"));
            if (count == 0)
            {
                inst_data.Add("item_code", new InventoryCore(Request, Response).getItmCode());
                long res = db.Insert(table_name, inst_data);
                if (res > 0)
                {
                    json_string = res.ToString();
                }
            }
            else
            {
                long res = db.Update(table_name, inst_data, "id='" + Request["select_item"] + "'");
                if (res > 0)
                {
                    json_string = Request["select_item"];
                }
            }
            Response.Clear();
            Response.ContentType = "application/json;charset=UTF-8";
            Response.Write(json_string);
        }
        else
        {
            Hashtable erros = validate.GetErrors();
%>
<style>
        #table_wrap{white-space:nowrap}
    <%
            foreach (string s in erros.Keys)
            {
            
                %>
                #<%=s %> {
                background-color: #ffa8a8;
        }
    <% 
            }
            %>
        </style>
<%
        
        }
    }
    catch (Exception ex)
    {
        Response.Write(ex.ToString()); 
    }
    
%>