<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("sgname", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
        if (validator.Validate())
        {
            string table_name = "tbl_stockgroup_master";
            string json_string = "Unknown Error.";
            ClassDB db = new ClassDB(Request, Response);
            Hashtable inst_data = new Hashtable();
            inst_data.Add("name", Request["sgname"].ToUpper());
            inst_data.Add("description", Request["sgdescription"].ToUpper());
            inst_data.Add("company_id", db.COMPANY["id"]);
            int count = Convert.ToInt32(db.GetCount("*", table_name, "company_id='" + db.COMPANY["id"] + "' and name='" + Request["sgname"] + "'"));
            if (count == 0)
            {
                inst_data.Add("code", new InventoryCore(Request, Response).getStockGrpCode());
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
            Response.Clear();
            Response.ContentType = "application/json;charset=UTF-8";
            Response.Write(json_string);
        }
        else
        {
            Hashtable erros = validator.GetErrors();
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