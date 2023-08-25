<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 5.08.2023
  Time: 17:51
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="com.bya.ConSql" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.ArrayList" %>
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


        ArrayList<GetInfo> settingsInfo = new ArrayList<>();
        ConSql consql = new ConSql();
        sqlQuery = "SELECT * FROM settings";
        settingsInfo = consql.getSettings(sqlQuery);

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

    <title>Sayfalar / Ayarlar</title>
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
        <h1>Ayarlar</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index.jsp">Ana Sayfa</a></li>
                <li class="breadcrumb-item active"><a href="settingsPage.jsp">Ayarlar</a></li>
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
                                        <h5 class="card-title">Ayarlar
                                        </h5>
                                    </div>

                                </div>
                                <table class="table table-striped table-hover table-bordered">
                                    <tbody>
                                    <%
                                        session.setAttribute("custId", Integer.toString(settingsInfo.get(0).getId()));
                                        session.setAttribute("companyName", settingsInfo.get(0).getCompanyName());
                                        session.setAttribute("openingHour", settingsInfo.get(0).getOpeningHour());
                                        session.setAttribute("closingHour", settingsInfo.get(0).getClosingHour());
                                        session.setAttribute("appointMessageBody", settingsInfo.get(0).getAppointMessageBody());
                                        session.setAttribute("appointMessageTitle", settingsInfo.get(0).getAppointMessageTitle());
                                        session.setAttribute("holiday", settingsInfo.get(0).getHoliday());
                                        session.setAttribute("calendarId", settingsInfo.get(0).getCalendarId());

                                    %>
                                    <tr>
                                        <th>Firma Adı</th>
                                        <td><%out.println((String) session.getAttribute("companyName"));%></td>
                                    </tr>
                                    <tr>
                                        <th>Açılış Saati</th>
                                        <td><%
                                            out.println((String) session.getAttribute("openingHour"));%></td>
                                    </tr>
                                    <tr>
                                        <th>Kapanış Saati</th>
                                        <td><%
                                            out.println((String) session.getAttribute("closingHour"));%></td>
                                    </tr>
                                    <tr>
                                        <th>Başarılı Uyarı Metni</th>
                                        <td><%
                                            out.println((String) session.getAttribute("appointMessageBody"));%>
                                    </tr>
                                    <tr>
                                        <th>Başarılı Uyarı Başlığı</th>
                                        <td><%
                                            out.println((String) session.getAttribute("appointMessageTitle"));%>
                                    </tr>
                                    <tr>
                                        <th>Tatil Günü</th>
                                        <td><%
                                            out.println((String) session.getAttribute("holiday"));%></td>
                                    </tr>
                                    <tr>
                                        <th>Calendar ID</th>
                                        <td><%
                                            String _calendarId =  (String) session.getAttribute("calendarId");
                                                _calendarId = _calendarId.substring(0, 25) + "...";
                                        %><%out.println(_calendarId);%></td>
                                    </tr>

                                    </tbody>

                                    <div class='col-md-2 ms-auto mt-3 d-grid gap-3 me-5 mb-3'>
                                    <button type="button" class="btn btn-info" data-bs-toggle="modal"
                                            data-bs-target="#editModal"
                                            data-bs-id="<%out.println(Integer.parseInt((String)session.getAttribute("custId")));%>"
                                            data-bs-companyName="<%out.println((String)session.getAttribute("companyName"));%>"
                                            data-bs-openingHour="<%out.println((String)session.getAttribute("openingHour"));%>"
                                            data-bs-closingHour="<%out.println((String)session.getAttribute("closingHour"));%>"

                                            data-bs-appointMessageBody="<%out.println((String)session.getAttribute("appointMessageBody"));%>"
                                            data-bs-appointMessageTitle="<%out.println((String)session.getAttribute("appointMessageTitle"));%>"
                                            data-bs-holiday="<%out.println((String)session.getAttribute("holiday"));%>"
                                            data-bs-calendarId="<%out.println((String)session.getAttribute("calendarId"));%>">
                                        <i class="bi bi-info-circle"></i> Düzenle</button>
                                        </div>
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
                                                            <label for="companyName" class="col-form-label">Firma
                                                                Adı:</label>
                                                            <input type="text" class="form-control companyNameInput"
                                                                   name="companyName" id="companyName">
                                                        </div>
                                                        <input type="text" value="settingsEdit" name="iam" hidden>
                                                        <input type="text" value="settingsPage.jsp" name="page"
                                                               hidden>

                                                        <div class="mb-3 col-md-6">
                                                            <label for="holiday" class="col-form-label">Tatil
                                                                Günü:</label>
                                                            <select class="form-select holidayInput"
                                                                    name="holiday" id="holiday" >
                                                                <option selected disabled>Saati Seçin</option>
                                                                <option value="Pazartesi" >Pazartesi</option>
                                                                <option value="Salı" >Salı</option>
                                                                <option value="Çarşamba" >Çarşamba</option>
                                                                <option value="Perşembe" >Perşembe</option>
                                                                <option value="Cuma" >Cuma</option>
                                                                <option value="Cumartesi" >Cumartesi</option>
                                                                <option value="Pazar" >Pazar</option>

                                                            </select>
                                                        </div>
                                                    </div>

                                                    <div class="row">

                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="openingHour" class="col-form-label">Açılış Saati:</label>
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
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="appointMessageBody" class="col-form-label">Başarılı
                                                                Uyarı Metni:</label>
                                                            <input type="text"
                                                                   class="form-control appointMessageBodyInput"

                                                                   name="appointMessageBody" id="appointMessageBody">
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="appointMessageTitle" class="col-form-label">Başarılı
                                                                Uyarı Başlıgı: </label>
                                                            <input type="text"
                                                                   class="form-control appointMessageTitleInput"

                                                                   name="appointMessageTitle" id="appointMessageTitle">
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="calendarId" class="col-form-label">Calendar ID:</label>
                                                            <input type="text"
                                                                   class="form-control calendarId"

                                                                   name="calendarId" id="calendarId">
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
        var companyName = button.getAttribute('data-bs-companyName');
        var openingHour = button.getAttribute('data-bs-openingHour');
        var id = button.getAttribute('data-bs-id');
        var closingHour = button.getAttribute('data-bs-closingHour');
        var appointMessageBody = button.getAttribute('data-bs-appointMessageBody');
        var appointMessageTitle = button.getAttribute('data-bs-appointMessageTitle');
        var holiday = button.getAttribute('data-bs-holiday');
        var calendarId = button.getAttribute('data-bs-calendarId');

        var modalBodycompanyNameInput = exampleModal.querySelector('.modal-body .companyNameInput');
        var modalBodyholidayInput = exampleModal.querySelector('.modal-body .holidayInput');
        var modalBodyopeningHourInput = exampleModal.querySelector('.modal-body .openingHourInput');
        var modalBodyclosingHourInput = exampleModal.querySelector('.modal-body .closingHourInput');
        var modalBodyappointMessageBodyInput = exampleModal.querySelector('.modal-body .appointMessageBodyInput');
        var modalBodyappointMessageTitleInput = exampleModal.querySelector('.modal-body .appointMessageTitleInput');
        var modalBodyInputId = exampleModal.querySelector('.modal-body .idInput');
        var modalBodyCalendarId = exampleModal.querySelector('.modal-body .calendarId');


        modalBodycompanyNameInput.value = companyName;
        modalBodyholidayInput.value = holiday.trim();
        modalBodyInputId.value = id;
        modalBodyopeningHourInput.value = openingHour.trim();
        modalBodyclosingHourInput.value = closingHour.trim();
        modalBodyappointMessageBodyInput.value = appointMessageBody;
        modalBodyappointMessageTitleInput.value = appointMessageTitle;
        modalBodyCalendarId.value = calendarId.trim();

    });


    <% if (requestStr != null && requestStr.length() > 1) { %>
    clickButton();

    <% } %>

    function clickButton() {
        var myButton = document.getElementById("sucsessModalBtn");
        myButton.click();
    }



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


    });



</script>


</body>

</html>
<%}%>