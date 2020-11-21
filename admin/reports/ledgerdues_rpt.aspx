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

    $(function () {
        $("#print").click(function () {
            var contents = $("#printableArea").html();
            var frame1 = $('<iframe />');
            frame1[0].name = "frame1";
            frame1.css({ "position": "absolute", "top": "-1000000px" });
            $("body").append(frame1);
            var frameDoc = frame1[0].contentWindow ? frame1[0].contentWindow : frame1[0].contentDocument.document ? frame1[0].contentDocument.document : frame1[0].contentDocument;
            frameDoc.document.open();
            //Create a new HTML document.
            frameDoc.document.write('<html><head><title></title>');
            frameDoc.document.write('</head><body>');
            //Append the external CSS file.
            //frameDoc.document.write('<link href="bootstrap.min.css" rel="stylesheet" type="text/css" />');
            //Append the DIV contents.
            frameDoc.document.write(contents);
            frameDoc.document.write('</body></html>');
            frameDoc.document.close();
            setTimeout(function () {
                window.frames["frame1"].focus();
                window.frames["frame1"].print();
                frame1.remove();
            }, 500);
        });
    });

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
                <h3 class="box-title">Dues Report</h3>
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
                            where[0] = Request["Keywords"]; 
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
                                    <input type="text" name="Keywords" id="Keywords" value="<%=where[0]%>" class="form-control input-sm" placeholder="LEDGER NAME, LEDGER CODE" />
                                </div>
                                <div class="col-md-3 col-sm-7">
                                    <input type="submit" name="search" id="search" value="Search" class="btn btn-success" onclick="showLoader()"/>
                                </div>
                            </div>
                         </fieldset>
                    </div>
                    </form>

                    <%if(where[2]=="Search"){ %>
                    <div class="box-body">
                        <div id="printableArea">
                        <table class="table table-bordered" id="testTable" rules="groups" style="width: 80%;margin:auto">
                            <tr>
                                <td colspan="5" style="text-align: center; font-size: 27px; font-weight: bold">Dues Report</td>
                            </tr>
 
                            <tr>
                                <th>#</th>
                                <th>LEDGER</th>
                                <th style="text-align:right;">Group</th>
                                <th style="text-align:right;">CR</th>
                                <th style="text-align:right;">DR</th>
                            </tr>

                            <%
                                int i=0;

                                string whereClause = " company_id='" + where[1] + "' and (name like '%"+where[0]+"%' or code like '%"+where[0]+"%') ";

                                SqlDataReader rdr = inventory.GetDataReader("select ledger_id, name, code, group_name, sum(cr) as cr, sum(dr) as dr  from view_transaction_master where " + whereClause + " and status=1 group by ledger_id, name, code,group_name order by name asc");
           
                                if(rdr.HasRows){
                                while (rdr.Read()){

                                
                            %>
                            <tr>
                                <td><%=++i %></td>
                                <td>
                                    <a href="invoicedues_rpt.aspx?uid=<%=inventory.MD5(rdr["ledger_id"].ToString()) %>"><%=rdr["name"] %> (<%=rdr["code"] %>)</a>
                                </td>
                                <td style="text-align:right;"><%=rdr["group_name"] %></td>
                                <td style="text-align:right;">&#8377; <%=rdr["cr"] %></td>
                                <td style="text-align:right;">&#8377; <%=rdr["dr"] %></td>
                            </tr>
                            <%} %>
                            <tr style="color:red; font-weight:bold">
                                <td colspan="5">#Click on Ledger to see invoice wise report.</td>
                            </tr>
                            <%} %>
                        </table></div>
                    </div>
                     <div class="form-group row">
                    <div class="col-md-12 col-sm-7" style="text-align: center;">
                        <button type="button" onclick="tableToExcel('testTable', 'admission')" class="btn btn-info">
                        <i class="fa fa-file-excel-o"> Export To Excel</i>
                        </button>
                        &nbsp;
                        <button type="button" id="print" name="print" class="btn btn-info"  ><!--onclick="printDiv('printableArea')"-->
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
<!-- #include file="../footer.aspx"-->
