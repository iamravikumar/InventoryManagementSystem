<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
    try
    {
        InputValidator validator = new InputValidator(Request);
        validator.Add("value", true, InputRule.DIGITS);
        if (validator.Validate())
        {
            string crdr_type = "";
            decimal totamt = 0;
            decimal totdisc = 0;
            decimal totscg = 0;
            decimal totrndf = 0;
            decimal totrate = 0;
            decimal totdue = 0;

            string eTable = "";
            InventoryCore db = new InventoryCore(Request, Response);
            Hashtable hsLdg = db.GetRecords("select id, name, code, mobile_no, group_id, billing_type from tbl_ledger_master where company_id='" + db.COMPANY["id"] + "' and id='"+Request["value"]+"'");
            if (hsLdg.Count > 0)
            {
                eTable = "<table class='table table-bordered' style='width:70%; margin:auto; border:1px solid #000'>"
                    +"<thead>"
                    +"<tr>"
                    +"<th style='border:1px solid #000'>#</th>"
                    +"<th style='border:1px solid #000'>Invoice No.</th>"
                    +"<th style='border:1px solid #000'>Date</th>"
                    +"<th style='border:1px solid #000'>Amount</th>"
                    +"<th style='border:1px solid #000'>Discount</th>"
                    +"<th style='border:1px solid #000'>S. Charge</th>"
                    +"<th style='border:1px solid #000'>Round Off</th>"
                    +"<th style='border:1px solid #000'>Total</th>"
                    +"<th style='border:1px solid #000'>Dues</th>"
                    +"</tr>"
                    +"</thead><tbody>";

                SqlDataReader dr = db.GetDataReader("select * from tbl_inventory_master where company_id='" + db.COMPANY["id"] + "' and ledger_id='" + hsLdg["id"] + "' and dueamt>0 and status=1");
                if (dr.HasRows)
                {
                    int sl = 0;
                    while (dr.Read())
                    {
                        crdr_type = hsLdg["group_id"].ToString() == "4" ? "CR" : "DR";
                        decimal invamt = Convert.ToDecimal(dr["invoice_amt"].ToString());
                        decimal dicamt = Convert.ToDecimal(dr["discount_amt"].ToString());
                        decimal schgam = Convert.ToDecimal(dr["shipping_charge"].ToString());
                        decimal roffam = Convert.ToDecimal(dr["round_off"].ToString());
                        decimal totalm = Convert.ToDecimal(dr["total_amt"].ToString());
                        decimal tdue = Convert.ToDecimal(dr["dueamt"].ToString());

                        totamt += invamt;
                        totdisc += dicamt;
                        totscg += schgam;
                        totrndf += roffam;
                        totrate += totalm;
                        totdue += tdue;

                        eTable += "<tr>";
                        if(hsLdg["billing_type"].ToString()=="BILL WISE")
                        {
                            eTable += "<td style='border:1px solid #000'><input type='checkbox' name='invids_" + dr["id"] + "' id='invids_" + dr["id"] + "' value='" + dr["id"] + "' checked onclick='calctot(this, "+tdue.ToString("0.00")+")' /></td>";
                        }
                        else
                        {
                            eTable += "<td style='border:1px solid #000'>" + ++sl + "</td>";
                        }
                        eTable += "<td style='border:1px solid #000'>" + dr["autogen_id"] + "</td>";
                        eTable += "<td style='border:1px solid #000'>" + Convert.ToDateTime(dr["stock_dt"]).ToString("dd-MMM-yyyy") + "</td>";
                        eTable += "<td style='border:1px solid #000'>" + invamt.ToString("0.00") + "</td>";
                        eTable += "<td style='border:1px solid #000'>" + dicamt.ToString("0.00") + "</td>";
                        eTable += "<td style='border:1px solid #000'>" + schgam .ToString("0.00")+ "</td>";
                        eTable += "<td style='border:1px solid #000'>" + roffam.ToString("0.00") + "</td>";
                        eTable += "<td style='border:1px solid #000'>" + totalm.ToString("0.00") + "</td>";
                        eTable += "<td style='border:1px solid #000'>" + tdue.ToString("0.00") + "</td>";
                        eTable += "</tr>";
                    }
                }

                if (totdue > 0)
                {
                    eTable += "<tr style='font-weight:bold;border:1px solid #000'>";
                    eTable += "<td colspan='3' style='text-align:right;border:1px solid #000'>Total Amount </td>";
                    eTable += "<td style='text-align:right;border:1px solid #000'>&#8377; " + totamt.ToString("0.00") + "</td>";
                    eTable += "<td style='text-align:right;border:1px solid #000'>&#8377; " + totdisc.ToString("0.00") + "</td>";
                    eTable += "<td style='text-align:right;border:1px solid #000'>&#8377; " + totscg.ToString("0.00") + "</td>";
                    eTable += "<td style='text-align:right;border:1px solid #000'>&#8377; " + totrndf.ToString("0.00") + "</td>";
                    eTable += "<td style='text-align:right;border:1px solid #000'>&#8377; " + totrate.ToString("0.00") + "</td>";
                    eTable += "<td style='text-align:right;border:1px solid #000'>&#8377; " + totdue.ToString("0.00") + "</td>";
                    eTable += "</tr>";
                    eTable += "</tbody></table>";

                    eTable += "<div class='box-footer'>"
                                + "<div class='col-md-12 col-sm-12' style='text-align: center;'>"
                                    + "<input type='submit' name='update_submit' id='update_submit' value='Update' class='btn btn-success'>"
                                + "</div>"
                            + "</div>";
                }
                else
                {
                    eTable += "<tr style='font-weight:bold'>";
                    eTable += "<td colspan='5' style='border:1px solid #000'>No Dues Exist.</td>";
                    eTable += "</tr>";
                }
                eTable += "</tbody></table>";
            }

            string json_string = "{\"eachtable\":\"" + eTable + "\",\"bal\":\"" + totdue.ToString("0.00") + "\",\"baltype\":\"" + crdr_type + "\"}";

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