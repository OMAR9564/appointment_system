<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 19.08.2023
  Time: 21:34
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="com.bya.ConSql" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.bya.Helper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

    //startcontrol is login
    Helper helper = new Helper();
    String username = null;
    String ip = null;

    Boolean finded = false;

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("luna_token")) {
                if (!cookie.getValue().isEmpty()) {
                    helper.decodeJWT(cookie.getValue());
                    finded = true;
                } else {
                    finded = false;
                    break;
                }
            } else if (cookie.getName().equals("lipad_token")) {
                if (!cookie.getValue().isEmpty()) {
                    ip = (cookie.getValue());

                } else {
                    finded = false;
                    break;
                }
            }
        }
    }

    if (!finded) {
        HttpSession loginSession = request.getSession(false); // Yeni session oluşturulmasını engelle

        if (loginSession != null && loginSession.getAttribute("luna_token") != null) {
            username = helper.decodeJWT((String) loginSession.getAttribute("luna_token"));
            ip = ((String) loginSession.getAttribute("lipad_token"));
            finded = true;
        }
    }

    String sessionId = request.getSession().getId();
    boolean isValidToken = helper.validateToken(sessionId, ip);

    if (!isValidToken){
        response.sendRedirect("loginPage.jsp");
        return;
    }else{



        //end control is login


    String sqlQuery = "";


    ArrayList<GetInfo> dailyOCHours = new ArrayList<>();
    ConSql consql = new ConSql();
    sqlQuery = "SELECT * FROM `dailyOCHour` ORDER BY `dailyOCHour`.`day` DESC ";
    try {
        dailyOCHours = consql.getDailyOCHour(sqlQuery);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

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

    <title>Sayfalar / Müsait Günler ve Saatler</title>
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
        <h1>Müsait Günler ve Saatler</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index.jsp">Ana Sayfa</a></li>
                <li class="breadcrumb-item active"><a href="settingsPage.jsp">Müsait Günler ve Saatler</a></li>
            </ol>
        </nav>
    </div><!-- End Page Title -->

    <section class="section dashboard">
        <div class="row">

            <!-- Left side columns -->
            <div class="">
                <div class="row">
                    <!-- Recent Sales -->
                    <div class="col-12">
                        <div class="card recent-sales overflow-auto">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <h5 class="card-title">Müsait Günler ve Saatler
                                        </h5>
                                    </div>
                                    <div class="row">
                                        <%--<div class='d-grid gap-2 d-md-flex justify-content-md-end mb-3'>
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#addModal">Günde Müsait Olmayan Saatler
                                            </button>
                                        </div>--%>
                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mb-3">
                                            <button type="button" class="btn btn-warning" data-bs-toggle="modal"
                                                    data-bs-target="#addModal">Günde Müsait Olmayan Saatler
                                            </button>
                                            <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#addModal">Ekle
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <table class="table ">
                                    <thead>
                                    <tr>
                                    <th scope="col">Gün</th>
                                    <th scope="col">Açılış Saati</th>
                                    <th scope="col">Kapanış Saati</th>

                                    <th scope="col">Düzenle</th>
                                    <th scope="col">Sil</th>
                                    </tr>
                                    </thead>
                                    <tbody>

                                    <%
                                        for (int i = 0; i < dailyOCHours.size(); i++){
                                        session.setAttribute("id", Integer.toString(dailyOCHours.get(i).getId()));
                                        session.setAttribute("day", dailyOCHours.get(i).getDay());
                                        session.setAttribute("openingHour", dailyOCHours.get(i).getOpeningHour());
                                        session.setAttribute("closingHour", dailyOCHours.get(i).getClosingHour());
                                    %>
                                    <tr>
                                        <td scope="row"><%out.println((String) session.getAttribute("day"));%></td>
                                        <% if(((String) session.getAttribute("openingHour")).equals("0")){ %>
                                        <td scope="row"><%out.println("Tatil");%></td>
                                        <td scope="row"><%out.println("Tatil");%></td>

                                        <% } else{ %>
                                        <td scope="row"><%out.println((String) session.getAttribute("openingHour"));%></td>
                                        <td scope="row"><%out.println((String) session.getAttribute("closingHour"));%></td>
                                        <% } %>
                                        <td scope="row">
                                            <button type="button" class="btn btn-info" data-bs-toggle="modal"
                                                    data-bs-target="#editModal"
                                                    data-bs-id="<%out.println(Integer.parseInt((String)session.getAttribute("id")));%>"
                                                    data-bs-day="<%out.println((String)session.getAttribute("day"));%>"
                                                    data-bs-openingHour="<%out.println((String)session.getAttribute("openingHour"));%>"
                                                    data-bs-closingHour="<%out.println((String)session.getAttribute("closingHour"));%>">
                                                <i class="bi bi-info-circle"></i> </button>

                                        </td>
                                        <td scope="row">
                                            <button type="button" class="btn btn-danger"
                                                    data-bs-toggle="modal" data-bs-target="#deleteModal"
                                                    data-bs-idDel="<%out.println(Integer.parseInt((String)session.getAttribute("id")));%>">
                                                <i class="bi bi-x-octagon"></i></button>
                                        </td>

                                    </tr>
                                    <%}%>

                                    </tbody>

                                </table>

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
                                                    Seçilen Günün Bilgileri Silenecektir!!
                                                </div>

                                                <form method="post" action="adminSqlCon.jsp">
                                                    <input type="text" class="delIdInput" name="id" id="id" hidden>
                                                    <input type="text" value="avalibaleHoursAndDays.jsp" name="page"
                                                           hidden>
                                                    <input type="text" value="deleteDailyOCHour" name="iam" hidden>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Kapat
                                                        </button>
                                                        <input type="submit" class="btn btn-danger"
                                                               value="Seçilen Günü Sil">

                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                </div>


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
                                                            <label for="day" class="col-form-label">Gün
                                                                </label>
                                                            <input type="date" class="form-control dayInput"
                                                                   name="day" id="day"  required>
                                                        </div>
                                                        <input type="text" value="editDailyOCHour" name="iam" hidden>
                                                        <input type="text" value="avalibaleHoursAndDays.jsp" name="page"
                                                               hidden>

                                                        <div class="mb-3 col-md-6 ms-auto fs-6">
                                                            <div class="form-check form-switch">
                                                                <label class="form-check-label" for="flexSwitchCheckDefault">Tatil Günü</label>
                                                                <input class="form-check-input" type="checkbox" role="switch" id="flexSwitchCheckDefault">

                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row">

                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="openingHour" class="col-form-label">Açılış
                                                                Saati:</label>
                                                            <select class="form-select openingHourInput"
                                                                   name="openingHour" id="openingHour" maxlength="5">
                                                                <option selected disabled>Saati Seçin</option>

                                                            </select>
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="closingHour" class="col-form-label">Kapanış
                                                                Saati:</label>
                                                            <select class="form-select closingHourInput"
                                                                   name="closingHour" id="closingHour" maxlength="5">
                                                                <option selected disabled>Saati Seçin</option>

                                                            </select>
                                                        </div>


                                                    </div>





                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Kapat
                                                        </button>
                                                        <input type="submit" class="btn btn-info" value="Düzenle">
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
                                                            <label for="addDay" class="col-form-label">Gün
                                                            </label>
                                                            <input type="date" class="form-control dayInput"
                                                                   name="addDay" id="addDay"  required>
                                                        </div>
                                                        <input type="text" value="addDailyOCHour" name="iam" hidden>
                                                        <input type="text" value="avalibaleHoursAndDays.jsp" name="page"
                                                               hidden>

                                                        <div class="mb-3 col-md-6 ms-auto fs-6">
                                                            <div class="form-check form-switch">
                                                                <label class="form-check-label" for="addFlexSwitchCheckDefault">Tatil Günü</label>
                                                                <input class="form-check-input" type="checkbox" role="switch" id="addFlexSwitchCheckDefault">

                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row">

                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="addOpeningHour" class="col-form-label">Açılış
                                                                Saati:</label>
                                                            <select class="form-select"
                                                                   name="addOpeningHour" id="addOpeningHour" maxlength="5">
                                                                <option selected disabled>Saati Seçin</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="addClosingHour" class="col-form-label">Kapanış
                                                                Saati:</label>
                                                            <select class="form-select"
                                                                   name="addClosingHour" id="addClosingHour" maxlength="5">
                                                                <option selected disabled>Saati Seçin</option>

                                                            </select>
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
    var openingHour = "";
    var closingHour = "";

    exampleModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var day = button.getAttribute('data-bs-day');
         openingHour = button.getAttribute('data-bs-openingHour');
        var id = button.getAttribute('data-bs-id');
         closingHour = button.getAttribute('data-bs-closingHour');

        var modalBodyDayInput = exampleModal.querySelector('.modal-body .dayInput');
        var modalBodyopeningHourInput = exampleModal.querySelector('.modal-body .openingHourInput');
        var  modalBodyclosingHourInput = exampleModal.querySelector('.modal-body .closingHourInput');
        var modalBodyInputId = exampleModal.querySelector('.modal-body .idInput');


        modalBodyDayInput.value = day.trim();
        modalBodyInputId.value = id;
        modalBodyopeningHourInput.value = openingHour.trim();
        modalBodyclosingHourInput.value = closingHour.trim();


    });

    var deleteModal = document.getElementById('deleteModal');

    deleteModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;

        var id = button.getAttribute('data-bs-idDel');

        var modalBodyInputId = deleteModal.querySelector('.modal-body .delIdInput');


        modalBodyInputId.value = id;

    });


    <% if (requestStr != null && requestStr.length() > 1) { %>
    clickButton();

    <% } %>

    function clickButton() {
        var myButton = document.getElementById("sucsessModalBtn");
        myButton.click();
    }

    const startHour = document.getElementById("openingHour");
    startHour.addEventListener("input", function () {
        const value = this.value.replace(/[^0-9]/g, "");
        if (value.length > 2) {
            this.value = value.slice(0, 2) + ":" + value.slice(2);
        }
    });
    const endHour = document.getElementById("closingHour");
    endHour.addEventListener("input", function () {
        const value = this.value.replace(/[^0-9]/g, "");
        if (value.length > 2) {
            this.value = value.slice(0, 2) + ":" + value.slice(2);
        }
    });

    //add modal oc hours
    const addStartHour = document.getElementById("addOpeningHour");
    addStartHour.addEventListener("input", function () {
        const value = this.value.replace(/[^0-9]/g, "");
        if (value.length > 2) {
            this.value = value.slice(0, 2) + ":" + value.slice(2);
        }
    });
    const addEndHour = document.getElementById("addClosingHour");
    addEndHour.addEventListener("input", function () {
        const value = this.value.replace(/[^0-9]/g, "");
        if (value.length > 2) {
            this.value = value.slice(0, 2) + ":" + value.slice(2);
        }
    });

    //edit modal checkbox
    var checkbox = document.getElementById('flexSwitchCheckDefault');
    var openingHour1 = document.getElementById('openingHour');
    var closingHour1 = document.getElementById('closingHour');

    var editModal = document.getElementById('editModal')
    editModal.addEventListener('show.bs.modal', function (event) {
        // Button that triggered the modal
        var button = event.relatedTarget
        // Extract info from data-bs-* attributes
        var openingHour = button.getAttribute('data-bs-openingHour')
        var closingHour = button.getAttribute('data-bs-closingHour')
        if(openingHour.trim() === '0'){
            openingHour1.disabled = true;
            closingHour1.disabled = true;
            checkbox.checked = true;
        }
        else if(closingHour.trim() === '0'){
            openingHour1.disabled = true;
            closingHour1.disabled = true;
            checkbox.checked = true;
        }
        else{
            openingHour1.disabled = false;
            closingHour1.disabled = false;
            checkbox.checked = false;

        }
    })



    checkbox.addEventListener('change', function () {
        if (checkbox.checked) {
            openingHour1.disabled = true;
            closingHour1.disabled = true;

            openingHour1.value = '0';
            closingHour1.value = '0';
        } else {
            openingHour1.disabled = false;
            closingHour1.disabled = false;

            openingHour1.value = openingHour;
            closingHour1.value = closingHour;
        }
    });


    //add modal checkbox
    var addCheckbox = document.getElementById('addFlexSwitchCheckDefault');
    var addOpeningHour1 = document.getElementById('addOpeningHour');
    var addClosingHour1 = document.getElementById('addClosingHour');

    addCheckbox.addEventListener('change', function () {
        if (addCheckbox.checked) {
            addOpeningHour1.disabled = true;
            addClosingHour1.disabled = true;

            addOpeningHour1.value = '0';
            addClosingHour1.value = '0';
        } else {
            addOpeningHour1.disabled = false;
            addClosingHour1.disabled = false;
        }
    });

    document.addEventListener('DOMContentLoaded', function () {
        function generateTimeOptions(selectElement) {
            for (var hours = 0; hours <= 23; hours++) {
                for (var minutes = 0; minutes <= 30; minutes += 30) {
                    var time = hours.toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0');
                    var value = time;
                    var option = new Option(time, value);
                    selectElement.appendChild(option);
                }
            }
        }

        var openingHour = document.getElementById('openingHour');
        generateTimeOptions(openingHour);

        var closingHour = document.getElementById('closingHour');
        generateTimeOptions(closingHour);

        var addOpeningHour = document.getElementById('addOpeningHour');
        generateTimeOptions(addOpeningHour);

        var addClosingHour = document.getElementById('addClosingHour');
        generateTimeOptions(addClosingHour);


    });

</script>


</body>

</html>

<%}%>