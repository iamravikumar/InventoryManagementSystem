using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for URLRewriter
/// </summary>
public class URLRewriter : IHttpModule
{
    #region IHttpModule Members
    public URLRewriter()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public void Dispose()
    {
        //throw new NotImplementedException();
    }

    public void Init(HttpApplication context)
    {
        context.BeginRequest += new EventHandler(context_BeginRequest);
    }

    void context_BeginRequest(object sender, EventArgs e)
    {

        //Create an instance of the application that has raised the event
        HttpApplication httpApplication = sender as HttpApplication;

        //Safety check for the variable httpApplication if it is not null
        if (httpApplication != null)
        {

            //get the request path - request path is    something you get in
            //the url
            string requestPath = httpApplication.Context.Request.Path;

            //variable for translation path
            string translationPath = "";

            //if the request path is /urlrewritetestingapp/laptops/dell/

            //it means the site is for DLL

            //else if "/urlrewritetestingapp/laptops/hp/"

            //it means the site is for HP

            //else it is the default path

            switch (requestPath.ToLower())
            {

                case "/inventory/admin/":

                    translationPath = "/inventory/admin/dashboard.aspx";

                    break;

                default:

                    translationPath = "/inventory/admin/dashboard.aspx";

                    break;

            }

            //use server transfer to transfer the request to the actual translated path
            httpApplication.Context.Server.Transfer(translationPath);

        }

    }

    #endregion
}