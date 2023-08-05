<%--
    Document   : pages-customers
    Created on : Dec 21, 2022, 10:32:33 PM
    Author     : omerfaruk
--%>

<%@ page import="com.bya.ConSql" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%
    //    if((((String)session.getAttribute("adminName")).length() > 1)){
    if (true) {

        ArrayList<GetInfo> info = new ArrayList<>();
        ArrayList<GetInfo> locInfo = new ArrayList<>();
        ArrayList<GetInfo> docInfo = new ArrayList<>();
        ArrayList<GetInfo> revInfo = new ArrayList<>();
        ArrayList<GetInfo> revNameInfo = new ArrayList<>();


        String sqlQuery = "SELECT * FROM `appointments` ORDER BY `appointments`.`date` DESC ";
        String locQuery = "SELECT * FROM `locationInfo`";
        String docQuery = "SELECT * FROM `doctorInfo`";
        String reservationQuery = "SELECT * FROM `reservationInfo`";
        String reverationNameQuery = "SELECT * FROM `reservationInfo` WHERE `tagName` = ?";

        ConSql consql = new ConSql();
        info = consql.getAppointmentData(sqlQuery);
        locInfo = consql.getInfos(locQuery);
        docInfo = consql.getInfos(docQuery);
        revInfo = consql.getRezervationInfos(reservationQuery);
        session.setAttribute("appointmentCount", Integer.toString(info.size()));

        String requestStr = null;
        String discroption = null;
        Boolean appointmentMade = null;
        String appointmentNotMadeStr = "";
        String messageHeader = "Işlemi sonucu";

        requestStr = request.getParameter("message");
        discroption = request.getParameter("dic");

        if (discroption == null) {
            discroption = "";
        }
        if (requestStr != null && requestStr.equals("true")) {
            appointmentMade = true;
        } else {
            if (discroption.length() != 0) {
                appointmentNotMadeStr = discroption;
            }
            appointmentMade = false;
        }


%>

<!DOCTYPE html>
<html lang="tr">

<head>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <title>Sayfalar / Randevular - Admin Page</title>
    <meta content="" name="description">
    <meta content="" name="keywords">

    <!-- Favicons -->
    <link href="assets/img/favicon.png" rel="icon">
    <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

    <!-- Google Fonts -->
    <link href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|
  Nunito:300,300i,400,400i,600,600i,700,700i|
  Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

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
        <h1>Randevular</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index.jsp">Ana Sayfa</a></li>
                <li class="breadcrumb-item active"><a href="pages-appointments.jsp">Randevular</li>
            </ol>
        </nav>
    </div><!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">
            <div class="alert alert-<%out.println((String)session.getAttribute("adminAlertOk"));%> alert-dismissible fade
                <%out.println((String)session.getAttribute("adminShowAlert"));%>" role="alert">
                <i class="bi bi-check-circle me-1"></i>
                <%out.println((String) session.getAttribute("adminAlertLog"));%>
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

                                    <li><a class="dropdown-item" href="#">Bugün</a></li>
                                    <li><a class="dropdown-item" href="#">Bu Ay</a></li>
                                    <li><a class="dropdown-item" href="#">Bu Yıl</a></li>
                                </ul>
                            </div>

                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <h5 class="card-title">Randevular <span>| Bugün</span></h5>
                                    </div>
                                    <div class='col-md-2 ms-auto mt-3 d-grid gap-3 me-5 mb-3'>
                                        <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                                data-bs-target="#addModal">Ekle
                                        </button>
                                    </div>
                                </div>
                                <table class="table">
                                    <thead>
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Adı Soyadı</th>
                                        <th scope="col">Telefon</th>
                                        <th scope="col">Doktor Adı</th>
                                        <th scope="col">Yer</th>
                                        <th scope="col">Tarih</th>
                                        <th scope="col">Baslangic Saati</th>
                                        <th scope="col">Bitis Saati</th>
                                        <th scope="col">Randevu Turu</th>

                                        <th scope="col">Düzenle</th>
                                        <th scope="col">Sil</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%

                                        for (int i = 0; i < Integer.parseInt((String) session.getAttribute("appointmentCount")); i++) {
                                            revNameInfo = consql.getRezervationInfos(reverationNameQuery, info.get(i).getRezervationInterval());
                                            session.setAttribute("custId", Integer.toString(info.get(i).getId()));
                                            session.setAttribute("custName", info.get(i).getCustName());
                                            session.setAttribute("custSurname", info.get(i).getCustSurname());
                                            session.setAttribute("custNameSurname", info.get(i).getCustNameSurname());
                                            session.setAttribute("CustPhone", info.get(i).getCustPhone());
                                            session.setAttribute("DoctorName", info.get(i).getDoctorName());
                                            session.setAttribute("AppLocation", info.get(i).getAppLocation());
                                            session.setAttribute("AppDate", info.get(i).getAppDate());
                                            session.setAttribute("AppStartHour", info.get(i).getAppStartHour());
                                            session.setAttribute("AppEndHour", info.get(i).getAppEndHour());
                                            session.setAttribute("AppIntervalValue", info.get(i).getRezervationInterval());

                                            session.setAttribute("AppInterval", revNameInfo.get(0).getRezervationName());



                                    %>
                                    <tr>
                                        <th scope="row"><a href="#">#<%out.println(i + 1);%></a></th>
                                        <td><%out.println((String) session.getAttribute("custNameSurname"));%></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("CustPhone"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("DoctorName"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppLocation"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppDate"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppStartHour"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppEndHour"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppInterval"));%></span></td>

                                        <td>
                                            <button type="button" class="btn btn-info" data-bs-toggle="modal"
                                                    data-bs-target="#editModal"
                                                    data-bs-id="<%out.println(Integer.parseInt((String)session.getAttribute("custId")));%>"
                                                    data-bs-nameSurname="<%out.println((String)session.getAttribute("custNameSurname"));%>"
                                                    data-bs-name="<%out.println((String)session.getAttribute("custName"));%>"
                                                    data-bs-surname="<%out.println((String)session.getAttribute("custSurname"));%>"

                                                    data-bs-phone="<%out.println((String)session.getAttribute("CustPhone"));%>"
                                                    data-bs-date="<%out.println((String)session.getAttribute("AppDate"));%>"
                                                    data-bs-doktorName="<%out.println((String)session.getAttribute("DoctorName"));%>"
                                                    data-bs-location="<%out.println((String)session.getAttribute("AppLocation"));%>"
                                                    data-bs-interval="<%out.println((String)session.getAttribute("AppIntervalValue"));%>"
                                                    data-bs-startHour="<%out.println((String)session.getAttribute("AppStartHour"));%>"
                                                    data-bs-endHour="<%out.println((String)session.getAttribute("AppEndHour"));%>">

                                                <i class="bi bi-info-circle"></i></button>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-danger"
                                                    data-bs-toggle="modal" data-bs-target="#deleteModal"
                                                    data-bs-idDel="<%out.println(Integer.parseInt((String)session.getAttribute("custId")));%>">
                                                <i class="bi bi-x-octagon"></i></button>
                                        </td>
                                    </tr>
                                    <%}%>
                                    </tbody>
                                </table>
                                <!--edit modal-->
                                <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel"
                                     aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="editModalLabel">Düzenle</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form method="post" action="adminSqlCon.jsp">
                                                    <input type="text" class=" idInput" name="id" hidden>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="name" class="col-form-label">Adı:</label>
                                                            <input type="text" class="form-control nameInput"
                                                                   name="name" id="name">
                                                        </div>
                                                        <input type="text" value="appointmentEdit" name="iam" hidden>
                                                        <input type="text" value="pages-appointments.jsp" name="page"
                                                               hidden>

                                                        <input type="text" value="pages-appointments.jsp" name="page"
                                                               hidden>

                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="surname" class="col-form-label">Soyadı:</label>
                                                            <input type="text" class="form-control surnameInput"
                                                                   name="surname" id="surname">
                                                        </div>


                                                    </div>

                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="phone" class="col-form-label">Phone:</label>
                                                            <input type="text" class="form-control phoneInput"
                                                                   name="phone" id="phone">
                                                        </div>
                                                        <div class="mb-3 col-md-6">
                                                            <label for="date" class="col-form-label">Tarih:</label>
                                                            <input type="date" class="form-control dateInput"
                                                                   name="date" id="date">
                                                        </div>

                                                    </div>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="startHour" class="col-form-label">Baslangic
                                                                Saati:</label>
                                                            <input type="text" class="form-control startHourInput"
                                                                   maxlength="5"
                                                                   name="startHour" id="startHour">
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="endHour" class="col-form-label">Bitis
                                                                Saati:</label>
                                                            <input type="text" class="form-control endHourInput"
                                                                   maxlength="5"
                                                                   name="endHour" id="endHour">
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="doktorName" class="col-form-label">Doktor
                                                                Adı:</label>
                                                            <select class="form-control doctorInput" name="doktorName"
                                                                    id="doktorName">
                                                                <option value="" selected hidden>Seçin</option>
                                                                <%
                                                                    for (int i = 0; i < docInfo.size(); i++) {
                                                                %>
                                                                <option value=<%out.println((docInfo.get(i).getId()));%>>
                                                                    <%out.println(docInfo.get(i).getName());%>
                                                                </option>
                                                                <%
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="location" class="col-form-label">Yer:</label>
                                                            <select class="form-control locationInput" name="location"
                                                                    id="location">
                                                                <option value="" selected hidden>Seçin</option>
                                                                <%
                                                                    for (int i = 0; i < locInfo.size(); i++) {
                                                                %>
                                                                <option value=<%out.println((locInfo.get(i).getId()));%>>
                                                                    <%out.println(locInfo.get(i).getName());%>
                                                                </option>
                                                                <%
                                                                    }
                                                                %>
                                                            </select>

                                                        </div>
                                                        <div class="row">
                                                            <div class="mb-3 col-md-6">
                                                                <label for="interval" class="col-form-label">Randevu
                                                                    Turu:</label>
                                                                <select class="form-control intervalInput" name="interval"
                                                                        id="interval" >
                                                                    <option value="" selected hidden>Seçin</option>
                                                                    <%
                                                                        for (int i = 0; i < revInfo.size(); i++) {
                                                                    %>
                                                                    <option value=<%out.println((revInfo.get(i).getRezervationNameTag()));%>>
                                                                        <%out.println(revInfo.get(i).getRezervationName());%>
                                                                    </option>
                                                                    <%
                                                                        }
                                                                    %>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>


                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Kapat
                                                        </button>
                                                        <input type="submit" class="btn btn-primary" value="Edit">
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--Delete modal-->
                                <div class="modal fade" id="deleteModal" tabindex="-1"
                                     aria-labelledby="deleteModalLabel" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="deleteModalLabel">Silmek istediğinizden
                                                    emin misiniz?</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    Bu randevular tüm bilgilerini silenecektir!!
                                                </div>

                                                <form method="post" action="adminSqlCon.jsp">
                                                    <input type="text" class="delIdInput" name="id" id="id" hidden>
                                                    <input type="text" value="pages-appointments.jsp" name="page"
                                                           hidden>
                                                    <input type="text" value="appoitnmentDelete" name="iam" hidden>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Kapat
                                                        </button>
                                                        <input type="submit" class="btn btn-danger"
                                                               value="Randevuyu sil">

                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <!--add modal-->
                                <div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel"
                                     aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="addModalLabel">Ekle</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form method="post" action="adminSqlCon.jsp">
                                                    <input type="text" class=" idInput" name="id" hidden>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="name" class="col-form-label">Adı Soyadı:</label>
                                                            <input type="text" class="form-control nameInput"
                                                                   name="name" id="name">
                                                        </div>
                                                        <input type="text" value="appointmentAdd" name="iam" hidden>
                                                        <input type="text" value="pages-appointments.jsp" name="page"
                                                               hidden>

                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="phone" class="col-form-label">Phone:</label>
                                                            <input type="text" class="form-control phoneInput"
                                                                   name="phone" id="phone">
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="date" class="col-form-label">Tarih:</label>
                                                            <input type="date" class="form-control dateInput"
                                                                   name="date" id="date">
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="hour" class="col-form-label">Saat:</label>
                                                            <input type="text" class="form-control hourInput"
                                                                   name="hour" id="hour">
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="doktorName" class="col-form-label">Doktor
                                                                Adı:</label>
                                                            <input type="text" class="form-control doctorInput"
                                                                   name="doktorName" id="doktorName">
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="location" class="col-form-label">Yer:</label>
                                                            <input type="text" class="form-control locationInput"
                                                                   name="location" id="location">
                                                        </div>
                                                    </div>


                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Kapat
                                                        </button>
                                                        <input type="submit" class="btn btn-primary" value="Ekle">
                                                    </div>
                                                </form>
                                            </div>


                                        </div>
                                    </div>
                                </div>
                                <!-- Button trigger modal -->
                                <button type="button" id="sucsessModalBtn" class="btn btn-primary"
                                        data-bs-toggle="modal" data-bs-target="#sucsessModal" hidden="hidden">
                                    Launch demo modal
                                </button>
                                <!-- Modal -->
                                <div class="modal fade" id="sucsessModal" tabindex="-1" aria-labelledby="sucsess-modal"
                                     aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5" id="sucsess-modal">
                                                    <%
                                                        if (appointmentMade) {
                                                            out.println(messageHeader);
                                                        } else {
                                                            out.println(messageHeader);
                                                        }
                                                    %>
                                                </h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <%
                                                    if (appointmentMade) {
                                                        out.println(discroption);
                                                    } else {
                                                        out.println(discroption);
                                                    }
                                                %>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                    Kapat
                                                </button>
                                            </div>
                                        </div>
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


<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i
        class="bi bi-arrow-up-short"></i></a>

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
        var surname = button.getAttribute('data-bs-surname');
        var id = button.getAttribute('data-bs-id');
        var date = button.getAttribute('data-bs-date');
        var phone = button.getAttribute('data-bs-phone');
        var doctorName = button.getAttribute('data-bs-doktorName');
        var location = button.getAttribute('data-bs-location');
        var startHour = button.getAttribute('data-bs-startHour');
        var endHour = button.getAttribute('data-bs-endHour');
        var interval = button.getAttribute('data-bs-interval');

        var modalBodyInputName = exampleModal.querySelector('.modal-body .nameInput');
        var modalBodyInputSurname = exampleModal.querySelector('.modal-body .surnameInput');

        var modalBodyInputId = exampleModal.querySelector('.modal-body .idInput');
        var modalBodyInputPhone = exampleModal.querySelector('.modal-body .phoneInput');
        var modalBodyInputDate = exampleModal.querySelector('.modal-body .dateInput');
        var modalBodyInputDoctor = exampleModal.querySelector('.modal-body .doctorInput');
        var modalBodyInputLocation = exampleModal.querySelector('.modal-body .locationInput');
        var modalBodyInputInterval = exampleModal.querySelector('.modal-body .intervalInput');
        var modalBodyInputStartHour = exampleModal.querySelector('.modal-body .startHourInput');
        var modalBodyInputEndHour = exampleModal.querySelector('.modal-body .endHourInput');


        modalBodyInputName.value = name;
        modalBodyInputSurname.value = surname;

        modalBodyInputId.value = id;
        modalBodyInputPhone.value = phone;
        modalBodyInputDate.value = date.trim();
        modalBodyInputDoctor.value = doctorName.trim();
        modalBodyInputLocation.value = location.trim();
        modalBodyInputInterval.value = interval.trim();
        modalBodyInputStartHour.value = startHour;
        modalBodyInputEndHour.value = endHour;


    });
    var deleteModal = document.getElementById('deleteModal');

    deleteModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        console.log("omeroemroemreomreormeormeorm");
        var delId = button.getAttribute('data-bs-idDel');
        var modalBodyInputDelId = deleteModal.querySelector('.modal-body .delIdInput');
        modalBodyInputDelId.value = delId;

    });

    <% if (requestStr != null && requestStr.length() > 1) { %>
    clickButton();
    <% } %>

    function clickButton() {
        var myButton = document.getElementById("sucsessModalBtn");
        myButton.click();
    }

    const startHour = document.getElementById("startHour");
    startHour.addEventListener("input", function () {
        const value = this.value.replace(/[^0-9]/g, "");
        if (value.length > 2) {
            this.value = value.slice(0, 2) + ":" + value.slice(2);
        }
    });
    const endHour = document.getElementById("endHour");
    endHour.addEventListener("input", function () {
        const value = this.value.replace(/[^0-9]/g, "");
        if (value.length > 2) {
            this.value = value.slice(0, 2) + ":" + value.slice(2);
        }
    });

</script>


</body>

</html>
<%
    } else {
        response.sendRedirect("../index.jsp");
    }
%>