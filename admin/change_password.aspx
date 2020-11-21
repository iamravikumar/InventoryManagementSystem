<!-- #include file="header.aspx"-->

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Change Password</h3>
            </div>
            <div class="box-body table-responsive">

                <%if(Request["change_password"]!=null){
                        SysLogin login = new SysLogin(Request, Response);
                        login.ChangePassword();                    
                    } %>

                <form method="post" style="width:50%; margin:auto">
                    <label for="old_password" class="col-md-7 col-sm-7 control-label">Enter Old Password</label>
                    <div class="form-group has-feedback">
                        <input type="password" name="old_password" id="old_password" class="form-control" required placeholder="Previous Password">
                        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    </div>
                    <label for="password" class="col-md-7 col-sm-7 control-label">Enter New Password</label>
                    <div class="form-group has-feedback">
                        <input type="password" name="password" id="password" class="form-control" required placeholder="Password">
                        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    </div>
                    <label for="cnf_password" class="col-md-7 col-sm-7 control-label">Confirm New Password</label>
                    <div class="form-group has-feedback">
                        <input type="text" id="cnf_password" name="cnf_password" class="form-control" required placeholder="Confirm Password">
                        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
                    </div>
                    <div class="row">
                        <!-- /.col -->
                        <div class="col-xs-5">
                            <input type="submit" name="change_password" id="change_password" class="btn btn-primary btn-block btn-flat" value="Change Password" />
                        </div>
                        <!-- /.col -->
                    </div>
                </form>
            </div>
        </div>
    </section>
</div>
<!-- #include file="footer.aspx" -->
