<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script>
    $(document).ready(function () {
        $(".select2").select2();
        $.validator.messages.required = "";
        addValidator();
        $("#FORM1").validate({
            rules: {
            },
            messages: {
            }
        });
    });

    function sumofob() {
        var oq = document.getElementById("nwopening_quantity").value;
        var or = document.getElementById("nwopening_rate").value;
        if (oq == "")
            oq = 0;
        if (or == "")
            or = 0;
        var tot = parseFloat(oq) * parseFloat(or);
        document.getElementById("nwtotal_value").value = tot.toFixed(2);
    }
    function copyPrintName(e) {
        document.getElementById("nwprint_name").value=e.value
    }

    function selectItem(eArg) {
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
                $('#nwstoreid').val(data.store_id).change();
                $('#nwstockgrp').val(data.stockgrp_id).change();
                $('#nwitem_name').val(data.item_name);
                $('#nwprint_name').val(data.print_name);
                $('#nwmanufacture_name').val(data.manufacture_name);
                $('#nwbarcode').val(data.barcode);
                $('#nwqty_type').val(data.per_unit_qty).change();
                $('#nwpurchase_rate').val(data.purchase_rate);
                $('#nwsale_rate').val(data.sale_rate);
                $('#nwmrp').val(data.mrp);
                $('#nwcgst').val(data.cgst);
                $('#nwsgst').val(data.sgst);
                $('#nwigst').val(data.igst);
                $('#nwhsn_code').val(data.hsn_code);
                $('#nwopening_quantity').val(data.opening_quantity);
                $('#nwopening_rate').val(data.opening_rate);
                $('#nwtotal_value').val(data.total_value);
                $('#addNewItem').val("Update");
                if (data.type == "error") {
                    $('#addNewItem').val("Add");
                }
            }
        }
        xmlhttp.open("POST", "../support/getItems.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("value=" + eArg);
    }

    /* add addItemData */
    function addItemData() {
        var nwstoreid = $('#nwstoreid').val();
        var nwstockgrp = $('#nwstockgrp').val();
        var nwitem_name = $('#nwitem_name').val();
        var nwprint_name = $('#nwprint_name').val();
        var nwmanufacture_name = $('#nwmanufacture_name').val();
        var nwbarcode = $('#nwbarcode').val();
        var nwqty_type = $('#nwqty_type').val();
        var nwpurchase_rate = $('#nwpurchase_rate').val();
        var nwsale_rate = $('#nwsale_rate').val();
        var nwmrp = $('#nwmrp').val();
        var nwcgst = $('#nwcgst').val();
        var nwsgst = $('#nwsgst').val();
        var nwigst = $('#nwigst').val();
        var nwhsn_code = $('#nwhsn_code').val();
        var nwopening_quantity = $('#nwopening_quantity').val();
        var nwopening_rate = $('#nwopening_rate').val();
        var nwtotal_value = $('#nwtotal_value').val();
        var select_item = $('#select_item').val();
        var xmlhttp;
        if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        }
        else {// code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                alert("Item Successfully Added.");
                var i = 0;
                var $select = $('#item_name');
                $select.find('option').remove();
                $('<option>').val("").text("Select").appendTo($select);
                $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("tbl_item_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("item_name + ' (' + item_code + ')'")%>", where: "<%=Crypto.Encrypt("status=1 and company_id='"+inventory.COMPANY["id"]+"'")%>" }, function (responseJson) {
                    $.each(responseJson, function (key, value) {
                        $('<option>').val(key).text(value).appendTo($select);
                        $("#item_name").val(xmlhttp.responseText).change();
                    });
                });
                $('#nwstoreid').val("").change();
                $('#nwstockgrp').val("").change();
                $('#nwitem_name').val("");
                $('#nwprint_name').val("");
                $('#nwmanufacture_name').val("");
                $('#nwbarcode').val("");
                $('#nwqty_type').val("").change();
                $('#nwpurchase_rate').val("0.00");
                $('#nwsale_rate').val("0.00");
                $('#nwmrp').val("0.00");
                $('#nwcgst').val("0.00");
                $('#nwsgst').val("0.00");
                $('#nwigst').val("0.00");
                $('#nwhsn_code').val("");
                $('#nwopening_quantity').val("0");
                $('#nwopening_rate').val("0");
                $('#nwtotal_value').val("0");
                $('#select_item').val("").change();
                $('#addNewItem').val("Add");
            }
        }
        xmlhttp.open("POST", "../support/addUpdateItem.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("select_item=" + select_item + "&nwstoreid=" + nwstoreid + "&nwstockgrp=" + 
            nwstockgrp + "&nwitem_name=" + nwitem_name + "&nwprint_name=" + nwprint_name + "&nwmanufacture_name=" + 
            nwmanufacture_name + "&nwbarcode=" + nwbarcode + "&nwqty_type=" + nwqty_type + "&nwpurchase_rate=" + nwpurchase_rate + "&nwsale_rate=" + 
            nwsale_rate + "&nwmrp=" + nwmrp + "&nwcgst=" + nwcgst + "&nwsgst=" + 
            nwsgst + "&nwigst=" + nwigst + "&nwhsn_code=" + nwhsn_code + "&nwopening_quantity=" + 
            nwopening_quantity + "&nwopening_rate=" + nwopening_rate + "&nwtotal_value=" + nwtotal_value + "");
    }

    function reset() {
        $("#item_name").
        $("#item_qty").val("").change();
        $("#usp").val("0.00");
    }

    $.fn.focusNextInputField = function () {
        return this.each(function () {
            var fields = $(this).parents('form:eq(0),body').find('button,input,textarea,select');
            var index = fields.index(this);
            if (index > -1 && (index + 1) < fields.length) {
                fields.eq(index + 1).focus();
            }
            return false;
        });
    };

    
    function selectsupplier(eArg) {
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
                $('#name').val(data.name);
                $('#email').val(data.email);
                $('#mobile_no').val(data.mobile_no);
                $('#contact_no').val(data.contact_no);
                $('#address_1').val(data.address_1);
                $('#address_2').val(data.address_2);
                $('#city').val(data.city);
                $('#state').val(data.state_id).change();
                $('#pincode').val(data.pincode);
                $('#pan_no').val(data.pan_no);
                $('#gstin_no').val(data.gstin_no);
                $('#gstin_type').val(data.gstin_type_id).change();
                $('#billing_type').val(data.billing_type).change();
                $('#master_discount').val(data.master_discount);
                $('#addSupplier').val("Update");
                if (data.type == "error") {
                    $('#addSupplier').val("Add");
                }
            }
        }
        xmlhttp.open("POST", "../support/getLedger.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("value=" + eArg);
    }

    /* add addsupplier */
    function addSupplierData() {
        var name = $('#name').val();
        var email = $('#email').val();
        var mobile_no = $('#mobile_no').val();
        var contact_no = $('#contact_no').val();
        var address_1 = $('#address_1').val();
        var address_2 = $('#address_2').val();
        var city = $('#city').val();
        var state = $('#state').val();
        var pincode = $('#pincode').val();
        var pan_no = $('#pan_no').val();
        var gstin_no = $('#gstin_no').val();
        var gstin_type = $('#gstin_type').val();
        var billing_type = $('#billing_type').val();
        var master_discount = $('#master_discount').val();
        var select_supplier = $('#select_supplier').val();
        var xmlhttp;
        if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
            xmlhttp = new XMLHttpRequest();
        }
        else {// code for IE6, IE5
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                alert("Supplier Successfully Added.");
                var i = 0;
                var $select = $('#supplier');
                $select.find('option').remove();
                $('<option>').val("").text("Select").appendTo($select);
                $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("view_ledger_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("name + ' /' + code + ' /' + mobile_no + ' /' + address_1")%>", where: "<%=Crypto.Encrypt("group_name='SUNDRY CREDITORS' and status=1 and company_id='"+inventory.COMPANY["id"]+"'")%>" }, function (responseJson) {
                    $.each(responseJson, function (key, value) {
                        $('<option>').val(key).text(value).appendTo($select);
                        $("#supplier").val(xmlhttp.responseText).change();
                    });
                });
                $('#name').val("");
                $('#email').val("");
                $('#mobile_no').val("");
                $('#contact_no').val("");
                $('#address_1').val("");
                $('#address_2').val("");
                $('#city').val("");
                $('#state').val("").change();
                $('#pincode').val("");
                $('#pan_no').val("");
                $('#gstin_no').val("");
                $('#gstin_type').val("").change();
                $('#billing_type').val("").change();
                $('#master_discount').val("0.00");
                $('#addSupplier').val("Add");
                $('#select_supplier').val("").change();
            }
        }
        xmlhttp.open("POST", "../support/addLedger.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("select_supplier=" + select_supplier + "&name=" + name + "&email=" + email + "&mobile_no=" + mobile_no + "&contact_no=" + contact_no + "&address_1=" + address_1 + "&address_2=" + address_2 + "&city=" + city + "&state=" + state + "&pincode=" + pincode + "&pan_no=" + pan_no + "&gstin_no=" + gstin_no + "&gstin_type=" + gstin_type + "&billing_type=" + billing_type + "&master_discount=" + master_discount + "&group=4");
    }

    function getDet(e) {
        var supplier = $("#supplier").val();
        var item = $("#item_name").val();
        if(supplier=="" && item!="")
        {
            alert("First select supplier");
            $("#item_name").val("").change();
            return;
        }
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
                $("#usp").val(data.purchase_rate);
                $("#item_qty").val("").change();
                getItQty(e.id, "item_qty_type");
            }
        }
        xmlhttp.open("POST", "../support/getItems.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("value=" + e.value);
    }

    function getDetByQty(e) {
        var itemval = $("#item_name").val();
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
                $("#usp").val(data.purchase_rate);
                var pr = data.purchase_rate;
                if (pr == "")
                    pr = 0;
                var tot = parseFloat(data.purchase_rate) * parseFloat($("#item_qty").val());
                $("#vsp").val(tot.toFixed(2));
            }
        }
        xmlhttp.open("POST", "../support/getItemsByQty.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("value=" + e.value + "&itemval=" + itemval);
    }

    function deleteRow(arg) {
        var r = confirm("Do you want to delete item from list?");

        if (r == true) {
            var xmlhttp;
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    $("#item_list").load(location.href + " #item_list");
                    $("#boxfooter").load(location.href + " #boxfooter");
                
                }
            }
            xmlhttp.open("POST", "../support/deleteitem.aspx", true);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send("row_id=" + arg);
        }
    }

    //code for add item details in data table
    $(document).ready(function () {
        $('#add').click(function (event) {
            var $sup = $("#supplier option:selected").val();
            var $item_name = $("#item_name option:selected").val();
            var $item_qty = $("#item_qty").val();
            var $item_qty_type = $("#item_qty_type option:selected").val();
            var $usp = $('#usp').val();
            var $vsp = $('#vsp').val();
            var $add = $('#add').val();
            $('#add').val("Wait For Process...");
            $.post('../support/additem.aspx', { sup: $sup, item_name: $item_name, item_qty: $item_qty, item_qty_type: $item_qty_type, usp: $usp, vsp: $vsp, add: $add }, function (data, status) {
                $("#item_list").load(location.href + " #item_list");
                $("#boxfooter").load(location.href + " #boxfooter");
                $("#add").val("ADD");
                $("#supplier").attr("disabled", true);
                $("#item_name").val("").change();
                $("#item_qty").val("0");
                $("#item_qty_type").val("").change();
                $("#usp").val("0");
                $("#vsp").val("0");
                $("#item_name").focus();
            });
        });
    });

    
    //code for get supplier dues
    $(document).ready(function () {
        $('#supplier').change(function (event) {
            var $supplier = $("#supplier option:selected").val();            
            $.post('../support/readcredit.aspx', { supplier: $supplier }, function (data, status) {
                if(data.type=="error")
                    $('#creditamt').html("");
                else
                    if(data.baltype=="None")
                        $('#creditamt').html("CR :- &#8377; " + data.bal);
                    else
                        $('#creditamt').html(data.baltype + ":- &#8377; " + data.bal);
            });
        });
    });
    
    //code for add item details in data table
    $(document).ready(function () {
        $('#item_qty').change(function () {
            var pr = $("#usp").val();
            if (pr == "")
                pr = 0;
            var tot = parseFloat(pr) * parseFloat($("#item_qty").val());
            $("#vsp").val(tot.toFixed(2));
        });
    });
    $(document).ready(function () {
        $('#usp').keyup(function () {
            var pr = $("#item_qty").val();
            if (pr == "")
                pr = 0;
            var tot = parseFloat(pr) * parseFloat($("#usp").val());
            $("#vsp").val(tot.toFixed(2));
        });
    });

    /* Find Item Quantity */
    function getItQty(e, u) {
        var $test_val = $("select#" + e).val();
        var $select = $('#' + u);
        $select.find('option').remove();
        $('<option>').val("").text("Select").appendTo($select);
        $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("tbl_unit_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("symbol")%>", where: "<%=Crypto.Encrypt("(id in (select per_unit_qty from tbl_item_master where status=1 and id=0?)) or (id in (select other_unit_id from tbl_item_qty_master where status=1 and item_id=0? group by other_unit_id))")%>", whereArgs: "'" + $test_val + "'" }, function (responseJson) {
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
                <h3 class="box-title">Purchase Order</h3>
                <div class="box-tools pull-right">
                    <a href="purchase_list.aspx?cmd=Clear" class="btn btn-primary"><i class="fa fa-fw fa-long-arrow-left"></i>Go To List</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <% inventory.Execute();

                        string order_no = "";
                        string required="required";
                        string read_only="readonly onfocus='setReadOnly(this)' onblur='hideReadOnly(this)'";
                        Hashtable poInv=new Hashtable();
                        if(Request["uid"]==null)
                        {
                            poInv=inventory.getInvoice("PURCHASE");
                            if(poInv["invType"].ToString()=="MANUAL")
                            {
                                read_only="";
                            }
                            else {
                                order_no = poInv["invNo"].ToString();
                            }
                        }
                        
                        DataTable dtItem =null;
                        if (Session["dtItem"] == null)
                        {
                            dtItem = new DataTable();
                            dtItem.Columns.Add("lgr_id");
                            dtItem.Columns.Add("item_id");
                            dtItem.Columns.Add("order_qty");
                            dtItem.Columns.Add("unit_id");
                            dtItem.Columns.Add("usp");
                            dtItem.Columns.Add("vsp");

                            SqlDataReader dr1 = inventory.GetDataReader("select * from tbl_order_item_details where inv_id='" + inventory.TempRs["id"] + "' and status=1 order by id asc");
                            while(dr1.Read())
                            {
                                dtItem.Rows.Add(inventory.TempRs["ledger_id"], dr1["item_id"], dr1["unit"], dr1["unit_id"], dr1["purchase_rate"], dr1["total_purchase_rate"]);
                            }

                            Session["dtItem"] = dtItem;
                        }
                        else
                        {
                            dtItem = (DataTable)Session["dtItem"];
                        }

                        string disabled = "";
                        string lgr_id="";
                        if(dtItem.Rows.Count>0)
                        {
                            lgr_id = dtItem.Rows[0].Field<string>(0);
                            disabled = "disabled";
                        }

                         string dues="";
                        if(!string.IsNullOrWhiteSpace(lgr_id))
                        {
                            dues="CR :- &#8377; 0.00";
                            Hashtable ldue = inventory.GetRecords("select * from tbl_transaction_master where company_id='" + inventory.COMPANY["id"] + "' and ledger_id='"+lgr_id+"' order by id desc");
                            if(ldue.Count>0)
                            {
                                dues= ldue["bal_type"] + ":- &#8377; " + ldue["bal"];
                            }
                        }

                    %>
                    <br />


                    <div class="form-group row">
                        <div class="col-md-7 col-sm-12">
                            <div class="form-group row">
                                <label for="supplier" class="col-md-3 col-sm-5 control-label">Supplier <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-9 col-sm-7 ">
                                    <div class="col-md-11 col-sm-11" style="padding-left: 0px">
                                        <select name="supplier" id="supplier" required class="form-control input-sm" <%=disabled %> style="cursor:pointer"> 
                                            <option value="">Select</option>
                                            <%
                                            DataTable dtLdg = inventory.GetDataTable("select id,name,code,mobile_no, address_1 from tbl_ledger_master where company_id='" + inventory.COMPANY["id"] + "' and group_id='4' and status=1 order by id asc");
                                            foreach(DataRow rdt in dtLdg.Rows)
                                            { 
                                            %>
                                                <option value="<%=rdt["id"]%>" <%=lgr_id!=""?rdt["id"].ToString()==lgr_id?"selected":"":"" %>><%=rdt["name"] %> /<%=rdt["code"] %> /<%=rdt["mobile_no"] %> /<%=rdt["address_1"] %></option>
                                            <%
                                            } 
                                            %>
                                        </select>
                                    </div>
                                    <div class="col-md-1 col-sm-1" style="padding-left: 0px">
                                        <span aria-hidden="true" style="cursor: pointer; color: coral; border: solid 2px #000000; padding-left: 2px; padding-right: 2px" title="Click here to add new supplier" data-toggle="modal" data-target="#supModel"><b>+</b></span>


                                        <!-- Modal start -->
                                        <div class="modal fade" id='supModel' tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                                            <div class="modal-dialog" role="document">
                                                <div class="modal-content">
                                                    <div class="modal-header btn btn-danger" style="width: 100%;">
                                                        <span style="float: left"><strong>ADD/EDIT SUPPLIER</strong></span>
                                                        <span data-dismiss="modal" aria-label="Close" style="float: right" class="btn">X</span>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="form-group row">
                                                            <label for="select_supplier" class="col-md-2 col-sm-5 control-label">Select Supplier <span style="font-weight: bold; color: red">*</span></label>
                                                            <div class="col-md-10 col-sm-7">
                                                                <select name="select_supplier" id="select_supplier" class="form-control input-sm" onchange="selectsupplier(this.value)">
                                                                    <option value="">Add New</option>
                                                                    <%
                                                                    foreach(DataRow rdt in dtLdg.Rows)
                                                                    { 
                                                                    %>
                                                                    <option value="<%=rdt["id"]%>"><%=rdt["name"] %> /<%=rdt["code"] %> /<%=rdt["mobile_no"] %> /<%=rdt["address_1"] %></option>
                                                                    <%
                                                                    } 
                                                                    %>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <hr />
                                                        <div class="form-group row">
                                                            <label for="name" class="col-md-2 col-sm-5 control-label">Ledger Name <span style="font-weight: bold; color: red">*</span></label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="name" id="name" value="" class="form-control input-sm" maxlength="200" />
                                                            </div>
                                                            <label for="email" class="col-md-2 col-sm-5 control-label">E-Mail</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="email" name="email" id="email" value="" class="form-control input-sm" />
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="mobile_no" class="col-md-2 col-sm-5 control-label">Mobile No</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="mobile_no" id="mobile_no" value="" class="form-control input-sm" maxlength="10" />
                                                            </div>
                                                            <label for="contact_no" class="col-md-2 col-sm-5 control-label">Contact No</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="contact_no" id="contact_no" value="" class="form-control input-sm" maxlength="20" />
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="address_1" class="col-md-2 col-sm-5 control-label">Address 1</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="address_1" id="address_1" value="" class="form-control input-sm" maxlength="200" />
                                                            </div>
                                                            <label for="address_2" class="col-md-2 col-sm-5 control-label">Address 2</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="address_2" id="address_2" value="" class="form-control input-sm" maxlength="200" />
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="city" class="col-md-2 col-sm-5 control-label">City </label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="city" id="city" value="" class="form-control input-sm" maxlength="50" />
                                                            </div>
                                                            <label for="state" class="col-md-2 col-sm-5 control-label">State <span style="font-weight: bold; color: red">*</span></label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <select name="state" id="state" class="form-control input-sm" required>
                                                                    <option value="">Select</option>
                                                                    <%
                                                                    SqlDataReader rdr = inventory.GetDataReader("select id,state_name from tbl_state_master where status=1 order by state_code asc");
                                                                    while (rdr.Read())
                                                                    { 
                                                                    %>
                                                                    <option value="<%=rdr["id"]%>"><%=rdr["state_name"] %></option>
                                                                    <%
                                                                    } rdr.Close();
                                                                    %>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="pincode" class="col-md-2 col-sm-5 control-label">Pin Code</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="pincode" id="pincode" value="" class="form-control input-sm" maxlength="6" />
                                                            </div>
                                                            <label for="pan_no" class="col-md-2 col-sm-5 control-label">Pan No </label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="pan_no" id="pan_no" value="" class="form-control input-sm" maxlength="10" />
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="gstin_no" class="col-md-2 col-sm-5 control-label">GSTIN No.</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <input type="text" name="gstin_no" id="gstin_no" value="" class="form-control input-sm" />
                                                            </div>
                                                            <label for="gstin_type" class="col-md-2 col-sm-5 control-label">GSTIN Type</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <select name="gstin_type" id="gstin_type" class="form-control input-sm">
                                                                    <option value="">Select</option>
                                                                    <%
                                                                    rdr = inventory.GetDataReader("select id,gstin_type from tbl_gstintype_master where status=1 order by id asc");
                                                                    while (rdr.Read())
                                                                    { 
                                                                    %>
                                                                    <option value="<%=rdr["id"]%>"><%=rdr["gstin_type"] %></option>
                                                                    <%
                                                                     } rdr.Close();
                                                                    %>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="billing_type" class="col-md-2 col-sm-5 control-label">Billing Type <span style="font-weight: bold; color: red">*</span></label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <select name="billing_type" id="billing_type" class="form-control input-sm">
                                                                    <option value="">Select</option>
                                                                    <option value="BILL WISE">Bill-by-Bill</option>
                                                                    <option value="ACCOUNT WISE">Account</option>
                                                                    <option value="FIRST-IN-FIRST-OUT">First-In-First-Out</option>
                                                                </select>
                                                            </div>
                                                            <label for="master_discount" class="col-md-2 col-sm-5 control-label">Discount (In %)</label>
                                                            <div class="col-md-4 col-sm-7">
                                                                <div class="col-md-12 col-sm-12 input-group">
                                                                    <span class="input-group-addon">&#8377;
                                                                    </span>
                                                                    <input type="number" name="master_discount" id="master_discount" min="0" max="100" value="" class="form-control input-sm" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer" style="text-align: center">
                                                        <input type="button" class="btn btn-success" id="addSupplier" value="Add" data-dismiss="modal" aria-label="Close" onclick="addSupplierData()" />
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Modal end -->

                                    </div>
                                    <label class="col-md-12 col-sm-5 control-label" id="creditamt" style="color:red"><%=dues %></label>
                                </div>
                            </div>
                            <div class="form-group row">
                                <label class="col-md-3 col-sm-5 control-label">Narration</label>
                                <div class="col-md-9 col-sm-7">
                                    <textarea name="narration" id="narration" class="form-control input-sm" style="height: 80px; resize: none" maxlength="100" onkeyup="this.value=this.value.toUpperCase()"><%=inventory.TempRs["naration"] %></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5 col-sm-12">
                            <div class="form-group row">
                                <label for="po_no" class="col-md-4 col-sm-5 control-label">Order No. <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-6 col-sm-7">
                                    <input type="text" name="order_no" id="order_no" value="<%=inventory.TempRs["autogen_id"]!=""?inventory.TempRs["autogen_id"]:order_no %>" required class="form-control input-sm" <%=read_only %> onkeyup="this.value=this.value.toUpperCase()" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="po_dt" class="col-md-4 col-sm-5 control-label">Order Date <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-6 col-sm-7">
                                    <input type="text" name="order_dt" id="order_dt" required class="form-control input-sm" value="<%=inventory.TempRs["stock_dt"]!=""?Convert.ToDateTime(inventory.TempRs["stock_dt"]).ToString("dd-MM-yyyy"):DateTime.Now.ToString("dd-MM-yyyy") %>" <%=read_only %> />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="due_dt" class="col-md-4 col-sm-5 control-label">Due Date <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-6 col-sm-7">
                                    <input type="text" name="due_dt" id="due_dt" required class="form-control input-sm" value="<%=inventory.TempRs["due_dt"]!=""?Convert.ToDateTime(inventory.TempRs["due_dt"]).ToString("dd-MM-yyyy"):DateTime.Now.ToString("dd-MM-yyyy") %>" readonly />
                                </div>
                            </div>
                        </div>
                    </div>

                    <fieldset>
                        <legend>Add Items in Cart</legend>
                        <div class="form-group row">
                            <div class="col-md-4 col-sm-6">
                                <label for="item_name">Item </label>
                                <div class="col-md-11 col-sm-11" style="padding-left: 0px">
                                    <select name="item_name" id="item_name" class="form-control input-sm" onchange="getDet(this)" onblur="getDet(this)">
                                        <option value="">Select</option>
                                        <%
                                        DataTable dtitm = inventory.GetDataTable("select id,item_name,item_code from view_item_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by id asc");
                                        foreach(DataRow rdt in dtitm.Rows)
                                        { 
                                        %>
                                        <option value="<%=rdt["id"]%>"><%=rdt["item_name"] %> (<%=rdt["item_code"]%>)</option>
                                        <%
                                         } 
                                        %>
                                    </select>
                                </div>
                                <div class="col-md-1 col-sm-1" style="padding-left: 0px">
                                    <span aria-hidden="true" style="cursor: pointer; color: coral; border: solid 2px #000000; padding-left: 2px; padding-right: 2px" title="Click here to add new item" data-toggle="modal" data-target="#ItemModel"><b>+</b></span>

                                    <!-- Modal start -->
                                    <div class="modal fade" id='ItemModel' tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                                        <div class="modal-dialog" role="document">
                                            <div class="modal-content">
                                                <div class="modal-header btn btn-danger" style="width: 100%;">
                                                    <span style="float: left"><strong>ADD/EDIT ITEM</strong></span>
                                                    <span data-dismiss="modal" aria-label="Close" style="float: right" class="btn">X</span>
                                                </div>
                                                <div class="modal-body">

                                                    <div class="form-group">
                                                        <label for="select_item">Select Item</label>
                                                        <select name="select_item" id="select_item" class="form-control input-sm" onchange="selectItem(this.value)">
                                                            <option value="">Add New</option>
                                                            <%
                                                            foreach(DataRow rdt in dtitm.Rows)
                                                            { 
                                                            %>
                                                            <option value="<%=rdt["id"]%>"><%=rdt["item_name"] %> (<%=rdt["item_code"] %>)</option>
                                                            <%
                                                            } 
                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="stockgrp">Stock Group <span style="font-weight: bold; color: red">*</span></label>
                                                        <select name="nwstockgrp" id="nwstockgrp" class="form-control input-sm">
                                                            <option value="">Select</option>
                                                            <%
                                                            rdr = inventory.GetDataReader("select id,name,code from tbl_stockgroup_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by name asc");
                                                            while (rdr.Read())
                                                            { 
                                                            %>
                                                            <option value="<%=rdr["id"]%>"><%=rdr["name"] %> (<%=rdr["code"] %>)</option>
                                                            <%
                                                            } rdr.Close();
                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwitem_name">Item Name <span style="font-weight: bold; color: red">*</span></label>
                                                        <input type="text" name="nwitem_name" id="nwitem_name" value="" class="form-control input-sm" maxlength="100" onkeyup="copyPrintName(this)" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwprint_name">Item Print Name <span style="font-weight: bold; color: red">*</span></label>
                                                        <input type="text" name="nwprint_name" id="nwprint_name" value="" class="form-control input-sm" maxlength="100" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwmanufacture_name">Manufacture Name <span style="font-weight: bold; color: red">*</span></label>
                                                        <input type="text" name="nwmanufacture_name" id="nwmanufacture_name" value="" class="form-control input-sm" maxlength="100" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwbarcode">Item Barcode </label>
                                                        <input type="text" name="nwbarcode" id="nwbarcode" value="" class="form-control input-sm" maxlength="100" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwqty_type">
                                                            Unit Of Measurment <span style="font-weight: bold; color: red">*</span>
                                                        </label>
                                                        <select name="nwqty_type" id="nwqty_type" class="form-control input-sm">
                                                            <option value="">Select</option>
                                                            <%
                                                            rdr = inventory.GetDataReader("select id,symbol,formal_name from tbl_unit_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by symbol asc");
                                                            while (rdr.Read())
                                                            { 
                                                            %>
                                                            <option value="<%=rdr["id"]%>"><%=rdr["symbol"] %> (<%=rdr["formal_name"]%>)</option>
                                                            <%
                                                            } rdr.Close();
                                                            %>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwpurchase_rate">Purchase Rate <span style="font-weight: bold; color: red">*</span></label>
                                                        <div class="col-md-12 col-sm-12 input-group">
                                                            <span class="input-group-addon">&#8377;
                                                            </span>
                                                            <input type="text" name="nwpurchase_rate" id="nwpurchase_rate" value="0" class="form-control input-sm" />
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwsale_rate">Sale Rate <span style="font-weight: bold; color: red">*</span></label>
                                                        <div class="col-md-12 col-sm-12 input-group">
                                                            <span class="input-group-addon">&#8377;
                                                            </span>
                                                            <input type="text" name="nwsale_rate" id="nwsale_rate" value="" class="form-control input-sm" />
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwmrp">MRP <span style="font-weight: bold; color: red">*</span></label>
                                                        <div class="col-md-12 col-sm-12 input-group">
                                                            <span class="input-group-addon">&#8377;
                                                            </span>
                                                            <input type="text" name="nwmrp" id="nwmrp" value="" class="form-control input-sm" />
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwcgst">CGST (In %) <span style="font-weight: bold; color: red">*</span></label>
                                                        <input type="text" name="nwcgst" id="nwcgst" value="" class="form-control input-sm" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwsgst">SGST (In %) <span style="font-weight: bold; color: red">*</span></label>
                                                        <input type="text" name="nwsgst" id="nwsgst" value="" class="form-control input-sm" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwigst">IGST (In %) <span style="font-weight: bold; color: red">*</span></label>
                                                        <input type="text" name="nwigst" id="nwigst" value="" class="form-control input-sm" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwhsn_code">HSN Code </label>
                                                        <input type="text" name="nwhsn_code" id="nwhsn_code" value="" class="form-control input-sm" maxlength="50" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwopening_quantity">Opening Quantity </label>
                                                        <input type="text" name="nwopening_quantity" id="nwopening_quantity" value="" class="form-control input-sm" onkeyup="sumofob()" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwopening_rate">Opening Rate </label>
                                                        <input type="text" name="nwopening_rate" id="nwopening_rate" value="" class="form-control input-sm" onkeyup="sumofob()" />
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwtotal_value">Total Value </label>
                                                        <div class="col-md-12 col-sm-12 input-group">
                                                            <span class="input-group-addon">&#8377;
                                                            </span>
                                                            <input type="text" name="nwtotal_value" id="nwtotal_value" value="" class="form-control input-sm" readonly />
                                                        </div>
                                                    </div>

                                                    <div class="form-group">
                                                        <label for="nwstoreid">Store </label>
                                                        <select name="nwstoreid" id="nwstoreid" class="form-control input-sm">
                                                            <option value="">Select</option>
                                                            <%
                                                            rdr = inventory.GetDataReader("select id,name,code from tbl_store_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by name asc");
                                                            while (rdr.Read())
                                                            { 
                                                            %>
                                                            <option value="<%=rdr["id"]%>"><%=rdr["name"] %> (<%=rdr["code"] %>)</option>
                                                            <%
                                                            } rdr.Close();
                                                            %>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="modal-footer" style="text-align: center">
                                                    <input type="button" class="btn btn-success" id="addNewItem" value="Add" data-dismiss="modal" aria-label="Close" onclick="addItemData()" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Modal end -->

                                </div>
                            </div>
                            <div class="col-md-1 col-sm-6">
                                <label for="item_qty">Qty </label>
                                <input type="number" name="item_qty" id="item_qty" class="form-control input-sm" value="0" min="0" max="1000" />
                            </div>
                            <div class="col-md-3 col-sm-6">
                                <label for="item_qty_type">Unit </label>
                                <select name="item_qty_type" id="item_qty_type" class="form-control input-sm" onchange="getDetByQty(this)">
                                    <option value="">Select</option>
                                </select>
                            </div>
                            <div class="col-md-2 col-sm-6">
                                <label for="usp">Rate </label>
                                <div class="col-md-12 col-sm-12 input-group">
                                    <span class="input-group-addon">&#8377;
                                    </span>
                                    <input type="text" name="usp" id="usp" value="0.00" class="form-control input-sm" />
                                </div>
                            </div>
                            <div class="col-md-2 col-sm-6">
                                <label for="vsp">Total </label>
                                <div class="col-md-12 col-sm-12 input-group">
                                    <span class="input-group-addon">&#8377;
                                    </span>
                                    <input type="text" name="vsp" id="vsp" value="0.00" class="form-control input-sm" readonly />
                                </div>
                            </div>
                        </div>
                        <div class="form-group row" style="text-align: center">
                            <div class="col-md-12 col-sm-12">
                                <input type="button" name="add" id="add" value="ADD" class="btn btn-info" />
                                &nbsp;&nbsp;&nbsp;
                                <input type="button" name="btnreset" id="btnreset" value="Reset" class="btn btn-warning" onclick="reset()" />
                            </div>
                        </div>
                        <hr />

                        <div class="form-group row" style="border: solid 1px #8d8080; max-height: 450px; min-height: 250px; height: 100%; width: 99%; margin: auto; background-color: #ccc6c6; overflow: scroll;">
                            <div id="item_list">
                                <% if(dtItem.Rows.Count > 0){ %>
                                <table class="table table-bordered" id="dataTable" style="width: 100%; margin: auto">
                                    <tr>
                                        <th>#</th>
                                        <th>Item</th>
                                        <th>Quantity</th>
                                        <th>Unit</th>
                                        <th>Rate</th>
                                        <th>Total</th>
                                        <th>Delete</th>
                                    </tr>
                                    <%
                                    int i=0;
                                    foreach(DataRow rdt in dtItem.Rows){
                                    
                                    Hashtable item=inventory.GetRecords("select * from view_item_master where id='"+rdt["item_id"]+"'");
                                    Hashtable qty=inventory.GetRecords("select * from tbl_unit_master where id='"+item["per_unit_qty"]+"' or (id in (select other_unit_id from tbl_item_qty_master where status=1 and item_id='"+rdt["item_id"]+"'))");
                                    
                                    %>
                                    <tr>
                                        <td><%= ++i %></td>
                                        <td><%= item["item_name"] %> (<%=item["item_code"] %>)</td>
                                        <td><%= rdt["order_qty"] %></td>
                                        <td><%= qty["symbol"] %></td>
                                        <td><%= rdt["usp"] %></td>
                                        <td><%= rdt["vsp"] %></td>
                                        <td>
                                            <input type="button" class="btn btn-danger" value="Delete" onclick="deleteRow(<%=dtItem.Rows.IndexOf(rdt)%>)" />
                                        </td>
                                    </tr>
                                    <%}%>
                                </table>
                                <%} %>
                            </div>
                        </div>

                    </fieldset>


                    <div class="box-footer" id="boxfooter" style="text-align: center">

                        <% if(dtItem.Rows.Count > 0){ %>
                        <input type="hidden" name="invlastvalof" value="<%=poInv["invCurrVal"]%>" />
                        <input type="hidden" name="invlastiof" value="<%=poInv["invCurrId"]%>" />
                        <input type="hidden" name="invidf" value="<%=poInv["invfId"]%>" />
                        <input type="submit" class="btn btn-success" name="btn_save" value="Save" />&nbsp;&nbsp;
                        <% if(Request["uid"]!=null && Request["wid"]!=null)
                        { %>
                        <a href="order_print.aspx?uid=<%=Request["uid"] %>&wid=<%=Request["wid"] %>" class="btn btn-info">Print</a>
                        <% } } %>
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
        $('#order_dt').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            //daysOfWeekDisabled: [0], sunday disable 0-6 sun-sat
            endDate: '0d', //disable after today
        });


        
        //Date picker
        $('#due_dt').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            //daysOfWeekDisabled: [0], sunday disable 0-6 sun-sat
            startDate: '0d', //disable after today
        });
    });
</script>


<!-- #include file="../footer.aspx"-->
