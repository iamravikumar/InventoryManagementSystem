<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>

<%
    ClassDB db = new ClassDB(Request, Response);
    try
    {
        string table = Crypto.Decrypt(Request["table"]);
        string value = Crypto.Decrypt(Request["value"]);
        string text = Crypto.Decrypt(Request["text"]);
        string where = Request["where"] == null ? null : Crypto.Decrypt(Request["where"]);
        string whereArgs = Request["whereArgs"] == null ? null : Request["whereArgs"];
        if (whereArgs != null)
        {
            string[] whereArgArr = whereArgs.Split(',');
            int i = 0;
            foreach (string argsarr in whereArgArr)
            {
                where = where.Replace(i+"?", argsarr);
                i++;
            }
        }
        string groupby = Request["groupby"] == null ? null : Crypto.Decrypt(Request["groupby"]);
        string having = Request["having"] == null ? null : Crypto.Decrypt(Request["having"]);
        string orderby = Request["orderby"] == null ? null : Crypto.Decrypt(Request["orderby"]);

        String query = "select " + value + "," + text + " from " + table + " where company_id='" + db.COMPANY["id"] + "' and ";
        query = where == null ? query + "1=1" : query + where;
        query = groupby == null ? query : query + " group by " + groupby;
        query = having == null ? query : query + " having " + having;
        query = orderby == null ? query : query + " order by " + orderby;

        string json_string = "{";
       
        SqlDataReader rdr = db.GetDataReader(query);
        while (rdr.Read())
        {
            json_string += " \"" + rdr[0].ToString() + "\":\"" + rdr[1].ToString() + "\",";
        }
        rdr.Close();
        json_string = json_string.Substring(0, json_string.Length - 1);
        json_string += "}";

        Response.Clear();
        Response.ContentType = "application/json;charset=UTF-8";
        Response.Write(json_string);
    }
    catch (Exception ex)
    {
        StreamWriter sw=new StreamWriter(@"E:\log.txt");
        sw.WriteLine(ex.ToString() + db.GetLastQuery());
        sw.Close();
    }
        //Response.End();

%>