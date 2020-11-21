<%@ Page Language="C#" %>

<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Collections" %>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<% NameValueCollection setting = WebConfigurationManager.AppSettings;
   String SOURCE_ROOT = Request.ApplicationPath == "/" ? "" : Request.ApplicationPath;
   if (Session["USER"] == null)
   {
       //new SysLogin(Request, Response).LogOut();
       Session.Clear();
       Response.Redirect(SOURCE_ROOT + "/signing.aspx");
   }
   if (Request["logout"] != null)
   {
       //new SysLogin(Request, Response).LogOut();
       Session.Clear();
       Response.Redirect(SOURCE_ROOT + "/signing.aspx");
   }
   String ADMIN_ROOT = SOURCE_ROOT + "/admin/";
   AdminCore adminCore = new AdminCore(Request, Response);
%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><%=setting["title"] %> | Dashboard</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="<%=SOURCE_ROOT%>/bootstrap/css/bootstrap.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="<%=SOURCE_ROOT%>/plugins/select2/select2.min.css">
     <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="<%=SOURCE_ROOT%>/plugins/datepicker/datepicker3.css">
    <!-- bootstrap datatable -->
    <link rel="stylesheet" href="<%=SOURCE_ROOT%>/plugins/datatables/dataTables.bootstrap.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="<%=SOURCE_ROOT%>/dist/css/AdminLTE.css">
    <!-- AdminLTE Skins. We have chosen the skin-blue for this starter
        page. However, you can choose any other skin. Make sure you
        apply the skin class to the body tag so the changes take effect.
  -->
    <link rel="stylesheet" href="<%=SOURCE_ROOT%>/dist/css/skins/skin-yellow.min.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

    <!-- REQUIRED JS SCRIPTS -->

    <!-- jQuery 2.2.3 -->
    <script src="<%=SOURCE_ROOT%>/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="<%=SOURCE_ROOT%>/bootstrap/js/bootstrap.min.js"></script>
        <!-- AdminLTE App -->
    <script src="<%=SOURCE_ROOT%>/dist/js/app.min.js"></script>
    <script src="<%=SOURCE_ROOT%>/common/js/jquery.validate.js"></script>
    <!-- Select2 -->
    <script src="<%=SOURCE_ROOT%>/plugins/select2/select2.full.min.js"></script>
    

    <style>
        .form-control {
            border: 1px solid black;
            color: black;
        }
        .select2 {
            border: 1px solid black;
            color: black;
        }

        select.error {
            background-color: #ffa8a8;
            border: 1px dotted red;
            /*float: left;*/
        }

        input.error {
            background-color: #ffa8a8;
            border: 1px dotted red;
            /*float: left;*/
        }

        textarea.error {
            background-color: #ffa8a8;
            border: 1px dotted red;
            vertical-align: top;
            /*float: left;*/
        }

        /*.header {
            z-index: 9999;
        }*/

    </style>

    <script type="text/javascript">
        function addValidator() {
            $.validator.addMethod("alpha_with_space", function (value, element) {
                return this.optional(element) || /^[a-zA-Z\s]+$/i.test(value);
            }, "Only Alphabet or Space Allowed.");
            $.validator.addMethod("alpha_num_with_space", function (value, element) {
                return this.optional(element) || /^[a-zA-Z0-9 ]+$/i.test(value);
            }, "Only Alphabet, Number or Space Allowed.");
            $.validator.addMethod("alpha_no_space", function (value, element) {
                return this.optional(element) || /^[a-zA-Z][a-zA-Z\\s]+$/i.test(value);
            }, "No Space, Number or Extra Character Allowed.");
            $.validator.addMethod("alpha_num_no_space", function (value, element) {
                return this.optional(element) || /^[a-zA-Z0-9]+$/i.test(value);
            }, "Only Alphabet or Number Allowed.");
            $.validator.addMethod("user_name", function (value, element) {
                return this.optional(element) || /^[a-zA-Z0-9_.]+$/i.test(value);
            }, "Invalid Text");
            $.validator.addMethod("file_name", function (value, element) {
                return this.optional(element) || /^[a-zA-Z0-9_]+$/i.test(value);
            }, "Invalid Text");
            $.validator.addMethod("decimal", function (value, element) {
                return this.optional(element) || /^[0-9.]+$/i.test(value);
            }, "Only Decimal Value Allowed.");
            $.validator.addMethod("digit", function (value, element) {
                return this.optional(element) || /^[0-9]+$/i.test(value);
            }, "Only Digit Value Allowed.");
            $.validator.addMethod("date_slash", function (value, element) {
                return this.optional(element) || /^(((0[1-9]|[12]\d|3[01])\/(0[13578]|1[02])\/((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\/(0[13456789]|1[012])\/((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\/02\/((19|[2-9]\d)\d{2}))|(29\/02\/((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$/i.test(value);
            }, "Invalid Date (DD/MM/YYYY Allowed.)");
            $.validator.addMethod("date_hyphen", function (value, element) {
                return this.optional(element) || /^(((0[1-9]|[12]\d|3[01])\-(0[13578]|1[02])\-((19|[2-9]\d)\d{2}))|((0[1-9]|[12]\d|30)\-(0[13456789]|1[012])\-((19|[2-9]\d)\d{2}))|((0[1-9]|1\d|2[0-8])\-02\-((19|[2-9]\d)\d{2}))|(29\-02\-((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))))$/i.test(value);
            }, "Invalid Date (DD-MM-YYYY Allowed.)");
            $.validator.addMethod("mobile_no", function (value, element) {
                return this.optional(element) || /^[0-9]{10}$/i.test(value);
            }, "Invalid Mobile No.");
            $.validator.addMethod("email", function (value, element) {
                return this.optional(element) || /^((([\w]+\.[\w]+)+)|([\w]+))@(([\w]+\.)+)([A-Za-z]{1,3})$/i.test(value);
            }, "Invalid E-Mail ID");
        }


        function PopupCenter(url, title, w, h) {
            // Fixes dual-screen position                         Most browsers      Firefox  
            var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
            var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;

            width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
            height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

            var left = ((width / 2) - (w / 2)) + dualScreenLeft;
            var top = ((height / 2) - (h / 2)) + dualScreenTop;
            var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);

            // Puts focus on the newWindow  
            if (window.focus) {
                newWindow.focus();
            }
        }

    </script>

    <style>
        /* Paste this css to your style sheet file or under head tag */
        /* This only works with JavaScript, 
        if it's not present, don't show loader */
        .no-js #loader { display: none;  }
        .js #loader { display: block; position: absolute; left: 100px; top: 0; }
        .se-pre-con {
	        position: fixed;
	        left: 0px;
	        top: 0px;
	        width: 100%;
	        height: 100%;
	        z-index: 9999;
	        background: url(<%=SOURCE_ROOT%>/common/loader/loader-128x/Preloader_2.gif) center no-repeat #fff;
        }
    </style>

    
    <script>
        //paste this code under head tag or in a seperate js file.
        // Wait for window load
        $(window).load(function () {
            // Animate loader off screen
            $(".se-pre-con").fadeOut("slow");;
        });
    </script>

</head>
<!--
BODY TAG OPTIONS:
=================
Apply one or more of the following classes to get the
desired effect
|---------------------------------------------------------|
| SKINS         | skin-blue                               |
|               | skin-black                              |
|               | skin-purple                             |
|               | skin-yellow                             |
|               | skin-red                                |
|               | skin-green                              |
|---------------------------------------------------------|
|LAYOUT OPTIONS | fixed                                   |
|               | layout-boxed                            |
|               | layout-top-nav                          |
|               | sidebar-collapse                        |
|               | sidebar-mini                            |
|---------------------------------------------------------|
-->
<body class="hold-transition skin-yellow sidebar-mini">
    
<div class="se-pre-con"></div>

    <div class="wrapper">

        <!-- Main Header -->
        <header class="main-header">

            <!-- Logo -->
            <a href="#" class="logo">
                <!-- mini logo for sidebar mini 50x50 pixels -->
                <span class="logo-mini"><b><%=WebConfigurationManager.AppSettings["miniheading"] %></b></span>
                <!-- logo for regular state and mobile devices -->
                <span class="logo-lg"><b><%=WebConfigurationManager.AppSettings["heading"] %></b></span>
            </a>

            <!-- Header Navbar -->
            <nav class="navbar navbar-static-top" role="navigation">
                <!-- Sidebar toggle button-->
                <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
                    <span class="sr-only">Toggle navigation</span>
                </a>
                <!-- Navbar Right Menu -->
                <div class="navbar-custom-menu">
                    <ul class="nav navbar-nav">
                        <!-- User Account Menu -->
                        <li class="dropdown user user-menu">
                            <!-- Menu Toggle Button -->
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <!-- The user image in the navbar-->
                                <img src="<%=SOURCE_ROOT%>/dist/img/user_e.png" class="user-image" alt="User Image">
                                <!-- hidden-xs hides the username on small devices so only the image appears. -->
                                <span class="hidden-xs"><%=adminCore.USER["user_name"].ToString().ToUpper() %></span>
                            </a>
                            <ul class="dropdown-menu">
                                <!-- The user image in the menu -->
                                <li class="user-header">
                                    <img src="<%=SOURCE_ROOT%>/dist/img/user_e.png" class="img-circle" alt="User Image">
                                    <p>
                                        <%=adminCore.USER["user_name"].ToString().ToUpper() %>
                                    </p>
                                </li>

                                <!-- Menu Footer-->
                                <li class="user-footer">
                                    <div class="pull-left">
                                        <a href="<%=ADMIN_ROOT%>dashboard.aspx" class="btn btn-default btn-flat">Home</a>
                                    </div>
                                    <div class="pull-right">
                                        <a href="?logout=true" class="btn btn-default btn-flat" id="logoutanchor">Sign out</a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </nav>
        </header>
        <!-- Left side column. contains the logo and sidebar -->
        <aside class="main-sidebar">

            <!-- sidebar: style can be found in sidebar.less -->
            <section class="sidebar">

                <!-- search form (Optional) -->
                <form method="post" class="sidebar-form">
                    <div class="input-group">
                        <input type="text" name="txt_header_search" class="form-control" placeholder="Search...">
                        <span class="input-group-btn">
                            <button type="submit" name="btn_header_search" id="search-btn" class="btn btn-flat">
                                <i class="fa fa-search"></i>
                            </button>
                        </span>
                    </div>
                </form>
                <!-- /.search form -->

                <!-- Sidebar Menu -->
                <ul class="sidebar-menu">
                    <li><a href="<%=ADMIN_ROOT%>dashboard.aspx"><i class="fa fa-dashboard"></i><span>Dashboard</span></a></li>

                    <!-- Inventory based menu start-->
                    <li class="treeview">
                        <a href="#"><i class="fa fa-gear"></i><span>Master Setting</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="<%=ADMIN_ROOT%>master/company_alter.aspx">Company Setting</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/fy_list.aspx?cmd=Clear">Financial Year</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/voucherset_list.aspx?cmd=Clear">Invoice Setup</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/ledger_list.aspx?cmd=Clear">Ledger</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/store_list.aspx?cmd=Clear">Store (F2)</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/qtytype_list.aspx?cmd=Clear">Unit Master (F3)</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/stockgrp_list.aspx?cmd=Clear">Stock Group</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/item_list.aspx?cmd=Clear">Item Entry (F1)</a></li>
                            <li><a href="<%=ADMIN_ROOT%>master/itemqty_list.aspx?cmd=Clear">Measurments of Items (F5)</a></li>
                        </ul>
                    </li>

                    <li><a href="<%=ADMIN_ROOT%>transaction/purchase_list.aspx?cmd=Clear"><i class="fa fa-shopping-basket"></i><span>Purchase Order</span></a></li>
                    
                    <li><a href="<%=ADMIN_ROOT%>transaction/purvoucher_list.aspx?cmd=Clear"><i class="fa fa-shopping-cart"></i><span>Purchase</span></a></li>

                    <li><a href="<%=ADMIN_ROOT%>transaction/salevoucher_list.aspx?cmd=Clear"><i class="fa fa-shopping-cart"></i><span>Sale</span></a></li>

                    <li><a href="<%=ADMIN_ROOT%>transaction/purchaseret_list.aspx?cmd=Clear"><i class="fa fa-shopping-cart"></i><span>Purchase Return</span></a></li>

                    <li><a href="<%=ADMIN_ROOT%>transaction/saleret_list.aspx?cmd=Clear"><i class="fa fa-shopping-cart"></i><span>Sale Return</span></a></li>

                    <li><a href="<%=ADMIN_ROOT%>transaction/payment.aspx"><i class="fa fa-money"></i><span>Payment</span></a></li>
                   <%-- 
                    <li><a href="<%=ADMIN_ROOT%>transaction/payment.aspx"><i class="fa fa-exchange"></i><span>Stock Transfer*</span></a></li>
                    
                    <li><a href="<%=ADMIN_ROOT%>transaction/scheme_list.aspx?cmd=Clear"><i class="fa fa-gear"></i><span>Scheme Setting*</span></a></li>--%>

                    <li class="treeview">
                        <a href="#"><i class="fa fa-bar-chart"></i><span>Report</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="<%=ADMIN_ROOT%>reports/pur_rpt.aspx?cmd=Clear">Purchase</a></li>
                            <li><a href="<%=ADMIN_ROOT%>reports/sale_rpt.aspx?cmd=Clear">Sale</a></li>
                            <li><a href="<%=ADMIN_ROOT%>reports/purret_rpt.aspx?cmd=Clear">Purchase Return</a></li>
                            <li><a href="<%=ADMIN_ROOT%>reports/saleret_rpt.aspx?cmd=Clear">Sale Return</a></li>
                            <li><a href="<%=ADMIN_ROOT%>reports/daybook_rpt.aspx?cmd=Clear">Daybook</a></li>
                            <li><a href="<%=ADMIN_ROOT%>reports/ledgerdues_rpt.aspx?cmd=Clear">Existing Dues</a></li>
                            <li><a href="<%=ADMIN_ROOT%>reports/stock_rpt.aspx?cmd=Clear"">Stock Register</a></li>
                            <li><a href="<%=ADMIN_ROOT%>reports/stock_rpt.aspx?cmd=Clear"">Payment & Dues</a></li>
                        </ul>
                    </li>
                    <!-- Inventory based menu end-->

                    <li><a href="<%=ADMIN_ROOT%>change_password.aspx"><i class="fa fa-link"></i><span>Change Password</span></a></li>
                </ul>
                <!-- /.sidebar-menu -->
            </section>
            <!-- /.sidebar -->
        </aside>
