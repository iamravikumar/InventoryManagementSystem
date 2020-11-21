<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Configuration" %>

<!DOCTYPE html>
<html>
<head>
<title><%=WebConfigurationManager.AppSettings["title"] %> | Home</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<link href="layout/styles/layout.css" rel="stylesheet" type="text/css" media="all">
</head>
<body id="top">

<!-- Top Background Image Wrapper -->
<div class="bgded" style="background-image:url('common/images/login-register.jpg');">
  <div class="overlay"> 
    <div class="wrapper row0">
      <div id="topbar" class="clear"> 
        <!-- ################################################################################################ -->
        <div class="fl_left">
          <ul class="nospace inline pushright">
            <li><i class="fa fa-phone"></i> +91 7762849714</li>
            <li><i class="fa fa-envelope-o"></i> ntsh.vicky@gmail.com</li>
          </ul>
        </div>
        <div class="fl_right">
          <ul class="faico clear">
            <li><a class="faicon-facebook" href="#"><i class="fa fa-facebook"></i></a></li>
            <li><a class="faicon-pinterest" href="#"><i class="fa fa-pinterest"></i></a></li>
            <li><a class="faicon-twitter" href="#"><i class="fa fa-twitter"></i></a></li>
            <li><a class="faicon-dribble" href="#"><i class="fa fa-dribbble"></i></a></li>
            <li><a class="faicon-linkedin" href="#"><i class="fa fa-linkedin"></i></a></li>
            <li><a class="faicon-google-plus" href="#"><i class="fa fa-google-plus"></i></a></li>
            <li><a class="faicon-rss" href="#"><i class="fa fa-rss"></i></a></li>
          </ul>
        </div>
        <!-- ################################################################################################ -->
      </div>
    </div>
    <!-- ################################################################################################ -->
    <!-- ################################################################################################ -->
    <!-- ################################################################################################ -->
    <div class="wrapper row1">
      <header id="header" class="clear"> 
        <!-- ################################################################################################ -->
        <div id="logo" class="fl_left">
          <h1><%=WebConfigurationManager.AppSettings["title"] %></h1>
        </div>
        <nav id="mainav" class="fl_right">
          <ul class="clear">
            <li><a href="signing.aspx">Existing User? Login Here</a></li>
            <li><a href="registration.aspx">New User? Register Here</a></li>
          </ul>
        </nav>
        <!-- ################################################################################################ -->
      </header>
    </div>
    <!-- ################################################################################################ -->
    <div class="wrapper row1">
      <section id="pageintro" class="clear"> 
        <!-- ################################################################################################ -->
        <p class="font-x2 capitalise"></p>
        <i class="fa fa-5x fa-pagelines"></i>
        <h2 class="font-x3 uppercase">Easy & Smart<br>
          Solution for Stock Entry</h2>
        <a class="btn" href="registration.aspx">REGISTER NOW</a> 
        <!-- ################################################################################################ -->
      </section>
    </div>
    <!-- ################################################################################################ -->
  </div>
</div>
<!-- End Top Background Image Wrapper -->
<!-- ################################################################################################ -->

<div class="wrapper coloured">
  <section id="cta" class="clear"> 
    <!-- ################################################################################################ -->
    <div class="three_quarter first">
      <h2 class="uppercase nospace">Best Solution Ever</h2>
      <p class="nospace">Don't Afraid of GST, If We are Here.</p>
    </div>
    <div class="one_quarter"><a class="btn" href="#">CLICK LINK</a></div>
    <!-- ################################################################################################ -->
  </section>
</div>

<div class="wrapper row3">
  <main class="container clear center"> 
    <!-- main body -->
    <!-- ################################################################################################ -->
    <article class="one_quarter first">
      <h2>Some Text Here</h2>
      <p class="btmspace-30">This Text  Field is Used For Long Description About Software ................<br />................</p>
      <p class="nospace"><a class="btn" href="#">CLICK LINK</a></p>
    </article>
    <article class="one_quarter"><i class="icon circle btmspace-50 fa fa-life-ring"></i>
      <h4 class="font-x1"><a href="#">Just In Time Update</a></h4>
      <p>You Can Add Or Update Data Any Time</p>
    </article>
    <article class="one_quarter"><i class="icon circle btmspace-50 fa fa-legal"></i>
      <h4 class="font-x1"><a href="#">Easy GST Setting Available</a></h4>
      <p>You Can Easily Make GST Slab</p>
    </article>
    <article class="one_quarter"><i class="icon circle btmspace-50 fa fa-cogs"></i>
      <h4 class="font-x1"><a href="#">Easy To Use</a></h4>
      <p>No More Setting or Other With Easy to Use Facility For All Types Of Inventory.</p>
    </article>
    <!-- ################################################################################################ -->
    <!-- / main body -->
    <div class="clear"></div>
  </main>
</div>

<div class="wrapper row4">
  <footer id="footer" class="clear"> 
    <div class="one_quarter first">
      <h6 class="title">Company Details</h6>
      <address class="btmspace-15">
      Company Name<br>
      Street Name &amp; Number<br>
      Town<br>
      Postcode/Zip
      </address>
      <ul class="nospace">
        <li class="btmspace-10"><span class="fa fa-phone"></span> +91 7762849714</li>
        <li><span class="fa fa-envelope-o"></span> ntsh.vicky@gmail.com</li>
      </ul>
    </div>
    <div class="one_quarter">
      <h6 class="title">From The Blog</h6>
      <article>
        <h2 class="nospace font-x1"><a href="#">XYZ</a></h2>
        <time class="smallfont" datetime="2045-04-06">Friday, 6<sup>th</sup> April 2045</time>
        <p>abc def ghi jkl mno pqr stu vwx yz</p>
      </article>
    </div>
    <div class="one_quarter">
      <h6 class="title">Some Text Here</h6>
      <ul class="nospace linklist">
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
      </ul>
    </div>
    <div class="one_quarter">
      <h6 class="title">Some Text Here</h6>
      <ul class="nospace linklist">
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
        <li><a href="#">Some Text Here For Link</a></li>
      </ul>
    </div>
    <!-- ################################################################################################ -->
  </footer>
</div>
<!-- ################################################################################################ -->
<!-- ################################################################################################ -->
<!-- ################################################################################################ -->
<div class="wrapper row5">
  <div id="copyright" class="clear"> 
    <!-- ################################################################################################ -->
    <p class="fl_right">Powered By <a href="http://www.iotasonl.com/" target="_blank"><%=WebConfigurationManager.AppSettings["footer"]%></a></p>
    <!-- ################################################################################################ -->
  </div>
</div>
<!-- ################################################################################################ -->
<!-- ################################################################################################ -->
<!-- ################################################################################################ -->
<a id="backtotop" href="#top"><i class="fa fa-chevron-up"></i></a>
<!-- JAVASCRIPTS -->
<script src="layout/scripts/jquery.min.js"></script>
<script src="layout/scripts/jquery.backtotop.js"></script>
<script src="layout/scripts/jquery.mobilemenu.js"></script>
</body>
</html>