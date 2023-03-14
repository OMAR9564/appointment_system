<%--
    Document   : pages-customers
    Created on : Dec 21, 2022, 10:32:33 PM
    Author     : omerfaruk
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.omar.hotelreservation.mySql"%>
<%@page import="com.omar.hotelreservation.getInfo"%>
<%@page import="com.omar.hotelreservation.hotelData"%>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.lang.module.FindException" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if((((String)session.getAttribute("adminName")).length() > 1)){
//    customers data
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://app.sobiad.com:3306/grup9?useUnicode=true&characterEncoding=UTF-8&useSSL=false", "grup9", "9564");

    ArrayList<getInfo> info;
    mySql mysql = new mySql();

    String sqlQuery = "SELECT * FROM `customer`";
    PreparedStatement ps = con.prepareStatement(sqlQuery);
    ResultSet rls = ps.executeQuery();
    info = mysql.readCustomersData(rls);

    session.setAttribute("custCountPagesCust", Integer.toString(info.size()));


%>

<!DOCTYPE html>
<html lang="tr">

<head>
   <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Pages / Customers - Admin Page</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <!-- Favicons -->
  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.gstatic.com" rel="preconnect">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
  <link href="assets/vendor/quill/quill.snow.css" rel="stylesheet">
  <link href="assets/vendor/quill/quill.bubble.css" rel="stylesheet">
  <link href="assets/vendor/remixicon/remixicon.css" rel="stylesheet">
  <link href="assets/vendor/simple-datatables/style.css" rel="stylesheet">

  <!-- Template Main CSS File -->
  <link href="assets/css/style.css" rel="stylesheet">
  
  <script>
      
</script>

</head>

<body>

    <jsp:include page="adminHeader.jsp" flush="true"/>
    
    <jsp:include page="adminSidebar.jsp" flush="true"/>



  <main id="main" class="main">
    <div class="pagetitle">
      <h1>Customers</h1>
      <nav>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="pages-customers.jsp">Home</a></li>
          <li class="breadcrumb-item active">Customers</li>
        </ol>
      </nav>
    </div><!-- End Page Title -->
    
    <section class="section dashboard">
    <div class="row">
             <div class="alert alert-<%out.println((String)session.getAttribute("adminAlertOk"));%> alert-dismissible fade <%out.println((String)session.getAttribute("adminShowAlert"));%>" role="alert">
                <i class="bi bi-check-circle me-1"></i>
                <%out.println((String)session.getAttribute("adminAlertLog"));%>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
              </div>
        <!-- Left side columns -->
        <div class="">
            <div class="row">
            <!-- Recent Sales -->
            <div class="col-12">
              <div class="card recent-sales overflow-auto">

                <div class="filter">
                  <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                  <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                    <li class="dropdown-header text-start">
                      <h6>Filter</h6>
                    </li>

                    <li><a class="dropdown-item" href="#">Today</a></li>
                    <li><a class="dropdown-item" href="#">This Month</a></li>
                    <li><a class="dropdown-item" href="#">This Year</a></li>
                  </ul>
                </div>

                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4">
                        <h5 class="card-title">Costumer <span>| Today</span></h5>
                        </div>
                        <div class='col-md-2 ms-auto mt-3 d-grid gap-3 me-5 mb-3' >
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">Add</button>
                        </div>
                    </div>
                  <table class="table">
                    <thead>
                      <tr>
                        <th scope="col">#</th>
                        <th scope="col">Adi Soyadı</th>
                        <th scope="col">E-Mail</th>
                        <th scope="col">Phone</th>
                        <th scope="col">Edit</th>
                        <th scope="col">Delete</th>
                      </tr>
                    </thead>
                    <tbody>
                        <%
                            
                            for(int i = 0; i < Integer.parseInt((String)session.getAttribute("custCountPagesCust")); i++){
                            session.setAttribute("custId", Integer.toString(info.get(i).getCustId()));
                            session.setAttribute("custName", info.get(i).getCustName());
                            session.setAttribute("CustMail", info.get(i).getCustMail());
                            session.setAttribute("CustPhone", info.get(i).getCustPhone());
                        %>
                      <tr>
                        <th scope="row"><a href="#">#<%out.println(i + 1);%></a></th>
                        <td><%out.println((String)session.getAttribute("custName"));%></td>
                        <td><a href="#" class="text-primary"><%out.println((String)session.getAttribute("CustMail"));%></a></td>
                        <td><span class="badge" style="color:black; font-size: 12px;"><%out.println((String)session.getAttribute("CustPhone"));%></span></td>
                        <td><button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#editModal" data-bs-id="<%out.println(Integer.parseInt((String)session.getAttribute("custId")));%>" data-bs-name="<%out.println((String)session.getAttribute("custName"));%>" data-bs-mail="<%out.println((String)session.getAttribute("CustMail"));%>" data-bs-phone="<%out.println((String)session.getAttribute("CustPhone"));%>"><i class="bi bi-info-circle" ></i></button></td>
                        <td><button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-bs-idDel="<%out.println(Integer.parseInt((String)session.getAttribute("custId")));%>"><i class="bi bi-x-octagon"></i></button></td>
                      </tr>
                      <%}%>
                    </tbody>
                  </table>
                    <!--edit modal-->
                    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
                      <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 class="modal-title" id="editModalLabel">Edit</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                              <form method="post" action="adminSqlCon.jsp">
                                  <input type="text" class=" idInput" name="id" hidden>
                              <div class="row">  
                              <div class="mb-3 col-md-6">
                                <label for="name" class="col-form-label">Name:</label>
                                <input type="text" class="form-control nameInput" name="name" id="name">
                              </div>
                                <input type="text" value="customerEdit" name="iam" hidden>

                              <div class="mb-3 col-md-6 ms-auto">
                                <label for="Mail" class="col-form-label">E-Mail:</label>
                                <input class="form-control mailInput" id="Mail" name="mail"></input>
                              </div></div>
                                <div class="mb-3 col-md-6">
                                <label for="phone" class="col-form-label">Phone:</label>
                                <input type="text" class="form-control phoneInput" name="phone" id="phone">
                              </div>
                            
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <input type="submit" class="btn btn-primary" value="Edit">
                          </div>
                        </form>
                        </div>
                      </div>
                    </div>
                    </div>
                    <!--Delete modal-->
                    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                          <div class="modal-content">
                            <div class="modal-header">
                              <h5 class="modal-title" id="deleteModalLabel">Silmek istediğinizden eminmisiniz?</h5>
                              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    Bu kullanıcının tüm bilgilerini silenecektir!!
                                </div>
                              
                              <form method="post" action="adminSqlCon.jsp">
                                  <input type="text" class="delIdInput" name="id" hidden>
                              
                                <input type="text" value="customerDelete" name="iam" hidden>
                                <div class="modal-footer">
                              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                              <input type="submit" class="btn btn-danger" value="Delete this customer">
                              
                            </div>
                              </form>
                        </div>
                      </div>
                </div>

              </div>
                    <!--add modal-->
                    <div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
                      <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 class="modal-title" id="addModalLabel">ADD</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                          </div>
                          <div class="modal-body">
                              <form method="post" action="adminSqlCon.jsp">
                              <div class="row">  
                              <div class="mb-3 col-md-6">
                                <label for="name" class="col-form-label">Name:</label>
                                <input type="text" class="form-control nameInput" name="name" id="name">
                              </div>
                              <div class="mb-3 col-md-6 ms-auto">
                                <label for="Mail" class="col-form-label">E-Mail:</label>
                                <input class="form-control mailInput" id="Mail" name="mail"></input>
                              </div></div>
                                  <div class="row"> 
                                <div class="mb-3 col-md-6">
                                <label for="phone" class="col-form-label">Phone:</label>
                                <input type="text" class="form-control phoneInput" name="phone" id="phone">
                                <input type="text" value="customerAdd" name="iam" hidden>
                              </div>
                                <div class="mb-3 col-md-6 ms-auto">
                                <label for="phone" class="col-form-label">Password</label>
                                <input type="password" class="form-control phoneInput" name="pass" id="pass">
                                </div></div>
                            <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <input type="submit" class="btn btn-success" value="Add">
                          </div>
                        </form>
                          </div>
                          

                        </div>
                      </div>
                    </div>
            </div><!-- End Recent Sales -->
            </div>   
        </div> 
    </div> 
    </div> 
    </div> 
    </section>
    
  </main><!-- End #main -->



  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="assets/vendor/chart.js/chart.min.js"></script>
  <script src="assets/vendor/echarts/echarts.min.js"></script>
  <script src="assets/vendor/quill/quill.min.js"></script>
  <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
  <script src="assets/vendor/tinymce/tinymce.min.js"></script>
  <script src="assets/vendor/php-email-form/validate.js"></script>

  <!-- Template Main JS File -->
  <script src="assets/js/main.js"></script>
  <script>
      `use strict`;
    var exampleModal = document.getElementById('editModal');
    
    exampleModal.addEventListener('show.bs.modal', function (event) {
  var button = event.relatedTarget;
  var name = button.getAttribute('data-bs-name');
  var id = button.getAttribute('data-bs-id');
  var mail = button.getAttribute('data-bs-mail');
  var phone = button.getAttribute('data-bs-phone');

  var modalBodyInputName = exampleModal.querySelector('.modal-body .nameInput');
  var modalBodyInputId = exampleModal.querySelector('.modal-body .idInput');
  var modalBodyInputPhone = exampleModal.querySelector('.modal-body .phoneInput');
  var modalBodyInputMail = exampleModal.querySelector('.modal-body .mailInput');


  modalBodyInputName.value = name;
  modalBodyInputId.value = id;
  modalBodyInputPhone.value = phone;
  modalBodyInputMail.value = mail;


});
   var deleteModal = document.getElementById('deleteModal');

      deleteModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;
console.log("omeroemroemreomreormeormeorm");
  var delId = button.getAttribute('data-bs-idDel'); 
  var modalBodyInputDelId = deleteModal.querySelector('.modal-body .delIdInput');
    modalBodyInputDelId.value = delId;

});

  </script>



</body>

</html>
<%
    }else {
        response.sendRedirect("../index.jsp");
    }
%>