

<script>
  $(function () {
      $('#bootstarp-table').DataTable({
      "paging": true,
      "lengthChange": true,
      "searching": true,
      "ordering": true,
      "info": true,
      "autoWidth": false
    });
  });
</script>

  <!-- Main Footer -->
  <footer class="main-footer">
    <!-- To the right -->
    <!-- Default to the left -->
    <strong>Powered By <a href="#" target="_blank"><%=setting["footer"]%></a></strong>
  </footer>

<!-- bootstrap datepicker -->
<script src="<%=SOURCE_ROOT%>/plugins/datepicker/bootstrap-datepicker.js"></script>
<script src="<%=SOURCE_ROOT%>/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="<%=SOURCE_ROOT%>/plugins/datatables/dataTables.bootstrap.min.js"></script>

</div>
</body>
</html>

