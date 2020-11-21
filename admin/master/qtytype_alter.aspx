<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                type: { alpha_num_no_space: true },
                description: { alpha_num_with_space: true },
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
                <h3 class="box-title">Unit Master</h3>
                <div class="box-tools pull-right">
                    <a href="qtytype_list.aspx?cmd=Clear" class="btn btn-primary "><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();%>
                    
                    <div class="form-group">
                        <label for="type">Symbol <span style="font-weight: bold; color: red">*</span></label>
                        <input type="text" name="type" id="type" value="<%=inventory.TempRs["symbol"]%>" <%=inventory.diasableit%> required class="form-control input-sm" maxlength="10" />
                    </div>

                    <div class="form-group">
                        <label for="description">Formal Name <span style="font-weight: bold; color: red">*</span></label>
                        <input type="text" name="description" id="description" value="<%=inventory.TempRs["formal_name"]%>" required <%=inventory.diasableit%> class="form-control input-sm" maxlength="50" />
                    </div>
                    
                </div>
                <div class="box-footer">
                    <input type="submit" class="btn btn-success" style="width: 150px" name="btn_add" value="<%=inventory.ButtonOperation2%>" />
                </div>
            </form>
        </div>
        <!-- Your Page Content Here -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
<!-- #include file="../footer.aspx"-->
