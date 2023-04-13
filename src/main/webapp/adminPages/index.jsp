<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.bya.ConSql" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %><%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 27.02.2023
  Time: 17:08
  To change this template use File | Settings | File Templates.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%

  DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
  LocalDate today = LocalDate.now();
  String strToday = today.format(formatter);
  strToday = "2023-03-17";
  ConSql conSql = new ConSql();
  int count = 0;
  ArrayList<GetInfo> sqlInfo = new ArrayList<>();

  sqlInfo = conSql.readData("SELECT * FROM appointments Where `date` = '" +strToday+"'");
%>

<!DOCTYPE html>
<html lang="tr">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Yönetici Sayfası</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <!-- Favicons -->
  <link href="assets/img/favicon.png" rel="icon">


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

</head>

<body>

    <jsp:include page="adminHeader.jsp" flush="true"/>

    <jsp:include page="adminSidebar.jsp" flush="true"/>



  <main id="main" class="main">

    <div class="pagetitle">
      <h1>Gösterge Paneli</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.jsp">Ana Sayfa</a></li>
          <li class="breadcrumb-item active">Gösterge Paneli</li>
        </ol>
      </nav>
    </div><!-- End Page Title -->

    <section class="section dashboard">
      <div class="row">

        <!-- Left side columns -->
        <div class="">
          <div class="row">

            <!-- Sales Card -->
            <div class="col-xxl-4 col-md-6">
              <div class="card info-card sales-card">

                <div class="filter">
                  <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                  <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                    <li class="dropdown-header text-start">
                      <h6>Filter</h6>
                    </li>

                    <li><a class="dropdown-item" href="#">Bugün</a></li>
                    <li><a class="dropdown-item" href="#">Bu Ay</a></li>
                    <li><a class="dropdown-item" href="#">Bu Yil</a></li>
                  </ul>
                </div>

                <div class="card-body">
                  <h5 class="card-title">Randevular <span>| Bugün</span></h5>

                  <div class="d-flex align-items-center">
                    <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                      <i class="bi bi-person"></i>
                    </div>
                    <div class="ps-3">
                        <h6><%out.println(sqlInfo.size());%></h6>

                    </div>
                  </div>
                </div>

              </div>
            </div><!-- End Sales Card -->


             


            <div class="col-12">
              <div class="card top-selling overflow-auto">

                <div class="filter">
                  <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                  <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                    <li class="dropdown-header text-start">
                      <h6>Filter</h6>
                    </li>

                    <li><a class="dropdown-item" href="#">Bugün</a></li>
                    <li><a class="dropdown-item" href="#">Bu Ay</a></li>
                    <li><a class="dropdown-item" href="#">This Year</a></li>
                  </ul>
                </div>

                <div class="card-body pb-0">
                  <h5 class="card-title">Randevular <span>| Bugün</span></h5>

                  <table class="table table-borderless">
                    <thead>
                      <tr>
                        <th scope="col">#</th>
                        <th scope="col">Danışanın Adı-Soyadı</th>
                        <th scope="col">Saat</th>
                        <th scope="col">Telefon No</th>
                        <th scope="col">Yer</th>
                        <th scope="col">Düzenle</th>
                        <th scope="col">Iptal</th>


                      </tr>
                    </thead>
                    <tbody>
                    <%
                        for(int i = 0; i < sqlInfo.size(); i++){
                          sqlInfo.get(i).getCustNameSurname();
                          sqlInfo.get(i).getCustNameSurname();
                          sqlInfo.get(i).getCustNameSurname();
                          sqlInfo.get(i).getCustNameSurname();
                    %>
                    <tr>
                      <th class="pt-3">#<%out.println(i+1);%></th>
                      <td><%out.println(sqlInfo.get(i).getCustNameSurname());%></td>
                      <td><%out.println(sqlInfo.get(i).getAppHour());%></td>
                      <td><%out.println(sqlInfo.get(i).getCustPhone());%></td>
                      <td><%out.println(sqlInfo.get(i).getAppHour());%></td>
                      <td><button type="button" class="btn btn-info">Info</button></td>
                      <td><button type="button" class="btn btn-danger">Danger</button></td>


                    </tr>
                    <%
                      }
                    %>

                    </tbody>
                  </table>

                </div>
            </div>
              <div class="row align-items-start">
                <div class = "col-5">
                  <button class="btn btn-warning btn-lg" type="button" style="padding:30px;">Müsait Günler ve Saatler</button>
                </div>
                <div class = "col-7">
                  <button class="btn btn-secondary btn-lg" type="button" style="padding:30px;">Tüm Randevular</button>
                </div>
                <div class = "col-7 mt-4">
                  <button class="btn btn-info btn-lg" type="button" style="padding:30px;">Sayfa Ayarlari</button>
                </div>

              </div>
            </div>

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

</body>

</html>

