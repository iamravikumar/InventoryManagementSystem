<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $(".select2").select2();
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                start_no: { digit: true, },
                width_of_digit: { digit: true, },
                prefix_code: { alpha_num_no_space: true, },
                suffix_code: { alpha_num_no_space: true, },
                effective_date: { date_hyphen: true, required: true, },
            },
            messages: {
            }
        });
    });

    function showhidenmb(e) {
        if (e.value == "MANUAL") {
            document.getElementById("manual").hidden = false;
            document.getElementById("automatic").hidden = true;
        }
        else if (e.value == "AUTOMATIC") {
            document.getElementById("manual").hidden = true;
            document.getElementById("automatic").hidden = false;
        }
        else {
            document.getElementById("manual").hidden = true;
            document.getElementById("automatic").hidden = true;
        }
    }
</script>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Invoice Setup Master</h3>
                <div class="box-tools pull-right">
                    <a href="voucherset_list.aspx" class="btn btn-primary"><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <% inventory.Execute(); %>
                    <br />
                    <div class="form-group row">
                        <label for="invoice_type" class="col-md-2 col-sm-5 control-label">Invoice Type <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="invoice_type" id="invoice_type" <%=inventory.diasableit%> required class="form-control input-sm">
                                <option value="">Select</option>
                                <option value="PURCHASE" <%=inventory.TempRs["invoice_type"]!=""?inventory.TempRs["invoice_type"].ToString()=="PURCHASE"?"selected":"":""%>>PURCHASE</option>
                                <option value="SALE" <%=inventory.TempRs["invoice_type"]!=""?inventory.TempRs["invoice_type"].ToString()=="SALE"?"selected":"":""%>>SALE</option>
                                <option value="PURCHASE RETURN" <%=inventory.TempRs["invoice_type"]!=""?inventory.TempRs["invoice_type"].ToString()=="PURCHASE RETURN"?"selected":"":""%>>PURCHASE RETURN</option>
                                <option value="SALE RETURN" <%=inventory.TempRs["invoice_type"]!=""?inventory.TempRs["invoice_type"].ToString()=="SALE RETURN"?"selected":"":""%>>SALE RETURN</option>
                            </select>
                        </div>
                        <label for="types_of_numbering" class="col-md-2 col-sm-5 control-label">Type of Numbering <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="types_of_numbering" id="types_of_numbering" <%=inventory.diasableit%> required class="form-control input-sm" onchange="showhidenmb(this)">
                                <option value="">Select</option>
                                <option value="MANUAL" <%=inventory.TempRs["types_of_numbering"]!=""?inventory.TempRs["types_of_numbering"].ToString()=="MANUAL"?"selected":"":""%>>MANUAL</option>
                                <option value="AUTOMATIC" <%=inventory.TempRs["types_of_numbering"]!=""?inventory.TempRs["types_of_numbering"].ToString()=="AUTOMATIC"?"selected":"":""%>>AUTOMATIC</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row" id="manual" <%=inventory.TempRs["types_of_numbering"]!=""?inventory.TempRs["types_of_numbering"].ToString()=="MANUAL"?"":"hidden":"hidden"%>>
                        <label for="prevent_duplicacy" class="col-md-2 col-sm-5 control-label">Prevent Duplicacy  <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="prevent_duplicacy" id="prevent_duplicacy" <%=inventory.diasableit%> class="form-control input-sm" required>
                                <option value="">Select</option>
                                <option value="0" <%=inventory.TempRs["prevent_duplicacy"]!=""?inventory.TempRs["prevent_duplicacy"].ToString()=="0"?"selected":"":""%>>No</option>
                                <option value="1" <%=inventory.TempRs["prevent_duplicacy"]!=""?inventory.TempRs["prevent_duplicacy"].ToString()=="1"?"selected":"":""%>>Yes</option>
                            </select>
                        </div>
                    </div>

                    <div id="automatic" <%=inventory.TempRs["types_of_numbering"]!=""?inventory.TempRs["types_of_numbering"].ToString()=="AUTOMATIC"?"":"hidden":"hidden"%>>
                        <div class="form-group row">
                            <label for="start_no" class="col-md-2 col-sm-5 control-label">Start No. <span style="font-weight: bold; color: red">*</span></label>
                            <div class="col-md-4 col-sm-7">
                                <input type="text" name="start_no" id="start_no" value="<%=inventory.TempRs["start_no"]%>" <%=inventory.diasableit%> class="form-control input-sm" required />
                            </div>

                            <label for="prefill_with_zero" class="col-md-2 col-sm-5 control-label">Prefill With Zero <span style="font-weight: bold; color: red">*</span></label>
                            <div class="col-md-4 col-sm-7">
                                <select name="prefill_with_zero" id="prefill_with_zero" <%=inventory.diasableit%> class="form-control input-sm" required>
                                    <option value="">Select</option>
                                    <option value="0" <%=inventory.TempRs["prefill_with_zero"]!=""?inventory.TempRs["prefill_with_zero"].ToString()=="0"?"selected":"":""%>>No</option>
                                    <option value="1" <%=inventory.TempRs["prefill_with_zero"]!=""?inventory.TempRs["prefill_with_zero"].ToString()=="1"?"selected":"":""%>>Yes</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="width_of_digit" class="col-md-2 col-sm-5 control-label">Width of Digit <span style="font-weight: bold; color: red">*</span></label>
                            <div class="col-md-4 col-sm-7">
                                <input type="text" name="width_of_digit" id="width_of_digit" value="<%=(inventory.TempRs["width_of_digit"]!="" && inventory.TempRs["width_of_digit"]!=null)?inventory.TempRs["width_of_digit"]:"0"%>" <%=inventory.diasableit%> class="form-control input-sm" />
                            </div>

                            <label for="restarting_period" class="col-md-2 col-sm-5 control-label">Restarting Period <span style="font-weight: bold; color: red">*</span></label>
                            <div class="col-md-4 col-sm-7">
                                <select name="restarting_period" id="restarting_period" <%=inventory.diasableit%> required class="form-control input-sm">
                                    <option value="">Select</option>
                                    <option value="YEARLY" <%=inventory.TempRs["restarting_period"]!=""?inventory.TempRs["restarting_period"].ToString()=="YEARLY"?"selected":"":""%>>YEARLY (Year Prefix)</option>
                                    <option value="MONTHLY" <%=inventory.TempRs["restarting_period"]!=""?inventory.TempRs["restarting_period"].ToString()=="MONTHLY"?"selected":"":""%>>MONTHLY (Month Prefix)</option>
                                    <option value="DAILY" <%=inventory.TempRs["restarting_period"]!=""?inventory.TempRs["restarting_period"].ToString()=="DAILY"?"selected":"":""%>>DAILY (Date Prefix)</option>
                                    <option value="NONE" <%=inventory.TempRs["restarting_period"]!=""?inventory.TempRs["restarting_period"].ToString()=="NONE"?"selected":"":""%>>NONE</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="prefix_code" class="col-md-2 col-sm-5 control-label">Prefix Code </label>
                            <div class="col-md-4 col-sm-7">
                                <input type="text" name="prefix_code" id="prefix_code" value="<%=inventory.TempRs["prefix_code"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="20" />
                            </div>

                            <label for="suffix_code" class="col-md-2 col-sm-5 control-label">Suffix Code </label>
                            <div class="col-md-4 col-sm-7">
                                <input type="text" name="suffix_code" id="suffix_code" value="<%=inventory.TempRs["suffix_code"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="20" />
                            </div>
                        </div>

                        <div class="form-group row">
                            <label for="prefix_split_code" class="col-md-2 col-sm-5 control-label">Prefix Split Code </label>
                            <div class="col-md-4 col-sm-7">
                                <select name="prefix_split_code" id="prefix_split_code" <%=inventory.diasableit%> class="form-control input-sm">
                                    <option value="">Select</option>
                                    <option value="-" <%=inventory.TempRs["prefix_split_code"]!=""?inventory.TempRs["prefix_split_code"].ToString()=="-"?"selected":"":""%>>- (Dash)</option>
                                    <option value="/" <%=inventory.TempRs["prefix_split_code"]!=""?inventory.TempRs["prefix_split_code"].ToString()=="/"?"selected":"":""%>>/ (Slash)</option>
                                </select>
                            </div>

                            <label for="suffix_split_code" class="col-md-2 col-sm-5 control-label">Suffix Split Code </label>
                            <div class="col-md-4 col-sm-7">
                                <select name="suffix_split_code" id="suffix_split_code" <%=inventory.diasableit%> class="form-control input-sm">
                                    <option value="">Select</option>
                                    <option value="-" <%=inventory.TempRs["suffix_split_code"]!=""?inventory.TempRs["suffix_split_code"].ToString()=="-"?"selected":"":""%>>- (Dash)</option>
                                    <option value="/" <%=inventory.TempRs["suffix_split_code"]!=""?inventory.TempRs["suffix_split_code"].ToString()=="/"?"selected":"":""%>>/ (Slash)</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="is_taxable" class="col-md-2 col-sm-5 control-label">Is Taxable? <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="is_taxable" id="is_taxable" <%=inventory.diasableit%> class="form-control input-sm">
                                <option value="1" <%=inventory.TempRs["is_taxable"]!=""?inventory.TempRs["is_taxable"].ToString()=="1"?"selected":"":""%>>Yes</option>
                                <option value="0" <%=inventory.TempRs["is_taxable"]!=""?inventory.TempRs["is_taxable"].ToString()=="0"?"selected":"":""%>>No</option>
                            </select>
                        </div>
                        <label for="effective_date" class="col-md-2 col-sm-5 control-label">Effective Date <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="effective_date" id="effective_date" value="<%=inventory.TempRs["effective_date"]!=""?Convert.ToDateTime(inventory.TempRs["effective_date"].ToString()).ToString("dd-MM-yyyy"):DateTime.Now.ToString("dd-MM-yyyy")%>" <%=inventory.diasableit%> required class="form-control input-sm" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="footer_text" class="col-md-2 col-sm-5 control-label">Footer Text </label>
                        <div class="col-md-10 col-sm-7">
                            <input type="text" name="footer_text" id="footer_text" value="<%=inventory.TempRs["footer_text"]%>" <%=inventory.diasableit%> class="form-control input-sm" />
                        </div>
                    </div>

                </div>
                <div class="box-footer" style="text-align:center">
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
        $('#effective_date').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
        });
    });
</script>


<!-- #include file="../footer.aspx"-->
