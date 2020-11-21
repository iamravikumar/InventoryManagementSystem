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

    /* read purchase order prefix */
    function getItemData(e) {
        var xmlhttp;
        if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        }
        else {// code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                var data = JSON.parse(xmlhttp.responseText);
                document.getElementById("unit_qty_type").innerHTML = "(In " + data.symbol + ")";
                document.getElementById("item_unit_qty").value = data.formal_name + " (" + data.symbol + ")";
                document.getElementById("hidpurchase_rate").value = data.purchase_rate;
                document.getElementById("hidsale_rate").value = data.sale_rate;
                document.getElementById("hidmrp").value = data.mrp;
                getItQty();
            }
        }
        xmlhttp.open("POST", "support/getItems.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("value=" + e.value);
    }
    function sumofob(e) {
        var pr = document.getElementById("hidpurchase_rate").value;
        var sr = document.getElementById("hidsale_rate").value;
        var mrp = document.getElementById("hidmrp").value;
        if (pr == "")
            pr = 0;
        if (sr == "")
            sr = 0;
        if (mrp == "")
            mrp = 0;
        var totpr = parseFloat(pr) * parseFloat(e);
        var totsr = parseFloat(sr) * parseFloat(e);
        var totmrp = parseFloat(mrp) * parseFloat(e);
        document.getElementById("purchase_rate").value = totpr.toFixed(2);
        document.getElementById("sale_rate").value = totsr.toFixed(2);
        document.getElementById("mrp").value = totmrp.toFixed(2);
    }

    function getItQty() {
        var $test_val = $("select#item_name").val();
        var $select = $('#other_unit_id');
        $select.find('option').remove();
        $('<option>').val("").text("Select").appendTo($select);
        $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("tbl_unit_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("symbol")%>", where: "<%=Crypto.Encrypt("(id not in (select per_unit_qty from tbl_item_master where status=1 and id=0?))")%>", whereArgs: "'" + $test_val + "'", orderby: "<%=Crypto.Encrypt("symbol asc")%>" }, function (responseJson) {
            $.each(responseJson, function (key, value) {
                $('<option>').val(key).text(value).appendTo($select);
            });
        });
    }
</script>
<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Items Measurment Setup</h3>
                <div class="box-tools pull-right">
                    <a href="itemqty_list.aspx" class="btn btn-primary"><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <%inventory.Execute();%>

                    <div class="form-group row">
                        <label for="item_name" class="col-md-2 col-sm-5 control-label">Item Name <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="item_name" id="item_name" <%=inventory.diasableit%> required class="form-control input-sm select2" onchange="getItemData(this)">
                                <option value="">Select</option>
                                <%
                                SqlDataReader rdr = inventory.GetDataReader("select * from tbl_item_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by item_name asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["item_id"]?"selected":""%>><%=rdr["item_name"] %> (<%=rdr["item_code"] %>)</option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>

                        <label for="item_unit_qty" class="col-md-2 col-sm-5 control-label">Unit </label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="item_unit_qty" id="item_unit_qty" value="<%=inventory.TempRs["formal_name"] %> (<%=inventory.TempRs["symbol"] %>)" readonly class="form-control input-sm" <%=inventory.diasableit%> />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="other_unit_id" class="col-md-2 col-sm-5 control-label">Different Unit <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <select name="other_unit_id" id="other_unit_id" <%=inventory.diasableit%> class="form-control input-sm" required>
                                <option value="">Select</option>
                                <%
                                    string where="";
                                    if(inventory.TempRs["per_unit_qty"]!=null && inventory.TempRs["per_unit_qty"]!="")
                                    {   
                                        where+=" and id!='"+inventory.TempRs["per_unit_qty"]+"'";
                                    }
                                rdr = inventory.GetDataReader("select * from tbl_unit_master where company_id='" + inventory.COMPANY["id"] + "' "+where+" and status=1 order by formal_name asc");
                                while (rdr.Read())
                                { 
                                %>
                                <option value="<%=rdr["id"]%>" <%=rdr["id"].ToString()==inventory.TempRs["other_unit_id"]?"selected":""%>><%=rdr["symbol"] %> (<%=rdr["formal_name"] %>)</option>
                                <%
                                } rdr.Close();
                                %>
                            </select>
                        </div>

                        <label for="def_unit" class="col-md-2 col-sm-5 control-label">Unit Quantity
                            <label id="unit_qty_type"></label>
                            <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="def_unit" id="def_unit" value="<%=inventory.TempRs["def_unit"] %>" class="form-control input-sm" required onkeyup="sumofob(this.value)" <%=inventory.diasableit%> />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="purchase_rate" class="col-md-2 col-sm-5 control-label">Purchase Rate <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="purchase_rate" id="purchase_rate" value="<%=inventory.TempRs["purchase_rate"]!=""?inventory.TempRs["purchase_rate"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>

                        <label for="sale_rate" class="col-md-2 col-sm-5 control-label">Sale Rate <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="sale_rate" id="sale_rate" value="<%=inventory.TempRs["sale_rate"]!=""?inventory.TempRs["sale_rate"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>
                    </div>

                    <div class="form-group row">
                        <label for="mrp" class="col-md-2 col-sm-5 control-label">MRP <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="mrp" id="mrp" value="<%=inventory.TempRs["mrp"]!=""?inventory.TempRs["mrp"]:"0"%>" class="form-control input-sm" required <%=inventory.diasableit%> />
                        </div>

                        <label for="effective_date" class="col-md-2 col-sm-5 control-label">Effective Date  <span style="font-weight: bold; color: red">*</span></label>
                        <div class="col-md-4 col-sm-7">
                            <input type="text" name="effective_date" id="effective_date" value="<%=inventory.TempRs["effective_date"]!=""?Convert.ToDateTime(inventory.TempRs["effective_date"].ToString()).ToString("dd-MM-yyyy"):DateTime.Now.ToString("dd-MM-yyyy")%>" <%=inventory.diasableit%> required class="form-control input-sm" />
                        </div>
                    </div>

                </div>
                <div class="box-footer" style="text-align:center">
                    <input type="hidden" name="hidpurchase_rate" id="hidpurchase_rate" />
                    <input type="hidden" name="hidsale_rate" id="hidsale_rate" />
                    <input type="hidden" name="hidmrp" id="hidmrp" />
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
