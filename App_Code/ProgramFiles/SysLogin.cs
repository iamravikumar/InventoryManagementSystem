using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Text;
using System.Collections;
/// <summary>
/// Summary description for Login
/// </summary>
/// 

public class SysLogin : ClassDB
{
    public SysLogin(HttpRequest request, HttpResponse response)
        : base(request, response)
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public void Execute()
    {
        if (URLFILENAME.ToLower() == "registration")
            SignUp();
        if (URLFILENAME.ToLower() == "signing")
        {
            LogIn();
        }
    }

    private void SignUp()
    {
        if (request["register"] == "Register")
        {
            InputValidator validator = new InputValidator(request);
            validator.Add("comp_name", true, InputRule.ALL);
            validator.Add("mobile", true, InputRule.MOBILE, 10, 10);
            validator.Add("email", true, InputRule.EMAIL);
            if (validator.Validate())
            {
                //check if company name exist
                int count = Convert.ToInt32(GetCount("*", "tbl_company_master", "company_name='" + request["comp_name"].Trim() + "'"));
                if (count > 0)
                {
                    Error("Company name is already exist.");
                    return;
                }

                //check if mobile no exist
                count = Convert.ToInt32(GetCount("*", "tbl_company_master", "mobile_no='" + request["mobile"].Trim() + "'"));
                if (count > 0)
                {
                    Error("This mobile no. is already uses by another Company User.");
                    return;
                }

                Hashtable inv_data = new Hashtable();
                inv_data.Add("company_name", request["comp_name"].ToUpper().Trim());
                inv_data.Add("mailing_name", request["comp_name"].ToUpper().Trim());
                inv_data.Add("country", "INDIA");
                inv_data.Add("email_address", request["email"].Trim());
                inv_data.Add("reg_mobile_no", request["mobile"].Trim());
                inv_data.Add("currency_symbol", "Rupees");
                long res = Insert("tbl_company_master", inv_data);
                if (res > 0)
                {
                    inv_data.Clear();
                    inv_data.Add("company_id", res);
                    inv_data.Add("roles_type", "ADMINISTRATOR");
                    long roles_id = Insert("tbl_user_role_master", inv_data);

                    string passcode = "1234";// CreateRandomPassword(8);
                    inv_data.Clear();
                    inv_data.Add("company_id", res);
                    inv_data.Add("user_name", "ADMINISTRATOR");
                    inv_data.Add("login_id", request["mobile"].Trim());
                    inv_data.Add("mobile_no", request["mobile"].Trim());
                    inv_data.Add("password", MD5(passcode));
                    inv_data.Add("role_id", roles_id);
                    long user_id = Insert("tbl_user_master", inv_data);

                    //try
                    //{
                    //    string smsmsg = "Dear User. Welcome to eStore System. Your login username is registered mobile no and password is " + passcode + ". Thank You.";

                    //    Hashtable hsSMS = new Hashtable();
                    //    hsSMS.Add("company_id", res);
                    //    hsSMS.Add("user_id", user_id);
                    //    hsSMS.Add("msg_text", smsmsg);
                    //    hsSMS.Add("response_msg", sendSMS(request["mobile"].Trim(), smsmsg));
                    //    hsSMS.Add("mobile_no", request["mobile"].Trim());
                    //    Insert("tbl_sms_details", hsSMS);
                    //}
                    //catch { }

                    session["success_signup"] = true;
                    response.Redirect(SOURCE_ROOT + "/signing.aspx");
                }
            }
            else
            {
                ValidationError(validator);
            }
        }
    }

    public void LogIn()
    {
        if (request["login"] == "Validating...")
        {
            InputValidator validator = new InputValidator(request);
            validator.Add("user_name", true, InputRule.USER_NAME);
            validator.Add("password", true, InputRule.ALL);
            if (validator.Validate())
            {
                Hashtable user = new Hashtable();
                String userName = request["user_name"].Replace("'", "");
                String password = MD5(request["password"]);
                SqlDataReader rdr = GetDataReader("select * from tbl_user_master where login_id='" + userName + "' and password='" + password + "' and status=1");

                if (rdr.Read())
                {
                    for (int i = 0; i < rdr.FieldCount; i++)
                        user.Add(rdr.GetName(i), rdr[i].ToString());
                    session["USER"] = user;

                    //code for company setup in Inventory
                    Hashtable company = GetRecords("select * from tbl_company_master where id='" + user["company_id"] + "' and status=1");
                    if (company.Count > 0)
                    {
                        session["COMPANY"] = company;
                    }
                    else
                    {
                        Error("Company not found.");
                        return;
                    }
                    string url = SOURCE_ROOT + "/admin/dashboard.aspx";
                    response.Redirect(url);
                }
                else
                {
                    Error("Invalid User Name or Password.");
                }
                rdr.Close();
            }
            else
            {
                ValidationError(validator);
            }
        }
    }

    public void LogOut()
    {
        session.Clear();
        response.Redirect(SOURCE_ROOT + "/signing.aspx"); 
    }

    public void ChangePassword()
    {

        if (request["change_password"] == "Change Password")
        {
            if (request["password"] != request["cnf_password"])
            {
                Error("Confirm password doesnot match.");
                return;
            }
            SqlDataReader rds = GetDataReader("select * from tbl_user_master where id='" + USER["id"].ToString() + "'");
            if (rds.Read())
            {
                if (MD5(request["old_password"]) == rds["password"].ToString())
                {
                    Hashtable LoginData = new Hashtable();
                    LoginData.Add("password", MD5(request["password"]));
                    String where = "id='" + USER["id"] + "'";
                    long res = Update("tbl_user_master", LoginData, where);

                    if (res > 0)
                    {
                        Message("Password changed successfully ");
                    }
                }
                else
                {
                    Error("Invalid old password.");
                }
            }
            rds.Close();
        }
    }
}