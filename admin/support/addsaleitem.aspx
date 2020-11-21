<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("item_name", true, InputRule.DIGITS);
        validator.Add("item_qty", true, InputRule.DECIMAL);
        validator.Add("ref_no", false, InputRule.ALPHA_NUMERIC_NO_SPACE);
        validator.Add("mfg_dt", false, InputRule.DATE_HYPHEN);
        validator.Add("exp_dt", false, InputRule.DATE_HYPHEN);
        validator.Add("rate", true, InputRule.DECIMAL);
        validator.Add("netrate", true, InputRule.DECIMAL);
        validator.Add("discper", true, InputRule.DECIMAL);
        validator.Add("discrate", true, InputRule.DECIMAL);
        validator.Add("gross", true, InputRule.DECIMAL);
        validator.Add("gstper", true, InputRule.DECIMAL);
        validator.Add("gstrate", true, InputRule.DECIMAL);
        validator.Add("cessper", true, InputRule.DECIMAL);
        validator.Add("cessrate", true, InputRule.DECIMAL);
        validator.Add("totprice", true, InputRule.DECIMAL);
        validator.Add("free_item_name", false, InputRule.DIGITS);
        validator.Add("freeitem_qty", false, InputRule.DECIMAL);
        if(Convert.ToDecimal(Request["freeitem_qty"].ToString())>0)
            validator.Add("freeitem_qty_type", true, InputRule.DIGITS);
        else
            validator.Add("freeitem_qty_type", false, InputRule.DIGITS);
        validator.Add("store", true, InputRule.DECIMAL);
        validator.Add("add", true, InputRule.ALPHABET_NO_SPACE);
        validator.Add("sup", true, InputRule.DIGITS);
        validator.Add("taxcalc", true, InputRule.DIGITS);
        if (validator.Validate())
        {
            DataTable dtItem = null;
            if (Session["dtItem"] == null)
            {
                dtItem = new DataTable();
                dtItem.Columns.Add("item_id");
                dtItem.Columns.Add("order_qty");
                dtItem.Columns.Add("ref_no");
                dtItem.Columns.Add("mfg_dt");
                dtItem.Columns.Add("exp_dt");
                dtItem.Columns.Add("rate");
                dtItem.Columns.Add("netrate");
                dtItem.Columns.Add("disc_per");
                dtItem.Columns.Add("disc_amt");
                dtItem.Columns.Add("gross");
                dtItem.Columns.Add("gst_per");
                dtItem.Columns.Add("gst_amt");
                dtItem.Columns.Add("cess_per");
                dtItem.Columns.Add("cess_amt");
                dtItem.Columns.Add("total_rate");
                dtItem.Columns.Add("free_item");
                dtItem.Columns.Add("free_item_qty");
                dtItem.Columns.Add("free_qty_type");
                dtItem.Columns.Add("store_id");
                dtItem.Columns.Add("lgr_id");
                dtItem.Columns.Add("taxcalc");
                Session["dtItem"] = dtItem;
            }
            else
            {
                dtItem = (DataTable)Session["dtItem"];
            }

            if (Request["add"].ToUpper() == "ADD")
            {
                 dtItem.Rows.Add(Request["item_name"], Request["item_qty"], 
                    Request["ref_no"], Request["mfg_dt"], Request["exp_dt"], Request["rate"], Request["netrate"], Request["discper"], Request["discrate"], 
                    Request["gross"],Request["gstper"], Request["gstrate"], Request["cessper"], Request["cessrate"], 
                    Request["totprice"],Request["free_item_name"],Request["freeitem_qty"],Request["freeitem_qty_type"],Request["store"],Request["sup"],Request["taxcalc"]
                    );
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
        Response.Write(ex.ToString()); 
    }
    
%>