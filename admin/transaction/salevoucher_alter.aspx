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
        $('#nwpurchase_rate').css('background-color','#fff');
        $('#nwsale_rate').css('background-color','#fff');
        $('#nwmrp_rate').css('background-color','#fff');
        var flag=0;
        if(parseFloat($('#nwpurchase_rate').val())<=0)
        {
            $('#nwpurchase_rate').css('background-color','#ffa8a8');
            flag=1;
        }
        if(parseFloat($('#nwsale_rate').val())<=0)
        {
            $('#nwsale_rate').css('background-color','#ffa8a8');
            flag=1;
        }
        if(parseFloat($('#nwmrp_rate').val())<=0)
        {
            $('#nwmrp_rate').css('background-color','#ffa8a8');
            flag=1;
        }
        if(flag==1)
            return;
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
                if(xmlhttp.responseText.trim()!="")
                {
                    alert("Item Successfully Added.");
                    var i = 0;
                    var $select = $('#item_name');
                    $select.find('option').remove();
                    $('<option>').val("").text("Select").appendTo($select);
                    $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("tbl_item_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("item_name + ' (' + item_code + ')'")%>", where: "<%=Crypto.Encrypt("status=1 and company_id='"+inventory.COMPANY["id"]+"'")%>" }, function (responseJson) {
                        $.each(responseJson, function (key, value) {
                            $('<option>').val(key).text(value).appendTo($select);

                            var supplier = $("#supplier").val();
                            var item = $("#item_name").val();
                            if(supplier!="" && item!="")
                            {
                                $("#item_name").val(xmlhttp.responseText).change();
                            }
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
                    $("#unitqtymsr").html("");
                    $('#addNewItem').val("Add");
                }
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

    function getfreedata()
    {
        getItQty("free_item_name", "freeitem_qty_type");
    }

    function reset() {
        $("#item_name").
        $("#item_qty").val("").change();
        $("#usp").val("0.00");
        $("#unitqtymsr").html("");
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
                alert("Customer Successfully Added.");
                var i = 0;
                var $select = $('#supplier');
                $select.find('option').remove();
                $('<option>').val("").text("Select").appendTo($select);
                $.post('<%=SOURCE_ROOT%>/dropdown/Default.aspx', { table: "<%=Crypto.Encrypt("view_ledger_master")%>", value: "<%=Crypto.Encrypt("id")%>", text: "<%=Crypto.Encrypt("name + ' /' + code + ' /' + mobile_no + ' /' + address_1")%>", where: "<%=Crypto.Encrypt("group_name='SUNDRY DEBITORS' and status=1 and company_id='"+inventory.COMPANY["id"]+"'")%>" }, function (responseJson) {
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
        xmlhttp.send("select_supplier=" + select_supplier + "&name=" + name + "&email=" + email + "&mobile_no=" + mobile_no + "&contact_no=" + contact_no + "&address_1=" + address_1 + "&address_2=" + address_2 + "&city=" + city + "&state=" + state + "&pincode=" + pincode + "&pan_no=" + pan_no + "&gstin_no=" + gstin_no + "&gstin_type=" + gstin_type + "&billing_type=" + billing_type + "&master_discount=" + master_discount + "&group=3");
    }

    function getDet(e) {

        var supplier = $("#supplier").val();
        var item = $("#item_name").val();
        if(supplier=="" && item!="")
        {
            alert("First select customer");
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
                $("#item_qty").val("1").change();
                $("#unitqty").html(data.symbol);
                $("#rate").val(data.sale_rate).keyup();
                $("#discper").val("0").keyup();
                $("#gross").val(data.sale_rate).keyup();
                $("#gstper").val(data.gstper).keyup();
                $("#cessper").val("0").keyup();
                calculate();
            }
        }
        xmlhttp.open("POST", "../support/getItems.aspx", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("value=" + e.value);
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
                    $("#mainbox").load(location.href + " #mainbox");
                    $("#boxfooter").load(location.href + " #boxfooter");
                
                }
            }
            xmlhttp.open("POST", "../support/deleteitem.aspx", true);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send("row_id=" + arg);
        }
    }

    //code for add item details in data table
    function validateinput()
    {
        $('#freeitem_qty_type').css('background-color','#fff');
        $('#freeitem_qty').css('background-color','#fff');
        $('#store').css('background-color','#fff');
        var flag=0;
        if(parseFloat($('#freeitem_qty').val())>0 && $('#freeitem_qty_type option:selected').val()=="")
        {
            $('#freeitem_qty_type').css('background-color','#ffa8a8');
            flag=1;
        }
        if(parseFloat($('#freeitem_qty').val())<=0 && $('#freeitem_qty_type option:selected').val()!="")
        {
            $('#freeitem_qty').css('background-color','#ffa8a8');
            flag=1;
        }
        if($('#store option:selected').val()=="")
        {
            $('#store').css('background-color','#ffa8a8');
            flag=1;
        }
        if(flag==1)
            return false;
        return true;
    }

    $(document).ready(function () {
        $('#add').click(function (event) {
            if(validateinput()==false)
                return;
            var $sup = $("#supplier option:selected").val();
            var $taxcalc = $("#taxcalc option:selected").val();
            var $item_name = $("#item_name option:selected").val();
            var $item_qty = $("#item_qty").val();
            var $ref_no = $('#ref_no').val();
            var $mfg_dt = $('#mfg_dt').val();
            var $exp_dt = $('#exp_dt').val();
            var $rate = $('#rate').val();
            var $netrate = $('#netrate').val();
            var $discper = $('#discper').val();
            var $discrate = $('#discrate').val();
            var $gross = $('#gross').val();
            var $gstper = $('#gstper').val();
            var $gstrate = $('#gstrate').val();
            var $cessper = $('#cessper').val();
            var $cessrate = $('#cessrate').val();
            var $totprice = $('#totprice').val();
            var $free_item_name = $('#free_item_name option:selected').val();
            var $freeitem_qty = $('#freeitem_qty').val();
            var $freeitem_qty_type = $('#freeitem_qty_type option:selected').val();
            var $store = $('#store').val();
            var $add = $('#add').val();
     
            $('#add').val("Wait For Process...");
            $.post('../support/addpuritem.aspx', {  sup: $sup, taxcalc: $taxcalc, item_name: $item_name, item_qty: $item_qty,
                ref_no: $ref_no, mfg_dt: $mfg_dt, exp_dt: $exp_dt, rate: $rate, netrate: $netrate, discper: $discper, discrate: $discrate,
                gross: $gross, gstper: $gstper, gstrate: $gstrate, cessper: $cessper, cessrate: $cessrate, totprice: $totprice, 
                free_item_name: $free_item_name, freeitem_qty: $freeitem_qty,freeitem_qty_type: $freeitem_qty_type, store: $store,
                add: $add
            }, function (data, status) {
                $("#item_list").load(location.href + " #item_list");
                $("#mainbox").load(location.href + " #mainbox");
                $("#boxfooter").load(location.href + " #boxfooter");
                $("#add").val("ADD");
                $("#item_name").val("").change();
                $("#item_qty").val("0").change();
                $('#ref_no').val("");
                $('#mfg_dt').val("");
                $('#exp_dt').val("");
                $('#rate').val("0").change();
                $('#netrate').val("0").change();
                $('#discper').val("0").change();
                $('#discrate').val("0").change();
                $('#gross').val("0").change();
                $('#gstper').val("0").change();
                $('#gstrate').val("0").change();
                $('#cessper').val("0").change();
                $('#cessrate').val("0").change();
                $('#totprice').val("0").change();
                $("#unitqtymsr").html("");
                $('#free_item_name').val("").change();
                $('#freeitem_qty').val("0").change();
                $('#freeitem_qty_type').val("").change();
                $("#supplier").attr("disabled", true);
                $("#taxcalc").attr("disabled", true);
            });
        });
    });

    //code for add item details in data table
    $(document).ready(function () {
        $('#item_qty').change(function () {
            var v=$('#item_qty').val();
            if(v=="")
                v=0;
            var d=$('#discper').val();
            if(d=="")
                d=0;
            $("#discper").val(d).keyup();
            d=$('#gstper').val();
            if(d=="")
                d=0;
            $("#gstper").val(d).keyup();
            d=$('#cessper').val();
            if(d=="")
                d=0;
            $("#cessper").val(d).keyup();
            calculate();
        });
    });
    $(document).ready(function () {
        $('#rate').keyup(function () {
            var d=$('#discper').val();
            if(d=="")
                d=0;
            $("#discper").val(d).keyup();
            d=$('#gstper').val();
            if(d=="")
                d=0;
            $("#gstper").val(d).keyup();
            d=$('#cessper').val();
            if(d=="")
                d=0;
            $("#cessper").val(d).keyup();
            calculate();
        });
    });
    $(document).ready(function () {
        $('#discper').keyup(function () {
            var d=$('#discper').val();
            if(d=="")
                d=0;
            var t=$("#netrate").val();
            if(t=="")
                t=0;
            var dr=parseFloat(t)*parseFloat(d)/100;
            $('#discrate').val(dr.toFixed(2));
           
            d=$('#gstper').val();
            if(d=="")
                d=0;
            $("#gstper").val(d).keyup();
            d=$('#cessper').val();
            if(d=="")
                d=0;
            $("#cessper").val(d).keyup();
            calculate();
        });
    });
    $(document).ready(function () {
        $('#discrate').keyup(function () {
            var dr=$('#discrate').val();
            if(dr=="")
                dr=0;
            var t=$("#netrate").val();
            if(t=="")
                t=0;
            var d=(parseFloat(dr)*100)/parseFloat(t);
            $('#discper').val(d.toFixed(2));
           
            d=$('#gstper').val();
            if(d=="")
                d=0;
            $("#gstper").val(d).keyup();
            d=$('#cessper').val();
            if(d=="")
                d=0;
            $("#cessper").val(d).keyup();
            calculate();
        });
    });

    $(document).ready(function () {
        $('#gstper').keyup(function () {
            var g=$('#gstper').val();
            if(g=="")
                g=0;
            var gross=$("#gross").val();
            if(gross=="")
                gross=0;
            var gr=parseFloat(gross)*parseFloat(g)/100;
            $('#gstrate').val(gr.toFixed(2));
            calculate();
        });
    });
    $(document).ready(function () {
        $('#cessper').keyup(function () {
            var c=$('#cessper').val();
            if(c=="")
                c=0;
            var gross=$("#gross").val();
            if(gross=="")
                gross=0;
            var cr=parseFloat(gross)*parseFloat(c)/100;
            $('#cessrate').val(cr.toFixed(2));
            calculate();
        });
    });
    $(document).ready(function () {
        $('#cessrate').keyup(function () {
            var cr=$('#cessrate').val();
            if(cr=="")
                cr=0;
            var gross=$("#gross").val();
            if(gross=="")
                gross=0;
            var c=(parseFloat(cr)*100)/parseFloat(gross);
            $('#cessper').val(c.toFixed(2));
            calculate();
        });
    });
    $(document).ready(function () {
        $('#taxcalc').change(function () {
            calculate();
        });
    });
    function calculate()
    {
        var q=$("#item_qty").val();
        if(q=="")
            q=0;
        var r=$("#rate").val();
        if(r=="")
            r=0;
        var gr=$("#gstrate").val();
        if(gr=="")
            gr=0;
        var cr=$("#cessrate").val();
        if(cr=="")
            cr=0;
        var dr=$("#discrate").val();
        if(dr=="")
            dr=0;
        var txc=$("#taxcalc").val();

        var t=parseFloat(q)*parseFloat(r);
        $("#netrate").val(t.toFixed(2));
        var gross=parseFloat(t)-parseFloat(dr);
        $("#gross").val(gross.toFixed(2));
        var tp=parseFloat(gross)+parseFloat(cr);
        if(txc==0)
        {
            tp=parseFloat(tp)+parseFloat(gr);
        }     
        $("#totprice").val(tp.toFixed(2));

    }

    function calculateinvoice()
    {
        var q=$("#totinvval").val();
        if(q=="")
            q=0;
        var r=$("#discount").val();
        if(r=="")
            r=0;
        var s=$("#shipping_charge").val();
        if(s=="")
            s=0;
        var t=$("#round_off").val();
        if(t=="")
            t=0;

        var disc=(parseFloat(q)-parseFloat(r));
        var tot= (parseFloat(disc)+parseFloat(s));
        var z= (parseFloat(tot)-parseFloat(t));
        $("#total_amt").val(z.toFixed(2));
        $("#amttopay").val(z.toFixed(2));

    }
    
    $(document).ready(function () {
        $('#paymode').change(function (event) {
            if($('#paymode').val()=="Cheque")
            {
                $('#lblchqno').html("Cheque No.");
                $('#chqno').attr("required", true);
                $('#lblchqdt').html("Cheque Date");
                $('#chqdt').attr("required", true);
                $('#lblbnkname').html("Bank Name");
                $('#bnkname').attr("required", true);
                $('#chqdetails').show();
            }
            else if($('#paymode').val()=="DD"){
                $('#lblchqno').html("DD No.");
                $('#chqno').attr("required", true);
                $('#lblchqdt').html("DD Date");
                $('#chqdt').attr("required", true);
                $('#lblbnkname').html("Bank Name");
                $('#bnkname').attr("required", true);
                $('#chqdetails').show();
            }
            else{
                $('#lblchqno').html("Ref No.");
                $('#chqno').removeAttr("required");
                $('#lblchqdt').html("Ref Date");
                $('#chqdt').removeAttr("required");
                $('#lblbnkname').html("Bank Name");
                $('#bnkname').removeAttr("required");
                $('#chqdetails').hide();
            }
        });
    });    
    
    //code for add item details in data table
    $(document).ready(function () {
        $('#supplier').change(function (event) {
            var $supplier = $("#supplier option:selected").val();            
            $.post('../support/readdebit.aspx', { supplier: $supplier }, function (data, status) {
                if(data.type=="error")
                {
                    $('#custdetails').hide();
                    $('#custdetails').html("");
                }
                else
                {
                    $('#custdetails').show();
                    if(data.details=="None")
                        $('#custdetails').html(data.details);
                    else
                        $('#custdetails').html(data.details);
                }
            });
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
                <h3 class="box-title">Sale & Billing</h3>
                <div class="box-tools pull-right">
                    <a href="salevoucher_list.aspx?cmd=Clear" class="btn btn-primary"><i class="fa fa-fw fa-long-arrow-left"></i>Go To List</a>
                </div>
            </div>
            <form method="post" role="form" id="FORM1" name="FORM1">
                <div class="box-body">
                    <% inventory.Execute();
                        
                        string order_no = "";
                        decimal totalitemamt = 0;
                        string required="required";
                        string read_only="readonly onfocus='setReadOnly(this)' onblur='hideReadOnly(this)'";
                        Hashtable poInv=new Hashtable();
                        if(Request["uid"]==null)
                        {
                            poInv=inventory.getInvoice("SALE");
                            if(poInv["invType"].ToString()=="MANUAL")
                            {
                                read_only="";
                            }
                            else {
                                order_no = (Convert.ToInt64(poInv["invNo"].ToString())+1)+"";
                            }
                        }
                        
                        DataTable dtItem =null;
                        if (Session["dtItem"] == null)
                        {
                            dtItem = new DataTable();
                            dtItem.Columns.Add("item_id");
                            dtItem.Columns.Add("order_qty");
                            dtItem.Columns.Add("order_unit");
                            dtItem.Columns.Add("stkqty");
                            dtItem.Columns.Add("ref_no");
                            dtItem.Columns.Add("mfg_dt");
                            dtItem.Columns.Add("exp_dt");
                            dtItem.Columns.Add("rate");
                            dtItem.Columns.Add("netrate");
                            dtItem.Columns.Add("disc_per");
                            dtItem.Columns.Add("disc_amt");
                            dtItem.Columns.Add("gross");
                            dtItem.Columns.Add("gst_per");
                            dtItem.Columns.Add("gst_amt");
                            dtItem.Columns.Add("cess_per");
                            dtItem.Columns.Add("cess_amt");
                            dtItem.Columns.Add("total_rate");
                            dtItem.Columns.Add("free_item");
                            dtItem.Columns.Add("free_item_qty");
                            dtItem.Columns.Add("free_qty_type");
                            dtItem.Columns.Add("store_id");
                            dtItem.Columns.Add("lgr_id");
                            dtItem.Columns.Add("taxcalc");
                            SqlDataReader dr1 = inventory.GetDataReader("select * from tbl_stock_details where company_id='" + inventory.COMPANY["id"] + "' and ref_id='" + inventory.TempRs["id"] + "' and ref_by='tbl_inventory_master' and status=1");
                            while(dr1.Read())
                            {
                                string free_item=null;
                                string free_item_qty=null;
                                string free_qty_type=null;
                                Hashtable frrhs = inventory.GetRecords("select item_id, outwardqty, outwardunit from tbl_stock_details where company_id='" + inventory.COMPANY["id"] + "' and ref_id='" + inventory.TempRs["id"] + "' and ref_by='tbl_inventory_master' and itemid_freewith='" + dr1["id"] + "' and is_free_item=1 and status=1");
                                if(frrhs.Count > 0)
                                {
                                    free_item=frrhs["item_id"].ToString();
                                    free_item_qty=frrhs["outwardqty"].ToString();
                                    free_qty_type=frrhs["outwardunit"].ToString();
                                }
                                dtItem.Rows.Add(dr1["item_id"], dr1["outwardqty"], dr1["outwardunit"], dr1["outwardunitqty"], dr1["reference_no"], dr1["mfg_dt"], dr1["exp_dt"], dr1["rate"], dr1["net_rate"], dr1["disc_per"], dr1["disc_amt"], dr1["gross_amt"], dr1["gst_per"], dr1["gst_amt"], dr1["cess_per"], dr1["cess_amt"], dr1["total_rate"], free_item, free_item_qty, free_qty_type, dr1["store_id"],inventory.TempRs["ledger_id"],inventory.TempRs["taxinclude"]);
                                
                            }

                            Session["dtItem"] = dtItem;
                        }
                        else
                        {
                            dtItem = (DataTable)Session["dtItem"];
                        }

                       string disabled = "";
                        string lgr_id=inventory.TempRs["ledger_id"];
                        string taxcalc="";
                        if(dtItem.Rows.Count>0)
                        {
                            lgr_id = dtItem.Rows[0].Field<string>(21);
                            taxcalc = dtItem.Rows[0].Field<string>(22);
                            disabled = "disabled";
                        }

                         string dues="";
                        string dueamt="0";
                        if(!string.IsNullOrWhiteSpace(lgr_id))
                        {
                            dues="DR :- &#8377; 0.00";
                            Hashtable ldue = inventory.getCustDue(lgr_id, DateTime.Now.ToString("yyyy-MM-dd"));
                            if(ldue.Count>0)
                            {
                                dues= ldue["bal_type"] + ":- &#8377; " + ldue["bal"];
                                dueamt=ldue["bal"].ToString();
                            }
                        }

                        
                        string disableonpay = "";
                        long cntchkPay = Convert.ToInt64(inventory.GetCount("id", "tbl_invoicewisepayment_details", "company_id='" + inventory.COMPANY["id"] + "' and inv_id='" + inventory.TempRs["id"] + "' and mode='Payment'"));
                        if(cntchkPay > 0)
                        {
                            disableonpay = "disabled";
                        }

                    %>
                    <br />


                    <div class="form-group row">
                        <div class="col-md-7 col-sm-12">
                            <div class="form-group row">
                                <label for="supplier" class="col-md-3 col-sm-5 control-label">Customer <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-9 col-sm-7 ">
                                    <div class="col-md-11 col-sm-11" style="padding-left: 0px">
                                        <select name="supplier" id="supplier" required class="form-control input-sm" <%=disabled %> style="cursor: pointer">
                                            <option value="">Select</option>
                                            <%
                                            DataTable dtLdg = inventory.GetDataTable("select id,name,code,mobile_no, address_1 from tbl_ledger_master where company_id='" + inventory.COMPANY["id"] + "' and group_id in ('1','3') and status=1 order by id asc");
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
                                        <span aria-hidden="true" style="cursor: pointer; color: coral; border: solid 2px #000000; padding-left: 2px; padding-right: 2px" title="Click here to add new customer" data-toggle="modal" data-target="#supModel"><b>+</b></span>


                                        <!-- Modal start -->
                                        <div class="modal fade" id='supModel' tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
                                            <div class="modal-dialog" role="document">
                                                <div class="modal-content">
                                                    <div class="modal-header btn btn-danger" style="width: 100%;">
                                                        <span style="float: left"><strong>ADD/EDIT CUSTOMER</strong></span>
                                                        <span data-dismiss="modal" aria-label="Close" style="float: right" class="btn">X</span>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="form-group row">
                                                            <label for="select_supplier" class="col-md-2 col-sm-5 control-label">Select Customer <span style="font-weight: bold; color: red">*</span></label>
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
                                                                   SqlDataReader  rdr = inventory.GetDataReader("select id,state_name from tbl_state_master where status=1 order by state_code asc");
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
                                                                <input type="number" name="master_discount" id="master_discount" min="0" max="100" value="" class="form-control input-sm" />
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

                                    
                                    <div class="col-sm-11 invoice-col" id="custdetails" hidden style="border: 1px solid #b7b3b3; border-style:solid; padding-top:10px; padding-bottom:0px; margin-top: 10px"></div>
                                </div>
                            </div>

                            <div class="form-group row">
                                <label for="taxcalc" class="col-md-3 col-sm-5 control-label">Tax Calculation <span style="font-weight: bold; color: red">*</span><br />
                                    (With Item)</label>
                                <div class="col-md-6 col-sm-7">
                                    <select id="taxcalc" name="taxcalc" required class="form-control input-sm" <%=disabled %> style="cursor: pointer">
                                        <option value="1" <%=taxcalc=="1"?"selected":"" %>>Included</option>
                                        <option value="0" <%=taxcalc=="0"?"selected":""%>>Excluded</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-5 col-sm-12">
                            <div class="form-group row">
                                <label for="order_no" class="col-md-4 col-sm-5 control-label">Order No. <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-6 col-sm-7">
                                    <input type="text" name="order_no" id="order_no" <%=disableonpay %> value="<%=inventory.TempRs["autogen_id"]!=""?inventory.TempRs["autogen_id"]:order_no %>" required class="form-control input-sm" <%=read_only %> onkeyup="this.value=this.value.toUpperCase()" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="order_dt" class="col-md-4 col-sm-5 control-label">Order Date <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-6 col-sm-7">
                                    <input type="text" name="order_dt" id="order_dt" <%=disableonpay %> required class="form-control input-sm" value="<%=inventory.TempRs["stock_dt"]!=""?Convert.ToDateTime(inventory.TempRs["stock_dt"]).ToString("dd-MM-yyyy"):DateTime.Now.ToString("dd-MM-yyyy") %>" <%=read_only %> />
                                </div>
                            </div>
                            <div class="form-group row">
                                <label for="due_dt" class="col-md-4 col-sm-5 control-label">Due Date <span style="font-weight: bold; color: red">*</span></label>
                                <div class="col-md-6 col-sm-7">
                                    <input type="text" name="due_dt" id="due_dt" <%=disableonpay %> required class="form-control input-sm" value="<%=inventory.TempRs["due_dt"]!=""?Convert.ToDateTime(inventory.TempRs["due_dt"]).ToString("dd-MM-yyyy"):DateTime.Now.ToString("dd-MM-yyyy") %>" readonly />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-group row">
                        <div class="col-md-12 col-sm-12">
                            <fieldset>
                                <legend>Add Items in Cart</legend>

                                <% if(cntchkPay == 0) { %>

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
                                                                <input type="text" name="nwpurchase_rate" id="nwpurchase_rate" value="0" class="form-control input-sm" />
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="nwsale_rate">Sale Rate <span style="font-weight: bold; color: red">*</span></label>
                                                                <input type="text" name="nwsale_rate" id="nwsale_rate" value="" class="form-control input-sm" />
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="nwmrp">MRP <span style="font-weight: bold; color: red">*</span></label>
                                                                <input type="text" name="nwmrp" id="nwmrp" value="" class="form-control input-sm" />
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
                                                                <input type="text" name="nwtotal_value" id="nwtotal_value" value="" class="form-control input-sm" readonly />
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="nwstoreid">Store </label>
                                                                <select name="nwstoreid" id="nwstoreid" class="form-control input-sm">
                                                                    <option value="">Select</option>
                                                                    <%
                                                            DataTable dtstore = inventory.GetDataTable("select id,name,code from tbl_store_master where company_id='" + inventory.COMPANY["id"] + "' and status=1 order by name asc");
                                                            foreach(DataRow rdt in dtstore.Rows)
                                                            { 
                                                                    %>
                                                                    <option value="<%=rdt["id"]%>"><%=rdt["name"] %> (<%=rdt["code"] %>)</option>
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
                                    <div class="col-md-3 col-sm-6">
                                        <label for="ref_no">Reference No. </label>
                                        <input type="text" name="ref_no" id="ref_no" class="form-control input-sm" />
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="mfg_dt">Mfg Dt. </label>
                                        <input type="text" name="mfg_dt" id="mfg_dt" class="form-control input-sm" value="" />
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="exp_dt">Exp Dt. </label>
                                        <input type="text" name="exp_dt" id="exp_dt" class="form-control input-sm" value="" />
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="item_qty">Qty </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon" id="unitqty"></span>
                                            <input type="number" name="item_qty" id="item_qty" class="form-control input-sm" value="0" min="0" max="1000" />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="rate">Rate </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="text" name="rate" id="rate" value="0.00" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="netrate">Net Rate </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="text" name="netrate" id="netrate" value="0.00" class="form-control input-sm" readonly />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="discper">Discount (%) </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">%
                                            </span>
                                            <input type="text" name="discper" id="discper" value="0.00" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="discrate">Discount </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="text" name="discrate" id="discrate" value="0.00" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="gross">Gross </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="text" name="gross" id="gross" value="0.00" class="form-control input-sm" readonly />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="gstper">GST (%) </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">%
                                            </span>
                                            <input type="text" name="gstper" id="gstper" value="0.00" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="gstrate">GST </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="text" name="gstrate" id="gstrate" value="0.00" class="form-control input-sm" readonly />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="cessper">Cess (%) </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">%
                                            </span>
                                            <input type="text" name="cessper" id="cessper" value="0.00" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="cessrate">Cess </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="text" name="cessrate" id="cessrate" value="0.00" class="form-control input-sm" />
                                        </div>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="totprice">Total Price </label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="text" name="totprice" id="totprice" value="0.00" class="form-control input-sm" readonly />
                                        </div>
                                    </div>
                                    <div class="col-md-4 col-sm-6">
                                        <label for="item_name">Free Item </label>
                                        <div class="col-md-11 col-sm-11" style="padding-left: 0px">
                                            <select name="free_item_name" id="free_item_name" class="form-control input-sm" onclick="getfreedata()">
                                                <option value="">Select</option>
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
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="freeitem_qty">Free Item's Qty </label>
                                        <input type="number" name="freeitem_qty" id="freeitem_qty" class="form-control input-sm" value="0" min="0" max="1000" />
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="freeitem_qty_type">Unit Type </label>
                                        <select name="freeitem_qty_type" id="freeitem_qty_type" class="form-control input-sm">
                                            <option value="">Select</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2 col-sm-6">
                                        <label for="store">Store/Warehouse </label>
                                        <select name="store" id="store" class="form-control input-sm">
                                            <option value="">Select</option>
                                            <%
                                            foreach(DataRow rdt in dtstore.Rows)
                                            { 
                                            %>
                                            <option value="<%=rdt["id"]%>"><%=rdt["name"] %> (<%=rdt["code"] %>)</option>
                                            <%
                                            }
                                            %>
                                        </select>
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
                                <% }  %>
                                <div class="form-group row" style="border: solid 1px #8d8080; max-height: 450px; min-height: 250px; height: 100%; width: 99%; margin: auto; background-color: #ccc6c6; overflow: auto;">
                                    <div id="item_list">
                                        <% if(dtItem.Rows.Count > 0){ %>
                                        <table class="table table-bordered" id="dataTable" style="width: 100%; margin: auto; white-space: nowrap">
                                            <tr>
                                                <th>#</th>
                                                <th>Item</th>
                                                <th>Ref No.</th>
                                                <th>Mfg Dt</th>
                                                <th>Exp Dt</th>
                                                <th>Qty</th>
                                                <th>Rate</th>
                                                <th>Net Rate</th>
                                                <th>Discount</th>
                                                <th>Gross</th>
                                                <th>GST</th>
                                                <th>Cess</th>
                                                <th>Total</th>
                                                <th>Free Item</th>
                                                <th>Free Qty</th>
                                                <th>Store</th>

                                                <%if(cntchkPay == 0) {   %>
                                                <th>Delete</th>
                                                <%} %>
                                            </tr>
                                            <%
                                    int i=0;
                                    foreach(DataRow rdt in dtItem.Rows){
                                    
                                                Hashtable item=inventory.GetRecords("select * from view_item_master where id='"+rdt["item_id"]+"'");
                                                Hashtable store=inventory.GetRecords("select * from tbl_store_master where id='"+rdt["store_id"]+"'");

                                                Hashtable freeitem=inventory.GetRecords("select * from view_item_master where id='"+rdt["free_item"]+"'");
                                                Hashtable free_unit=inventory.GetRecords("select * from tbl_unit_master where id='"+rdt["free_qty_type"]+"'");
                                         
                                                totalitemamt += Convert.ToDecimal(rdt["total_rate"].ToString());
                                    
                                            %>
                                            <tr>
                                                <td><%= ++i %></td>
                                                <td><%= item["item_name"] %> (<%=item["item_code"] %>)</td>
                                                <td><%= item["ref_no"] %></td>
                                                <td><%= item["exp_dt"] %></td>
                                                <td><%= item["mfg_dt"] %></td>
                                                <td><%= rdt["order_qty"] %> <%= item["symbol"] %></td>
                                                <td>&#8377;<%= rdt["rate"] %></td>
                                                <td>&#8377;<%= rdt["netrate"] %></td>
                                                <td><%= rdt["disc_per"] %> % (&#8377;<%= rdt["disc_amt"] %>)</td>
                                                <td>&#8377;<%= rdt["gross"] %></td>
                                                <td><%= rdt["gst_per"] %> % (&#8377;<%= rdt["gst_amt"] %>)</td>
                                                <td><%= rdt["cess_per"] %> % (&#8377;<%= rdt["cess_amt"] %>)</td>
                                                <td>&#8377;<%= rdt["total_rate"] %></td>

                                                <% if(freeitem.Count > 0){ %>
                                                <td><%= freeitem["item_name"] %> (<%=freeitem["item_code"] %>)</td>
                                                <td><%= rdt["free_item_qty"] %> <%= free_unit["symbol"] %></td>
                                                <%}else{ %>
                                                <td></td>
                                                <td></td>
                                                <%} %>
                                                <td><%= store["name"] %> (<%= store["code"] %>)</td>

                                                <%if(cntchkPay == 0) {   %>
                                                <td>
                                                    <input type="button" class="btn btn-danger" value="Delete" onclick="deleteRow(<%=dtItem.Rows.IndexOf(rdt)%>)" />
                                                </td>
                                                <%} %>
                                            </tr>
                                            <%}%>
                                        </table>
                                        <%} %>
                                    </div>
                                </div>

                            </fieldset>
                        </div>
                    </div>

                    <div id="mainbox">
                        <div class="form-group row">
                            <div class="col-md-7 col-sm-6">
                                <div class="form-group row">
                                    <label for="totinvprice" class="col-md-3 col-sm-5 control-label">Total <span style="font-weight: bold; color: red">*</span></label>
                                    <div class="col-md-3 col-sm-7">
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="number" name="totinvval" id="totinvval" value="<%=totalitemamt.ToString("0.00") %>" required class="form-control input-sm" readonly min="0" onblur="calculateinvoice()" />
                                        </div>
                                    </div>
                                </div>

                                <%
                                decimal roundoff = (totalitemamt - (Math.Truncate(totalitemamt)));
                                decimal totalprice = totalitemamt-roundoff;
                                if (!string.IsNullOrWhiteSpace(inventory.TempRs["discount_amt"]))
                                {
                                    totalprice = (totalprice-Convert.ToDecimal(inventory.TempRs["discount_amt"]));
                                }
                                if(!string.IsNullOrWhiteSpace(inventory.TempRs["shipping_charge"]))
                                {
                                    totalprice = (totalprice+Convert.ToDecimal(inventory.TempRs["shipping_charge"]));
                                }
                    
                                %>
                                <div class="form-group row">
                                    <label for="discount" class="col-md-3 col-sm-5 control-label">Discount <span style="font-weight: bold; color: red">*</span></label>
                                    <div class="col-md-3 col-sm-7">
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="number" name="discount" id="discount" <%=disableonpay %> value="<%=inventory.TempRs["discount_amt"]!=""?inventory.TempRs["discount_amt"]:"0" %>" required class="form-control input-sm" min="0" onchange="calculateinvoice()" />
                                        </div>
                                    </div>
                                    <label for="shipping_charge" class="col-md-3 col-sm-5 control-label">Service Charge <span style="font-weight: bold; color: red">*</span></label>
                                    <div class="col-md-3 col-sm-7">
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="number" name="shipping_charge" id="shipping_charge" <%=disableonpay %> required class="form-control input-sm" value="<%=inventory.TempRs["shipping_charge"]!=""?inventory.TempRs["shipping_charge"]:"0" %>" min="0" onchange="calculateinvoice()" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="round_off" class="col-md-3 col-sm-5 control-label">Round Off <span style="font-weight: bold; color: red">*</span></label>
                                    <div class="col-md-3 col-sm-7">
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="number" name="round_off" id="round_off" value="<%=inventory.TempRs["round_off"]!=""?inventory.TempRs["round_off"]:roundoff.ToString("0.00") %>" required class="form-control input-sm" readonly onchange="calculateinvoice()" />
                                        </div>
                                    </div>
                                    <label for="total_amt" class="col-md-3 col-sm-5 control-label">Total Invoice Amount <span style="font-weight: bold; color: red">*</span></label>
                                    <div class="col-md-3 col-sm-7">
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="number" name="total_amt" id="total_amt" required class="form-control input-sm" value="<%=totalprice.ToString("0.00") %>" readonly />
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group row">
                                    <label class="col-md-3 col-sm-5 control-label">Narration</label>
                                    <div class="col-md-9 col-sm-7">
                                        <textarea name="narration" id="narration" class="form-control input-sm" <%=disableonpay %> style="height: 80px; resize: none" maxlength="100" onkeyup="this.value=this.value.toUpperCase()"><%=inventory.TempRs["naration"] %></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-5 col-sm-6" style="border-left: solid 1px #000">
                                <div class="form-group row">
                                    <div class="col-md-12 col-sm-12">
                                        <label for="paymode" class="control-label">Payment Mode </label>
                                        <select name="paymode" id="paymode" class="form-control input-sm" <%=disableonpay %>>
                                            <option value="Credit">Credit</option>
                                            <option value="Cash">Cash</option>
                                            <option value="Cheque">Cheque</option>
                                            <option value="DD">DD</option>
                                            <option value="Others">Others</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group row" id="chqdetails" hidden>
                                    <div class="col-md-4 col-sm-12">
                                        <label for="chqno" class="control-label" id="lblchqno">Cheque No. <span style="font-weight: bold; color: red">*</span></label>
                                        <input type="text" name="chqno" id="chqno" value="" class="form-control input-sm" <%=disableonpay %> />
                                    </div>
                                    <div class="col-md-4 col-sm-12">
                                        <label for="chqdt" class="control-label" id="lblchqdt">Cheque Date <span style="font-weight: bold; color: red">*</span></label>
                                        <input type="text" name="chqdt" id="chqdt" value="" class="form-control input-sm" <%=disableonpay %> />
                                    </div>
                                    <div class="col-md-4 col-sm-12">
                                        <label for="bnkname" class="control-label" id="lblbnk">Bank Name <span style="font-weight: bold; color: red">*</span></label>
                                        <input type="text" name="bnkname" id="bnkname" value="" class="form-control input-sm" <%=disableonpay %> />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-md-12 col-sm-12">
                                        <label for="amttopay" class="control-label">Amount To Pay <span style="font-weight: bold; color: red">*</span></label>
                                        <div class="col-md-12 col-sm-12 input-group">
                                            <span class="input-group-addon">&#8377;
                                            </span>
                                            <input type="number" name="amttopay" id="amttopay" value="0" <%=disableonpay %> required class="form-control input-sm" min="0" max="<%=totalprice.ToString("0.00")%>" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <div class="col-md-12 col-sm-12">
                                        <label for="modedesc" class="control-label">Remarks</label>
                                        <textarea name="modedesc" id="modedesc" class="form-control input-sm" <%=disableonpay %> style="height: 80px; resize: none" maxlength="100" onkeyup="this.value=this.value.toUpperCase()"></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="box-footer" id="boxfooter" style="text-align: center">

                    <% if(cntchkPay == 0) {  
                         if(dtItem.Rows.Count > 0){ %>
                    <input type="hidden" name="invlastvalof" value="<%=poInv["invCurrVal"]%>" />
                    <input type="hidden" name="invlastiof" value="<%=poInv["invCurrId"]%>" />
                    <input type="hidden" name="invidf" value="<%=poInv["invfId"]%>" />
                    <input type="submit" class="btn btn-success" name="btn_save" value="Save" />&nbsp;&nbsp;
                          <% }}
                            else {
                             inventory.Error("You have no permission to edit this invoice after payment.");
                            } %>
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
        $('#mfg_dt').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            //daysOfWeekDisabled: [0], sunday disable 0-6 sun-sat
            endDate: '0d', //disable after today
        });

        //Date picker
        $('#exp_dt').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            //daysOfWeekDisabled: [0], sunday disable 0-6 sun-sat
            startDate: '0d', //disable before today
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
