<!-- #include file="local_header.aspx"-->
<%--<%@ Page Language="C#" %>--%>

<script type="text/javascript">
    function printDiv(divName) {
        var printContents = document.getElementById(divName).innerHTML;
        var originalContents = document.body.innerHTML;
        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
    }

</script>

<!-- Content Wrapper. Contains page content -->
<div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <!-- Main content -->
    <section class="content">
        <div class="box box-default">
            <div class="box-header with-border">
                <h3 class="box-title">Payment Voucher</h3>
                <div class="box-tools pull-right">
                    <a href="payment.aspx?cmd=Clear" class="btn btn-primary"><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
                </div>
            </div>
            <%inventory.Execute();
                Hashtable ledger = inventory.GetRecords("select * from view_ledger_master where company_id='" + inventory.COMPANY["id"] + "' and id='"+inventory.TempRs["ledger_id"]+"'");
                %>
            <section class="invoice">

                <!-- print row -->
                <div id="printableArea">
                    <div class="row">
                        <div class="col-xs-12">
                            <h2 class="page-header">
                                <center><medium><i class="fa fa-globe"></i>&nbsp;<%=inventory.COMPANY["mailing_name"]%></medium></center>
                            </h2>
                        </div>
                        <!-- /.col -->
                    </div>
                    <div class="row">
                        <div class="col-xs-12">
                            <h2 class="page-header">
                                <center>Payment Voucher</center>
                            </h2>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- info row -->
                    <div class="row invoice-info">
                        <div class="col-sm-10 invoice-col">
                            <span>
                            <b>Voucher ID:</b> <%=String.Format(inventory.TempRs["id"], "00000") %>
                            </span>
                            <span style="float:right">
                            <b>Voucher Date:</b> <%=Convert.ToDateTime(inventory.TempRs["ledger_dt"]).ToString("dd-MMM-yyyy") %>
                            </span>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <!-- Table row -->
                    <div class="row">
                        <div class="col-xs-12 table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th style="border-top:1px solid #000; border-bottom:1px solid #000">#</th>
                                        <th style="border-top:1px solid #000; border-bottom:1px solid #000">Particulars</th>
                                        <th style="border-top:1px solid #000; border-bottom:1px solid #000">Debit</th>
                                        <th style="border-top:1px solid #000; border-bottom:1px solid #000">Credit</th>
                                    </tr>
                                </thead>
                                <tbody>
                                     <tr>
                                        <td>1.</td>
                                        <td><%=ledger["name"] %></td>
                                        <td><%=inventory.TempRs["dr"] %></td>
                                        <td><%=inventory.TempRs["cr"] %></td>
                                    </tr>
                                    <tr>
                                        <td>2.</td>
                                        <td>Cash</td>
                                        <td><%=inventory.TempRs["cr"] %></td>
                                        <td><%=inventory.TempRs["dr"] %></td>
                                    </tr>
                                     <tr>
                                        <td style="border-top:1px solid #000"></td>
                                        <td style="border-top:1px solid #000">Total</td>
                                        <td style="border-top:1px solid #000"><%=inventory.TempRs["dr"] %></td>
                                        <td style="border-top:1px solid #000"><%=inventory.TempRs["dr"] %></td>
                                    </tr>
                                    <tr>
                                        <td style="border-top:1px solid #000" colspan="4"><b><%=new NumberToEnglish().changeCurrencyToWords(inventory.TempRs["dr"].ToString()) %></b></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <div class="row">
                        <div class="col-xs-1"></div>
                        <div class="col-xs-4">
                           Reciever
                        </div>
                        <div class="col-xs-3">
                           Accountant
                        </div>
                        <div class="col-xs-4">
                           Payee
                        </div>
                    </div>
                </div>
                <!-- .print row -->

                <hr />
                <!-- this row will not appear when printing -->
                <div class="row no-print" style="text-align:center">
                    <div class="col-xs-12">
                        <button type="button" class="btn btn-success" style="margin-right: 5px;" onclick="printDiv('printableArea')">
                            <i class="fa fa-print"></i>Print
                        </button>
                        <button type="button" class="btn btn-primary" style="margin-right: 5px;" onclick="printDiv('printableArea')">
                            <i class="fa fa-download"></i>Generate PDF
                        </button>
                    </div>
                </div>
            </section>
            <div class="clearfix"></div>
        </div>
        <!-- Your Page Content Here -->
    </section>
    <!-- /.content -->
</div>
<!-- /.content-wrapper -->
<!-- #include file="../footer.aspx"-->
