<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><%=WebConfigurationManager.AppSettings["title"] %> | Log in</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css">
    <!-- Style ample -->
    <link rel="stylesheet" href="common/css/style.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/AdminLTE.min.css">
    <!-- iCheck -->
    <link rel="stylesheet" href="plugins/iCheck/square/blue.css">

    <!-- jQuery 2.2.3 -->
    <script src="plugins/jQuery/jquery-2.2.3.min.js"></script>
    <script src="common/js/jquery.validate.js"></script>


    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

    <script>
        function loginprocess() {
            var u = document.getElementById("user_name").value;
            var p = document.getElementById("password").value;
            if (u.length > 0 && p.length > 0) {
                $("#login").val("Validating...");
            }
            else if (u.length <= 0) {
                alert("User Name is Mandatory.");
                return;
            }
            else if (p.length <= 0) {
                alert("Password is Mandatory.");
                return;
            }
            else {
                alert("Invalid Login.");
                return;
            }
        }
    </script>
    
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
	        background: url(common/loader/loader-128x/Preloader_2.gif) center no-repeat #fff;
        }
    </style>

    
    <script src="common/js/jquery.min.js"></script>
<script src="common/js/modernizr.js"></script>

    <script>
        //paste this code under head tag or in a seperate js file.
        // Wait for window load
        $(window).load(function () {
            // Animate loader off screen
            $(".se-pre-con").fadeOut("slow");
        });
    </script>

    <style>
        h1 {
            font-family: "Avant Garde", Avantgarde, "Century Gothic", CenturyGothic, "AppleGothic", sans-serif;
            font-size: 30px;
            padding: 10px 10px;
            text-align: center;
            text-transform: uppercase;
            text-rendering: optimizeLegibility;
        }

            h1.elegantshadow {
                color: #131313;
                letter-spacing: .15em;
                text-shadow: 1px -1px 0 #767676, -1px 2px 1px #737272, -2px 4px 1px #767474;
            }
    </style>
</head>
<body>
    <div class="se-pre-con"></div>
    <section id="wrapper" class="login-register">
        <div class="login-box">
            <div class="white-box">

                <%
                    if (Request["login"] != null)
                    {
                        new SysLogin(Request, Response).Execute();
                    }
                    else if (Session["success_signup"] != null)
                    {
                        if ((bool)Session["success_signup"] == true)
                        {
                            new ClassDB(Request, Response).Message("Your company is successfully registered. Your username and password has sent to your registered mobile no.");
                            Session.Clear();
                        }
                        Session.Clear();
                    }
                    else if (Session["USER"] != null)
                    {
                        string url = "admin/dashboard.aspx";
                        Response.Redirect(url);
                    }

                %>
                <form class="form-horizontal form-material" id="loginform" method="post" enctype="application/x-www-form-urlencoded">
                    <a href="javascript:void(0)" class="text-center db">
                        <h1 class='elegantshadow'><%=WebConfigurationManager.AppSettings["title"] %></h1>
                    </a>
                    <div class="form-group m-t-40">
                        <div class="col-xs-12">
                            <div class="col-md-12 col-sm-12 input-group">
                            <input type="text" name="user_name" id="user_name" class="form-control" required autocomplete="off" placeholder="Enter Mobile No. or User Name" style="border:1px solid black; padding-left: 5px;">
                            <span class="glyphicon glyphicon-phone form-control-feedback"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group m-t-40">
                        <div class="col-xs-12">
                            <div class="col-md-12 col-sm-12 input-group">
                            <input type="password" id="password" name="password" class="form-control" required autocomplete="off" placeholder="Password" style="border:1px solid black; padding-left: 5px;">
                            <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group text-center m-t-20">
                        <div class="col-xs-12">
                            <input type="submit" name="login" id="login" class="btn btn-primary btn-block btn-flat" value="Sign In!" onclick="loginprocess()" />
                        </div>
                    </div>
                    <div class="form-group m-b-0">
                        <div class="col-sm-12 text-center">
                            <p>Don't have an account? <a href="registration.aspx" class="text-primary m-l-5"><b>Sign Up</b></a></p>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </section>
    <!-- /.login-box-body -->

    <!-- jQuery 2.2.3 -->
    <script src="plugins/jQuery/jquery-2.2.3.min.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="bootstrap/js/bootstrap.min.js"></script>
    <!-- iCheck -->
    <script src="plugins/iCheck/icheck.min.js"></script>
    <script>
        $(function () {
            $('input').iCheck({
                checkboxClass: 'icheckbox_square-blue',
                radioClass: 'iradio_square-blue',
                increaseArea: '20%' // optional
            });
        });
    </script>
    
</body>
</html>
