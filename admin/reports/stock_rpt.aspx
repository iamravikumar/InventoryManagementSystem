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
                <h3 class="box-title">Stock Book</h3>
            </div>
            <div class="box-body table-responsive">

                <%
                        string[] where = new string[3];
                        if (Request["cmd"] != null)
                        {
                            if (Session["src_" + inventory.URLFILENAME] != null)
                                Session["src_" + inventory.URLFILENAME] = null;
                        }
                        if (Request["Search"] != null)
                        {
                            where[0] = Request["Keywords"].Trim(); 
                            where[1] = inventory.COMPANY["id"].ToString();   
                            where[2] = Request["search"];                
                            Session["src_" + inventory.URLFILENAME] = where;
                        }
                        if (Session["src_" + inventory.URLFILENAME] != null)
                        {
                            where = (string[])Session["src_" + inventory.URLFILENAME];
                        }
                        else
                        {
                            where[0] = "";
                            where[1] = inventory.COMPANY["id"].ToString();   
                            where[2] = "Search";
                        }
           
                %>
                <form name="FORMNAME1" id="FORMNAME1" method="post">
                    <div class="box-body">
                        <fieldset>
                            <legend>Search Keywords</legend>
                             <div class="form-group row">
                                <label for="Keywords" class="col-md-2 col-sm-5 control-label">Keywords</label>
                                <div class="col-md-3 col-sm-7">
                                    <input type="text" name="Keywords" id="Keywords" value="<%=where[0]%>" class="form-control input-sm" placeholder="ITEM NAME, ITEM CODE, ITEM TYPE, MANUFACTURE NAME" />
                                </div>
                                <div class="col-md-3 col-sm-7">
                                    <input type="submit" name="search" id="Submit1" value="Search" class="btn btn-success" onclick="showLoader()"/>
                                </div>
                            </div>
                        </fieldset>
                    </div>
                </form>

                <%if(where[2]=="Search"){ %>
                <div class="box-body">
                    <div id="printableArea">
                        <table class="table table-striped" id="testTable" rules="groups" style="border:1px solid #000">
                            <tr>
                                <td colspan="11" style="text-align: center; font-size: 27px; font-weight: bold;border:1px solid #000">Stock Book</td>
                            </tr>
                            <tr>
                                <th style="border:1px solid #000">#</th>
                                <th style="border:1px solid #000">ITEM DESCRIPTION</th>
                                <th style="border:1px solid #000">QUANTITY</th>
                                <th style="border:1px solid #000">VALUE</th>
                            </tr>
                            <%
                                int i=0;

                                String whereClause = " company_id='" + where[1] + "' ";
                                
                                if(where[0]!="")
                                {
                                    whereClause += " and item_name='" + where[0] + "'  ";
                                }
                                decimal totqty = 0;
                                decimal totval = 0;
                                SqlDataReader rdr = inventory.GetDataReader("select * from tbl_item_master where " + whereClause + " order by item_name asc");
                                if(rdr.HasRows){
                                while (rdr.Read()){

                                string inwardqty = inventory.GetSum("inwardunitqty", "tbl_stock_details", "company_id='" + where[1] + "' and item_id='" + rdr["id"] + "' and status=1");
                                
                                string outwardqty = inventory.GetSum("outwardunitqty", "tbl_stock_details", "company_id='" + where[1] + "' and item_id='" + rdr["id"] + "' and status=1");

                                if(string.IsNullOrWhiteSpace(inwardqty))
                                    inwardqty = "0";
                                if(string.IsNullOrWhiteSpace(outwardqty))
                                    outwardqty = "0";

                                decimal avlqty = Convert.ToDecimal(inwardqty) - Convert.ToDecimal(outwardqty);
                                totqty += avlqty;

                                decimal rateval = Convert.ToDecimal(inventory.GetMax("rate", "tbl_stock_details", "company_id='" + where[1] + "' and item_id='" + rdr["id"] + "' and status=1"));
                                totval += rateval;

                                string colors = "style='background-color:green;'";
                                if(avlqty<0)
                                {
                                    colors = "style='background-color:#ff4d4d;'";
                                }
                                if(avlqty==0)
                                {
                                    colors = "style='background-color:orange'";
                                }
                            %>
                            <tr <%=colors %>>
                                <td style="border:1px solid #000"><%=++i %></td>
                                <td style="border:1px solid #000"><%=rdr["item_name"] %> <%=rdr["item_code"] %> <%=rdr["manufacture_name"] %></td>
                                <td style="border:1px solid #000"><%=avlqty.ToString("#") %></td>
                                <td style="text-align:right;border:1px solid #000">&#8377; <%=rateval.ToString("#.##")%></td>
                            </tr>
                            <%}%>
                            <tr style="font-weight:bold">
                                <td style="text-align:right;border:1px solid #000" colspan="2">Total</td>
                                <td style="border:1px solid #000"><%=totqty.ToString("#")%></td>
                                <td style="text-align:right;border:1px solid #000">&#8377; <%=0.ToString("0.00")%></td>
                            </tr>
                             <%   } else{ %>
                            <tr>
                                <td colspan="4" style="border:1px solid #000"><strong>No records found.</strong></td>
                            </tr>

                            <%} %>
                        </table>
                    </div>
                </div>
                <div class="form-group row">
                    <div class="col-md-12 col-sm-7" style="text-align: center;">
                        <button type="button" onclick="tableToExcel('testTable', 'admission')" class="btn btn-info">
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
