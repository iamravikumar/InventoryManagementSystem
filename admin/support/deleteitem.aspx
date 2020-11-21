<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<%
    DataTable dtItem = (DataTable)Session["dtItem"];
    int row_id = Convert.ToInt32(Request["row_id"].ToString());
    dtItem.Rows.RemoveAt(row_id);  
%>