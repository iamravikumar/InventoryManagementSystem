using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Net;
using System.Threading;
using System.Collections.Specialized;
using System.Web.Configuration;
/// <summary>
/// Summary description for AdminCore
/// </summary>
public class AdminCore : ClassDB
{
    public AdminCore(HttpRequest request, HttpResponse response)
        : base(request, response)
    {
        //
        // TODO: Add constructor logic here
        //
    }

    public void Execute()
    {
        
    }
}