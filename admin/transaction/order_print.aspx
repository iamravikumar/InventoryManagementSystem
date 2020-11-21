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
                <h3 class="box-title">Purchase Order</h3>
                <div class="box-tools pull-right">
                    <a href="purchase_list.aspx?cmd=Clear" class="btn btn-primary"><i class="fa fa-fw fa-long-arrow-left"></i>Back</a>
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
                    <!-- info row -->
                    <div class="row invoice-info">
                        <div class="col-sm-4 invoice-col">
                            From
         
                        <address>
                            <strong><%=inventory.COMPANY["company_name"]%></strong><br />
                            <strong>Mailing Address: <%=inventory.COMPANY["mailing_name"]%></strong><br />
                            <%if(inventory.COMPANY["address_1"]!=""){ %>
                            <%=inventory.COMPANY["address_1"]%><br />
                            <%} %>
                            <%if(inventory.COMPANY["address_2"]!=""){ %>
                            <%=inventory.COMPANY["address_2"]%><br />
                            <%} %>
                            <%if(inventory.COMPANY["state"]!=""){ %>
                            <%=inventory.COMPANY["state"]%>, <%=inventory.COMPANY["country"]%><br />
                            <%} %>
                            <%if(inventory.COMPANY["pin_code"]!=""){ %>
                            <%=inventory.COMPANY["pin_code"]%><br />
                            <%} %>
                            GSTIN No.: <%=inventory.COMPANY["gstin_no"]%><br />
                            Phone: (91) <%=inventory.COMPANY["mobile_no"]%><br />
                            Email: <%=inventory.COMPANY["email_address"]%>
                        </address>
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-4 invoice-col">
                            To
         
                        <address>
                            <strong><%=ledger["name"] %> (<%=ledger["code"] %>)</strong><br>
                            <%if(ledger["address_1"]!=""){ %>
                            <%=ledger["address_1"] %><br>
                            <%} %>
                            <%if(ledger["address_2"]!=""){ %>
                            <%=ledger["address_2"] %><br>
                            <%} %>
                            Phone: (91) <%=ledger["mobile_no"] %><br>
                            Helpdesk: <%=ledger["contact_no"] %><br>
                            Email: <%=ledger["email"] %><br />
                            GSTIN No.: <%=ledger["gstin_no"] %><br />         
                        </address>
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-4 invoice-col">
                            <b>Order ID:</b> <%=inventory.TempRs["autogen_id"] %><br>
                            <b>Order Date:</b> <%=Convert.ToDateTime(inventory.TempRs["stock_dt"]).ToString("dd-MMM-yyyy") %><br>
                            <b>Due Date:</b> <%=Convert.ToDateTime(inventory.TempRs["due_dt"]).ToString("dd-MMM-yyyy") %>
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
                                        <th>#</th>
                                        <th>Particulars</th>
                                        <th>Quantity</th>
                                        <th>Unit Price</th>
                                        <th>Total Price</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        SqlDataReader rdr = inventory.GetDataReader("select * from tbl_order_item_details where inv_id='" + inventory.TempRs["id"] + "' and status=1 order by id asc");
                                         int i=0;
                                         decimal total=0;
                                    while (rdr.Read())
                                    {
                                         Hashtable itemhs = inventory.GetRecords("select item_name + ' ('+ item_code +')' as item_name from view_item_master where id='" + rdr["item_id"]+"'");
                                         string qty_type=inventory.GetText("tbl_unit_master", "symbol", "id='"+rdr["unit_id"]+"'");
                                         total+=Convert.ToDecimal(rdr["total_purchase_rate"]);
                                    %>
                                    <tr>
                                        <td><%=++i %></td>
                                        <td><%=itemhs["item_name"] %></td>
                                        <td><%=rdr["unit"] %> <%=qty_type %></td>
                                        <td><%=rdr["purchase_rate"]%></td>
                                        <td><%=rdr["total_purchase_rate"]%></td>
                                    </tr>
                                    <%} rdr.Close();%>
                                </tbody>
                            </table>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <div class="row">
                        <!-- accepted payments column -->
                        <div class="col-xs-6">
                            &nbsp;
                        </div>
                        <!-- /.col -->
                        <div class="col-xs-6">
                            <div class="table-responsive">
                                <table class="table">
                                    <tr>
                                        <th style="text-align:right">Subtotal:</th>
                                        <td>&#8377; <%=total.ToString("0.00") %></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <div class="row">
                        <div class="col-xs-6">
                           <b><%=inventory.GetText("tbl_invoice_setup_master", "footer_text", "invoice_type='PURCHASE ORDER' and company_id='" + inventory.COMPANY["id"] + "' and effective_date<=getdate() and status=1 order by effective_date desc") %></b>
                        </div>
                    </div>
                </div>
                <!-- .print row -->

                <!-- this row will not appear when printing -->
                <div class="row no-print">
                    <div class="col-xs-12">
                        <button type="button" class="btn btn-success pull-right" style="margin-right: 5px;" onclick="printDiv('printableArea')">
                            <i class="fa fa-print"></i>Print
                        </button>
                        <button type="button" class="btn btn-primary pull-right" style="margin-right: 5px;" onclick="printDiv('printableArea')">
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
