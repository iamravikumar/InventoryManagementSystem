<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $(".select2").select2();
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                pin_code: { digit: true, maxlength: 6, minlength: 6, },
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
                <h3 class="box-title">Company Master</h3>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();

                        if(Convert.ToBoolean(Session["update"]) == true)
                        {
                            inventory.Message("Data Successfully Updated.");
                            Session["update"]=null;
                        }

                    %>
                    <br />
                    <div class="form-group row">
                        <label for="company_name" class="col-md-2 col-sm-5 control-label">Company Name</label>
                        <div class="col-md-4 col-sm-7">
                            <%=inventory.TempRs["company_name"]%>
                        </div>
                        <label for="mailing_name" class="col-md-2 col-sm-5 control-label">Mailing Name</label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="mailing_name" id="mailing_name" value="<%=inventory.TempRs["mailing_name"]%>" <%=inventory.diasableit%> required class="form-control input-sm" placeholder="No Special Character" maxlength="200" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="address_1" class="col-md-2 col-sm-5 control-label">Address 1</label>
                        <div class="col-md-4 col-sm-7">
                            <textarea name="address_1" id="address_1" class="form-control input-sm" maxlength="200" style="height: 80px;"><%=inventory.TempRs["address_1"]%></textarea>
                        </div>
                        <label for="address_2" class="col-md-2 col-sm-5 control-label">Address 2</label>
                        <div class="col-md-4 col-sm-7">
                            <textarea name="address_2" id="address_2" class="form-control input-sm" maxlength="200" style="height: 80px;"><%=inventory.TempRs["address_2"]%></textarea>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="state" class="col-md-2 col-sm-5 control-label">State <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="state" id="state" required class="form-control input-sm">
                                <option value="">Select</option>
                                 <%
                                    SqlDataReader rdr = inventory.GetDataReader("select * from tbl_state_master where status=1 order by state_code asc");
                                    while (rdr.Read())
                                    { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["state_id"]?"selected":""%>><%=rdr["state_name"] %></option>
                                <%
                                    } rdr.Close();
                                %>
                            </select>
                        </div>
                        <label for="pin_code" class="col-md-2 col-sm-5 control-label">Pin Code </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="pin_code" id="pin_code" value="<%=inventory.TempRs["pin_code"]%>" class="form-control input-sm" maxlength="6" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="contact_no" class="col-md-2 col-sm-5 control-label">Contact No <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="contact_no" id="contact_no" value="<%=inventory.TempRs["reg_mobile_no"]%>" required class="form-control input-sm" maxlength="10" />
                        </div>
                        <label for="email_address" class="col-md-2 col-sm-5 control-label">E-Mail </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="email" name="email_address" id="email_address" value="<%=inventory.TempRs["email_address"]%>" class="form-control input-sm" maxlength="200" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="gstin_no" class="col-md-2 col-sm-5 control-label">GSTIN No </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="gstin_no" id="gstin_no" value="<%=inventory.TempRs["gstin_no"]%>" class="form-control input-sm" maxlength="50" />
                        </div>
                        <label for="gstin_type" class="col-md-2 col-sm-5 control-label">GSTIN Type </label>
                        <div class="col-md-4 col-sm-7">
                            <select name="gstin_type" id="gstin_type" required class="form-control input-sm">
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
                        <label for="pan_no" class="col-md-2 col-sm-5 control-label">Pan No </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="pan_no" id="pan_no" value="<%=inventory.TempRs["pan_no"]%>" class="form-control input-sm" maxlength="10" />
                        </div>
                        <label for="currency_symbol" class="col-md-2 col-sm-5 control-label">Currency Symbol  <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="currency_symbol" id="currency_symbol" disabled required class="form-control input-sm">
                                <option value="">Select</option>
                                <option value="Rupees" <%=inventory.TempRs["currency_symbol"]!=""?inventory.TempRs["currency_symbol"].ToString()=="Rupees"?"selected":"":"selected"%>>₹ (Rupees)</option>
                                <option value="Doller" <%=inventory.TempRs["currency_symbol"]!=""?inventory.TempRs["currency_symbol"].ToString()=="Doller"?"selected":"":""%>>$ (Doller)</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="negativestock" class="col-md-2 col-sm-5 control-label">Allow Negative Stock  <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="negativestock" id="negativestock" required class="form-control input-sm">
                                <option value="">Select</option>
                                <option value="0" <%=inventory.TempRs["negative_stock"]!=""?inventory.TempRs["negative_stock"].ToString()=="0"?"selected":"":"selected"%>>No</option>
                                <option value="1" <%=inventory.TempRs["negative_stock"]!=""?inventory.TempRs["negative_stock"].ToString()=="1"?"selected":"":""%>>Yes</option>
                            </select>
                        </div>
                         <label for="batchentry" class="col-md-2 col-sm-5 control-label">Allow Batchwise Entry  <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="batchentry" id="batchentry" required class="form-control input-sm">
                                <option value="">Select</option>
                                <option value="0" <%=inventory.TempRs["batchwise_entry"]!=""?inventory.TempRs["batchwise_entry"].ToString()=="0"?"selected":"":"selected"%>>No</option>
                                <option value="1" <%=inventory.TempRs["batchwise_entry"]!=""?inventory.TempRs["batchwise_entry"].ToString()=="1"?"selected":"":""%>>Yes</option>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="box-footer" style="text-align:center">
                    <input type="submit" class="btn btn-success" style="width: 150px" name="btn_add" value="Update" />
                </div>
            </form>
        </div>
        <!-- Your Page Content Here -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
<!-- #include file="../footer.aspx"-->
