<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("sup", true, InputRule.DIGITS);
        validator.Add("item_name", true, InputRule.DIGITS);
        validator.Add("item_qty", true, InputRule.DECIMAL);
        validator.Add("item_qty_type", true, InputRule.DIGITS);
        validator.Add("usp", true, InputRule.DECIMAL);
        validator.Add("vsp", true, InputRule.DECIMAL);
        validator.Add("add", true, InputRule.ALPHABET_NO_SPACE);
        if (validator.Validate())
        {
            DataTable dtItem = null;
            if (Session["dtItem"] == null)
            {
                dtItem = new DataTable();
                dtItem.Columns.Add("lgr_id");
                dtItem.Columns.Add("item_id");
                dtItem.Columns.Add("order_qty");
                dtItem.Columns.Add("unit_id");
                dtItem.Columns.Add("usp");
                dtItem.Columns.Add("vsp");
                Session["dtItem"] = dtItem;
            }
            else
            {
                dtItem = (DataTable)Session["dtItem"];
            }

            if (Request["add"].ToUpper() == "ADD")
            {
                dtItem.Rows.Add(Request["sup"], Request["item_name"], Request["item_qty"], Request["item_qty_type"], Request["usp"], Request["vsp"]);
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
        //Response.Write(ex.ToString()); 
    }
    
%>