<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>
<script>
    $(document).ready(function () {
        $.validator.messages.required = "";
        $("#FROM1").validate({
            rules: {
            },
            messages: {
            }
        });
    });

    function printDiv(divName) {
        var printContents = document.getElementById(divName).innerHTML;
        var originalContents = document.body.innerHTML;
        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
    }

    var tableToExcel = (function () {
        var uri = 'data:application/vnd.ms-excel;base64,'
            , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'
            , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
            , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
        return function (table, name) {
            if (!table.nodeType) table = document.getElementById(table)
            var ctx = { worksheet: name || 'Worksheet', table: table.innerHTML }
            window.location.href = uri + base64(format(template, ctx))
        }
    })()

</script>


<style>
    /* Center the loader */
    #inner_loader {
        position: absolute;
        left: 50%;
        top: 50%;
        z-index: 99999;
        width: 150px;
        height: 150px;
        margin: -75px 0 0 -75px;
        border: 16px solid #f3f3f3;
        border-top: 16px solid blue;
        border-right: 16px solid green;
        border-bottom: 16px solid red;
        border-radius: 50%;
        border-top: 16px solid #3498db;
        width: 120px;
        height: 120px;
        -webkit-animation: spin 2s linear infinite;
        animation: spin 2s linear infinite;
    }

    @-webkit-keyframes spin {
        0% {
            -webkit-transform: rotate(0deg);
        }

        100% {
            -webkit-transform: rotate(360deg);
        }
    }

    @keyframes spin {
        0% {
            transform: rotate(0deg);
        }

        100% {
            transform: rotate(360deg);
        }
    }

    /* Add animation to "page content" */
    .animate-bottom {
        position: relative;
        -webkit-animation-name: animatebottom;
        -webkit-animation-duration: 1s;
        animation-name: animatebottom;
        animation-duration: 1s;
    }

    @-webkit-keyframes animatebottom {
        from {
            bottom: -100px;
            opacity: 0;
        }

        to {
            bottom: 0px;
            opacity: 1;
        }
    }

    @keyframes animatebottom {
        from {
            bottom: -100px;
            opacity: 0;
        }

        to {
            bottom: 0;
            opacity: 1;
        }
    }

    #inner_loader_bg {
        background: #666666;
        opacity: 0.5;
        position: absolute;
        z-index: 9999;
        top: 0px;
        width: 100%;
        height: 100%;
    }

    .loader_up {
        position: absolute;
        z-index: 99999;
    }
</style>


<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Sale Retrun Report</h3>
            </div>
            <div class="box-body table-responsive">

                <%
                        string[] where = new string[4];
                        if (Request["cmd"] != null)
                        {
                            if (Session["src_" + inventory.URLFILENAME] != null)
                                Session["src_" + inventory.URLFILENAME] = null;
                        }
                        if (Request["Search"] != null)
                        {
                            where[0] = Request["datefrom"]; 
                            where[1] = Request["dateupto"]; 
                            where[2] = inventory.COMPANY["id"].ToString();   
                            where[3] = Request["search"];                
                            Session["src_" + inventory.URLFILENAME] = where;
                        }
                        if (Session["src_" + inventory.URLFILENAME] != null)
                        {
                            where = (string[])Session["src_" + inventory.URLFILENAME];
                        }
                        else
                        {
                            where[0] = DateTime.Now.ToString("dd-MM-yyyy");
                            where[1] = DateTime.Now.ToString("dd-MM-yyyy");
                            where[2] = inventory.COMPANY["id"].ToString();   
                            where[3] = "";
                        }
           
                %>
                <form name="FORMNAME1" id="FORMNAME1" method="post">
                    <div class="box-body">
                        <fieldset>
                            <legend>Search Keywords</legend>
                            <div class="form-group row">
                                <label for="datefrom" class="col-md-2 col-sm-5 control-label">Date From</label>
                                <div class="col-md-3 col-sm-7">
                                    <input type="text" name="datefrom" id="datefrom" value="<%=where[0]%>" class="form-control input-sm searchdate" required />
                                </div>
                                <label for="dateupto" class="col-md-2 col-sm-5 control-label">Date Upto</label>
                                <div class="col-md-3 col-sm-7">
                                    <input type="text" name="dateupto" id="dateupto" value="<%=where[1]%>" class="form-control input-sm searchdate" required />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-md-12 col-sm-7" style="text-align: center">
                                    <input type="submit" name="search" id="search" value="Search" class="btn btn-success" onclick="showLoader()" />
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </form>

                <%if(where[3]=="Search"){ %>
                <div class="box-body">
                    <div id="printableArea">
                        <table class="table table-bordered" id="testTable" rules="groups">
                            <tr>
                                <td colspan="11" style="text-align: center; font-size: 27px; font-weight: bold">Sale Return</td>
                            </tr>
                            <tr>
                                <td colspan="34" style="text-align: center;">
                                <b>Date From</b>  :- <%=where[0]%> <b>Date Upto</b>  :- <%=where[1]%>
                                </td>
                            </tr>
                            <tr>
                                <th>#</th>
                                <th>AUTO ID</th>
                                <th>INVOICE NO</th>
                                <th>INVOICE DATE</th>
                                <th>STOCK DATE</th>
                                <th>LEDGER NAME</th>
                                <th>DUES DATE</th>
                                <th style="text-align:right;">AMOUNT</th>
                                <th style="text-align:right;">DUES</th>
                            </tr>
                            <%
                                int i=0;
                                
                                string whereClause = "invoice_type in ('SR') and company_id='" + where[2] + "' and invoice_dt>='"+DateTime.ParseExact(where[0], "dd-MM-yyyy", null).ToString("MM-dd-yyyy")+"' and invoice_dt<='"+DateTime.ParseExact(where[1], "dd-MM-yyyy", null).ToString("MM-dd-yyyy")+"' ";

                                SqlDataReader rdr = inventory.GetDataReader("select * from view_inventory_master where " + whereClause + " order by id asc");
                                if(rdr.HasRows){
                                while (rdr.Read()){
                            %>
                            <tr>
                                <td><%=++i %></td>
                                <td><%=rdr["autogen_id"] %></td>
                                <td><%=rdr["invoice_no"] %></td>
                                <td><%=Convert.ToDateTime(rdr["invoice_dt"].ToString()).ToString("dd-MMM-yyyy") %></td>
                                <td><%=Convert.ToDateTime(rdr["stock_dt"].ToString()).ToString("dd-MMM-yyyy") %></td>
                                <td><%=rdr["ladgername"] %>(<%=rdr["ledgercode"] %>)</td>
                                <td><%=Convert.ToDateTime(rdr["due_dt"].ToString()).ToString("dd-MMM-yyyy") %></td>
                                <td style="text-align:right;">&#8377; <%=rdr["total_amt"]%></td>
                                <td style="text-align:right;">&#8377; <%=rdr["dueamt"]%></td>
                            </tr>
                            <%} } else{ %>
                            <tr>
                                <td colspan="5"><strong>No records found.</strong></td>
                            </tr>
                            <%} %>
                        </table>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-12 col-sm-7" style="text-align: center;">
                        <button type="button" onclick="tableToExcel('testTable', 'daybook')" class="btn btn-info">
                        <i class="fa fa-file-excel-o"> Export To Excel</i>
                        </button>
                        &nbsp;
                        <button type="button" name="print" class="btn btn-info" onclick="printDiv('printableArea')" >
                         <i class="fa fa-print"> Print</i>
                        </button>
                    </div>
                </div>
                <%} %>
            </div>
        </div>
        <!-- Your Page Content Here -->

    </section>
    <!-- /.content -->

</div>
<!-- /.content-wrapper -->


    
<div id="inner_loader" class="loader_up" style="display:none"></div>
<div id="inner_loader_bg" style="display:none"></div>
<script>

    function showLoader() {
        document.getElementById("inner_loader").style.display = "block";
        document.getElementById("inner_loader_bg").style.display = "block";
    }

</script>
<script>
    $(function () {

        //Date picker
        $('.searchdate').datepicker({
            autoclose: true,
            format: 'dd-mm-yyyy',
            todayHighlight: true,
            //daysOfWeekDisabled: [0], sunday disable 0-6 sun-sat
            endDate: '0d', //disable after today
        });
    });
</script>
<!-- #include file="../footer.aspx"-->
