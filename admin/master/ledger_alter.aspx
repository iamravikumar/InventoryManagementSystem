<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $(".select2").select2();
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                mobile_no: { digit: true },
                contact_no: { digit: true },
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
                <h3 class="box-title">Ledger Master</h3>
                <div class="box-tools pull-right">
                    <a href="ledger_list.aspx" class="btn btn-primary "><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();
                        
                        string supcode = inventory.TempRs["code"];
                        if(String.IsNullOrWhiteSpace(supcode))
                        {
                            supcode = inventory.getLedgerCode();
                        }

                    %>
                    <br />
                    <div class="form-group row">
                        <label for="code" class="col-md-2 col-sm-5 control-label">Ledger Code <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="code" id="code" value="<%=supcode%>" <%=inventory.diasableit%> readonly required class="form-control input-sm" maxlength="200" />
                        </div>
                        <label for="name" class="col-md-2 col-sm-5 control-label">Ledger Name <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="name" id="name" value="<%=inventory.TempRs["name"]%>" <%=inventory.diasableit%> required class="form-control input-sm" maxlength="200" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="group_id" class="col-md-2 col-sm-5 control-label">Group Under <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="group_id" id="group_id" <%=inventory.diasableit%> required class="form-control input-sm">
                                <option value="">Select</option>
                                <%
                                SqlDataReader rdr = inventory.GetDataReader("select * from tbl_group_master where status=1 order by id asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["group_id"]?"selected":""%>><%=rdr["group_name"] %></option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>
                         <label for="email" class="col-md-2 col-sm-5 control-label">E-Mail</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="email" name="email" id="email" value="<%=inventory.TempRs["email"]%>" <%=inventory.diasableit%> class="form-control input-sm" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="mobile_no" class="col-md-2 col-sm-5 control-label">Mobile No</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="mobile_no" id="mobile_no" value="<%=inventory.TempRs["mobile_no"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="10" />
                        </div>
                        <label for="contact_no" class="col-md-2 col-sm-5 control-label">Contact No</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="contact_no" id="contact_no" value="<%=inventory.TempRs["contact_no"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="20" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="address_1" class="col-md-2 col-sm-5 control-label">Address 1</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="address_1" id="address_1" value="<%=inventory.TempRs["address_1"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="200" />
                        </div>
                        <label for="address_2" class="col-md-2 col-sm-5 control-label">Address 2</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="address_2" id="address_2" value="<%=inventory.TempRs["address_2"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="200" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="city" class="col-md-2 col-sm-5 control-label">City </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="city" id="city" value="<%=inventory.TempRs["city"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="50" />
                        </div>
                        <label for="state" class="col-md-2 col-sm-5 control-label">State <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="state" id="state" required class="form-control input-sm" <%=inventory.diasableit%>>
                                <option value="">Select</option>
                                <%
                                rdr = inventory.GetDataReader("select * from tbl_state_master where status=1 order by state_code asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["state_id"]?"selected":""%>><%=rdr["state_name"] %></option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group row">
                        <label for="pincode" class="col-md-2 col-sm-5 control-label">Pin Code</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="pincode" id="pincode" value="<%=inventory.TempRs["pincode"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="6" />
                        </div>
                        <label for="pan_no" class="col-md-2 col-sm-5 control-label">Pan No </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="pan_no" id="pan_no" value="<%=inventory.TempRs["pan_no"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="10" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="gstin_no" class="col-md-2 col-sm-5 control-label">GSTIN No.</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="gstin_no" id="gstin_no" value="<%=inventory.TempRs["gstin_no"]%>" <%=inventory.diasableit%> class="form-control input-sm" />
                        </div>
                        <label for="gstin_type" class="col-md-2 col-sm-5 control-label">GSTIN Type</label>
                        <div class="col-md-4 col-sm-7">
                            <select name="gstin_type" id="gstin_type" class="form-control input-sm"  <%=inventory.diasableit%>>
                                <option value="">Select</option>
                                <%
                                rdr = inventory.GetDataReader("select * from tbl_gstintype_master where status=1 order by id asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["gstin_type_id"]?"selected":""%>><%=rdr["gstin_type"] %></option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="billing_type" class="col-md-2 col-sm-5 control-label">Billing Type <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="billing_type" id="billing_type" required class="form-control input-sm" <%=inventory.diasableit%>>
                                <option value="">Select</option>
                                <option value="BILL WISE" <%="BILL WISE"==inventory.TempRs["billing_type"]?"selected":""%>>Bill-by-Bill</option>
                                <option value="ACCOUNT WISE" <%="ACCOUNT WISE"==inventory.TempRs["billing_type"]?"selected":""%>>Account</option>
                                <option value="FIFO" <%="FIFO"==inventory.TempRs["billing_type"]?"selected":""%>>FIFO</option>
                            </select>
                        </div>
                         <label for="master_discount" class="col-md-2 col-sm-5 control-label">Discount (In %)</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="number" name="master_discount" id="master_discount" min="0" max="100" required value="<%=inventory.TempRs["master_discount"]%>" class="form-control input-sm"  <%=inventory.diasableit%>/>
                        </div>
                    </div>

                </div>
                <div class="box-footer" style="text-align:center">
                    <input type="submit" class="btn btn-success" style="width: 150px" name="btn_add" value="<%=inventory.ButtonOperation2%>" data-loading-text="<i class='fa fa-circle-o-notch fa-spin'></i> Processing Order"/>
                </div>
            </form>
        </div>
        <!-- Your Page Content Here -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
<!-- #include file="../footer.aspx"-->
