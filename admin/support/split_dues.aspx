<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("totpay", true, InputRule.DECIMAL);
        validator.Add("suppliers", true, InputRule.DIGITS);
        if (validator.Validate())
        {
            string json_string = "{";
            decimal totamt = Convert.ToDecimal(Request["totpay"]);
            ClassDB db = new ClassDB(Request, Response);
            Hashtable hsLdg = db.GetRecords("select id, name, code, mobile_no, group_id, billing_type from tbl_ledger_master where company_id='" + db.COMPANY["id"] + "' and id='"+Request["suppliers"]+"'");
            if (hsLdg.Count > 0)
            {
                string crdr_type = hsLdg["group_id"].ToString() == "4" ? "CR" : "DR";
                SqlDataReader dr = db.GetDataReader("select * from tbl_inventory_master where status=1 and ledger_id='" + hsLdg["id"] + "' and company_id='" + db.COMPANY["id"] + "'");
                if (dr.HasRows)
                {
                    while (dr.Read())
                    {
                        decimal invamt = Convert.ToDecimal(dr["total_amt"].ToString());
                        decimal apaid = 0;
                        if(crdr_type == "CR")
                            apaid = Convert.ToDecimal(db.GetSum("isnull(dr,0)", "tbl_transaction_master", "company_id='" + db.COMPANY["id"] + "' and autogen_id='" + dr["autogen_id"] + "' and ledger_id='" + hsLdg["id"] + "'"));
                        else
                            apaid = Convert.ToDecimal(db.GetSum("isnull(cr,0)", "tbl_transaction_master", "company_id='" + db.COMPANY["id"] + "' and autogen_id='" + dr["autogen_id"] + "' and ledger_id='" + hsLdg["id"] + "'"));


                        decimal dues = invamt - apaid;
                        if (dues > 0)
                        {
                            decimal splitamt = totamt <= 0 ? 0 : totamt <= dues ? totamt : dues;
                            json_string += "\"paidamt_" + dr["id"] + "\":\"" + splitamt + "\",";
                            totamt = totamt - splitamt;
                        }
                    }
                }
            }
            json_string = json_string.Substring(0, json_string.Length - 1);
            json_string += "}";

            Response.Clear();
            Response.ContentType = "application/json;charset=UTF-8";
            Response.Write(json_string + Request["chk"]);
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