<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $(".select2").select2();
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                def_unit: { decimal: true, },
                effective_date: { date_hyphen: true, required: true, },
            },
            messages: {
            }
        });
    });
</script>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Scheme Setup</h3>
                <div class="box-tools pull-right">
                    <a href="scheme_list.aspx" class="btn btn-primary"><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();%>
                    
                    <h1>Work under construction.</h1>
                </div>
                <div class="box-footer">
                    
                </div>
            </form>
        </div>
        <!-- Your Page Content Here -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->

<!-- #include file="../footer.aspx"-->
