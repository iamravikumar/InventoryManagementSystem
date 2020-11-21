<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $.validator.messages.required = "";
        $("#FORM1").validate({
            rules: {
                fin_year: { maxlength: 9, minlength: 9, }
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
                <h3 class="box-title">Financial Year</h3>
                <div class="box-tools pull-right">
                    <a href="fy_list.aspx?cmd=Clear" class="btn btn-primary "><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();%>
                    <br />
                    <div class="form-group row">
                        <label for="fin_year" class="col-md-2 col-sm-5 control-label">Financial Year <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="fin_year" id="fin_year" value="<%=inventory.TempRs["fin_year"]%>" <%=inventory.diasableit%> required class="form-control input-sm" maxlength="9" placeholder="YYYY-YYYY" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="book_start_dt" class="col-md-2 col-sm-5 control-label">Book Start Date <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="book_start_dt" class="form-control pull-right" value="<%=inventory.TempRs["book_start_dt"]!=""?Convert.ToDateTime(inventory.TempRs["book_start_dt"].ToString()).ToString("dd-MM-yyyy"):DateTime.Now.ToString("dd-MM-yyyy")%>" id="book_start_dt" <%=inventory.diasableit%> required />
                        </div>
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


<script>
    $(function () {

        //Date picker
        $('#book_start_dt').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            //daysOfWeekDisabled: [0], sunday disable 0-6 sun-sat
            endDate: '0d', //disable after today
        });
    });
</script>



<!-- #include file="../footer.aspx"-->
