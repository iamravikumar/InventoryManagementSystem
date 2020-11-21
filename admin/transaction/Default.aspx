<!-- #include file="../../header.aspx"-->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
        <h1>
            <%=setting["title"]%>
            <small><%=setting["version"]%></small>
        </h1>
        <ol class="breadcrumb">
            <li><a href="<%=ADMIN_ROOT%>dashboard.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
            <li class="active">Error 404</li>
        </ol>
    </section>

    <%
          string where_dashboard="";
    %>

    <!-- Main content -->
    <!-- Main content -->
    <section class="content">
        <div class="error-page">
            <h2 class="headline text-yellow">404</h2>

            <div class="error-content">
                <h3><i class="fa fa-warning text-yellow"></i>Oops! Page not found.</h3>

                <p>
                    We could not find the page you were looking for.
            Meanwhile, you may <a href="<%=ADMIN_ROOT%>dashboard.aspx">return to dashboard</a> or try using the search form.
                </p>


                <form class="search-form">
                    <div class="input-group">
                        <div class="col-xs-12" style="background-color:white; padding:10px;">
                            <!-- To the right -->
                            <!-- Default to the left -->
                            <strong>Powered By <a href="http://www.iotasonl.com/" target="_blank"><%=WebConfigurationManager.AppSettings["footer"]%></a></strong>
                        </div>
                    </div>
                    <!-- /.input-group -->
                </form>
            </div>
            <!-- /.error-content -->
        </div>
        <!-- /.error-page -->
    </section>
    <!-- /.content -->
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->


<!-- #include file="../../footer.aspx" -->
