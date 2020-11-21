<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>

<%
    try
    {
        InputValidator validate = new InputValidator(Request);
        validate.Add("name", true, InputRule.ALL, 200, 1);
        validate.Add("mobile_no", false, InputRule.DIGITS, 10, 10);
        validate.Add("contact_no", false, InputRule.DIGITS, 20, 10);
        validate.Add("address_1", false, InputRule.ALL, 200, 0);
        validate.Add("address_2", false, InputRule.ALL, 200, 0);
        validate.Add("pincode", false, InputRule.DIGITS, 6, 6);
        validate.Add("city", false, InputRule.ALL, 100, 0);
        validate.Add("state", true, InputRule.DIGITS);
        validate.Add("email", false, InputRule.EMAIL);
        validate.Add("gstin_no", false, InputRule.ALPHA_NUMERIC_NO_SPACE, 20, 0);
        validate.Add("gstin_type", false, InputRule.DIGITS);
        validate.Add("billing_type", true, InputRule.ALL);
        validate.Add("master_discount", false, InputRule.DECIMAL);
        validate.Add("group", true, InputRule.DIGITS);
        if (validate.Validate())
        {
            string table_name = "tbl_ledger_master";
            string json_string = "Unknown Error.";
            ClassDB db = new ClassDB(Request, Response);
            Hashtable inst_data = new Hashtable();
            inst_data.Add("group_id", Request["group"].ToUpper());
            inst_data.Add("name", Request["name"].ToUpper());
            inst_data.Add("mobile_no", Request["mobile_no"].ToUpper());
            inst_data.Add("contact_no", Request["contact_no"].ToUpper());
            inst_data.Add("address_1", Request["address_1"].ToUpper());
            inst_data.Add("address_2", Request["address_2"].ToUpper());
            inst_data.Add("pincode", Request["pincode"].ToUpper());
            inst_data.Add("city", Request["city"].ToUpper());
            inst_data.Add("state_id", Request["state"].ToUpper());
            inst_data.Add("email", Request["email"].ToUpper());
            inst_data.Add("gstin_no", Request["gstin_no"].ToUpper());
            if (Request["gstin_type"]!=null && Request["gstin_type"]!="")
                inst_data.Add("gstin_type_id", Request["gstin_type"].ToUpper());
            inst_data.Add("pan_no", Request["pan_no"].ToUpper());
            inst_data.Add("billing_type", Request["billing_type"].ToUpper());
            if (Request["master_discount"]!=null && Request["master_discount"]!="")
                inst_data.Add("master_discount", Request["master_discount"].ToUpper());
            else
                inst_data.Add("master_discount", 0);
            inst_data.Add("company_id", db.COMPANY["id"]);
            inst_data.Add("status", 1);
            int count = Convert.ToInt32(db.GetCount("*", table_name, "id='" + Request["select_supplier"] + "'"));
            if (count == 0)
            {
                inst_data.Add("code", new InventoryCore(Request, Response).getLedgerCode());
                long res = db.Insert(table_name, inst_data);
                if (res > 0)
                {
                    json_string = res.ToString();
                }
                else
                {
                    json_string = "Error While Updating Record.."+db.GetLastError();
                }
            }
            else
            {
                long res = db.Update(table_name, inst_data, "id='" + Request["select_supplier"] + "'");
                if (res > 0)
                {
                    json_string = Request["select_supplier"];
                }
                else
                {
                    json_string = "Error While Updating Record.."+db.GetLastError();
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