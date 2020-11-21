<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title><%=WebConfigurationManager.AppSettings["title"] %> | Registration</title>
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

    <script src="common/js/jquery.validate.js"></script>

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
    

     <style>
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
        $("#FORM1").submit(function () {
            // Animate loader off screen
            $(".se-pre-con").fadeOut("slow");
        });
    </script>

<script>
    $(document).ready(function () {
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                email: { email: true, },
                mobile: { mobile_no: true, },
            },
            messages: {
            }
        });
    });
</script>

    <style>
        h1 {
            font-family: "Avant Garde", Avantgarde, "Century Gothic", CenturyGothic, "AppleGothic", sans-serif;
            font-size: 30px;
            margin-top: 0px;
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
        <div class="login-box login-sidebar" style="margin-top: 0px">
            <div class="white-box">

                <%
                    if (Request["register"] != null)
                    {
                        SysLogin login = new SysLogin(Request, Response);
                        login.Execute();
                    }
                %>
                <!-- /.login-logo -->
                <div class="register-box-body">
                     <a href="javascript:void(0)" class="text-center db">
                        <h1 class='elegantshadow'><%=WebConfigurationManager.AppSettings["title"] %></h1>
                    </a>
                    <p class="login-box-msg elegantshadow">Register a new membership</p>

                    <form class="form-horizontal form-material" name="FORM1" id="FORM1">
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" name="comp_name" id="comp_name" placeholder="Company name" required title="Enter name of the company">
                            <span class="glyphicon glyphicon-user form-control-feedback"></span>
                        </div>
                        <div class="form-group has-feedback">
                            <input type="text" class="form-control" name="mobile" id="mobile" placeholder="Mobile No (Default User ID)" maxlength="10" required title="Register Mobile No.">
                            <span class="glyphicon glyphicon-phone form-control-feedback"></span>
                        </div>
                        <div class="form-group has-feedback">
                            <input type="email" class="form-control" name="email" id="email" placeholder="Email" required title="Register Email ID">
                            <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
                        </div>
                        <div class="row">
                            <!-- /.col -->
                            <div class="col-xs-12">
                                <input type="submit" class="btn btn-primary btn-block btn-flat" name="register" id="register" value="Register" />
                            </div>
                            <!-- /.col -->
                        </div>
                    </form>

                    <div class="social-auth-links text-center">
                        <p>- OR -</p>
                        <a class="btn btn-block btn-social btn-facebook btn-flat" onclick="checkLoginState();" ><i class="fa fa-facebook"></i>Sign up using
        Facebook</a>
                        <a href="#" class="btn btn-block btn-social btn-google btn-flat"><i class="fa fa-google-plus"></i>Sign up using
        Google+</a>
                    </div>
                    <div class="row">
                        <div class="col-xs-12">
                            <a href="signing.aspx" class="text-center">I already have a membership</a>
                        </div>
                    </div>
                </div>
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


    <div id="inner_loader" class="loader_up" style="display: none"></div>
    <div id="inner_loader_bg" style="display: none"></div>
    <script>

        function showLoader() {
            document.getElementById("inner_loader").style.display = "block";
            document.getElementById("inner_loader_bg").style.display = "block";
        }
    </script>

</body>
</html>
