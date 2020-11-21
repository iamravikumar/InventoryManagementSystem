<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                contact_no: { mobile_no: true, maxlength: 10, minlength: 10, },
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
                <h3 class="box-title">Store/Warehouse Master</h3>
                <div class="box-tools pull-right">
                    <a href="store_list.aspx" class="btn btn-primary "><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();
                        
                        string storecode = inventory.TempRs["code"];
                        if(String.IsNullOrWhiteSpace(storecode))
                        {
                            storecode = inventory.getStoreCode();
                        }
                        
                    %>

                    <div class="form-group">
                        <label for="store_type">Store Type <span style="font-weight: bold; color: red">*</span></label>
                        <select name="store_type" id="store_type" <%=inventory.diasableit%> required class="form-control input-sm select2">
                            <option value="WAREHOUSE" <%=inventory.TempRs["store_type"]!=""?inventory.TempRs["store_type"].ToString()=="WAREHOUSE"?"selected":"":""%>>WAREHOUSE</option>
                            <option value="SHOP" <%=inventory.TempRs["store_type"]!=""?inventory.TempRs["store_type"].ToString()=="SHOP"?"selected":"":""%>>SHOP</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="store_code">Store Code <span style="font-weight: bold; color: red">*</span></label>
                        <input type="text" name="store_code" id="store_code" value="<%=storecode%>" readonly <%=inventory.diasableit%> required class="form-control input-sm" maxlength="200" />
                    </div>

                    <div class="form-group">
                        <label for="store_name">Store Name <span style="font-weight: bold; color: red">*</span></label>
                        <input type="text" name="store_name" id="store_name" value="<%=inventory.TempRs["name"]%>" <%=inventory.diasableit%> required class="form-control input-sm" maxlength="200" />
                    </div>

                    <div class="form-group">
                        <label for="contact_no">Store's Contact No </label>
                        <input type="text" name="contact_no" id="contact_no" value="<%=inventory.TempRs["contact_no"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="10" />
                    </div>

                    <div class="form-group">
                        <label for="store_address">Store Address </label>
                        <textarea name="store_address" id="store_address" <%=inventory.diasableit%> class="form-control input-sm" maxlength="500" style="height: 80px;"><%=inventory.TempRs["address"]%></textarea>
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
