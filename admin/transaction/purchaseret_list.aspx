﻿<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->

    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Purchase Return</h3>
                <div class="box-tools pull-right">
                    <a href="purchaseret_alter.aspx" class="btn btn-primary">Add Purchase Return</a>
                </div>
            </div>
            <div class="box-body table-responsive">
               <% inventory.Execute(); %>
            </div>
        </div>
        <!-- Your Page Content Here -->

    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
<!-- #include file="../footer.aspx"-->
