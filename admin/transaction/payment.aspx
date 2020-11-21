<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $(".select2").select2();
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                account_no: { alpha_num_no_space: true },
                account_type: { alpha_num_with_space: true },
                bank_name: { alpha_num_with_space: true },
                ifsc_code: { alpha_num_no_space: true },
            },
            messages: {
            }
        });
    });

    $(document).ready(function () {
        $("#search_dues").click(function () {
            retrieveDues();
        });
        $("#supplier").change(function () {
            retrieveDues();
        });
    });

    function retrieveDues() {
        //disable the submit button
        $('#search_dues').val('Wait for Retrieving Data...');
        $('#search_dues').attr('disabled', 'true');
        $('#search_dues').css('cursor', 'progress');
        $('#search_dues').html('processing');
        var suppliers = $('#supplier').val();
        if (suppliers == "") {
            alert("Invalid Ledger Selected.");
            $('#search_dues').val('Search');
            $('#search_dues').css('cursor', 'pointer');
            $('#search_dues').html('Submit');
            $('#search_dues').removeAttr('disabled');
            $('#eachTable').html("");
            $('#divall').hide();

            return;
        }
        $.ajax({
            type: 'POST',
            url: '../support/get_dues.aspx',
            data: { value: suppliers },
            success: function (data, status) {
                if (data.baltype == "None" || data.baltype == "") {
                    $('#creditamt,#payamt').val(data.bal);
                    $('#crdrtype').html("&nbsp;&nbsp;Dues Amount");
                    $('#eachTable').html("");
                    $('#divall,#divpaynow,#divtotal').hide();
                    $('#amtdetails,#amtdetails2').hide();
                }
                else {
                    $('#creditamt,#payamt').val(data.bal);
                    $('#crdrtype').html("&nbsp;&nbsp;Dues Amount (In " + data.baltype + ")");
                    $('#eachTable').html(data.eachtable);
                    $('#divall,#divpay,#divpaynow,#divtotal,#naratdiv').show();
                }
                //enable the submit button
                $('#search_dues').val('Search');
                $('#search_dues').css('cursor', 'pointer');
                $('#search_dues').html('Submit');
                $('#search_dues').removeAttr('disabled');
                $('#divpay').show();
            },
            async: true,
            dataType: 'json'
        });
    }

    function calctot(e,f) {
        var payamt = document.getElementById('payamt').value;
        var chkd = e.checked;
        if (chkd == true) {
            payamt = parseFloat(payamt) + parseFloat(f);
        }
        else {
            payamt = parseFloat(payamt) - parseFloat(f);
        }
        document.getElementById('payamt').value = payamt.toFixed(2);
    }

    $(document).ready(function () {
        $('#paymode').change(function (event) {
            if ($('#paymode').val() == "Cheque") {
                $('#lblchqno').html("&nbsp;&nbsp;Cheque No. <span style='font-weight: bold; color: red'>*</span>");
                $('#chqno').attr("required", true);
                $('#lblchqdt').html("&nbsp;&nbsp;Cheque Date <span style='font-weight: bold; color: red'>*</span>");
                $('#chqdt').attr("required", true);
                $('#lblbnkname').html("&nbsp;&nbsp;Bank Name <span style='font-weight: bold; color: red'>*</span>");
                $('#bnkname').attr("required", true);
                $('#chqdetails,#amtdetails,#naratdiv,#chqdetails2').show();
            }
            else if ($('#paymode').val() == "DD") {
                $('#lblchqno').html("&nbsp;&nbsp;DD No. <span style='font-weight: bold; color: red'>*</span>");
                $('#chqno').attr("required", true);
                $('#lblchqdt').html("&nbsp;&nbsp;DD Date <span style='font-weight: bold; color: red'>*</span>");
                $('#chqdt').attr("required", true);
                $('#lblbnkname').html("&nbsp;&nbsp;Bank Name <span style='font-weight: bold; color: red'>*</span>");
                $('#bnkname').attr("required", true);
                $('#chqdetails,#amtdetails,#naratdiv,#chqdetails2').show();
            }
            else {
                $('#lblchqno').html("&nbsp;&nbsp;Ref No. <span style='font-weight: bold; color: red'>*</span>");
                $('#chqno').removeAttr("required");
                $('#lblchqdt').html("&nbsp;&nbsp;Ref Date <span style='font-weight: bold; color: red'>*</span>");
                $('#chqdt').removeAttr("required");
                $('#lblbnkname').html("&nbsp;&nbsp;Bank Name <span style='font-weight: bold; color: red'>*</span>");
                $('#bnkname').removeAttr("required");
                $('#amtdetails,#naratdiv').show();
                $('#chqdetails,#chqdetails2').hide();
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
                <h3 class="box-title">Payment</h3>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();%>

                    <div class="form-group row">
                        <div class="col-md-12 col-sm-12">
                            <div class="form-group row">
                                <label for="supplier" class="col-md-3 col-sm-5 control-label">Choose Supplier/Customer <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-4 col-sm-7">
                                    <select name="supplier" id="supplier" required class="form-control input-sm select2">
                                        <option value="">Select</option>
                                        <%
                                SqlDataReader rdr = inventory.GetDataReader("select id,name,code from tbl_ledger_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by name asc");
                                while (rdr.Read())
                                { 
                                        %>
                                        <option value="<%=rdr["id"]%>"><%=rdr["name"] %> (<%=rdr["code"] %>)</option>
                                        <%
                                    } rdr.Close();
                                        %>
                                    </select>
                                </div>
                                <div class="col-md-5 col-sm-7">
                                    <input type="button" name="search_dues" id="search_dues" value="Search" class="btn btn-info" />
                                </div>
                            </div>
                           <hr style="border:1px solid #000" />
                            <div class="form-group row" id="divpay" hidden>
                                <label for="creditamt" id="crdrtype" class="col-md-2 col-sm-5 control-label">&nbsp;&nbsp;Dues Amount</label>
                                <div class="col-md-3 col-sm-7">
                                    <div class="input-group">
                                        <span class="input-group-addon">&#8377;
                                        </span>
                                        <input type="text" name="creditamt" id="creditamt" readonly class="form-control input-sm" style="text-align: right; width: 150px" />
                                    </div>
                                </div>
                                <label for="payamt" class="col-md-2 col-sm-5 control-label">&nbsp;&nbsp;Amount to be paid </label>
                                <div class="col-md-3 col-sm-7">
                                    <div class="input-group">
                                        <span class="input-group-addon">&#8377;
                                        </span>
                                        <input type="text" name="payamt" id="payamt" required readonly class="form-control input-sm" style="text-align: right; width: 150px" onkeyup="splitamt()" />
                                    </div>
                                </div>
                            </div>

                            <div class="form-group row" id="divpaynow" hidden>
                                <label for="paymode" class="col-md-2 col-sm-5 control-label">&nbsp;&nbsp;Payment Mode </label>
                                <div class="col-md-3 col-sm-7">
                                    <select name="paymode" id="paymode" class="form-control input-sm" style="width: 184px" required>
                                        <option value="Cash">Cash</option>
                                        <option value="Cheque">Cheque</option>
                                        <option value="DD">DD</option>
                                        <option value="Others">Others</option>
                                    </select>
                                </div>

                                <label for="paynow" class="col-md-2 col-sm-5 control-label">&nbsp;&nbsp;Current Payment</label>
                                <div class="col-md-3 col-sm-7">
                                    <div class="input-group">
                                        <span class="input-group-addon">&#8377;
                                        </span>
                                        <input type="text" name="paynow" id="paynow" class="form-control input-sm" style="text-align: right; width: 150px" required />
                                    </div>
                                </div>
                            </div>
                            <div class="form-group row" id="chqdetails" hidden>
                                <label for="chqno" class="col-md-2 col-sm-5 control-label" id="lblchqno">&nbsp;&nbsp;Cheque No. <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-3 col-sm-7">
                                    <input type="text" name="chqno" id="chqno" value="" class="form-control input-sm" />
                                </div>
                                <label for="chqdt" class="col-md-2 col-sm-5 control-label" id="lblchqdt">&nbsp;&nbsp;Cheque Date <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-3 col-sm-7">
                                    <input type="text" name="chqdt" id="chqdt" value="" class="form-control input-sm" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div id="chqdetails2" hidden>
                                    <label for="bnkname" class="col-md-2 col-sm-5 control-label" id="lblbnk">&nbsp;&nbsp;Bank Name <span style="font-weight: bold; color: red">*</span></label>
                                    <div class="col-md-3 col-sm-7">
                                        <input type="text" name="bnkname" id="bnkname" value="" class="form-control input-sm" />
                                    </div>
                                </div>
                                <div id="naratdiv" hidden>
                                    <label for="narat" class="col-md-2 col-sm-5 control-label">&nbsp;&nbsp;Narration</label>
                                    <div class="col-md-3 col-sm-7">
                                        <textarea name="modedesc" id="modedesc" class="form-control input-sm" style="height: 80px"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr style="border:1px solid #000" />
                    <div class="form-group row">
                        <div id='eachTable'></div>
                    </div>
                </div>
                <div class="box-footer" style="text-align: center">
                    <input type="hidden" name="totalpaidamt" id="totalpaidamt" value="0" />
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
        $('#chqdt').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
        });
    });
</script>


<!-- #include file="../footer.aspx"-->
