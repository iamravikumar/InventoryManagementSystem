<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("symbol", true, InputRule.ALPHA_NUMERIC_NO_SPACE, 10, 0);
        validator.Add("formal_name", true, InputRule.ALPHA_NUMERIC_WITH_SPACE, 50, 0);
        if (validator.Validate())
        {
            string table_name = "tbl_unit_master";
            string json_string = "Unknown Error.";
            ClassDB db = new ClassDB(Request, Response);
            Hashtable inst_data = new Hashtable();
            inst_data.Add("symbol", Request["symbol"].ToUpper());
            inst_data.Add("formal_name", Request["formal_name"].ToUpper());
            inst_data.Add("company_id", db.COMPANY["id"]);
            int count = Convert.ToInt32(db.GetCount("*", table_name, "company_id='" + db.COMPANY["id"] + "' and symbol='" + Request["symbol"] + "'"));
            if (count == 0)
            {
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