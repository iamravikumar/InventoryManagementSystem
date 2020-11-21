using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.IO;
using System.Data;
using System.Data.SqlClient;
/// <summary>
/// Summary description for Inventory
/// </summary>
public class InventoryCore : ClassDB
{
    public InventoryCore(HttpRequest request, HttpResponse response)
        : base(request, response)
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public void Execute()
    {
        if (URLFILENAME.ToLower() == "company_alter")
            CompanyAlter();
        else if (URLFILENAME.ToLower() == "fy_list")
            FYList();
        else if (URLFILENAME.ToLower() == "fy_alter")
            FYAlter();
        else if (URLFILENAME.ToLower() == "voucherset_list")
            VoucherSettingList();
        else if (URLFILENAME.ToLower() == "voucherset_alter")
            VoucherSettingAlter();
        else if (URLFILENAME.ToLower() == "ledger_list")
            ledgerList();
        else if (URLFILENAME.ToLower() == "ledger_alter")
            ledgerAlter();
        else if (URLFILENAME.ToLower() == "store_list")
            StoreList();
        else if (URLFILENAME.ToLower() == "store_alter")
            StoreAlter();
        else if (URLFILENAME.ToLower() == "qtytype_list")
            UnitList();
        else if (URLFILENAME.ToLower() == "qtytype_alter")
            UnitAlter();
        else if (URLFILENAME.ToLower() == "stockgrp_list")
            StockgrpList();
        else if (URLFILENAME.ToLower() == "stockgrp_alter")
            StockgrpAlter();
        else if (URLFILENAME.ToLower() == "item_list")
            ItemList();
        else if (URLFILENAME.ToLower() == "item_alter")
            ItemAlter();
        else if (URLFILENAME.ToLower() == "itemqty_list")
            ItemQtyList();
        else if (URLFILENAME.ToLower() == "itemqty_alter")
            ItemQtyAlter();


        //code for transactions
        else if (URLFILENAME.ToLower() == "bank_alter")
            BankACAlter();
        else if (URLFILENAME.ToLower() == "accdetails_list")
            BankACDetList();
        else if (URLFILENAME.ToLower() == "accdetails_alter")
            BankACDetAlter();

        /* Purchase data*/
        else if (URLFILENAME.ToLower() == "purchase_list")
            OrderList();
        else if (URLFILENAME.ToLower() == "purchase_alter")
            GenerateOrder();
        else if (URLFILENAME.ToLower() == "purvoucher_list")
            IssuedList();
        else if (URLFILENAME.ToLower() == "order_print")
            OrderAlter();
        else if (URLFILENAME.ToLower() == "purvoucher_alter")
            PurchaseAlter();
        else if (URLFILENAME.ToLower() == "purvoucher_print")
            IssuePrint();

        /* Sale data*/
        else if (URLFILENAME.ToLower() == "salevoucher_list")
            SaleList();
        else if (URLFILENAME.ToLower() == "salevoucher_alter")
            SaleOrder();
        else if (URLFILENAME.ToLower() == "salevoucher_print")
            InvoiceAlter();

        /* Purchase Return data*/
        else if (URLFILENAME.ToLower() == "purchaseret_list")
            PurReturnList();
        else if (URLFILENAME.ToLower() == "purchaseret_alter")
            PurReturnAlter();
        else if (URLFILENAME.ToLower() == "purchaseret_print")
            PurReturnPrint();

        /* sale Return data*/
        else if (URLFILENAME.ToLower() == "saleret_list")
            SaleReturnList();
        else if (URLFILENAME.ToLower() == "saleret_alter")
            SaleReturnAlter();
        else if (URLFILENAME.ToLower() == "saleret_print")
            SaleReturnPrint();

        else if (URLFILENAME.ToLower() == "payment")
            Payment();
        else if (URLFILENAME.ToLower() == "payment_voucher")
            PaymentVoucher();

        /* production data*/
        else if (URLFILENAME.ToLower() == "production_list")
            ProductionList();
        else if (URLFILENAME.ToLower() == "production")
            Production();

    }


    /*######################Extra Function######################################*/
    public Hashtable getSupDue(string LdgId, string LdgDt)
    {
        Hashtable hsdue = new Hashtable();
        string baltype = "CR";
        string bal = GetText("select sum(cr)-sum(dr) from tbl_transaction_master where company_id='" + COMPANY["id"] + "' and ledger_id='" + LdgId+"' and ledger_dt<='"+ LdgDt + "' and status=1");
        if(!string.IsNullOrWhiteSpace(bal))
        {
            hsdue.Add("bal", Math.Abs(Convert.ToDecimal(bal)));
            if(Convert.ToDecimal(bal)<0)
            {
                baltype = "DR";
            }
            hsdue.Add("bal_type", baltype);
        }
        else
        {
            hsdue.Add("bal", 0);
            hsdue.Add("bal_type", baltype);
        }
        return hsdue;
    }

    public Hashtable getCustDue(string LdgId, string LdgDt)
    {
        Hashtable hsdue = new Hashtable();
        string baltype = "DR";
        string bal = GetText("select sum(dr)-sum(cr) from tbl_transaction_master where company_id='" + COMPANY["id"] + "' and ledger_id='" + LdgId + "' and ledger_dt<='" + LdgDt + "' and status=1");
        if (!string.IsNullOrWhiteSpace(bal))
        {
            hsdue.Add("bal", Math.Abs(Convert.ToDecimal(bal)));
            if (Convert.ToDecimal(bal) < 0)
            {
                baltype = "CR";
            }
            hsdue.Add("bal_type", baltype);
        }
        else
        {
            hsdue.Add("bal", 0);
            hsdue.Add("bal_type", baltype);
        }
        return hsdue;
    }

    public Hashtable getInvoice(string voucherType)
    {
        Hashtable Invoice = new Hashtable();
        string InvNo = "1";
        string InvTyp = "MANUAL";
        string InvVal = "1";
        string currVal = "0";
        string dddata = "";
        Hashtable hsInvSetting = GetRecords("tbl_invoice_setup_master",
            "id,prevent_duplicacy,types_of_numbering,start_no,prefill_with_zero," +
            "width_of_digit,restarting_period,prefix_code,suffix_code," +
            "prefix_split_code,suffix_split_code,last_invoiceno,last_invoicevalue", 
            "invoice_type='" + voucherType + "' and company_id='" + COMPANY["id"] + "' and effective_date<=getdate() and status=1 order by effective_date desc");
        if (hsInvSetting.Count > 0)
        {
            InvVal = hsInvSetting["prevent_duplicacy"].ToString();
            if (hsInvSetting["types_of_numbering"].ToString() == "AUTOMATIC")
            {
                InvTyp = "AUTOMATIC";
                string startNo = hsInvSetting["start_no"].ToString();
                string prefillWithZero = hsInvSetting["prefill_with_zero"].ToString();
                string widthOfDigit = hsInvSetting["width_of_digit"].ToString();

                string restartingPeriod = "";
                if (!String.IsNullOrWhiteSpace(hsInvSetting["restarting_period"].ToString()))
                    restartingPeriod = hsInvSetting["restarting_period"].ToString();

                string prefixCode = "";
                if (!String.IsNullOrWhiteSpace(hsInvSetting["prefix_code"].ToString()))
                    prefixCode = hsInvSetting["prefix_code"].ToString();

                string suffixCode = "";
                if (!String.IsNullOrWhiteSpace(hsInvSetting["suffix_code"].ToString()))
                    suffixCode = hsInvSetting["suffix_code"].ToString();

                string prefixSplitCode = "";
                if (!String.IsNullOrWhiteSpace(hsInvSetting["prefix_split_code"].ToString()))
                    prefixSplitCode = hsInvSetting["prefix_split_code"].ToString();

                string suffixSplitCode = "";
                if (!String.IsNullOrWhiteSpace(hsInvSetting["suffix_split_code"].ToString()))
                    suffixSplitCode = hsInvSetting["suffix_split_code"].ToString();

                string last_invoiceno = "0";
                if (!String.IsNullOrWhiteSpace(hsInvSetting["last_invoiceno"].ToString()))
                    last_invoiceno = hsInvSetting["last_invoiceno"].ToString();

                DateTime CurrDateTime = DateTime.Now;

                //restart lastinvoice no=0 based on data
                if (restartingPeriod.ToLower() == "daily")
                {
                    dddata = CurrDateTime.ToString("ddMMyy");
                    string getLastDt = hsInvSetting["last_invoicevalue"].ToString();
                    if (CurrDateTime.ToString("ddMMyy") != getLastDt)
                        last_invoiceno = "0";
                }
                else if (restartingPeriod.ToLower() == "monthly")
                {
                    dddata = CurrDateTime.ToString("MMyy");
                    string getLastMn = hsInvSetting["last_invoicevalue"].ToString();
                    if (CurrDateTime.ToString("MMyy") != getLastMn)
                        last_invoiceno = "0";
                }
                else if (restartingPeriod.ToLower() == "yearly")
                {
                    string getLastFY = hsInvSetting["last_invoicevalue"].ToString();
                    string getCrrFY = CurrDateTime.Month <= 3 ? CurrDateTime.AddYears(-1).ToString("yy") + "" + CurrDateTime.ToString("yy") : CurrDateTime.ToString("yy") + "" + CurrDateTime.AddYears(1).ToString("yy");
                    dddata = getCrrFY;
                    if (getCrrFY != getLastFY)
                        last_invoiceno = "0";
                }

                currVal = (Convert.ToInt64(last_invoiceno) + 1).ToString();
                if (prefillWithZero == "1")
                {
                    if (Convert.ToInt32(widthOfDigit) > 0)
                    {
                        currVal = currVal.ToString().PadLeft(Convert.ToInt32(widthOfDigit), '0');
                    }
                }

                InvNo = dddata + "" + prefixCode + "" + prefixSplitCode + "" + currVal + "" + suffixSplitCode + "" + suffixCode;
            }
        }

        Invoice.Add("invType", InvTyp);
        Invoice.Add("invNo", InvNo);
        Invoice.Add("invValidate", InvVal);
        Invoice.Add("invCurrVal", dddata);
        Invoice.Add("invCurrId", currVal);
        Invoice.Add("invfId", hsInvSetting["id"]);
        return Invoice;
    }

    public string getStock(string item_id)
    {
        string stock = GetText("select (sum(inwards_qty)-sum(outwards_qty)) as stock from tbl_stock_master where status=1 and company_id='" + COMPANY["id"] + "' and item_id='" + item_id + "'");
        if (stock == null || stock == "")
            stock = "0";
        if (stock.Contains('-'))
            stock = "0";
        return stock;
    }

    public string getStoreCode()
    {
        string storecode = "W001";
        string lastCode = GetText("select code from tbl_store_master where company_id='" + COMPANY["id"] + "' order by id desc");
        if (!String.IsNullOrWhiteSpace(lastCode))
        {
            string lastCodeID = lastCode.Remove(0, 1);
            storecode = "W" + (Convert.ToInt32(lastCodeID) + 1).ToString("000");
        }
        return storecode;
    }

    public string getLedgerCode()
    {
        string supcode = "L001";
        string lastCode = GetText("select code from tbl_ledger_master where company_id='" + COMPANY["id"] + "' order by id desc");
        if (!String.IsNullOrWhiteSpace(lastCode))
        {
            string lastCodeID = lastCode.Remove(0, 1);
            supcode = "L" + (Convert.ToInt32(lastCodeID) + 1).ToString("000");
        }
        return supcode;
    }

    public string getStockGrpCode()
    {
        string itmcode = "G001";
        string lastCode = GetText("select code from tbl_stockgroup_master where company_id='" + COMPANY["id"] + "' order by id desc");
        if (!String.IsNullOrWhiteSpace(lastCode))
        {
            string lastCodeID = lastCode.Remove(0, 1);
            itmcode = "G" + (Convert.ToInt32(lastCodeID) + 1).ToString("000");
        }
        return itmcode;
    }

    public string getItmCode()
    {
        string itmcode = "I001";
        string lastCode = GetText("select item_code from tbl_item_master where company_id='" + COMPANY["id"] + "' order by id desc");
        if (!String.IsNullOrWhiteSpace(lastCode))
        {
            string lastCodeID = lastCode.Remove(0, 1);
            itmcode = "I" + (Convert.ToInt32(lastCodeID) + 1).ToString("000");
        }
        return itmcode;
    }
    /*##################################End################################################*/

    private void CompanyAlter()
    {
        string table_name = "tbl_company_master";
        CheckUrl(table_name, COMPANY["id"].ToString());
        if (request["btn_add"] != null)
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("mailing_name", true, InputRule.ALL, 200, 0);
            validate.Add("pin_code", false, InputRule.DIGITS, 6, 6);
            validate.Add("email_address", false, InputRule.EMAIL, 200, 0);
            validate.Add("gstin_no", false, InputRule.ALPHA_NUMERIC_NO_SPACE, 20, 15);
            validate.Add("gstin_type", true, InputRule.DIGITS);
            validate.Add("pan_no", false, InputRule.ALPHA_NUMERIC_NO_SPACE, 15, 10);
            validate.Add("contact_no", false, InputRule.DIGITS, 10, 10);
            validate.Add("currency_symbol", true, InputRule.ALL);
            validate.Add("negativestock", true, InputRule.DIGITS);
            validate.Add("batchentry", true, InputRule.DIGITS);
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("mailing_name", request["mailing_name"].ToUpper());
                inst_data.Add("address_1", request["address_1"].ToUpper());
                inst_data.Add("address_2", request["address_2"].ToUpper());
                inst_data.Add("state_id", request["state"].ToUpper());
                inst_data.Add("pin_code", request["pin_code"].ToUpper());
                inst_data.Add("email_address", request["email_address"]);
                inst_data.Add("gstin_no", request["gstin_no"]);
                inst_data.Add("gstin_type_id", request["gstin_type"]);
                inst_data.Add("pan_no", request["pan_no"]);
                inst_data.Add("reg_mobile_no", request["contact_no"]);
                inst_data.Add("currency_symbol", "Rupees");
                inst_data.Add("negative_stock", request["negativestock"]);
                inst_data.Add("batchwise_entry", request["batchentry"]);
                int count = Convert.ToInt32(GetCount("id", table_name, "id='" +COMPANY["id"] + "'"));
                if (count > 0)
                {
                    Update(table_name, inst_data, "id='" + COMPANY["id"] + "'");
                    session["update"] = true;
                    response.Redirect("company_alter.aspx");
                }
                else
                {
                    Error("Data Updation Failed.");
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void FYAlter()
    {
        string table_name = "tbl_fy_master";
        string view_name = "tbl_fy_master";
        string back_url = "fy_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("fin_year", true, InputRule.ALL, 9, 9);
            validate.Add("book_start_dt", true, InputRule.DATE_HYPHEN);
            if (validate.Validate())
            {
                try
                {
                    string[] seyear = request["fin_year"].Split('-');
                    int syr = Convert.ToInt32(seyear[0]);
                    int eyr = Convert.ToInt32(seyear[1]);
                    if (eyr != (syr + 1))
                    {
                        Error("Invalid Financial Year.");
                        return;
                    }
                }
                catch (Exception ex)
                {
                    Error("Invalid Financial Year.");
                    return;
                }

                Hashtable inst_data = new Hashtable();
                inst_data.Add("fin_year", request["fin_year"]);
                inst_data.Add("book_start_dt", DateTime.ParseExact(request["book_start_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("company_id", COMPANY["id"]);
                if (ButtonOperation == "New")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id= '"+ COMPANY["id"] + "' and fin_year='" + request["fin_year"] + "' and status=1"));
                    if (count == 0)
                    {
                        long cntCloseStatus = Convert.ToInt64(GetCount("id", table_name, "company_id= '" + COMPANY["id"] + "' and book_close_dt is null"));
                        if (cntCloseStatus > 0)
                        {
                            Error("You need to close previous account before start new.");
                            return;
                        }

                        inst_data.Add("entry_by", USER["id"]);
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Financial Year already exists.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id= '" + COMPANY["id"] + "' and fin_year='" + request["fin_year"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Financial Year already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void FYList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (fin_year like '%" + src_prm[0] + "%')";
        response.Write(GetDataList("tbl_fy_master", "tbl_fy_master", "id, fin_year as 'Financial Year', convert(varchar, book_start_dt, 105) as 'Book Start Date'", whereClause, null, 1, 1, 1, null, null, null, "fy_alter", "fy_alter", request.Url.AbsolutePath, 10));
    }

    private void VoucherSettingAlter()
    {
        string table_name = "tbl_invoice_setup_master";
        string view_name = "tbl_invoice_setup_master";
        string back_url = "voucherset_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            if (request["invoice_type"].ToString().ToUpper() != "PURCHASE" && request["invoice_type"].ToString().ToUpper() != "SALE" && request["invoice_type"].ToString().ToUpper() != "PURCHASE RETURN" && request["invoice_type"].ToString().ToUpper() != "SALE RETURN")
            {
                Error("Invalid Invoice Type.");
                return;
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("invoice_type", true, InputRule.ALPHABET_WITH_SPACE);
            validate.Add("types_of_numbering", true, InputRule.ALPHABET_NO_SPACE);
            if (request["types_of_numbering"].ToString() == "MANUAL")
                validate.Add("prevent_duplicacy", true, InputRule.DIGITS);
            if (request["types_of_numbering"].ToString() == "AUTOMATIC")
            {
                validate.Add("start_no", true, InputRule.DIGITS);
                validate.Add("prefill_with_zero", true, InputRule.DIGITS);
                validate.Add("width_of_digit", true, InputRule.DIGITS);
                validate.Add("restarting_period", true, InputRule.ALPHABET_NO_SPACE);
                validate.Add("prefix_code", false, InputRule.ALPHA_NUMERIC_NO_SPACE);
                validate.Add("suffix_code", false, InputRule.ALPHA_NUMERIC_NO_SPACE);
                validate.Add("prefix_split_code", false, InputRule.ALL, 1, 1);
                validate.Add("suffix_split_code", false, InputRule.ALL, 1, 1);
            }
            validate.Add("is_taxable", true, InputRule.DIGITS);
            validate.Add("effective_date", true, InputRule.DATE_HYPHEN);
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("invoice_type", request["invoice_type"].ToUpper());
                inst_data.Add("types_of_numbering", request["types_of_numbering"].ToUpper());
                if (request["types_of_numbering"].ToString() == "MANUAL")
                    inst_data.Add("prevent_duplicacy", request["prevent_duplicacy"].ToUpper());
                else if (request["types_of_numbering"].ToString() == "AUTOMATIC")
                {
                    inst_data.Add("start_no", request["start_no"].ToUpper());
                    inst_data.Add("prefill_with_zero", request["prefill_with_zero"].ToUpper());
                    inst_data.Add("width_of_digit", request["width_of_digit"].ToUpper());
                    inst_data.Add("restarting_period", request["restarting_period"].ToUpper());
                    inst_data.Add("prefix_code", request["prefix_code"].ToUpper());
                    inst_data.Add("suffix_code", request["suffix_code"].ToUpper());
                    inst_data.Add("prefix_split_code", request["prefix_split_code"].ToUpper());
                    inst_data.Add("suffix_split_code", request["suffix_split_code"].ToUpper());
                }
                inst_data.Add("effective_date", DateTime.ParseExact(request["effective_date"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("footer_text", request["footer_text"].ToUpper());
                inst_data.Add("is_taxable", request["is_taxable"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and invoice_type='" + request["invoice_type"] + "' and is_taxable='" + request["is_taxable"] + "' and convert(varchar, effective_date, 105)='" + request["effective_date"] + "'"));
                    if (count == 0)
                    {
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Setting against this Invoice Type on given effective date is already exists.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and invoice_type='" + request["invoice_type"] + "' and is_taxable='" + request["is_taxable"] + "' and convert(varchar, effective_date, 105)='" + request["effective_date"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Setting against this Invoice Type on given effective date is already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void VoucherSettingList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (invoice_type like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_invoice_setup_master", "tbl_invoice_setup_master", "id, invoice_type as 'Invoice Type', types_of_numbering as 'Numbering Type', case when is_taxable=1 then 'Yes' else 'No' end as 'Tax Include', convert(varchar,effective_date, 105) as 'Effective Date'", whereClause, "effective_date desc", 1, 1, 2, null, null, null, "voucherset_alter", "voucherset_alter", request.Url.AbsolutePath, 10));
    }

    private void ledgerAlter()
    {
        string table_name = "tbl_ledger_master";
        string view_name = "view_ledger_master";
        string back_url = "ledger_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("group_id", true, InputRule.DIGITS);
            validate.Add("name", true, InputRule.ALL, 200, 1);
            validate.Add("code", true, InputRule.ALPHA_NUMERIC_NO_SPACE, 50, 0);
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
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("group_id", request["group_id"].ToUpper());
                inst_data.Add("name", request["name"].ToUpper());
                inst_data.Add("code", request["code"].ToUpper());
                inst_data.Add("mobile_no", request["mobile_no"].ToUpper());
                inst_data.Add("contact_no", request["contact_no"].ToUpper());
                inst_data.Add("address_1", request["address_1"].ToUpper());
                inst_data.Add("address_2", request["address_2"].ToUpper());
                inst_data.Add("pincode", request["pincode"].ToUpper());
                inst_data.Add("city", request["city"].ToUpper());
                inst_data.Add("state_id", request["state"].ToUpper());
                inst_data.Add("country", "INDIA");
                inst_data.Add("email", request["email"].ToUpper());
                inst_data.Add("gstin_no", request["gstin_no"].ToUpper());
                if (request["gstin_type"]!=null && request["gstin_type"]!="")
                inst_data.Add("gstin_type_id", request["gstin_type"].ToUpper());
                inst_data.Add("pan_no", request["pan_no"].ToUpper());
                inst_data.Add("billing_type", request["billing_type"].ToUpper());
                inst_data.Add("master_discount", request["master_discount"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and code='" + request["code"] + "'"));
                    if (count == 0)
                    {
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        if (request["btn_add"] == "Edit")
                        {
                            Update(table_name, inst_data, "id='" + request["select_item"] + "'");
                            Message("Data Successfully Updated.");
                        }
                        else
                            Error("Store already exists.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and code='" + request["code"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Ledger already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void ledgerList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (name like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_ledger_master", "view_ledger_master", "id, Code as 'Ledger Code', name as 'Ledger Name', group_name as 'Group Under', mobile_no as 'Mobile No.'", whereClause, "id asc", 1, 1, 2, null, null, null, "ledger_alter", "ledger_alter", request.Url.AbsolutePath, 10));
    }

    private void StoreAlter()
    {
        string table_name = "tbl_store_master";
        string view_name = "tbl_store_master";
        string back_url = "store_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("store_name", true, InputRule.ALL);
            validate.Add("code", true, InputRule.ALPHA_NUMERIC_NO_SPACE);
            validate.Add("contact_no", false, InputRule.MOBILE, 10, 10);
            validate.Add("address", false, InputRule.ALL, 500);
            validate.Add("store_type", true, InputRule.ALPHABET_NO_SPACE, 50);
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("name", request["store_name"].ToUpper());
                inst_data.Add("code", request["store_code"].ToUpper());
                inst_data.Add("store_type", request["store_type"].ToUpper());
                inst_data.Add("contact_no", request["contact_no"]);
                inst_data.Add("address", request["store_address"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and code='" + request["store_code"] + "'"));
                    if (count == 0)
                    {
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        if (request["btn_add"] == "Edit")
                        {
                            Update(table_name, inst_data, "id='" + request["select_item"] + "'");
                            Message("Data Successfully Updated.");
                        }
                        else
                            Error("Store already exists.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and code='" + request["store_code"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Store already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void StoreList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (name like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_store_master", "tbl_store_master", "id, code as 'Store Code', name as 'Store Name', store_type as 'Store Type', contact_no as 'Contact No'", whereClause, "id asc", 1, 1, 2, null, null, null, "store_alter", "store_alter", request.Url.AbsolutePath, 10));
    }

    private void UnitAlter()
    {
        string table_name = "tbl_unit_master";
        string view_name = "tbl_unit_master";
        string back_url = "qtytype_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("symbol", true, InputRule.ALPHA_NUMERIC_NO_SPACE, 10, 0);
            validate.Add("formal_name", true, InputRule.ALPHA_NUMERIC_WITH_SPACE, 50, 0);
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("symbol", request["type"].ToUpper());
                inst_data.Add("formal_name", request["description"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id= '" + COMPANY["id"] + "' and symbol='" + request["type"] + "'"));
                    if (count == 0)
                    {
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        if (request["btn_add"] == "Edit")
                        {
                            Update(table_name, inst_data, "id='" + request["select_item"] + "'");
                            Message("Data Successfully Updated.");
                        }
                        else
                            Error("Unit already exists.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id= '" + COMPANY["id"] + "' and symbol='" + request["type"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Unit already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void UnitList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (symbol like '%" + src_prm[0] + "%' or formal_name like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_unit_master", "tbl_unit_master", "id, symbol as 'Symbol', formal_name as 'Formal Name'", whereClause, "id asc", 1, 1, 2, null, null, null, "qtytype_alter", "qtytype_alter", request.Url.AbsolutePath, 10));
    }

    private void ItemAlter()
    {
        string table_name = "tbl_item_master";
        string view_name = "tbl_item_master";
        string back_url = "item_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("stockgrp", true, InputRule.DIGITS);
            validate.Add("item_name", true, InputRule.ALL, 100, 0);
            validate.Add("item_code", true, InputRule.ALL, 100, 0);
            validate.Add("print_name", true, InputRule.ALL, 100, 0);
            validate.Add("item_manufacture", true, InputRule.ALL);
            validate.Add("barcode", false, InputRule.ALPHA_NUMERIC_NO_SPACE, 100, 0);
            validate.Add("qty_type", true, InputRule.DIGITS);
            validate.Add("purchase_rate", true, InputRule.DECIMAL);
            validate.Add("sale_rate", true, InputRule.DECIMAL);
            validate.Add("mrp", true, InputRule.DECIMAL);
            validate.Add("cgst", true, InputRule.DECIMAL);
            validate.Add("sgst", true, InputRule.DECIMAL);
            validate.Add("igst", true, InputRule.DECIMAL);
            validate.Add("hsn_code", false, InputRule.ALL);
            validate.Add("opening_quantity", false, InputRule.DECIMAL);
            validate.Add("opening_rate", false, InputRule.DECIMAL);
            validate.Add("total_value", false, InputRule.DECIMAL);
            validate.Add("storeid", false, InputRule.DIGITS);
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("stockgrp_id", request["stockgrp"].ToUpper());
                inst_data.Add("item_name", request["item_name"].ToUpper());
                inst_data.Add("item_code", request["item_code"].ToUpper());
                inst_data.Add("print_name", request["print_name"].ToUpper());
                inst_data.Add("manufacture_name", request["manufacture_name"].ToUpper());
                if (request["barcode"] != null && request["barcode"] != "")
                    inst_data.Add("barcode", request["barcode"].ToUpper());
                inst_data.Add("per_unit_qty", request["qty_type"].ToUpper());
                inst_data.Add("purchase_rate", request["purchase_rate"].ToUpper());
                inst_data.Add("sale_rate", request["sale_rate"].ToUpper());
                inst_data.Add("mrp", request["mrp"].ToUpper());
                inst_data.Add("cgst", request["cgst"].ToUpper());
                inst_data.Add("sgst", request["sgst"].ToUpper());
                inst_data.Add("igst", request["igst"].ToUpper());
                if (request["hsn_code"] != null && request["hsn_code"] != "")
                    inst_data.Add("hsn_code", request["hsn_code"].ToUpper());
                if (request["opening_quantity"] != null && request["opening_quantity"] != "")
                    inst_data.Add("opening_quantity", request["opening_quantity"].ToUpper());
                if (request["opening_rate"] != null && request["opening_rate"] != "")
                    inst_data.Add("opening_rate", request["opening_rate"].ToUpper());
                if (request["total_value"] != null && request["total_value"] != "")
                    inst_data.Add("total_value", request["total_value"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                if (request["storeid"] != null && request["storeid"] != "")
                    inst_data.Add("store_id", request["storeid"].ToUpper());
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id= '" + COMPANY["id"] + "' and item_code='" + request["item_code"] + "'"));
                    if (count == 0)
                    {
                        long res = Convert.ToInt64(Insert(table_name, inst_data));
                        if (res > 0)
                        {
                            response.Redirect(back_url);
                        }
                    }
                    else
                    {
                        if (request["btn_add"] == "Edit")
                        {
                            Update(table_name, inst_data, "id='" + request["select_item"] + "'");
                            Message("Data Successfully Updated.");
                        }
                        else
                            Error("Item name already exists.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id= '" + COMPANY["id"] + "' and item_code='" + request["item_code"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        if (Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'")>0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Item name already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void ItemList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (item_name like '%" + src_prm[0] + "%' or item_code like '%" + src_prm[0] + "%' or print_name like '%" + src_prm[0] + "%' or manufacture_name like '%" + src_prm[0] + "%' ) ";
        response.Write(GetDataList("tbl_item_master", "tbl_item_master", "id, item_code as 'Item Code', item_name as 'Item Name', print_name as 'Print Name', purchase_rate as 'Purchase Rate', sale_rate as 'Sale Rate', mrp as 'MRP' ", whereClause, "item_code asc", 1, 1, 2, null, null, null, "item_alter", "item_alter", request.Url.AbsolutePath, 10));
    }

    private void StockgrpAlter()
    {
        string table_name = "tbl_stockgroup_master";
        string view_name = "tbl_stockgroup_master";
        string back_url = "stockgrp_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("code", true, InputRule.ALPHA_NUMERIC_NO_SPACE);
            validate.Add("name", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("code", request["code"].ToUpper());
                inst_data.Add("name", request["name"].ToUpper());
                inst_data.Add("description", request["description"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='"+ COMPANY["id"] +"' and code='" + request["code"].ToUpper() + "'"));
                    if (count == 0)
                    {
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        Update(table_name, inst_data, "code='" + request["code"].ToUpper() + "'");
                        Message("Data Successfully Updated.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and code='" + request["code"].ToUpper() + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Stock Group already exist.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void StockgrpList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (name like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_stockgroup_master", "tbl_stockgroup_master", "id, code as 'Code', name as 'Name'", whereClause, "code asc", 1, 1, 2, null, null, null, "stockgrp_alter", "stockgrp_alter", request.Url.AbsolutePath, 10));
    }

    private void ItemQtyAlter()
    {
        string table_name = "tbl_item_qty_master";
        string view_name = "view_item_qty_master";
        string back_url = "itemqty_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("item_name", true, InputRule.DIGITS);
            validate.Add("def_unit", true, InputRule.DECIMAL);
            validate.Add("other_unit_id", true, InputRule.DIGITS);
            validate.Add("purchase_rate", true, InputRule.DECIMAL);
            validate.Add("sale_rate", true, InputRule.DECIMAL);
            validate.Add("mrp", true, InputRule.DECIMAL);
            validate.Add("effective_date", true, InputRule.DATE_HYPHEN);
            if (validate.Validate())
            {
                Hashtable inst_data = new Hashtable();
                inst_data.Add("item_id", request["item_name"].ToUpper());
                inst_data.Add("def_unit", request["def_unit"].ToUpper());
                inst_data.Add("other_unit", 1);
                inst_data.Add("other_unit_id", request["other_unit_id"].ToUpper());
                inst_data.Add("purchase_rate", request["purchase_rate"].ToUpper());
                inst_data.Add("sale_rate", request["sale_rate"].ToUpper());
                inst_data.Add("mrp", request["mrp"].ToUpper());
                inst_data.Add("effective_date", DateTime.ParseExact(request["effective_date"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and item_id='" + request["item_name"].ToUpper() + "' and other_unit_id='" + request["other_unit_id"] + "' and convert(varchar, effective_date, 105)='" + request["effective_date"] + "'"));
                    if (count == 0)
                    {
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        Update(table_name, inst_data, "company_id='" + COMPANY["id"] + "' and item_id='" + request["item_name"].ToUpper() + "' and other_unit_id='" + request["other_unit_id"] + "' and convert(varchar, effective_date, 105)='" + request["effective_date"] + "'");
                        Message("Data Successfully Updated.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and item_id='" + request["item_name"].ToUpper() + "' and other_unit_id='" + request["other_unit_id"] + "' and convert(varchar, effective_date, 105)='" + request["effective_date"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {

                        inst_data.Add("last_alter_dt", DateTime.Now.ToString("MM-dd-yyyy"));
                        inst_data.Add("last_alter_by", USER["id"]);
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Item with derived measurment type is already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void ItemQtyList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (item_name like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_item_qty_master", "view_item_qty_master", "id, item_name as 'Item', convert(varchar,def_unit) + ' ' + symbol as 'Unit',  convert(varchar,other_unit) + ' ' + new_qty_symbol as 'Other Quantity', convert(varchar,effective_date,105) as 'Effective Date'", whereClause, "item_name asc, effective_date desc", 1, 1, 2, null, null, null, "itemqty_alter", "itemqty_alter", request.Url.AbsolutePath, 10));
    }

    private void BankACAlter()
    {
        string table_name = "tbl_company_ac_master";
        string view_name = "tbl_company_ac_master";
        string back_url = "accdetails_list.aspx?cmd=Clear";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            if (ButtonOperation == "View")
            {
                response.Redirect(back_url);
            }

            InputValidator validate = new InputValidator(request);
            validate.Add("account_type", true, InputRule.ALPHA_NUMERIC_WITH_SPACE, 200);
            validate.Add("account_no", true, InputRule.ALPHA_NUMERIC_NO_SPACE, 200);
            validate.Add("bank_name", true, InputRule.ALPHA_NUMERIC_WITH_SPACE, 200);
            validate.Add("branch", false, InputRule.ALL, 200);
            validate.Add("ifsc_code", false, InputRule.ALPHA_NUMERIC_NO_SPACE, 20);
            validate.Add("micr_code", false, InputRule.ALPHA_NUMERIC_NO_SPACE, 20);
            validate.Add("is_default", true, InputRule.DIGITS);
            if (validate.Validate())
            {
                if (request["is_default"] == "1")
                {
                    int cnt = Convert.ToInt32(GetCount("id", table_name, "is_default=1 and status=1 and company_id='" + COMPANY["id"] + "'"));
                    if (cnt > 0)
                    {
                        Error("Only onle default account allowed. Please update existing first.");
                        return;
                    }
                }
                Hashtable inst_data = new Hashtable();
                inst_data.Add("account_type", request["account_type"].ToUpper());
                inst_data.Add("account_no", request["account_no"].ToUpper());
                inst_data.Add("bank_name", request["bank_name"].ToUpper());
                inst_data.Add("branch", request["branch"].ToUpper());
                inst_data.Add("ifsc_code", request["ifsc_code"].ToUpper());
                inst_data.Add("micr_code", request["micr_code"].ToUpper());
                inst_data.Add("is_default", request["is_default"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("status", 1);
                if (ButtonOperation == "New")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and account_no='" + request["account_no"] + "'"));
                    if (count == 0)
                    {
                        if (Insert(table_name, inst_data) > 0)
                            response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Account details already exists.");
                    }
                }
                if (ButtonOperation == "Edit")
                {
                    int count = Convert.ToInt32(GetCount("id", table_name, "company_id='" + COMPANY["id"] + "' and account_no='" + request["account_no"] + "' and " + MD5_ID + "!='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        response.Redirect(back_url);
                    }
                    else
                    {
                        Error("Account details already exists.");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void BankACDetAlter()
    {
        string table_name = "tbl_company_ac_details";
        string view_name = "tbl_company_ac_master";
        CheckUrl(view_name);
        if (request["btn_add"] != null)
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("trans_amt", true, InputRule.DECIMAL);
            validate.Add("trans_type", true, InputRule.ALL);
            validate.Add("trans_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("narration", false, InputRule.ALPHA_NUMERIC_WITH_SPACE, 1000, 0);
            if (validate.Validate())
            {
                if (request["trans_type"].ToUpper() == "W")
                {
                    string currbal = GetText("select ((select isnull(sum(trans_amt),0) from tbl_company_ac_details where acc_id='" + request["acc_id"] + "' and company_id='" + COMPANY["id"] + "' and status=1 and trans_type='D')-(select isnull(sum(trans_amt),0) from tbl_company_ac_details where acc_id='" + request["acc_id"] + "' and company_id='" + COMPANY["id"] + "' and status=1 and trans_type='W')) as balance");
                    if (Convert.ToDecimal(request["trans_amt"]) > Convert.ToDecimal(currbal))
                    {
                        Error("Invalid Transaction.");
                        return;
                    }
                }
                else
                {
                    if (Convert.ToDecimal(request["trans_amt"]) <= 0)
                    {
                        Error("Invalid Transaction.");
                        return;
                    }
                }
                Hashtable inst_data = new Hashtable();
                inst_data.Add("acc_id", request["acc_id"].ToUpper());
                inst_data.Add("trans_amt", request["trans_amt"].ToUpper());
                inst_data.Add("trans_type", request["trans_type"].ToUpper());
                inst_data.Add("trans_date", DateTime.ParseExact(request["trans_dt"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("narration", request["narration"].ToUpper());
                inst_data.Add("ref_no", request["ref_no"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                if (request["btn_add"].ToString() == "Add New Transaction")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    if (Insert(table_name, inst_data) > 0)
                        Message("Transaction Information Successfully Inserted.");
                }
                else if (request["btn_add"].ToString() == "Update")
                {
                    if (Update(table_name, inst_data, MD5_ID + "='" + request["xid"] + "'") > 0)
                        Message("Transaction Information Successfully Updated.");
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
        else if (request["btn_del"] != null)
        {
            if (Delete(table_name, MD5_ID + "='" + request["yid"] + "'") > 0)
                Message("Transaction Information Successfully Deleted.");
        }
    }

    private void BankACDetList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (account_no like '%" + src_prm[0] + "%' or ifsc_code like '%" + src_prm[0] + "%' or bank_name like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_company_ac_master", "tbl_company_ac_master", "id, account_no as 'A/C No', account_type as 'Account Type', bank_name as 'Bank Name', ifsc_code as 'IFSC Code', case when is_default=1 then 'YES' else 'NO' end as 'IS Default?'", whereClause, "id asc", 0, 1, 0, null, null, null, "accdetails_alter", "accdetails_alter", request.Url.AbsolutePath, 10));
    }
    
    
    //code for Purchase Order
    private void IssuePrint()
    {
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
    }

    private void IssuedList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        session["dtItem"] = null;
        string whereClause = "invoice_type in ('PO','P') and company_id='" + COMPANY["id"] + "' and (autogen_id like '%" + src_prm[0] + "%' or invoice_no like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_inventory_master", "view_inventory_master", "id, autogen_id as 'Order No.', convert(varchar, stock_dt, 105) as 'Order Date', invoice_no as 'Invoice No.', convert(varchar, invoice_dt, 105) as 'Invoice Date', ladgername+' ('+ledgercode+')' as 'Supplier', total_amt as 'Amount', convert(varchar, due_dt, 105) as 'Dues Date' ", whereClause, "id desc", 1, 1, 2, "Edit", "Print", null, "purvoucher_alter", "purvoucher_print", request.Url.AbsolutePath, 10));
    }

    private void PurchaseAlter()
    {
        string table_name = "tbl_inventory_master";
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
        if (request["btn_save"] != null)
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("supplier", true, InputRule.DIGITS);
            validate.Add("invoice_no", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("invoice_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("order_no", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("order_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("due_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("taxcalc", true, InputRule.DIGITS);
            validate.Add("discount", true, InputRule.DECIMAL);
            validate.Add("shipping_charge", true, InputRule.DECIMAL);
            validate.Add("round_off", true, InputRule.DECIMAL);
            validate.Add("total_amt", true, InputRule.DECIMAL);
            validate.Add("narration", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("paymode", true, InputRule.ALPHABET_NO_SPACE);
            if(request["paymode"].ToString()=="Cheque" || request["paymode"].ToString() == "DD")
            {
                validate.Add("chqno", true, InputRule.ALPHA_NUMERIC_NO_SPACE);
                validate.Add("chqdt", true, InputRule.DATE_HYPHEN);
                validate.Add("bnkname", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            }
            validate.Add("amttopay", true, InputRule.DECIMAL);
            validate.Add("modedesc", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            if (validate.Validate())
            {
                DataTable dtItem = session["dtItem"] != null ? (DataTable)session["dtItem"] : new DataTable();
                if(dtItem.Rows.Count <= 0)
                {
                    Error("Atleast one item required on cart.");
                    return;
                }
                string supplier = dtItem.Rows[0].Field<string>(21);
                string taxcalc = dtItem.Rows[0].Field<string>(22);
                Hashtable inst_data = new Hashtable();
                string invtype_id = GetText("tbl_invoice_setup_master", "id", "invoice_type='PURCHASE' order by effective_date desc, id desc");
                if (!string.IsNullOrWhiteSpace(invtype_id))
                    inst_data.Add("invtype_id", invtype_id); 
                inst_data.Add("invoice_type", "P");
                inst_data.Add("naration", request["narration"]);
                inst_data.Add("invoice_no", request["invoice_no"]);
                inst_data.Add("invoice_dt", DateTime.ParseExact(request["invoice_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("invoice_naration", request["narration"]);
                inst_data.Add("invoice_amt", request["totinvval"]);
                inst_data.Add("taxinclude", taxcalc);
                decimal dp = (Convert.ToDecimal(request["discount"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("discount_per", dp.ToString("0.00"));
                inst_data.Add("discount_amt", request["discount"]);
                decimal sp = (Convert.ToDecimal(request["shipping_charge"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("shipping_per", sp.ToString("0.00"));
                inst_data.Add("shipping_charge", request["shipping_charge"]);
                decimal wr = (Convert.ToDecimal(request["shipping_charge"]) + Convert.ToDecimal(request["totinvval"])) + Convert.ToDecimal(request["discount"]);
                inst_data.Add("withoutrndoff", wr.ToString("0.00"));
                inst_data.Add("round_off", request["round_off"]);
                inst_data.Add("total_amt", request["total_amt"]);
                inst_data.Add("due_dt", DateTime.ParseExact(request["due_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("entry_by", USER["id"]);
                string where = "company_id='" + COMPANY["id"] + "' and ledger_id='" + supplier + "' and autogen_id='" + request["order_no"] + "' and invoice_type in ('P','PO')";
                long cnt = Convert.ToInt64(GetCount("autogen_id", table_name, where));
                long res = 0;
                if (cnt == 0)
                {
                    inst_data.Add("company_id", COMPANY["id"]);
                    inst_data.Add("ledger_id", supplier);
                    inst_data.Add("autogen_id", request["order_no"]);
                    inst_data.Add("stock_dt", DateTime.ParseExact(request["order_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                    res = Insert(table_name, inst_data);
                }
                else
                {
                    Update(table_name, inst_data, where);
                    res = Convert.ToInt64(GetText(table_name, "id", where));
                }

                if (res > 0)
                {
                    //code for update stock
                    Delete("tbl_stock_details", "ref_id='" + res + "' and ref_by='tbl_inventory_master'");
                    UpdateStock(res, "P", dtItem);

                    //code for insert transaction
                    long ldgid = Convert.ToInt64(supplier);
                    decimal dr = 0;
                    decimal cr = 0;

                    if (!string.IsNullOrWhiteSpace(request["total_amt"]))
                        cr = Convert.ToDecimal(request["total_amt"]);

                    long transid = createTrans(ldgid, "CR", 0, cr, "", "Credit", "", "", "", res);
                    createInvoicePayment(ldgid, res, transid, cr, "Credit");
                    if (request["paymode"].ToString().Trim().ToLower() != "credit")
                    {
                        if (!string.IsNullOrWhiteSpace(request["amttopay"]))
                        {
                            dr = Convert.ToDecimal(request["amttopay"]);
                            cr = 0;
                            if (dr > 0)
                            {
                                string chqno = "";
                                string chqdt = "";
                                string bnkname = "";
                                if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
                                {
                                    chqno = request["chqno"].ToString();
                                    chqdt = DateTime.ParseExact(request["chqdt"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy");
                                    bnkname = request["bnkname"].ToString();
                                }
                                transid = createTrans(ldgid, "CR", dr, 0, request["modedesc"], request["paymode"], chqno, chqdt, bnkname);
                                createInvoicePayment(ldgid, res, transid, dr, "Payment");
                            }
                        }
                    }
                    
                    //update invoice last id
                    Hashtable hsInvSetting = GetRecords("tbl_invoice_setup_master", "*", "company_id='" + COMPANY["id"] + "' and id='" + request["invidf"] + "'");
                    if (hsInvSetting.Count > 0)
                    {
                        hsInvSetting.Clear();
                        hsInvSetting.Add("last_invoiceno", request["invlastiof"].ToUpper());
                        hsInvSetting.Add("last_invoicevalue", request["invlastvalof"].ToUpper());
                        Update("tbl_invoice_setup_master", hsInvSetting, "id='" + request["invidf"] + "'");
                    }

                    response.Redirect("purvoucher_print.aspx?uid=" + MD5(res.ToString()) + "&wid=eccbc87e4b5ce2fe28308fd9f2a7baf3");
                }
                else
                {
                    Error("Error while updating purchase voucher.");
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    public long createTrans(long ldgid, string ldgtype, decimal dr, decimal cr, string nart, string pmode, string chqno="", string chqdt="", string bnkname="", long refid=0)
    {
        long res = 0;
        string table_name = "tbl_transaction_master";
        Hashtable Hscc = new Hashtable();
        Hscc.Add("company_id", COMPANY["id"]);
        Hscc.Add("ledger_id", ldgid);
        Hscc.Add("ledger_type", ldgtype);
        Hscc.Add("ledger_dt", DateTime.Now.ToString("MM-dd-yyyy"));
        Hscc.Add("dr", dr);
        Hscc.Add("cr", cr);
        Hscc.Add("naration", nart);
        Hscc.Add("pmode", pmode);
        int status = 1;
        if(pmode.ToLower().Trim()=="cheque" || pmode.ToLower().Trim() == "dd")
        {
            Hscc.Add("ref_no", chqno);
            Hscc.Add("ref_date", chqdt);
            Hscc.Add("bank_name", bnkname.ToUpper());
            status = 2;
        }
        Hscc.Add("status", status);
        Hscc.Add("entry_by", USER["id"]);
        string where = "company_id='" + COMPANY["id"] + "' and ledger_id='" + ldgid + "' and inv_id='" + refid + "' and mode='Credit'";
        long cnt = Convert.ToInt64(GetCount("id", "tbl_invoicewisepayment_details", where));
        if (cnt == 0)
        {
            res = Insert(table_name, Hscc);
        }
        else
        {
            res = Convert.ToInt64(GetText("tbl_invoicewisepayment_details", "trans_id", where));
            Update(table_name, Hscc, "company_id='" + COMPANY["id"] + "' and ledger_id='" + ldgid + "' and id='" + res + "'");            
        }
        return res;
    }

    public void createInvoicePayment(long ldgid, long invid, long transid, decimal amt, string mode)
    {
        string table_name = "tbl_invoicewisepayment_details";
        Hashtable Hscc = new Hashtable();
        Hscc.Add("company_id", COMPANY["id"]);
        Hscc.Add("ledger_id", ldgid);
        Hscc.Add("inv_id", invid);
        Hscc.Add("trans_id", transid);
        Hscc.Add("amt", amt);
        Hscc.Add("mode", mode);
        Hscc.Add("entry_by", USER["id"]);
        string where = "company_id='"+ COMPANY["id"] + "' and ledger_id='"+ ldgid + "' and inv_id='"+ invid + "' and trans_id='" + transid + "'";
        long cnt = Convert.ToInt64(GetCount("id", table_name, where));
        if (cnt == 0)
            Insert(table_name, Hscc);
        else
            Update(table_name, Hscc, where);
    }

    public void UpdateStock(long res, string vtype, DataTable dtItem)
    {
        string table_name = "tbl_stock_details";
        string fyid = GetText("tbl_fy_master", "id", "company_id='" + COMPANY["id"] + "' and status=1");
        for (int i = 0; i < dtItem.Rows.Count; i++)
        {
            Hashtable hsItem = GetRecords("tbl_item_master", "per_unit_qty,mrp,cgst,sgst,igst", "id='" + dtItem.Rows[i].ItemArray[0].ToString() + "'");
            Hashtable order_item = new Hashtable();
            order_item.Add("company_id", COMPANY["id"]);
            order_item.Add("store_id", dtItem.Rows[i].ItemArray[20].ToString());
            order_item.Add("ref_id", res);
            order_item.Add("ref_by", "tbl_inventory_master");
            order_item.Add("item_id", dtItem.Rows[i].ItemArray[0].ToString());
            order_item.Add("reference_no", dtItem.Rows[i].ItemArray[4].ToString());
            if(!String.IsNullOrEmpty(dtItem.Rows[i].ItemArray[5].ToString()))
                order_item.Add("mfg_dt", DateTime.ParseExact(dtItem.Rows[i].ItemArray[5].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
            if (!String.IsNullOrEmpty(dtItem.Rows[i].ItemArray[6].ToString()))
                order_item.Add("exp_dt", DateTime.ParseExact(dtItem.Rows[i].ItemArray[6].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
            order_item.Add("is_free_item", 0);
            //order_item.Add("itemid_freewith", 0);
            order_item.Add("mrp", hsItem["mrp"]);
            order_item.Add("rate", dtItem.Rows[i].ItemArray[7].ToString());
            if (vtype == "P" || vtype == "PO" || vtype == "SR")
            {
                order_item.Add("inwardqty", dtItem.Rows[i].ItemArray[1].ToString());
                order_item.Add("inwardunit", dtItem.Rows[i].ItemArray[2].ToString());
                order_item.Add("inwardunitqty", dtItem.Rows[i].ItemArray[3].ToString());
                order_item.Add("inwardunit_id", hsItem["per_unit_qty"]);
            }
            else if (vtype == "S" || vtype == "SO" || vtype == "PR")
            {
                order_item.Add("outwardqty", dtItem.Rows[i].ItemArray[1].ToString());
                order_item.Add("outwardunit", dtItem.Rows[i].ItemArray[2].ToString());
                order_item.Add("outwardunitqty", dtItem.Rows[i].ItemArray[3].ToString());
                order_item.Add("outwardunit_id", hsItem["per_unit_qty"]);
            }
            
            order_item.Add("net_rate", dtItem.Rows[i].ItemArray[8].ToString());
            order_item.Add("disc_per", dtItem.Rows[i].ItemArray[9].ToString());
            order_item.Add("disc_amt", dtItem.Rows[i].ItemArray[10].ToString());
            order_item.Add("gross_amt", dtItem.Rows[i].ItemArray[11].ToString());
            decimal txamt = (Convert.ToDecimal(dtItem.Rows[i].ItemArray[11].ToString()) * 100) / (100 + Convert.ToDecimal(dtItem.Rows[i].ItemArray[12].ToString()));
            order_item.Add("taxable_amt", txamt);
            order_item.Add("gst_per", dtItem.Rows[i].ItemArray[12].ToString());
            order_item.Add("gst_amt", dtItem.Rows[i].ItemArray[13].ToString());
            decimal cgstsgstper = Convert.ToDecimal(dtItem.Rows[i].ItemArray[12].ToString()) / 2;
            decimal cgstsgstamt = Convert.ToDecimal(dtItem.Rows[i].ItemArray[13].ToString()) / 2;
            order_item.Add("cgst_per", cgstsgstper);
            order_item.Add("cgst_amt", cgstsgstamt);
            order_item.Add("sgst_per", cgstsgstper);
            order_item.Add("sgst_amt", cgstsgstamt);
            order_item.Add("igst_per", 0);
            order_item.Add("igst_amt", 0);
            order_item.Add("cess_per", dtItem.Rows[i].ItemArray[14].ToString());
            order_item.Add("cess_amt", dtItem.Rows[i].ItemArray[15].ToString());
            order_item.Add("total_rate", dtItem.Rows[i].ItemArray[16].ToString());
            order_item.Add("fy_id", fyid);
            order_item.Add("is_ob", 0);
            order_item.Add("entry_by", USER["id"]);
            order_item.Add("status", 1);
            long stkid = Insert(table_name, order_item);

            if(!String.IsNullOrEmpty(dtItem.Rows[i].ItemArray[17].ToString()))
            {
                string store_id = dtItem.Rows[i].ItemArray[20].ToString();
                string free_item_id = dtItem.Rows[i].ItemArray[17].ToString();
                string free_qty = dtItem.Rows[i].ItemArray[18].ToString();
                string free_unit = dtItem.Rows[i].ItemArray[19].ToString();

                UpdateFreeStock(res, vtype, stkid, fyid, store_id, free_item_id, free_qty, free_unit);
            }
        }
    }


    public void UpdateFreeStock(long res, string vtype, long stkid, string fyid, string store_id, string free_item_id, string free_qty, string free_unit)
    {
        string table_name = "tbl_stock_details";
        Hashtable hsItem = GetRecords("tbl_item_master", "per_unit_qty,purchase_rate,sale_rate, mrp,cgst,sgst,igst", "id='" + free_item_id + "'");
        Hashtable order_item = new Hashtable();
        order_item.Add("company_id", COMPANY["id"]);
        order_item.Add("store_id", store_id);
        order_item.Add("ref_id", res);
        order_item.Add("ref_by", "tbl_inventory_master");
        order_item.Add("item_id", free_item_id);
        order_item.Add("is_free_item", 1);
        order_item.Add("itemid_freewith", stkid);
        order_item.Add("mrp", hsItem["mrp"]);

        decimal nrate = 0;
        if (vtype == "P" || vtype == "PO")
        {
            nrate = Convert.ToDecimal(hsItem["purchase_rate"].ToString()) * Convert.ToDecimal(free_qty);
            order_item.Add("rate", hsItem["purchase_rate"]);
            order_item.Add("inwardqty", free_qty);
            order_item.Add("inwardunit", free_unit);
            order_item.Add("inwardunitqty", free_qty);
            order_item.Add("inwardunit_id", free_unit);
        }
        else if (vtype == "S" || vtype == "SO")
        {
            nrate = Convert.ToDecimal(hsItem["sale_rate"].ToString()) * Convert.ToDecimal(free_qty);
            order_item.Add("rate", hsItem["sale_rate"]);
            order_item.Add("outwardqty", free_qty);
            order_item.Add("outwardunit", free_unit);
            order_item.Add("outwardunitqty", free_qty);
            order_item.Add("outwardunit_id", free_unit);
        }
        else if (vtype == "SR")
        {
            nrate = Convert.ToDecimal(hsItem["sale_rate"].ToString()) * Convert.ToDecimal(free_qty);
            order_item.Add("rate", hsItem["sale_rate"]);
            order_item.Add("inwardqty", free_qty);
            order_item.Add("inwardunit", free_unit);
            order_item.Add("inwardunitqty", free_qty);
            order_item.Add("inwardunit_id", free_unit);
        }
        else if (vtype == "PR")
        {
            nrate = Convert.ToDecimal(hsItem["purchase_rate"].ToString()) * Convert.ToDecimal(free_qty);
            order_item.Add("rate", hsItem["purchase_rate"]);
            order_item.Add("outwardqty", free_qty);
            order_item.Add("outwardunit", free_unit);
            order_item.Add("outwardunitqty", free_qty);
            order_item.Add("outwardunit_id", free_unit);
        }

        order_item.Add("net_rate", nrate);
        order_item.Add("gross_amt", nrate);
        order_item.Add("total_rate", nrate);
        order_item.Add("fy_id", fyid);
        order_item.Add("is_ob", 0);
        order_item.Add("entry_by", USER["id"]); 
        order_item.Add("status", 1);
        Insert(table_name, order_item);
    }

    private void OrderAlter()
    {
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
    }

    private void OrderList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        session["dtItem"] = null;
        string whereClause = "invoice_type='PO' and company_id='" + COMPANY["id"] + "' and (autogen_id like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_inventory_master", "view_inventory_master", "id, autogen_id as 'Order No.', convert(varchar, stock_dt, 105) as 'Order Date', ladgername+' ('+ledgercode+')' as 'Supplier', total_amt as 'Amount', convert(varchar, due_dt, 105) as 'Dues Date' ", whereClause, "id desc", 1, 1, 2, "Edit", "Print", null, "purchase_alter", "order_print", request.Url.AbsolutePath, 10));
    }

    private void GenerateOrder()
    {
        string table_name = "tbl_inventory_master";
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
        if (request["btn_save"] != null)
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("supplier", true, InputRule.DIGITS);
            validate.Add("order_no", true, InputRule.ALL);
            validate.Add("order_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("due_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("narration", false, InputRule.ALL, 100, 0);
            if (validate.Validate())
            {
                DataTable dtItem = session["dtItem"] != null ? (DataTable)session["dtItem"] : new DataTable();
                if (dtItem.Rows.Count <= 0)
                {
                    Error("Atleast one item required in cart.");
                    return;
                }
                string supplier = dtItem.Rows[0].Field<string>(0);
                Hashtable inst_data = new Hashtable();
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("invoice_type", "PO");
                inst_data.Add("ledger_id", supplier);
                inst_data.Add("autogen_id", request["order_no"].ToUpper());
                inst_data.Add("stock_dt", DateTime.ParseExact(request["order_dt"].ToUpper(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("due_dt", DateTime.ParseExact(request["due_dt"].ToUpper(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("naration", request["narration"]);
                inst_data.Add("status", 1);
                if (request["btn_save"].ToString() == "Save")
                {
                    inst_data.Add("entry_by", USER["id"]);
                    long res = 0;
                    int count = Convert.ToInt32(GetCount("*", table_name, MD5_ID + "='" + request["uid"] + "'"));
                    if (count == 0)
                    {
                        res = Insert(table_name, inst_data);

                        Hashtable hsInvSetting = GetRecords("tbl_invoice_setup_master", "*", "id='" + request["invidf"] + "'");
                        if (hsInvSetting.Count > 0)
                        {
                            inst_data.Clear();
                            inst_data.Add("last_invoiceno", request["invlastiof"].ToUpper());
                            inst_data.Add("last_invoicevalue", request["invlastvalof"].ToUpper());
                            Update("tbl_invoice_setup_master", inst_data, "id='" + request["invidf"] + "'");
                        }
                    }
                    else
                    {
                        Update(table_name, inst_data, MD5_ID + "='" + request["uid"] + "'");
                        res = Convert.ToInt64(GetText(table_name, "id", MD5_ID + "='" + request["uid"] + "'"));

                        Hashtable hsInvSetting = GetRecords("tbl_invoice_setup_master", "*", "id='" + request["invidf"] + "'");
                        if (hsInvSetting.Count > 0)
                        {
                            inst_data.Clear();
                            inst_data.Add("last_invoiceno", request["invlastiof"].ToUpper());
                            inst_data.Add("last_invoicevalue", request["invlastvalof"].ToUpper());
                            Update("tbl_invoice_setup_master", inst_data, "id='" + request["invidf"] + "'");
                        }
                    }
                    if (res > 0)
                    {
                        Delete("tbl_order_item_details", "inv_id = '" + res + "'");
                        for (int i = 0; i < dtItem.Rows.Count; i++)
                        {
                            Hashtable order_item = new Hashtable();
                            order_item.Add("inv_id", res);
                            order_item.Add("item_id", dtItem.Rows[i].ItemArray[1].ToString());
                            order_item.Add("unit", dtItem.Rows[i].ItemArray[2].ToString());
                            order_item.Add("unit_id", dtItem.Rows[i].ItemArray[3].ToString());
                            order_item.Add("purchase_rate", dtItem.Rows[i].ItemArray[4].ToString());
                            order_item.Add("total_purchase_rate", dtItem.Rows[i].ItemArray[5].ToString());
                            order_item.Add("status", 1);
                            count = Convert.ToInt32(GetCount("*", "tbl_order_item_details", "inv_id='" + res + "' and item_id='" + dtItem.Rows[i].ItemArray[1].ToString() + "' and unit_id='" + dtItem.Rows[i].ItemArray[3].ToString() + "'"));
                            if (count == 0)
                            {
                                order_item.Add("entry_by", USER["id"]);
                                Insert("tbl_order_item_details", order_item);
                            }
                            else
                            {
                                Update("tbl_order_item_details", order_item, "inv_id='" + res + "' and item_id='" + dtItem.Rows[i].ItemArray[1].ToString() + "' and unit_id='" + dtItem.Rows[i].ItemArray[3].ToString() + "'");
                            }
                            order_item.Clear();
                        }
                        session["dtItem"] = null;
                        response.Redirect("order_print.aspx?uid=" + MD5(res.ToString()) + "&wid=eccbc87e4b5ce2fe28308fd9f2a7baf3");
                    }
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }


    /* Code for Sale order */
    private void InvoiceAlter()
    {
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
    }

    private void SaleOrder()
    {
        string table_name = "tbl_inventory_master";
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
        if (request["btn_save"] != null)
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("supplier", true, InputRule.DIGITS);
            validate.Add("order_no", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("order_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("due_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("taxcalc", true, InputRule.DIGITS);
            validate.Add("discount", true, InputRule.DECIMAL);
            validate.Add("shipping_charge", true, InputRule.DECIMAL);
            validate.Add("round_off", true, InputRule.DECIMAL);
            validate.Add("total_amt", true, InputRule.DECIMAL);
            validate.Add("narration", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("paymode", true, InputRule.ALPHABET_NO_SPACE);
            if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
            {
                validate.Add("chqno", true, InputRule.ALPHA_NUMERIC_NO_SPACE);
                validate.Add("chqdt", true, InputRule.DATE_HYPHEN);
                validate.Add("bnkname", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            }
            validate.Add("amttopay", true, InputRule.DECIMAL);
            validate.Add("modedesc", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            if (validate.Validate())
            {
                DataTable dtItem = session["dtItem"] != null ? (DataTable)session["dtItem"] : new DataTable();
                if (dtItem.Rows.Count <= 0)
                {
                    Error("Atleast one item required on cart.");
                    return;
                }
                string supplier = dtItem.Rows[0].Field<string>(21);
                string taxcalc = dtItem.Rows[0].Field<string>(22);
                Hashtable inst_data = new Hashtable();
                string invtype_id = GetText("tbl_invoice_setup_master", "id", "company_id='" + COMPANY["id"] + "' and invoice_type='SALE' order by effective_date desc, id desc");
                if (!string.IsNullOrWhiteSpace(invtype_id))
                    inst_data.Add("invtype_id", invtype_id);
                inst_data.Add("invoice_type", "S");
                inst_data.Add("naration", request["narration"]);
                inst_data.Add("invoice_no", request["order_no"]);
                inst_data.Add("invoice_dt", DateTime.ParseExact(request["order_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("invoice_naration", request["narration"]);
                inst_data.Add("taxinclude", taxcalc);
                inst_data.Add("invoice_amt", request["totinvval"]);
                decimal dp = (Convert.ToDecimal(request["discount"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("discount_per", dp.ToString("0.00"));
                inst_data.Add("discount_amt", request["discount"]);
                decimal sp = (Convert.ToDecimal(request["shipping_charge"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("shipping_per", sp.ToString("0.00"));
                inst_data.Add("shipping_charge", request["shipping_charge"]);
                decimal wr = (Convert.ToDecimal(request["shipping_charge"]) + Convert.ToDecimal(request["totinvval"])) + Convert.ToDecimal(request["discount"]);
                inst_data.Add("withoutrndoff", wr.ToString("0.00"));
                inst_data.Add("round_off", request["round_off"]);
                inst_data.Add("total_amt", request["total_amt"]);
                inst_data.Add("due_dt", DateTime.ParseExact(request["due_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("entry_by", USER["id"]);
                string where = "company_id='" + COMPANY["id"] + "' and ledger_id='" + supplier + "' and autogen_id='" + request["order_no"] + "' and invoice_type in ('S','SO')";
                long cnt = Convert.ToInt64(GetCount("autogen_id", table_name, where));
                long res = 0;
                if (cnt == 0)
                {
                    inst_data.Add("company_id", COMPANY["id"]);
                    inst_data.Add("ledger_id", supplier);
                    inst_data.Add("autogen_id", request["order_no"]);
                    inst_data.Add("stock_dt", DateTime.ParseExact(request["order_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                    res = Insert(table_name, inst_data);
                }
                else
                {
                    //Update(table_name, inst_data, where);
                    //res = Convert.ToInt64(GetText(table_name, "id", where));
                    Error("Order number already exists.");
                    return;
                }

                if (res > 0)
                {
                    //code for update stock
                    Delete("tbl_stock_details", "ref_id='" + res + "' and ref_by='tbl_inventory_master'");
                    UpdateStock(res, "S", dtItem);

                    //code for insert transaction
                    long ldgid = Convert.ToInt64(supplier);
                    decimal dr = 0;
                    decimal cr = 0;

                    if (!string.IsNullOrWhiteSpace(request["total_amt"]))
                        dr = Convert.ToDecimal(request["total_amt"]);

                    long transid = createTrans(ldgid, "DR", dr, 0, "", "Credit", "", "", "", res);
                    createInvoicePayment(ldgid, res, transid, dr, "Credit");
                    if (request["paymode"].ToString().Trim().ToLower() != "credit")
                    {
                        if (!string.IsNullOrWhiteSpace(request["amttopay"]))
                        {
                            cr = Convert.ToDecimal(request["amttopay"]);
                            dr = 0;
                            if (cr > 0)
                            {
                                string chqno = "";
                                string chqdt = "";
                                string bnkname = "";
                                if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
                                {
                                    chqno = request["chqno"].ToString();
                                    chqdt = DateTime.ParseExact(request["chqdt"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy");
                                    bnkname = request["bnkname"].ToString();
                                }
                                transid = createTrans(ldgid, "DR", 0, cr, request["modedesc"], request["paymode"], chqno, chqdt, bnkname);
                                createInvoicePayment(ldgid, res, transid, cr, "Payment");
                            }
                        }
                    }


                    //update invoice last id
                    Hashtable hsInvSetting = GetRecords("tbl_invoice_setup_master", "*", "company_id='" + COMPANY["id"] + "' and id='" + request["invidf"] + "'");
                    if (hsInvSetting.Count > 0)
                    {
                        inst_data.Clear();
                        inst_data.Add("last_invoiceno", request["invlastiof"].ToUpper());
                        inst_data.Add("last_invoicevalue", request["invlastvalof"].ToUpper());
                        Update("tbl_invoice_setup_master", inst_data, "id='" + request["invidf"] + "'");
                    }

                    response.Redirect("salevoucher_print.aspx?uid=" + MD5(res.ToString()) + "&wid=eccbc87e4b5ce2fe28308fd9f2a7baf3");
                }
                else
                {
                    Error("Error while updating sale voucher.");
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void SaleList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        session["dtItem"] = null;
        string whereClause = "invoice_type in ('SO','S') and company_id='" + COMPANY["id"] + "' and (autogen_id like '%" + src_prm[0] + "%' or invoice_no like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_inventory_master", "view_inventory_master", "id, autogen_id as 'Invoice No.', convert(varchar, stock_dt, 105) as 'Invoice Date', ladgername+' ('+ledgercode+')' as 'Customer', total_amt as 'Amount', convert(varchar, due_dt, 105) as 'Dues Date' ", whereClause, "id desc", 1, 1, 2, "Edit", "Print", null, "salevoucher_alter", "salevoucher_print", request.Url.AbsolutePath, 10));
    }

    /* Code for Purchase return*/
    private void PurReturnList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        session["dtItem"] = null;
        string whereClause = "invoice_type='PR' and company_id='" + COMPANY["id"] + "' and (autogen_id like '%" + src_prm[0] + "%' or invoice_no like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_inventory_master", "view_inventory_master", "id, autogen_id as 'Order No.', convert(varchar, stock_dt, 105) as 'Order Date', invoice_no as 'Invoice No.', convert(varchar, invoice_dt, 105) as 'Invoice Date', ladgername+' ('+ledgercode+')' as 'Supplier', total_amt as 'Amount', convert(varchar, due_dt, 105) as 'Dues Date' ", whereClause, "id desc", 1, 1, 0, "Return", "Print", null, "purchaseret_alter", "purchaseret_print", request.Url.AbsolutePath, 10));
    }

    private void PurReturnAlter()
    {
        string table_name = "tbl_inventory_master";
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
        if (request["btn_save"] != null)
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("supplier", true, InputRule.DIGITS);
            validate.Add("invoice_no", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("invoice_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("order_no", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("order_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("due_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("taxcalc", true, InputRule.DIGITS);
            validate.Add("discount", true, InputRule.DECIMAL);
            validate.Add("shipping_charge", true, InputRule.DECIMAL);
            validate.Add("round_off", true, InputRule.DECIMAL);
            validate.Add("total_amt", true, InputRule.DECIMAL);
            validate.Add("narration", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("paymode", true, InputRule.ALPHABET_NO_SPACE);
            if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
            {
                validate.Add("chqno", true, InputRule.ALPHA_NUMERIC_NO_SPACE);
                validate.Add("chqdt", true, InputRule.DATE_HYPHEN);
                validate.Add("bnkname", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            }
            validate.Add("amttopay", true, InputRule.DECIMAL);
            validate.Add("modedesc", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            if (validate.Validate())
            {
                DataTable dtItem = session["dtItem"] != null ? (DataTable)session["dtItem"] : new DataTable();
                if (dtItem.Rows.Count <= 0)
                {
                    Error("Atleast one item required on cart.");
                    return;
                }
                string supplier = dtItem.Rows[0].Field<string>(21);
                string taxcalc = dtItem.Rows[0].Field<string>(22);
                Hashtable inst_data = new Hashtable();
                string invtype_id = GetText("tbl_invoice_setup_master", "id", "invoice_type='PURCHASE RETURN' order by effective_date desc, id desc");
                if (!string.IsNullOrWhiteSpace(invtype_id))
                    inst_data.Add("invtype_id", invtype_id);
                inst_data.Add("invoice_type", "PR");
                inst_data.Add("naration", request["narration"]);
                inst_data.Add("invoice_no", request["invoice_no"]);
                inst_data.Add("invoice_dt", DateTime.ParseExact(request["invoice_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("invoice_naration", request["narration"]);
                inst_data.Add("invoice_amt", request["totinvval"]);
                inst_data.Add("taxinclude", taxcalc);
                decimal dp = (Convert.ToDecimal(request["discount"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("discount_per", dp.ToString("0.00"));
                inst_data.Add("discount_amt", request["discount"]);
                decimal sp = (Convert.ToDecimal(request["shipping_charge"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("shipping_per", sp.ToString("0.00"));
                inst_data.Add("shipping_charge", request["shipping_charge"]);
                decimal wr = (Convert.ToDecimal(request["shipping_charge"]) + Convert.ToDecimal(request["totinvval"])) + Convert.ToDecimal(request["discount"]);
                inst_data.Add("withoutrndoff", wr.ToString("0.00"));
                inst_data.Add("round_off", request["round_off"]);
                inst_data.Add("total_amt", request["total_amt"]);
                inst_data.Add("due_dt", DateTime.ParseExact(request["due_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("entry_by", USER["id"]);
                string where = "company_id='" + COMPANY["id"] + "' and ledger_id='" + supplier + "' and autogen_id='" + request["order_no"] + "' and invoice_type='PR'";
                long cnt = Convert.ToInt64(GetCount("autogen_id", table_name, where));
                long res = 0;
                if (cnt == 0)
                {
                    inst_data.Add("company_id", COMPANY["id"]);
                    inst_data.Add("ledger_id", supplier);
                    inst_data.Add("autogen_id", request["order_no"]);
                    inst_data.Add("stock_dt", DateTime.ParseExact(request["order_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                    res = Insert(table_name, inst_data);
                }
                else
                {
                    Update(table_name, inst_data, where);
                    res = Convert.ToInt64(GetText(table_name, "id", where));
                }

                if (res > 0)
                {
                    //code for update stock
                    Delete("tbl_stock_details", "ref_id='" + res + "' and ref_by='tbl_inventory_master'");
                    UpdateStock(res, "PR", dtItem);

                    //code for insert transaction
                    long ldgid = Convert.ToInt64(supplier);
                    decimal dr = 0;
                    decimal cr = 0;

                    if (!string.IsNullOrWhiteSpace(request["total_amt"]))
                        dr = Convert.ToDecimal(request["total_amt"]);

                    long transid = createTrans(ldgid, "CR", dr, 0, "", "Credit", "", "", "", res);
                    createInvoicePayment(ldgid, res, transid, dr, "Credit");
                    if (request["paymode"].ToString().Trim().ToLower() != "credit")
                    {
                        if (!string.IsNullOrWhiteSpace(request["amttopay"]))
                        {
                            cr = Convert.ToDecimal(request["amttopay"]);
                            dr = 0;
                            if (cr > 0)
                            {
                                string chqno = "";
                                string chqdt = "";
                                string bnkname = "";
                                if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
                                {
                                    chqno = request["chqno"].ToString();
                                    chqdt = DateTime.ParseExact(request["chqdt"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy");
                                    bnkname = request["bnkname"].ToString();
                                }
                                transid = createTrans(ldgid, "CR", 0, cr, request["modedesc"], request["paymode"], chqno, chqdt, bnkname);
                                createInvoicePayment(ldgid, res, transid, cr, "Payment");
                            }
                        }
                    }

                    //update invoice last id
                    Hashtable hsInvSetting = GetRecords("tbl_invoice_setup_master", "*", "company_id='" + COMPANY["id"] + "' and id='" + request["invidf"] + "'");
                    if (hsInvSetting.Count > 0)
                    {
                        inst_data.Clear();
                        inst_data.Add("last_invoiceno", request["invlastiof"].ToUpper());
                        inst_data.Add("last_invoicevalue", request["invlastvalof"].ToUpper());
                        Update("tbl_invoice_setup_master", inst_data, "id='" + request["invidf"] + "'");
                    }

                    response.Redirect("purchaseret_print.aspx?uid=" + MD5(res.ToString()) + "&wid=eccbc87e4b5ce2fe28308fd9f2a7baf3");
                }
                else
                {
                    Error("Error while updating purchase voucher.");
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void PurReturnPrint()
    {
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
    }

    /* Code for sale return*/
    private void SaleReturnPrint()
    {
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
    }

    private void SaleReturnList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        session["dtItem"] = null;
        string whereClause = "invoice_type='SR' and company_id='" + COMPANY["id"] + "' and (autogen_id like '%" + src_prm[0] + "%' or invoice_no like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_inventory_master", "view_inventory_master", "id, invoice_no as 'Invoice No.', convert(varchar, invoice_dt, 105) as 'Invoice Date', ladgername+' ('+ledgercode+')' as 'Customer', total_amt as 'Amount'", whereClause, "id desc", 1, 1, 0, "Return", "Print", null, "saleret_alter", "saleret_print", request.Url.AbsolutePath, 10));
    }

    private void SaleReturnAlter()
    {
        string table_name = "tbl_inventory_master";
        string view_name = "tbl_inventory_master";
        CheckUrl(view_name);
        if (request["btn_save"] != null)
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("supplier", true, InputRule.DIGITS);
            validate.Add("order_no", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("order_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("due_dt", true, InputRule.DATE_HYPHEN);
            validate.Add("taxcalc", true, InputRule.DIGITS);
            validate.Add("discount", true, InputRule.DECIMAL);
            validate.Add("shipping_charge", true, InputRule.DECIMAL);
            validate.Add("round_off", true, InputRule.DECIMAL);
            validate.Add("total_amt", true, InputRule.DECIMAL);
            validate.Add("narration", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("paymode", true, InputRule.ALPHABET_NO_SPACE);
            if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
            {
                validate.Add("chqno", true, InputRule.ALPHA_NUMERIC_NO_SPACE);
                validate.Add("chqdt", true, InputRule.DATE_HYPHEN);
                validate.Add("bnkname", true, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            }
            validate.Add("amttopay", true, InputRule.DECIMAL);
            validate.Add("modedesc", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            if (validate.Validate())
            {
                DataTable dtItem = session["dtItem"] != null ? (DataTable)session["dtItem"] : new DataTable();
                if (dtItem.Rows.Count <= 0)
                {
                    Error("Atleast one item required on cart.");
                    return;
                }
                string supplier = dtItem.Rows[0].Field<string>(21);
                string taxcalc = dtItem.Rows[0].Field<string>(22);
                Hashtable inst_data = new Hashtable();
                string invtype_id = GetText("tbl_invoice_setup_master", "id", "invoice_type='SALE RETURN' order by effective_date desc, id desc");
                if (!string.IsNullOrWhiteSpace(invtype_id))
                    inst_data.Add("invtype_id", invtype_id);
                inst_data.Add("invoice_type", "SR");
                inst_data.Add("naration", request["narration"]);
                inst_data.Add("invoice_no", request["order_no"]);
                inst_data.Add("invoice_dt", DateTime.ParseExact(request["order_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("invoice_naration", request["narration"]);
                inst_data.Add("taxinclude", taxcalc);
                inst_data.Add("invoice_amt", request["totinvval"]);
                decimal dp = (Convert.ToDecimal(request["discount"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("discount_per", dp.ToString("0.00"));
                inst_data.Add("discount_amt", request["discount"]);
                decimal sp = (Convert.ToDecimal(request["shipping_charge"]) * 100) / Convert.ToDecimal(request["totinvval"]);
                inst_data.Add("shipping_per", sp.ToString("0.00"));
                inst_data.Add("shipping_charge", request["shipping_charge"]);
                decimal wr = (Convert.ToDecimal(request["shipping_charge"]) + Convert.ToDecimal(request["totinvval"])) + Convert.ToDecimal(request["discount"]);
                inst_data.Add("withoutrndoff", wr.ToString("0.00"));
                inst_data.Add("round_off", request["round_off"]);
                inst_data.Add("total_amt", request["total_amt"]);
                inst_data.Add("due_dt", DateTime.ParseExact(request["due_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                inst_data.Add("entry_by", USER["id"]);
                string where = "company_id='" + COMPANY["id"] + "' and ledger_id='" + supplier + "' and autogen_id='" + request["order_no"] + "' and invoice_type='SR'";
                long cnt = Convert.ToInt64(GetCount("autogen_id", table_name, where));
                long res = 0;
                if (cnt == 0)
                {
                    inst_data.Add("company_id", COMPANY["id"]);
                    inst_data.Add("ledger_id", supplier);
                    inst_data.Add("autogen_id", request["order_no"]);
                    inst_data.Add("stock_dt", DateTime.ParseExact(request["order_dt"], "dd-MM-yyyy", null).ToString("MM-dd-yyyy"));
                    res = Insert(table_name, inst_data);
                }
                else
                {
                    Update(table_name, inst_data, where);
                    res = Convert.ToInt64(GetText(table_name, "id", where));
                }

                if (res > 0)
                {
                    //code for update stock
                    Delete("tbl_stock_details", "ref_id='" + res + "' and ref_by='tbl_inventory_master'");
                    UpdateStock(res, "SR", dtItem);

                    //code for insert transaction
                    long ldgid = Convert.ToInt64(supplier);
                    decimal dr = 0;
                    decimal cr = 0;

                    if (!string.IsNullOrWhiteSpace(request["total_amt"]))
                        cr = Convert.ToDecimal(request["total_amt"]);

                    long transid = createTrans(ldgid, "DR", 0, cr, "", "Credit", "", "", "", res);
                    createInvoicePayment(ldgid, res, transid, cr, "Credit");
                    if (request["paymode"].ToString().Trim().ToLower() != "credit")
                    {
                        if (!string.IsNullOrWhiteSpace(request["amttopay"]))
                        {
                            dr = Convert.ToDecimal(request["amttopay"]);
                            cr = 0;
                            if (dr > 0)
                            {
                                string chqno = "";
                                string chqdt = "";
                                string bnkname = "";
                                if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
                                {
                                    chqno = request["chqno"].ToString();
                                    chqdt = DateTime.ParseExact(request["chqdt"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy");
                                    bnkname = request["bnkname"].ToString();
                                }
                                transid = createTrans(ldgid, "DR", dr, 0, request["modedesc"], request["paymode"], chqno, chqdt, bnkname);
                                createInvoicePayment(ldgid, res, transid, dr, "Payment");
                            }
                        }
                    }


                    //update invoice last id
                    Hashtable hsInvSetting = GetRecords("tbl_invoice_setup_master", "*", "company_id='" + COMPANY["id"] + "' and id='" + request["invidf"] + "'");
                    if (hsInvSetting.Count > 0)
                    {
                        inst_data.Clear();
                        inst_data.Add("last_invoiceno", request["invlastiof"].ToUpper());
                        inst_data.Add("last_invoicevalue", request["invlastvalof"].ToUpper());
                        Update("tbl_invoice_setup_master", inst_data, "id='" + request["invidf"] + "'");
                    }

                    response.Redirect("saleret_print.aspx?uid=" + MD5(res.ToString()) + "&wid=eccbc87e4b5ce2fe28308fd9f2a7baf3");
                }
                else
                {
                    Error("Error while updating sale voucher.");
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void PaymentVoucher()
    {
        string view_name = "tbl_transaction_master";
        CheckUrl(view_name);
    }

    private void Payment()
    {
        if (request["update_submit"] == "Update")
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("supplier", true, InputRule.DIGITS);
            validate.Add("creditamt", true, InputRule.DECIMAL);
            validate.Add("payamt", true, InputRule.DECIMAL);
            validate.Add("paymode", true, InputRule.ALPHABET_NO_SPACE);
            validate.Add("paynow", true, InputRule.DECIMAL);
            validate.Add("chqno", false, InputRule.ALPHA_NUMERIC_NO_SPACE);
            validate.Add("chqdt", false, InputRule.DATE_HYPHEN);
            validate.Add("bnkname", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            validate.Add("narat", false, InputRule.ALPHA_NUMERIC_WITH_SPACE);
            if (validate.Validate())
            {
                Hashtable hsLdg = GetRecords("select id, name, code, mobile_no, group_id, billing_type from tbl_ledger_master where company_id='" + COMPANY["id"] + "' and id='" + request["supplier"] + "'");
                if (hsLdg.Count > 0)
                {
                    //code for insert transaction
                    long ldgid = Convert.ToInt64(hsLdg["id"].ToString());
                    decimal dr = 0;
                    decimal cr = 0;
                    decimal amt = 0;
                    string ldgType = "";

                    string chqno = "";
                    string chqdt = "";
                    string bnkname = "";
                    if (request["paymode"].ToString() == "Cheque" || request["paymode"].ToString() == "DD")
                    {
                        chqno = request["chqno"].ToString();
                        chqdt = DateTime.ParseExact(request["chqdt"].ToString(), "dd-MM-yyyy", null).ToString("MM-dd-yyyy");
                        bnkname = request["bnkname"].ToString();
                    }

                    if (hsLdg["group_id"].ToString() == "3") //for customer
                    {
                        if (!string.IsNullOrWhiteSpace(request["paynow"]))
                            cr = Convert.ToDecimal(request["paynow"]);

                        ldgType = "DR";
                        amt = cr;
                    }
                    else
                    {
                        if (!string.IsNullOrWhiteSpace(request["paynow"]))
                            dr = Convert.ToDecimal(request["paynow"]);

                        ldgType = "CR";
                        amt = dr;
                    }
                    long transid = createTrans(ldgid, ldgType, dr, cr, request["modedesc"], request["paymode"], chqno, chqdt, bnkname);
                    
                    SqlDataReader sqdr = GetDataReader("select id, dueamt from tbl_inventory_master where company_id='" + COMPANY["id"] + "' and ledger_id='" + hsLdg["id"] + "' and dueamt>0 and status=1");
    
                    if (sqdr.HasRows)
                    {
                        while (sqdr.Read())
                        {
                            decimal payamt = amt >= Convert.ToInt64(sqdr["dueamt"]) ? Convert.ToInt64(sqdr["dueamt"]) : amt;
                            if (sqdr["id"].ToString() == request["invids_"+ sqdr["id"].ToString()] || ldgType == "DR")
                            createInvoicePayment(ldgid, Convert.ToInt64(sqdr["id"]), transid, payamt, "Payment");
                            amt = amt - payamt;
                        }
                    }
                    
                    response.Redirect("payment_voucher.aspx?uid="+MD5(transid.ToString()) + "&wid=eccbc87e4b5ce2fe28308fd9f2a7baf3");
                }
            }
            else
            {
                ValidationError(validate);
            }
        }
    }

    private void Production()
    {
        string view_name = "view_production_master";
        CheckUrl(view_name);
        if (request["btn_save"] == "Save")
        {
            InputValidator validate = new InputValidator(request);
            validate.Add("store_cat", true, InputRule.DIGITS);
            validate.Add("store", true, InputRule.DIGITS);
            validate.Add("item_category", true, InputRule.DIGITS);
            validate.Add("item_manufacture", true, InputRule.DIGITS);
            validate.Add("item_name", true, InputRule.ALL);
            validate.Add("item_code", true, InputRule.ALPHA_NUMERIC_NO_SPACE);
            validate.Add("per_unit_qty", true, InputRule.DECIMAL);
            if (validate.Validate())
            {
                long pd_id = 0;
                Hashtable inst_data = new Hashtable();
                inst_data.Add("store_id", request["store"].ToUpper());
                inst_data.Add("itm_cat_id", request["item_category"].ToUpper());
                inst_data.Add("itm_manuf_id", request["item_manufacture"].ToUpper());
                inst_data.Add("item_name", request["item_name"].ToUpper());
                inst_data.Add("item_code", request["item_code"].ToUpper());
                inst_data.Add("per_unit_qty", request["per_unit_qty"].ToUpper());
                inst_data.Add("company_id", COMPANY["id"]);
                inst_data.Add("last_alter_dt", DateTime.Now.ToString("MM-dd-yyyy"));
                inst_data.Add("last_alter_by", USER["id"]);
                inst_data.Add("status", 1);
                inst_data.Add("entry_by", USER["id"]);
                int count = Convert.ToInt32(GetCount("*", "tbl_item_master", "item_name='" + request["item_name"].ToUpper() + "' and item_code='" + request["item_code"] + "'"));
                if (count == 0)
                {
                    long item_id = Insert("tbl_item_master", inst_data);
                    if (item_id > 0)
                    {
                        inst_data.Clear();
                        inst_data.Add("item_id", item_id);
                        inst_data.Add("price_per_unit", request["unit_amount"].ToUpper());
                        inst_data.Add("is_taxable", 0);
                        inst_data.Add("usp", request["unit_amount"].ToUpper());
                        inst_data.Add("effective_date", DateTime.Now.ToString("MM-dd-yyyy"));
                        inst_data.Add("company_id", COMPANY["id"]);
                        inst_data.Add("entry_by", USER["id"]);
                        inst_data.Add("status", 1);
                        if (Convert.ToInt64(GetCount("*", "tbl_item_price_master", "item_id='" + item_id + "'")) == 0)
                            Insert("tbl_item_price_master", inst_data);
                        else
                            Update("tbl_item_price_master", inst_data, "item_id='" + item_id + "'");

                        //pd_id = update_product(item_id);
                    }
                }
                else
                {
                    Update("tbl_item_master", inst_data, "item_name='" + request["item_name"].ToUpper() + "' and item_code='" + request["item_code"] + "'");
                    long item_id = Convert.ToInt64(GetText("tbl_item_master", "id", "item_name='" + request["item_name"].ToUpper() + "' and item_code='" + request["item_code"] + "'"));
                    if (item_id > 0)
                    {
                        inst_data.Clear();
                        inst_data.Add("item_id", item_id);
                        inst_data.Add("price_per_unit", request["unit_amount"].ToUpper());
                        inst_data.Add("is_taxable", 0);
                        inst_data.Add("usp", request["unit_amount"].ToUpper());
                        inst_data.Add("effective_date", DateTime.Now.ToString("MM-dd-yyyy"));
                        inst_data.Add("company_id", COMPANY["id"]);
                        inst_data.Add("entry_by", USER["id"]);
                        inst_data.Add("status", 1);
                        if (Convert.ToInt64(GetCount("*", "tbl_item_price_master", "item_id='" + item_id + "'")) == 0)
                            Insert("tbl_item_price_master", inst_data);
                        else
                            Update("tbl_item_price_master", inst_data, "item_id='" + item_id + "'");

                        //pd_id = update_product(item_id);
                    }
                }

                if (pd_id > 0)
                    response.Redirect("production_list.aspx?cmd=Clear");
            }
            else
            {
                ValidationError(validate);
            }
        }

        if (request["btn_del"] == "Delete")
        {
            Hashtable inst_data = new Hashtable();
            inst_data.Add("status", 0);
            inst_data.Add("delete_by", USER["id"]);
            if (Update("tbl_production_master", inst_data, MD5_ID + "='" + request["uid"] + "'") > 0)
            {
                //write item and stock management code
                string item_id = GetText("tbl_production_master", "item_id", MD5_ID + "='" + request["uid"] + "'");
                inst_data.Clear();
                inst_data.Add("status", 0);
                Update("tbl_item_master", inst_data, "id='" + item_id + "'");
                inst_data.Clear();
                inst_data.Add("status", 0);
                Update("tbl_item_price_master", inst_data, "item_id='" + item_id + "'");
                response.Redirect("production_list.aspx?cmd=Clear");
            }
            else
            {
                Error("Error while updating Records.");
            }
        }
    }

    private void ProductionList()
    {
        string[] src_prm = new string[1];

        if (request["cmd"] != null)
        {
            session["src_" + URLFILENAME] = null;
        }
        if (request["btn_header_search"] != null)
        {
            src_prm[0] = request["txt_header_search"];
            session["src_" + URLFILENAME] = src_prm;
        }
        if (session["src_" + URLFILENAME] != null)
        {
            src_prm = (string[])session["src_" + URLFILENAME];
        }
        else
        {
            src_prm[0] = "";
        }
        string whereClause = "status=1 and company_id='" + COMPANY["id"] + "' and (item_name like '%" + src_prm[0] + "%' or item_code like '%" + src_prm[0] + "%') ";
        response.Write(GetDataList("tbl_production_master", "view_production_master", "id, item_name as 'Item_name', item_code as 'Item Code', convert(varchar, production_date, 105) as 'Entry Date', unit_symbol as 'Unit Symbol'", whereClause, "id desc", 1, 0, 0, null, null, null, "production", "production", request.Url.AbsolutePath, 10));
    }

}