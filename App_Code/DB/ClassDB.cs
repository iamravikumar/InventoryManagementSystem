using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Collections;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Globalization;
using System.IO;
using System.Configuration;
using System.Web.Configuration;
using System.Collections.Specialized;
using System.Net;
using RKLib.ExportData;
using System.Net.Mail;

/// <summary>
/// Summary description for ClassDB
/// </summary>
/// 

public class ClassDB
{
    protected HttpRequest request;
    protected HttpResponse response;
    protected HttpSessionStateBase session;
    protected SqlConnection con;
    private String connectionString = "";
    protected String lastError;
    protected String query;
    protected int ADMIN_PAGE_LIMIT;
    protected int FRONT_PAGE_LIMIT;
    public String URLFILENAME;
    public String ButtonOperation, ButtonOperation2;
    public String diasableit = "";
    public Dictionary<String, String> TempRs;
    protected String obj;
    protected SqlCommand cmd;
    protected SqlDataReader reader;
    protected String linkColor = "#018aa7";
    public readonly DateTime EPOCH = new DateTime(1970, 1, 1, 0, 0, 0);
    public String MD5_ID = " convert(varchar(100),HASHBYTES('md5',CONVERT(varchar(100),id)),2) ";
    public String SOURCE_ROOT = "";
    public String IMAGE_PATH = "";
    public int file_permission = 0;

    //Extra Definition, Need to define in page as per use
    public int ROLESTYPE = 0;
    public Hashtable USER;
    public Hashtable COMPANY;

    public ClassDB(HttpRequest request, HttpResponse response)
    {
        try
        {
            ADMIN_PAGE_LIMIT = 50;
            FRONT_PAGE_LIMIT = 10;
            this.request = request;
            this.response = response;
            this.session = request.RequestContext.HttpContext.Session;
            SOURCE_ROOT = request.ApplicationPath == "/" ? "" : request.ApplicationPath;
            IMAGE_PATH = SOURCE_ROOT + "/common/images/";
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();
            NameValueCollection setting = WebConfigurationManager.AppSettings;
            builder.DataSource = @"" + setting["DataSource"] + "";  //Sql Server Name           
            builder.InitialCatalog = setting["InitialCatalog"]; // Database Name
            builder.UserID = setting["UserID"];
            builder.Password = setting["Password"];
            builder.ConnectTimeout = 600; //Time (in seconds) -- time to wait while trying to establish a connection before terminating the attempt and generating an error.
            builder.MaxPoolSize = 100000; //maximum number of connections allowed in the connection pool for this specific connection String
            builder.MinPoolSize = 10; //minimum number of connections allowed in the connection pool for this specific connection String
            builder.Pooling = true;
            builder.MultipleActiveResultSets = true;
            this.connectionString = builder.ToString();
            con = new SqlConnection(this.connectionString);
            con.Open();

            if (session["USER"] != null)
            {
                USER = (Hashtable)session["USER"];

                if (USER["role_id"] != "" && USER["role_id"] != null)
                    ROLESTYPE = Convert.ToInt32(USER["role_id"]);//Note: Needs modification while working with role id. Aslo in GetDatalist Fuction;
            }
            else
            {
                USER = new Hashtable();
            }

            if (session["COMPANY"] != null)
                COMPANY = (Hashtable)session["COMPANY"];
            else
                COMPANY = new Hashtable();

            lastError = "";
            String uri = request.Url.ToString();
            String[] url = uri.Split('/');
            URLFILENAME = url[url.Length - 1].Substring(0, url[url.Length - 1].IndexOf('.'));
        }
        catch (Exception ex)
        {
            Notify("101", "Some error has been occured please contact to Admin", ex);
        }
    }

    public void Notify(String errorNO, String message, Exception ex)
    {
        response.Write("<div class='alert alert-danger'><a class='close' data-dismiss='alert' style='float:right; cursor:default; font-weight:bold'>X</a>  <h4>Warning : </h4>Error No:" + errorNO + " : " + message + " (Exception:- " + ex.ToString() + " <br><br></div>");
        lastError = ex.ToString();
    }

    public string WhereMD5(string columnName)
    {
        return " convert(varchar(100),HASHBYTES('md5',CONVERT(varchar(100)," + columnName + ")),2) ";
    }

    public void Message(String arg)
    {
        response.Write("<div class='alert alert-info'><a class='close' data-dismiss='alert' style='float:right; cursor:default; font-weight:bold'>x</a> " + arg + "</div>");
    }

    public void Error(String arg)
    {
        response.Write("<div class='alert alert-danger' style='margin:0px;'><a class='close' data-dismiss='alert' style='float:right; cursor:default; font-weight:bold'>x</a>  " + arg + "</div>");
    }

    public void ValidationError(InputValidator validate)
    {
        Hashtable errors = validate.GetErrors();
        foreach (string err in errors.Values)
            Error("Validation Error: " + err);
    }

    public void InvalidUrl()
    {
        response.Redirect("error500.aspx");
    }

    public String GetMin(String column, String tableName, String whereClause)
    {
        obj = null;
        try
        {
            query = "select min(" + column + ") from " + tableName;
            whereClause = whereClause == "" ? null : whereClause;
            query += whereClause != null ? " where " + whereClause : "";
            cmd = new SqlCommand(query, con);
            reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                if (reader[0] != DBNull.Value)
                    obj = reader[0].ToString();
            }
            reader.Close();
        }
        catch (Exception ex)
        {
            Notify("102", "Some error has been occured please contact to Admin", ex);
        }
        return obj;
    }

    public String GetMax(String column, String tableName, String whereClause)
    {
        obj = null;
        try
        {
            query = "select max(" + column + ") from " + tableName;
            whereClause = whereClause == "" ? null : whereClause;
            query += whereClause != null ? " where " + whereClause : "";
            cmd = new SqlCommand(query, con);
            reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                if (reader[0] != DBNull.Value)
                    obj = reader[0].ToString();
            }
            reader.Close();
        }
        catch (Exception ex)
        {
            Notify("103", "Some error has been occured please contact to Admin", ex);
        }
        return obj;
    } 

    public String GetSum(String column, String tableName, String whereClause)
    {
        obj = null; 
        try
        {
            query = "select isnull(sum(" + column + "),0) from " + tableName;
            whereClause = whereClause == "" ? null : whereClause;
            query += whereClause != null ? " where " + whereClause : "";
            cmd = new SqlCommand(query, con);
            reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                if (reader[0] != DBNull.Value)
                    obj = reader[0].ToString();
            }
            reader.Close();
        }
        catch (Exception ex)
        {
            Notify("104", "Some error has been occured please contact to Admin", ex);
        }
        return obj;
    }

    public virtual String GetCount(String column, String tableName, String whereClause)
    {
        obj = null;
        try
        {
            query = "select count(" + column + ") from " + tableName;
            whereClause = whereClause == "" ? null : whereClause;
            query += whereClause != null ? " where " + whereClause : "";
            cmd = new SqlCommand(query, con);
            reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                if (reader[0] != DBNull.Value)
                    obj = reader[0].ToString();
            }
            reader.Close();
        }
        catch (Exception ex)
        {
            Notify("104", "Some error has been occured please contact to Admin", ex);
        }
        return obj;
    }

    public String GetAVG(String column, String tableName, String whereClause)
    {
        obj = null;
        try
        {
            query = "select avg(" + column + ") from " + tableName;
            whereClause = whereClause == "" ? null : whereClause;
            query += whereClause != null ? " where " + whereClause : "";
            cmd = new SqlCommand(query, con);
            reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                if (reader[0] != DBNull.Value)
                    obj = reader[0].ToString();
            }
            reader.Close();
        }
        catch (Exception ex)
        {
            Notify("104", "Some error has been occured please contact to Admin", ex);
        }
        return obj;
    }

    public long Insert(String tableName, Hashtable values)
    {
        long lastInsertedId = 0;
        try
        {
            String colNames = "";
            String dataValues = "";
            foreach (String key in values.Keys)
            {
                String k = key.Trim();
                string val = "";
                if (values[k] == null)
                    val = null;
                else if (values[k].GetType() == typeof(DateTime))
                    val = ((DateTime)values[k]).ToString("yyyy-MM-dd HH:mm:ss");
                else
                    val = Convert.ToString(values[k]).Replace("'", "''").Trim();
                colNames += k + ",";

                if (val == null)
                    dataValues += "null,";
                else
                    dataValues += "'" + val + "',";
            }
            colNames = colNames.Substring(0, colNames.Length - 1);
            dataValues = dataValues.Substring(0, dataValues.Length - 1);
            query = "insert into " + tableName + "(" + colNames + ") values (" + dataValues + "); select SCOPE_IDENTITY();";
            cmd = new SqlCommand(query, con);
            lastInsertedId = Convert.ToInt64(cmd.ExecuteScalar());
        }
        catch (Exception ex)
        {
            Notify("105", "Some error has been occured please contact to Admin", ex);
        }
        return lastInsertedId;
    }

    public int Update(String tableName, Hashtable values, String whereClause)
    {
        int totalUpdated = 0;
        try
        {
            String colNames = "";
            foreach (String key in values.Keys)
            {
                String k = key.Trim();
                string val = "";
                if (values[k] == null)
                    val = null;
                else if (values[k].GetType() == typeof(DateTime))
                    val = ((DateTime)values[k]).ToString("yyyy-MM-dd HH:mm:ss");
                else
                    val = Convert.ToString(values[k]).Replace("'", "''").Trim();

                if (val == null)
                    colNames += k + "=null,";
                else
                    colNames += k + "='" + val + "',";
            }
            colNames = colNames.Substring(0, colNames.Length - 1);
            query = "update " + tableName + " set " + colNames;
            whereClause = whereClause == "" ? null : whereClause;
            query += whereClause != null ? " where " + whereClause : "";
            cmd = new SqlCommand(query, con);
            totalUpdated = cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            Notify("106", "Some error has been occured please contact to Admin", ex);
        }
        return totalUpdated;
    }

    public int Delete(String tableName, String whereClause)
    {
        query = "delete from " + tableName + " where " + whereClause;
        int res = 0;
        try
        {
            cmd = new SqlCommand(query, con);
            res = cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            if (ex.ToString().Contains("The DELETE statement conflicted with the REFERENCE constraint"))
            {
                Error("Error 117:- Child record exist. First delete or update all existing records with this data.");
            }
            else
            {
                Notify("117", "Some error has been occured please contact to Admin", ex);
            }
        }
        return res;
    }

    public object ExecuteFunction(String functionName, Hashtable values)
    {
        Object returnValue = null;
        String colNames = "";
        try
        {
            foreach (String key in values.Keys)
            {
                String k = key.Trim();
                string val = "";
                if (values[k] == null)
                    val = null;
                else if (values[k].GetType() == typeof(DateTime))
                    val = ((DateTime)values[k]).ToString("yyyy-MM-dd HH:mm:ss");
                else
                    val = Convert.ToString(values[k]).Replace("'", "''").Trim();
                if (val == null)
                    colNames += "null,";
                else
                    colNames += "'" + val + "',";
            }
            colNames = colNames.Substring(0, colNames.Length - 1);
            query = "select " + functionName + "(" + colNames + ")";
            cmd = new SqlCommand(query, con);

            returnValue = cmd.ExecuteScalar();
        }
        catch (Exception ex)
        {
            Notify("109", "Some error has been occured please contact to Admin", ex);
        }
        return returnValue;
    }

    public long ExecuteInsertStoredProcedure(String StoredPrcName, Hashtable values)
    {
        long return_value = 0;
        using (SqlCommand cmd = new SqlCommand(StoredPrcName, con))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            foreach (String key in values.Keys)
            {
                String k = key.Trim();
                cmd.Parameters.AddWithValue("@" + k, values[k]);
            }
            if (con.State == ConnectionState.Closed)
                con.Open();
            return_value = Convert.ToInt64(cmd.ExecuteScalar());
        }
        return return_value;
    }

    public int ExecuteUpdateStoredProcedure(String StoredPrcName, Hashtable values)
    {
        int return_value = 0;
        using (SqlCommand cmd = new SqlCommand(StoredPrcName, con))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            foreach (String key in values.Keys)
            {
                String k = key.Trim();
                cmd.Parameters.AddWithValue("@" + k, values[k]);
            }
            if (con.State == ConnectionState.Closed)
                con.Open();
            return_value = cmd.ExecuteNonQuery();
        }
        return return_value;
    }

    public int ExecuteBatchCommand(string commands)
    {
        this.query = commands;
        int rowsUpdated = 0;
        try
        {
            SqlCommand batchCmd = new SqlCommand(query, con);
            rowsUpdated = batchCmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            Notify("113", "Some error has been occured please contact to Admin", ex);
        }
        return rowsUpdated;
    }

    public bool TableExists(String tableName)
    {
        bool res = false;
        try
        {
            int count = Convert.ToInt32(GetCount("*", "INFORMATION_SCHEMA.TABLES", "TABLE_TYPE='BASE TABLE'  and TABLE_NAME='" + tableName + "'"));
            if (count > 0)
                res = true;
        }
        catch (Exception ex)
        {
            Notify("107", "Some error has been occured please contact to Admin", ex);
        }
        return res;
    }

    public virtual int Delete(String tableName)
    {
        query = "delete from " + tableName + " where convert(varchar(100),HASHBYTES('md5',CONVERT(varchar(100),id)),2)='" + request["del_id"] + "'";
        int res = 0;
        try
        {
            cmd = new SqlCommand(query, con);
            res = cmd.ExecuteNonQuery();
        }
        catch (Exception ex)
        {
            if (ex.ToString().Contains("The DELETE statement conflicted with the REFERENCE constraint"))
            {
                Error("Error 108:- Child record exist. First delete or update all existing records with this data.");
            }
            else
            {
                Notify("108", "Some error has been occured please contact to Admin", ex);
            }
        }
        return res;
    }

    public virtual int Delete(String tableName, int delete_type)
    {
        if (delete_type == 1)
            query = "delete from " + tableName + " where convert(varchar(100),HASHBYTES('md5',CONVERT(varchar(100),id)),2)='" + request["del_id"] + "'";
        else if (delete_type == 2)
            query = "update " + tableName + " set status=0 where convert(varchar(100),HASHBYTES('md5',CONVERT(varchar(100),id)),2)='" + request["del_id"] + "'";
        else
            query = "";
        int res = 0;
        try
        {
            if (query != "")
            {
                cmd = new SqlCommand(query, con);
                res = cmd.ExecuteNonQuery();
            }
        }
        catch (Exception ex)
        {
            if (ex.ToString().Contains("The DELETE statement conflicted with the REFERENCE constraint"))
            {
                Error("Error 108:- Child record exist. First delete or update all existing records with this data.");
            }
            else
            {
                Notify("108", "Some error has been occured please contact to Admin", ex);
            }
        }
        return res;
    }

    public SqlDataReader GetDataReader(String qry)
    {
        query = qry;
        SqlCommand sCmd = new SqlCommand(qry, con);
        sCmd.CommandTimeout = 0;
        SqlDataReader rdr = null;
        try
        {
            rdr = sCmd.ExecuteReader();
        }
        catch (Exception ex)
        {
            Notify("109", "Some error has been occured please contact to Admin", ex);
        }
        return rdr;
    }

    public String MD5(String str)
    {
        MD5CryptoServiceProvider md = new MD5CryptoServiceProvider();
        UTF8Encoding encoder = new UTF8Encoding();
        byte[] hashbytes = md.ComputeHash(encoder.GetBytes(str));
        StringBuilder builder = new StringBuilder();
        foreach (byte b in hashbytes)
        {
            builder.Append(b.ToString("x2"));
        }
        return builder.ToString();
    }

    public String GetLastError()
    {
        return lastError;
    }

    public String GetLastQuery()
    {
        return query;
    }

    protected void CheckUrl(String tableName)
    {
        try
        {
            lastError = "";
            TempRs = new Dictionary<String, String>(StringComparer.InvariantCultureIgnoreCase);
            String parameter = request.QueryString.ToString();
            if (parameter.Trim().Length > 0)
            {
                String[] param = parameter.Split('=');
                if (param[0] != ("uid"))
                {
                    InvalidUrl();
                }
                if ((request["wid"] != "c81e728d9d4c2f636f067f89cc14862c") && (request["wid"] != "eccbc87e4b5ce2fe28308fd9f2a7baf3"))
                {
                    InvalidUrl();
                }
                else
                {
                    if (request["wid"] == "c81e728d9d4c2f636f067f89cc14862c")
                    {
                        ButtonOperation = "Edit";
                        ButtonOperation2 = "Update";
                    }
                    if (request["wid"] == "eccbc87e4b5ce2fe28308fd9f2a7baf3")
                    {
                        ButtonOperation = "View";
                        ButtonOperation2 = "Back";
                        diasableit = " disabled readonly style='border:none; background:#FFFFFF; outline-style:none;box-shadow:none;color:#000;resize:none'";
                    }

                    String sid = request["uid"];
                    String where = "convert(varchar(100),HASHBYTES('md5',CONVERT(varchar(100),id)),2)='" + sid + "'";
                    SqlDataReader rs = GetRows(tableName, where);
                    int cols = rs.FieldCount;
                    if (rs.Read())
                    {
                        for (int i = 0; i < cols; i++)
                        {
                            if (rs[i] != DBNull.Value)
                                TempRs.Add(rs.GetName(i), rs[i].ToString());
                            else
                                TempRs.Add(rs.GetName(i), "");
                        }
                    }
                    rs.Close();
                }
            }
            else
            {
                ButtonOperation = "New";
                ButtonOperation2 = "Add";
                String where = "id=0";
                SqlDataReader rs = GetRows(tableName, where);
                int cols = rs.FieldCount;
                for (int i = 0; i < cols; i++)
                    TempRs.Add(rs.GetName(i), "");
                rs.Close();
            }
        }
        catch (Exception ex)
        {
            Notify("112", "Some error has been occured please contact to Admin", ex);
        }
    }

    protected void CheckUrl(String tableName, String id)
    {
        try
        {
            lastError = "";
            TempRs = new Dictionary<String, String>(StringComparer.InvariantCultureIgnoreCase);
            ButtonOperation = "New";
            ButtonOperation2 = "Add";
            String where = "id=" + id;
            SqlDataReader rs = GetRows(tableName, where);
            int cols = rs.FieldCount;
            if (rs.Read())
            {
                for (int i = 0; i < cols; i++)
                {
                    if (rs[i] != DBNull.Value)
                        TempRs.Add(rs.GetName(i), rs[i].ToString());
                    else
                        TempRs.Add(rs.GetName(i), "");
                }
            }
            rs.Close();
        }
        catch (Exception ex)
        {
            Notify("112", "Some error has been occured please contact to Admin", ex);
        }
    }

    public SqlDataReader GetRows(String tableName, String whereClause)
    {
        SqlDataReader rs = null;
        lastError = "";
        try
        {
            query = "select * from " + tableName + " where " + whereClause;
            rs = new SqlCommand(query, con).ExecuteReader();
        }
        catch (Exception ex)
        {
            Notify("111", "Some error has been occured please contact to Admin", ex);
        }
        return rs;
    }

    /*
     * GetText() is used for returning single field value
     * tableName= Table Name
     * returnField= Name of the whose value is to be returned
     * where = Where Clause
     * */
    public String GetText(string tableName, string returnField, string where)
    {
        string value = null;
        query = "select " + returnField + " from " + tableName + " where " + where;
        SqlDataReader rdr = GetDataReader(query);
        if (rdr != null)
        {
            if (rdr.Read())
            {
                if (rdr[0] != DBNull.Value)
                    value = rdr[0].ToString();
            }
        }
        return value;
    }

    /*
     * GetText() is used for returning single field value
     * sqlQuery= Full Sql Query
     * It will return value of at row index=0 ,column index=0
     * */

    public String GetText(string sqlQuery)
    {
        string value = null;
        query = sqlQuery;
        SqlDataReader rdr = GetDataReader(query);
        if (rdr != null)
        {
            if (rdr.Read())
            {
                if (rdr[0] != DBNull.Value)
                    value = rdr[0].ToString();
            }
        }
        return value;
    }

    /*
     * GetRecords() is used for returning value of single row
     * Return Value is Type of Hashtable where value can be accessed by using
     * sqlQuery= Full Sql Query
     * It will return values of at row index=0
     * */

    public Hashtable GetRecords(string sqlQuery)
    {
        Hashtable value = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
        query = sqlQuery;
        SqlDataReader rdr = GetDataReader(query);
        try
        {
            if (rdr != null)
            {
                if (rdr.Read())
                {
                    for (int i = 0; i < rdr.FieldCount; i++)
                    {
                        value.Add(rdr.GetName(i), rdr[i]);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Notify("115", "Some error has been occured please contact to Admin", ex);
        }
        return value;
    }
    /*
     * GetRecords() is used for returning value of single row
     * Return Value is Type of Hashtable where value can be accessed by using
     * field name as key
     * tableName= Table Name
     * columns= Name of the whose value is to be returned
     * where = Where Clause
     */
    public Hashtable GetRecords(string tableName, string columns, string where)
    {
        Hashtable value = new Hashtable(StringComparer.InvariantCultureIgnoreCase);
        query = "select " + columns + " from " + tableName + " where " + where;
        SqlDataReader rdr = GetDataReader(query);
        try
        {
            if (rdr != null)
            {
                if (rdr.Read())
                {
                    for (int i = 0; i < rdr.FieldCount; i++)
                    {
                        value.Add(rdr.GetName(i), rdr[i]);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Notify("114", "Some error has been occured please contact to Admin", ex);
        }
        return value;
    }

    public virtual String GetDataList(String tableName, String viewName, String columns, String whereClaues, String orderBy, int edit, int view, int delete, String editBtnText, String viewBtnText, String dltBtnText, string alter_page, string view_page, string pagination_target, int limit, int pagination=1)
    {
        lastError = "";
        pagination = 0;

        int start = 0;
        if (request["page"] != null)
        {
            int page = Convert.ToInt32(request["page"]);
            start = (page - 1) * limit;
        }
        String returnTable = "<table class='table table-bordered' id='bootstarp-table'>\n<thead>\n";
        try
        {
            if (request["lst_delete"] != null)
                Delete(tableName, delete); //delete =1 then Delete 
            //delete=2 then update status=0
            //delete=3 then deactivate related details=0
            String viewfile = view_page, editfile = alter_page;

            editBtnText = editBtnText == null ? "Edit" : editBtnText;
            viewBtnText = viewBtnText == null ? "View" : viewBtnText;
            dltBtnText = dltBtnText == null ? "Delete" : dltBtnText;

            int add = 1;

            String[] pName = URLFILENAME.Split('_');

            if (file_permission == 1)
            {
                query = "select * from view_systemfilelist where company_id='" + COMPANY["id"] + "' and file_name='" + URLFILENAME + "' and roles_id='" + ROLESTYPE + "' "; // Need to modify query if working with user type also in constructor
                SqlDataReader dr = new SqlCommand(query, con).ExecuteReader();
                if (dr.Read())
                {
                    add = (int)dr["can_add"];
                    edit = edit == 0 ? edit : (int)dr["can_edit"];
                    view = view == 0 ? view : (int)dr["can_view"];
                    delete = delete == 0 ? delete : (int)dr["can_delete"];
                    viewfile = (String)dr["view_file"];
                    editfile = (String)dr["edit_file"];
                    editBtnText = (String)dr["edit_button"];
                    viewBtnText = (String)dr["view_button"];
                    dltBtnText = (String)dr["delete_button"];
                }
                dr.Close();
            }

            if (whereClaues != null)
            {
                whereClaues = whereClaues.Trim().Length == 0 ? null : whereClaues;
            }
            if (orderBy != null)
            {
                orderBy = orderBy.Trim().Length == 0 ? null : orderBy;
            }
            query = "select " + columns + " from " + viewName;
            if (whereClaues != null)
            {
                query += " where " + whereClaues;
            }
            if (orderBy != null)
            {
                query += " order by " + orderBy;
            }
            else
            {
                query += " order by id asc ";
            }

            if(pagination==1)
                query += " offset " + start + " ROWS FETCH NEXT " + limit + " ROWS ONLY";
            SqlDataReader rs = new SqlCommand(query, con).ExecuteReader();

            int cols = rs.FieldCount;

            returnTable += "<tr>\n";
            returnTable += "<th>#</th>\n";
            String[] colArr = new String[cols];
            for (int i = 1; i < cols; i++)
            {
                colArr[i] = rs.GetName(i);
                returnTable += "<th>" + colArr[i] + "</th>\n";
            }

            if (edit == 1)
            {
                returnTable += "<th>"+editBtnText+"</th>\n";
            }
            if (view == 1)
            {
                returnTable += "<th>" + viewBtnText + "</th>\n";
            }
            if (delete > 0)
            {
                returnTable += "<th>" + dltBtnText + "</th>\n";
            }
            returnTable += "</tr>\n</thead><tbody>";
            int sl = start;
            while (rs.Read())
            {
                returnTable += "<tr>\n";
                returnTable += "<td>"+(++sl)+"</td>\n";
                String deleteDetails = "";

                for (int i = 1; i < cols; i++)
                {
                    String colName = colArr[i];
                    String val = rs[i] != DBNull.Value ? rs[i].ToString() : "";
                    returnTable += "<td>" + val + "</td>\n";

                    deleteDetails += "<div class='row'>";
                    deleteDetails += "<label class='col-sm-4'>" + colName + "</label>\n";
                    deleteDetails += "<div class='col-sm-8'>" + val + "</div>\n";
                    deleteDetails += "</div>\n";
                }
                if (edit == 1)
                {
                    returnTable += "<td><a href='" + editfile.Trim() + ".aspx?uid=" + MD5(rs[0].ToString()) + "&wid=c81e728d9d4c2f636f067f89cc14862c'>" + editBtnText + "</a></td>\n";
                }
                if (view == 1)
                {
                    returnTable += "<td><a href='" + viewfile.Trim() + ".aspx?uid=" + MD5(rs[0].ToString()) + "&wid=eccbc87e4b5ce2fe28308fd9f2a7baf3'>" + viewBtnText + "</a></td>\n";
                }
                if (delete > 0)
                {
                    returnTable += "<td width='40'><a href='#delModal" + rs[0].ToString() + "' data-toggle='modal'>" + dltBtnText + "</a>"
                           + "<!-- Modal -->"
                           + " <form method='post'>"
                             + "<input type='hidden' name='del_id' value='" + MD5(rs[0].ToString()) + "'>"
                                + "<div class='modal fade' id='delModal" + rs[0].ToString() + "' tabindex='-1' role='dialog' aria-labelledby='myModalLabel'>"
                                   + " <div class='modal-dialog' role='document'>"
                                      + "  <div class='modal-content'>"
                                        + "    <div class='modal-header'>"
                                          + "      <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
                                           + "     <h4 class='modal-title' id='myModalLabel'>Confirm Delete</h4>"
                                             + "</div>"
                                            + "<div class='modal-body'>"
                                               + deleteDetails
                                            + "</div>"
                                            + "<div class='modal-footer'>"
                                              + "  <button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>"
                                              + "  <input type='submit' name='lst_delete' value='Delete' class='btn btn-danger'/>"
                                           + " </div>"
                                        + "</div>"
                                    + "</div>"
                                + "</div>"
                            + "</form>"
                    + "</td>";
                }
                returnTable += "</tr>\n";
            }
            rs.Close();
            long total_records = Convert.ToInt64(GetCount("*", viewName, whereClaues));
            returnTable += "</tbody></table>" + (add == 1 ? "" : " <style>.disable-add {visibility:hidden}</style>");

            if (pagination == 1)
                returnTable += "</br>" + GetPagination(pagination_target, total_records, limit);
            else
                returnTable += "</br>";
        }
        catch (Exception ex)
        {
            Notify("110", "Some error has been occured please contact to Admin", ex);
        }
        return returnTable;
    }

    public virtual String GetPagination(string target_page, long total_records, int limit)
    {
        String pagination = "";
        int adjacents = 3;
        long page = 0, counter = 0;
        String targetPage = target_page;
        if (request["page"] != null)
        {
            page = Convert.ToInt32(request["page"]);
        }
        if (page == 0)
        {
            page = 1;
        }
        pagination = "";
        long prev = page - 1;
        long next = page + 1;
        long lastPage = (long)Math.Ceiling((double)total_records / limit);
        long lpm1 = lastPage - 1;
        if (lastPage > 1)
        {
            pagination += "<ul class='pagination'>";
            if (page > 1)
            {
                pagination += "<li><a href='" + targetPage + "?page=" + prev + "'>Previous</a></li>";
            }
            else
            {
                pagination += "<li class='disabled'><a>Previous</a></li>";
            }
            if (lastPage < 7 + (adjacents * 2))
            {
                for (counter = 1; counter <= lastPage; counter++)
                {
                    if (counter == page)
                    {
                        pagination += "<li class='active'><a>" + counter + "</a></li>";
                    }
                    else
                    {
                        pagination += "<li><a href='" + targetPage + "?page=" + counter + "'>" + counter + "</a></li>";
                    }
                }

            }
            else if ((lastPage - (adjacents * 2) > page) && (page > (adjacents * 2)))
            {
                pagination += "<li><a href='" + targetPage + "?page=1'>1</a></li>";
                pagination += "<li><a href='" + targetPage + "?page=2'>2</a></li>";
                pagination += "<li><a>...</a></li>";
                for (counter = page - adjacents; counter <= page + adjacents; counter++)
                {
                    if (counter == page)
                    {
                        pagination += "<li class='active'><a>" + counter + "</a></li>";
                    }
                    else
                    {
                        pagination += "<li><a href='" + targetPage + "?page=" + counter + "'>" + counter + "</a></li>";
                    }

                }
                pagination += "<li><a>...</a></li>";
                pagination += "<li><a href='" + targetPage + "?page=" + lpm1 + "'>" + lpm1 + "</a></li>";
                pagination += "<li><a href='" + targetPage + "?page=" + lastPage + "'>" + lastPage + "</a></li>";
            }
            else if (lastPage > 5 + (adjacents * 2))
            {
                if (page < 1 + (adjacents * 2))
                {
                    for (counter = 1; counter < 4 + (adjacents * 2); counter++)
                    {
                        if (counter == page)
                        {
                            pagination += "<li class='active'><a>" + counter + "</a></li>";
                        }
                        else
                        {
                            pagination += "<li><a href='" + targetPage + "?page=" + counter + "'>" + counter + "</a></li>";
                        }

                    }
                }
                pagination += "<li><a>...</a></li>";
                pagination += "<li><a href='" + targetPage + "?page=" + lpm1 + "'>" + lpm1 + "</a></li>";
                pagination += "<li><a href='" + targetPage + "?page=" + lastPage + "'>" + lastPage + "</a></li>";
            }
            else
            {
                pagination += "<li><a href='" + targetPage + "?page=1'>1</a></li>";
                pagination += "<li><a href='" + targetPage + "?page=2'>2</a></li>";
                pagination += "<li><a>...</a></li>";
                for (counter = lastPage - (2 + (adjacents * 2)); counter <= lastPage; counter++)
                {
                    if (counter == page)
                    {
                        pagination += "<li class='active'><a>" + counter + "</a></li>";
                    }
                    else
                    {
                        pagination += "<li><a href='" + targetPage + "?page=" + counter + "'>" + counter + "</a></li>";
                    }
                }
            }
            if (page < counter - 1)
            {
                pagination += "<li><a href='" + targetPage + "?page=" + next + "'>Next</a></li>";
            }
            else
            {
                pagination += "<li class='disabled'><a>Next</a></li>";
            }
            pagination += "</ul>\n";
        }
        return pagination;
    }

    public virtual String GetUIDPagination(String table, String whereCaluse, int page_limit)
    {
        String pagination = "";
        int limit = page_limit, adjacents = 3;
        long page = 0, counter = 0;
        long totalPages = Convert.ToInt64(GetCount("*", table, whereCaluse));
        String[] arr = request.Url.ToString().Split('/');
        String targetPage = arr[arr.Length - 1].Split('?')[0];
        string uid = request["uid"];
        string wid = request["wid"];
        targetPage += "?uid=" + uid + "&wid=" + wid;
        if (request["page"] != null)
        {
            page = Convert.ToInt32(request["page"]);
        }
        if (page == 0)
        {
            page = 1;
        }
        pagination = "";
        long prev = page - 1;
        long next = page + 1;
        long lastPage = (long)Math.Ceiling((double)totalPages / limit);
        long lpm1 = lastPage - 1;
        if (lastPage > 1)
        {
            pagination += "<ul class='pagination'>";
            if (page > 1)
            {
                pagination += "<li><a href='" + targetPage + "&page=" + prev + "'>Previous</a></li>";
            }
            else
            {
                pagination += "<li class='disabled'><a>Previous</a></li>";
            }
            if (lastPage < 7 + (adjacents * 2))
            {
                for (counter = 1; counter <= lastPage; counter++)
                {
                    if (counter == page)
                    {
                        pagination += "<li class='active'><a>" + counter + "</a></li>";
                    }
                    else
                    {
                        pagination += "<li><a href='" + targetPage + "&page=" + counter + "'>" + counter + "</a></li>";
                    }
                }

            }
            else if ((lastPage - (adjacents * 2) > page) && (page > (adjacents * 2)))
            {
                pagination += "<li><a href='" + targetPage + "&page=1'>1</a></li>";
                pagination += "<li><a href='" + targetPage + "&page=2'>2</a></li>";
                pagination += "<li><a>...</a></li>";
                for (counter = page - adjacents; counter <= page + adjacents; counter++)
                {
                    if (counter == page)
                    {
                        pagination += "<li class='active'><a>" + counter + "</a></li>";
                    }
                    else
                    {
                        pagination += "<li><a href='" + targetPage + "&page=" + counter + "'>" + counter + "</a></li>";
                    }

                }
                pagination += "<li><a>...</a></li>";
                pagination += "<li><a href='" + targetPage + "&page=" + lpm1 + "'>" + lpm1 + "</a></li>";
                pagination += "<li><a href='" + targetPage + "&page=" + lastPage + "'>" + lastPage + "</a></li>";
            }
            else if (lastPage > 5 + (adjacents * 2))
            {
                if (page < 1 + (adjacents * 2))
                {
                    for (counter = 1; counter < 4 + (adjacents * 2); counter++)
                    {
                        if (counter == page)
                        {
                            pagination += "<li class='active'><a>" + counter + "</a></li>";
                        }
                        else
                        {
                            pagination += "<li><a href='" + targetPage + "&page=" + counter + "'>" + counter + "</a></li>";
                        }

                    }
                }
                pagination += "<li><a>...</a></li>";
                pagination += "<li><a href='" + targetPage + "&page=" + lpm1 + "'>" + lpm1 + "</a></li>";
                pagination += "<li><a href='" + targetPage + "&page=" + lastPage + "'>" + lastPage + "</a></li>";
            }
            else
            {
                pagination += "<li><a href='" + targetPage + "&page=1'>1</a></li>";
                pagination += "<li><a href='" + targetPage + "&page=2'>2</a></li>";
                pagination += "<li><a>...</a></li>";
                for (counter = lastPage - (2 + (adjacents * 2)); counter <= lastPage; counter++)
                {
                    if (counter == page)
                    {
                        pagination += "<li class='active'><a>" + counter + "</a></li>";
                    }
                    else
                    {
                        pagination += "<li><a href='" + targetPage + "&page=" + counter + "'>" + counter + "</a></li>";
                    }
                }
            }
            if (page < counter - 1)
            {
                pagination += "<li><a href='" + targetPage + "&page=" + next + "'>Next</a></li>";
            }
            else
            {
                pagination += "<li class='disabled'><a>Next</a></li>";
            }
            pagination += "</ul>\n";
        }
        return pagination;
    }

    public long DateToInt(String dd_MM_yyyy)
    {
        TimeSpan t = StringToDate(dd_MM_yyyy) - EPOCH;
        return (long)t.TotalMilliseconds;
    }

    public DateTime IntToDate(object milliseconds)
    {
        long millsec = Convert.ToInt64(milliseconds);
        DateTime d = EPOCH.AddMilliseconds(millsec);
        return d;
    }
    public long CurrentTimeStampSec()
    {
        TimeSpan t = DateTime.Now - EPOCH;
        return (long)t.TotalSeconds;
    }

    public long CurrentTimeStampMilliSec()
    {
        TimeSpan t = DateTime.Now - EPOCH;
        return (long)t.TotalMilliseconds;
    }
    public String IntToDateStr(object milliseconds)
    {
        return IntToDate(milliseconds).ToString("dd-MM-yyyy");
    }

    public String SysDateStr()
    {
        return DateTime.Now.ToString("dd-MM-yyyy");
    }

    public String SysTimeStr()
    {
        return DateTime.Now.ToString("hh:mm tt");
    }

    public DateTime SysDate()
    {
        return DateTime.Now;
    }

    public DateTime StringToDate(String dd_MM_yyyy)
    {
        DateTime d = new DateTime();
        try
        {
            d = DateTime.ParseExact(dd_MM_yyyy, "dd-MM-yyyy", null);
        }
        catch (Exception ex)
        {
            Notify("111", "Invalid Date Format: Contact to admin", ex);
        }
        return d;
    }

    public int GetWeekDayInt(String dd_MM_yyyy)
    {
        return (int)StringToDate(dd_MM_yyyy).DayOfWeek;
    }

    public String WeekDayStr(String dd_MM_yyyy)
    {
        String[] days = new String[] { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };
        return days[(int)StringToDate(dd_MM_yyyy).DayOfWeek - 1];
    }

    public string ToTitleCase(string str)
    {
        TextInfo TT = CultureInfo.CurrentCulture.TextInfo;
        return TT.ToTitleCase(str);
    }

    public string GetCurrentFinancialYear()
    {
        DateTime date = DateTime.Now;
        if (date.Month <= 3)
        {
            return (date.Year - 1) + "-" + (date.Year);
        }
        else
        {
            return (date.Year) + "-" + (date.Year + 1);
        }
    }

    public DataTable GetDataTable(string sqlQuery)
    {
        DataTable dt = new DataTable();
        try
        {
            query = sqlQuery;
            SqlDataAdapter da = new SqlDataAdapter(query, con);
            da.SelectCommand.CommandTimeout = 600;
            da.Fill(dt);
        }
        catch (Exception ex)
        {
            Notify("118", "Some error has been occured please contact to Admin", ex);
        }
        return dt;
    }

    public string CreateRandomPassword(int PasswordLength)
    {
        string _allowedChars = "0123456789";
        Random randNum = new Random();
        char[] chars = new char[PasswordLength];
        int allowedCharCount = _allowedChars.Length;

        for (int i = 0; i < PasswordLength; i++)
        {
            chars[i] = _allowedChars[(int)((_allowedChars.Length) * randNum.NextDouble())];
        }

        return new string(chars);
    }

    //URL according to the Web Path
    public bool FileExists(string virtualPath)
    {
        bool flag = false;
        try
        {
            string abs_path = request.MapPath(virtualPath);
            flag = File.Exists(abs_path);
        }
        catch (Exception ex)
        {
            Notify("119", "Some error has been occured", ex);
        }
        return flag;
    }

    public bool UploadFile(string file_name, string key, int mb_limit, string[] content_type)
    {
        HttpPostedFile postFile = null;
        long limit = (mb_limit * 1024) * 1024;
        bool flag = false;
        bool content_flag = false;
        if (request.Files[key].ContentLength > 0 && request.Files[key] != null)
        {
            postFile = request.Files[key];

            for (int i = 0; i < content_type.Length; i++)
            {
                if (postFile.ContentType.ToLower() == content_type[i].ToString().ToLower())
                {
                    content_flag = true;
                }
            }

            if (content_flag == false)
            {
                Error("This file is not allowed.");
                return false;
            }

            if (postFile.ContentLength > limit)
            {
                Error("Only " + mb_limit + " MB of file size is allowed");
                return false;
            }
            try
            {
                postFile.SaveAs(file_name);
                flag = true;
            }
            catch (Exception ex)
            {
                Error("Unable to upload the file " + ex.ToString());
                return false;
            }
        }
        else
        {
            Error("No file uploaded");
            return false;
        }

        return flag;
    }

    public static void ExportData(DataTable table, string filename)
    {
        if (table != null)
        {
            if (table.Rows.Count > 0)
            {
                Export export = new Export("Web");
                export.ExportDetails(table, Export.ExportFormat.Excel, filename + ".xls");
            }
        }
    }

    public string sendSMS(string mobile_no, string msg)
    {
        string res_text="";
        try
        {
            string api_key = "258AA9B157A76D";
            string campaign="1";
            string routid="20";
            string type="text";
            string from = "IOTASL";
            string remoteUrl = "https://www.logonutility.in/app/smsapi/index.php";
            ASCIIEncoding encoding = new ASCIIEncoding();
            string data = string.Format("key={0}&campaign={1}&routeid={2}&type={3}&contacts={4}&senderid={5}&msg={6}", api_key, campaign, routid, type, mobile_no, from, msg);
            byte[] bytes = encoding.GetBytes(data);

            HttpWebRequest httpRequest = (HttpWebRequest)WebRequest.Create(remoteUrl);
            httpRequest.Method = "POST";
            httpRequest.ContentType = "application/x-www-form-urlencoded";
            httpRequest.ContentLength = bytes.Length;
            using (Stream stream = httpRequest.GetRequestStream())
            {
                stream.Write(bytes, 0, bytes.Length);
                stream.Close();
            }
            HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
            using (StreamReader resReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                 res_text = resReader.ReadToEnd();
            }
        }
        catch (Exception ex)
        {
            res_text = ex.ToString();
        }

        return res_text;
    }


    public int sendMail(string to, string subject, string body, string cc = null, string bcc = null, bool isBodyHTML = true, string attachedFileName = null)
    {
        try
        {
            MailMessage mailMessage = new MailMessage();
            mailMessage.To.Add(to);
            mailMessage.From = new MailAddress("ntsh.dns.programmer@gmail.com");
            if(!String.IsNullOrEmpty(cc))
                mailMessage.CC.Add(cc);
            if (!String.IsNullOrEmpty(bcc))
                mailMessage.Bcc.Add(bcc);
            mailMessage.Subject = subject;
            mailMessage.IsBodyHtml = isBodyHTML;
            mailMessage.Body = body;

            if (!String.IsNullOrEmpty(attachedFileName))
                mailMessage.Attachments.Add(new Attachment(attachedFileName));

            SmtpClient smtpClient = new SmtpClient();
            smtpClient.Host = "smtp.gmail.com";
            smtpClient.EnableSsl = true;
            NetworkCredential nc = new NetworkCredential("ntsh.dns.programmer@gmail.com", "P@ssw0rd9308380011");
            smtpClient.UseDefaultCredentials = false;
            smtpClient.Credentials = nc;
            smtpClient.Port = 587;
            smtpClient.Send(mailMessage);
            return 1;
        }
        catch (Exception ex)
        {
            Error("Could not send the e-mail - error: " + ex.Message);
        }
        return 0;
    }
}
