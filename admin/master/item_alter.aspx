<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $(".select2").select2();
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
                opening_quantity: { decimal: true },
                opening_rate: { decimal: true },
                total_value: { decimal: true },
                purchase_rate: { decimal: true },
                sale_rate: { decimal: true },
                mrp_rate: { decimal: true },
                cgst: { decimal: true },
                sgst: { decimal: true },
                igst: { decimal: true },
            },
            messages: {
            }
        });
    });

    function readsigst() {
        var cgst = $("#cgst").val();
        if (isNaN(cgst)) {
            cgst = 0;
        }
        var sgst = cgst;
        if (isNaN(sgst)) {
            sgst = 0;
        }
        var igst = parseFloat(cgst) + parseFloat(sgst);
        $("#cgst").val(cgst);
        $("#sgst").val(sgst);
        $("#igst").val(igst);
    }

    function sumofob() {
        var oq = document.getElementById("opening_quantity").value;
        var or = document.getElementById("opening_rate").value;
        if (oq == "")
            oq = 0;
        if (or == "")
            or = 0;
        var tot = parseFloat(oq) * parseFloat(or);
        document.getElementById("total_value").value = tot.toFixed(2);
    }
    function copyPrintName(e) {
        document.getElementById("print_name").value = e.value
    }

    /* add stockgrp */
    function addStockGroup() {
        var sgname = $("#sgname").val();
        var sgdescription = $("#sgdescription").val();
        var xmlhttp;
        if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        }
        else {// code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                alert("Stock Group Successfully Added.");
                var i = 0;
                var $select = $('#stockgrp');
                $select.find('option').remove();
                $('<option>').val("").text("Select").appendTo($select);
                $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("tbl_stockgroup_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("name +' (' + code + ')'")%>", where: "<%=Crypto.Encrypt("status=1 and company_id='"+inventory.COMPANY["id"]+"'")%>" }, function (responseJson) {
                    $.each(responseJson, function (key, value) {
                        $('<option>').val(key).text(value).appendTo($select);
                        document.getElementById("stockgrp").selectedIndex = ++i;
                    });
                });
                $("#sgname").val("");
                $("#sgdescription").val("");
            }
        }
        xmlhttp.open("POST", "support/addstockgrp.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("sgname=" + sgname + "&sgdescription=" + sgdescription + "");
    }

    /* add unitofmsrt */
    function addUnitM() {
        var symbol = $("#symbol").val();
        var formal_name = $("#formal_name").val();
        var xmlhttp;
        if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        }
        else {// code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                alert("Unit Of Measurment Successfully Added.");
                var i = 0;
                var $select = $('#qty_type');
                $select.find('option').remove();
                $('<option>').val("").text("Select").appendTo($select);
                $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("tbl_unit_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("symbol +' (' + formal_name + ')'")%>", where: "<%=Crypto.Encrypt("status=1 and company_id='"+inventory.COMPANY["id"]+"'")%>" }, function (responseJson) {
                    $.each(responseJson, function (key, value) {
                        $('<option>').val(key).text(value).appendTo($select);
                        document.getElementById("qty_type").selectedIndex = ++i;
                    });
                });
                $("#symbol").val("");
                $("#formal_name").val("");
            }
        }
        xmlhttp.open("POST", "support/addUnitoM.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("symbol=" + symbol + "&formal_name=" + formal_name + "");
    }

</script>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Item Master</h3>
                <div class="box-tools pull-right">
                    <a href="item_list.aspx?cmd=Clear" class="btn btn-primary "><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();
                        
                        string itmcode = inventory.TempRs["item_code"];
                        if(String.IsNullOrWhiteSpace(itmcode))
                        {
                            itmcode = inventory.getItmCode();
                        }
                        
                    %>

                    <div class="form-group row">
                        <label for="item_code" class="col-md-2 col-sm-5 control-label">Item Code <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="item_code" id="item_code" value="<%=itmcode%>" <%=inventory.diasableit%> required readonly class="form-control input-sm" maxlength="100" />
                        </div>

                        <label for="stockgrp" class="col-md-2 col-sm-5 control-label">
                            Stock Group <span style="font-weight: bold; color: red">*</span>&nbsp
                             <span aria-hidden="true" style="cursor: pointer; color: coral; border: solid 2px #000000; padding-left: 2px; padding-right: 2px" title="Click here to add new stock group" data-toggle="modal" data-target="#stkgrpModel">&nbsp;+&nbsp</span>
                        </label>
                        <div class="col-md-4 col-sm-7">
                            <select name="stockgrp" id="stockgrp" <%=inventory.diasableit%> required class="form-control input-sm">
                                <option value="">Select</option>
                                <%
                                SqlDataReader rdr = inventory.GetDataReader("select * from tbl_stockgroup_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by name asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["stockgrp_id"]?"selected":""%>><%=rdr["name"] %> (<%=rdr["code"] %>)</option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="item_name" class="col-md-2 col-sm-5 control-label">Item Name <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="item_name" id="item_name" value="<%=inventory.TempRs["item_name"]%>" <%=inventory.diasableit%> required class="form-control input-sm" maxlength="100" onkeyup="copyPrintName(this)" />
                        </div>
                        <label for="print_name" class="col-md-2 col-sm-5 control-label">Item Print Name <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="print_name" id="print_name" value="<%=inventory.TempRs["print_name"]%>" <%=inventory.diasableit%> required class="form-control input-sm" maxlength="100" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="manufacture_name" class="col-md-2 col-sm-5 control-label">Manufacture Name <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="manufacture_name" id="manufacture_name" value="<%=inventory.TempRs["manufacture_name"]%>" <%=inventory.diasableit%> required class="form-control input-sm" maxlength="100" />
                        </div>
                        <label for="barcode" class="col-md-2 col-sm-5 control-label">Item Barcode </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="barcode" id="barcode" value="<%=inventory.TempRs["barcode"]%>" <%=inventory.diasableit%> class="form-control input-sm" maxlength="100" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="qty_type" class="col-md-2 col-sm-5 control-label">
                            Unit <span style="font-weight: bold; color: red">*</span>
                            &nbsp;
                             <span aria-hidden="true" style="cursor: pointer; color: coral; border: solid 2px #000000; padding-left: 2px; padding-right: 2px" title="Click here to add new unit of measurment" data-toggle="modal" data-target="#qtyModel">+ </span>
                        </label>
                        <div class="col-md-4 col-sm-7">
                            <select name="qty_type" id="qty_type" <%=inventory.diasableit%> required class="form-control input-sm">
                                <option value="">Select</option>
                                <%
                                rdr = inventory.GetDataReader("select * from tbl_unit_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by symbol asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["per_unit_qty"]?"selected":""%>><%=rdr["symbol"] %> (<%=rdr["formal_name"]%>)</option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>

                        <label for="purchase_rate" class="col-md-2 col-sm-5 control-label">Purchase Rate <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="purchase_rate" id="purchase_rate" value="<%=inventory.TempRs["purchase_rate"]!=""?inventory.TempRs["purchase_rate"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="sale_rate" class="col-md-2 col-sm-5 control-label">Sale Rate <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="sale_rate" id="sale_rate" value="<%=inventory.TempRs["sale_rate"]!=""?inventory.TempRs["sale_rate"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>

                        <label for="mrp" class="col-md-2 col-sm-5 control-label">MRP <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="mrp" id="mrp" value="<%=inventory.TempRs["mrp"]!=""?inventory.TempRs["mrp"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="cgst" class="col-md-2 col-sm-5 control-label">CGST (In %) <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="cgst" id="cgst" value="<%=inventory.TempRs["cgst"]!=""?inventory.TempRs["cgst"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> onkeyup="readsigst()" />
                        </div>

                        <label for="sgst" class="col-md-2 col-sm-5 control-label">SGST (In %) <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="sgst" id="sgst" readonly value="<%=inventory.TempRs["sgst"]!=""?inventory.TempRs["sgst"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="igst" class="col-md-2 col-sm-5 control-label">IGST (In %) <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="igst" id="igst" readonly value="<%=inventory.TempRs["igst"]!=""?inventory.TempRs["igst"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>

                        <label for="hsn_code" class="col-md-2 col-sm-5 control-label">HSN Code </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="hsn_code" id="hsn_code" value="<%=inventory.TempRs["hsn_code"] %>" class="form-control input-sm" maxlength="50" <%=inventory.diasableit%> />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="opening_quantity" class="col-md-2 col-sm-5 control-label">Opening Quantity </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="opening_quantity" id="opening_quantity" value="<%=inventory.TempRs["opening_quantity"]!=""?inventory.TempRs["opening_quantity"]:"0"%>" <%=inventory.diasableit%> class="form-control input-sm" onkeyup="sumofob()" />
                        </div>

                        <label for="opening_rate" class="col-md-2 col-sm-5 control-label">Opening Rate </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="opening_rate" id="opening_rate" value="<%=inventory.TempRs["opening_rate"]!=""?inventory.TempRs["opening_rate"]:"0"%>" <%=inventory.diasableit%> class="form-control input-sm" onkeyup="sumofob()" />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="total_value" class="col-md-2 col-sm-5 control-label">Total Value </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="total_value" id="total_value" value="<%=inventory.TempRs["total_value"]!=""?inventory.TempRs["total_value"]:"0"%>" <%=inventory.diasableit%> class="form-control input-sm" readonly />
                        </div>


                        <label for="storeid" class="col-md-2 col-sm-5 control-label">Store <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="storeid" id="storeid" <%=inventory.diasableit%> class="form-control input-sm">
                                <option value="">Select</option>
                                <%
                                rdr = inventory.GetDataReader("select * from tbl_store_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by name asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["store_id"]?"selected":""%>><%=rdr["name"] %> (<%=rdr["code"] %>)</option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>
                    </div>

                    <!-- ====================================================Stock grp Modal start ===========================================================-->
                    <div class="modal fade" id='stkgrpModel' tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header btn btn-danger" style="width: 100%;">
                                    <span style="float: left"><strong>ADD NEW STOCK GROUP</strong></span>
                                    <span data-dismiss="modal" aria-label="Close" style="float: right" class="btn">X</span>
                                </div>
                                <div class="modal-body">
                                    <!-- start Editable field-->
                                    <div class="form-group row">
                                        <label for="name" class="col-md-3 col-sm-5 control-label">Name <span style="color: red;">*</span></label>
                                        <div class="col-md-9 col-sm-7">
                                            <input type="text" name="sgname" id="sgname" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="sgdescription" class="col-md-3 col-sm-5 control-label">Description </label>
                                        <div class="col-md-9 col-sm-7">
                                            <input type="text" name="sgdescription" id="sgdescription" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <!-- end Editable field-->
                                </div>
                                <div class="modal-footer">
                                    <input type="button" class="btn btn-success" name="addSG" value="ADD" data-dismiss="modal" aria-label="Close" onclick="addStockGroup()" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- ====================================================Stock grp Modal start ===========================================================-->



                    <!-- ====================================================Unit Modal start ===========================================================-->
                    <div class="modal fade" id='qtyModel' tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header btn btn-danger" style="width: 100%;">
                                    <span style="float: left"><strong>ADD NEW UNIT OF MEASURMENT</strong></span>
                                    <span data-dismiss="modal" aria-label="Close" style="float: right" class="btn">X</span>
                                </div>
                                <div class="modal-body">
                                    <!-- start Editable field-->
                                    <div class="form-group row">
                                        <label for="symbol" class="col-md-3 col-sm-5 control-label">Symbol <span style="color: red;">*</span></label>
                                        <div class="col-md-9 col-sm-7">
                                            <input type="text" name="symbol" id="symbol" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="formal_name" class="col-md-3 col-sm-5 control-label">Formal Name <span style="color: red;">*</span></label>
                                        <div class="col-md-9 col-sm-7">
                                            <input type="text" name="formal_name" id="formal_name" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <!-- end Editable field-->
                                </div>
                                <div class="modal-footer">
                                    <input type="button" class="btn btn-success" name="addUoM" value="ADD" data-dismiss="modal" aria-label="Close" onclick="addUnitM()" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- ====================================================Unit Modal start ===========================================================-->

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
<!-- #include file="../footer.aspx"-->
