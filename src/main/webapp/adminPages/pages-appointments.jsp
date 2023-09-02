        <%--
    Document   : pages-customers
    Created on : Dec 21, 2022, 10:32:33 PM
    Author     : omerfaruk
--%>

<%@ page import="com.bya.ConSql" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bya.Helper" %>
        <%@ page import="java.net.URLDecoder" %>
        <%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    //startcontrol is login
    Helper helper = new Helper();
    String username = null;
    String ip = null;
    String name = null;
    String surname = null;
    String email = null;

    String clientIP = request.getHeader("X-Forwarded-For");
    if (clientIP == null || clientIP.isEmpty() || "unknown".equalsIgnoreCase(clientIP)) {
        clientIP = request.getHeader("Proxy-Client-IP");
    }
    if (clientIP == null || clientIP.isEmpty() || "unknown".equalsIgnoreCase(clientIP)) {
        clientIP = request.getHeader("WL-Proxy-Client-IP");
    }
    if (clientIP == null || clientIP.isEmpty() || "unknown".equalsIgnoreCase(clientIP)) {
        clientIP = request.getHeader("HTTP_CLIENT_IP");
    }
    if (clientIP == null || clientIP.isEmpty() || "unknown".equalsIgnoreCase(clientIP)) {
        clientIP = request.getHeader("HTTP_X_FORWARDED_FOR");
    }
    if (clientIP == null || clientIP.isEmpty() || "unknown".equalsIgnoreCase(clientIP)) {
        clientIP = request.getRemoteAddr();
    }
    Cookie nameCookie = new Cookie("ip", clientIP);
    nameCookie.setMaxAge((int) (30 * 24 * 60 * 60)); //saniye cinsinden
    response.addCookie(nameCookie);

    Boolean finded = false;

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("luna_token")) {
                if (!cookie.getValue().isEmpty()) {
                    username = helper.decodeJWT(cookie.getValue());
                    finded = true;
                } else {
                    finded = false;
                    break;
                }
            } else if (cookie.getName().equals("lipad_token")) {
                if (!cookie.getValue().isEmpty()) {
                    ip = helper.decodeJWT(cookie.getValue());
                    finded = true;
                } else {
                    finded = false;
                    break;
                }
            } else if (cookie.getName().equals("lna_token")) {
                if (!cookie.getValue().isEmpty()) {
                    name = helper.decodeJWT(cookie.getValue());
                    finded = true;
                } else {
                    finded = false;
                    break;
                }
            } else if (cookie.getName().equals("lsna_token")) {
                if (!cookie.getValue().isEmpty()) {
                    surname = helper.decodeJWT(cookie.getValue());
                    finded = true;
                } else {
                    finded = false;
                    break;
                }
            } else if (cookie.getName().equals("lema_token")) {
                if (!cookie.getValue().isEmpty()) {
                    email = helper.decodeJWT(cookie.getValue());
                    finded = true;
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
            name = helper.decodeJWT((String) loginSession.getAttribute("lna_token"));
            surname = helper.decodeJWT((String) loginSession.getAttribute("lsna_token"));
            email = helper.decodeJWT((String) loginSession.getAttribute("lema_token"));

            ip = helper.decodeJWT((String) loginSession.getAttribute("lipad_token"));
            finded = true;
        }
    }

    String sessionId = request.getSession().getId();
    String _doctorId;
    if (clientIP == null || !(clientIP.equals(ip)) ||
            username == null || username.isEmpty() ||
            name == null || name.isEmpty() ||
            surname == null || surname.isEmpty() ||
            email == null || email.isEmpty()
    ) {
        response.sendRedirect("loginPage.jsp");
    } else {

        ConSql consql = new ConSql();

        ArrayList<GetInfo> doctorId = new ArrayList<>();
        String doctorIdQuery = "SELECT di.*\n" +
                "FROM doctorInfo di\n" +
                "INNER JOIN user u ON di.userId = u.id\n" +
                "WHERE u.username = ?;\n";
        doctorId = consql.getInfos(doctorIdQuery, username);
        _doctorId = Integer.toString(doctorId.get(0).getId());
        String _doctorName = doctorId.get(0).getName();


        //end control is login


        String filterName = "";
        String filter = "";
        filter = request.getParameter("filter");
        String sqlQuery = "";


        ArrayList<GetInfo> info = new ArrayList<>();
        ArrayList<GetInfo> locInfo = new ArrayList<>();
        ArrayList<GetInfo> docInfo = new ArrayList<>();
        ArrayList<GetInfo> revInfo = new ArrayList<>();
        ArrayList<GetInfo> revNameInfo = new ArrayList<>();
        ArrayList<GetInfo> docNameInfo = new ArrayList<>();
        ArrayList<GetInfo> locNameInfo = new ArrayList<>();


        String locQuery = "SELECT * FROM `locationInfo`";
        String docQuery = "SELECT * FROM `doctorInfo`";
        String reservationQuery = "SELECT * FROM `reservationInfo`";
        String reverationNameQuery = "SELECT * FROM `reservationInfo` WHERE `tagName` = ?";
        String doctorNameQuery = "SELECT * FROM `doctorInfo` WHERE `id` = ?";
        String locationNameQuery = "SELECT * FROM `locationInfo` WHERE `id` = ?";


        locInfo = consql.getInfos(locQuery);
        docInfo = consql.getInfos(docQuery);
        revInfo = consql.getRezervationInfos(reservationQuery);
        session.setAttribute("appointmentCount", Integer.toString(info.size()));

        if (filter != null && filter.equals("today")) {
            sqlQuery = "SELECT * FROM `appointments` \n" +
                    "WHERE date = CURDATE() AND `doctorId` = ?\n" +
                    "ORDER BY `startHour` DESC;";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Bugün";
        } else if (filter != null && filter.equals("thisMonth")) {
            sqlQuery = "SELECT * FROM `appointments`\n" +
                    "WHERE YEAR(date) = YEAR(CURDATE()) AND MONTH(date) = MONTH(CURDATE())\n" +
                    "  AND `doctorId` = ?\n" +
                    "ORDER BY `date` DESC, `startHour` DESC;\n";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Bu Ay";
        } else if (filter != null && filter.equals("theseThreeMonths")) {
            sqlQuery = "SELECT * FROM `appointments`\n" +
                    "WHERE doctorId = ? AND date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)\n" +
                    "ORDER BY `date` DESC, `startHour` DESC;\n";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Bu 3 Ay";
        } else if (filter != null && filter.equals("thisYear")) {
            sqlQuery = "SELECT * FROM `appointments`\n" +
                    "WHERE doctorId = ? AND YEAR(date) = YEAR(CURDATE())\n" +
                    "ORDER BY `date` DESC, `startHour` DESC;\n ";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Bu Yıl";
        } else if (filter != null && filter.equals("all")) {
            sqlQuery = "SELECT * FROM `appointments`\n" +
                    "WHERE doctorId = ?\n" +
                    "ORDER BY `date` DESC, `startHour` DESC;\n";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Hepsi";
        } else if (filter != null && filter.equals("receivedToday")) {
            sqlQuery = "SELECT * FROM `appointments`\n" +
                    "WHERE DATE(createdAt) = CURDATE()\n" +
                    "AND `doctorId`=?\n" +
                    "ORDER BY createdAt DESC;\n";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Bugüne Alınan Randevular";
        } else if (filter == null) {
            sqlQuery = "SELECT * FROM `appointments`\n" +
                    "WHERE doctorId = ?\n" +
                    "AND YEAR(date) = YEAR(CURDATE())\n" +
                    "AND MONTH(date) = MONTH(CURDATE())\n" +
                    "ORDER BY `date` DESC, `startHour` DESC;\n";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Bu Ay";

        } else {
            sqlQuery = "SELECT * FROM `appointments`\n" +
                    "WHERE doctorId = ?\n" +
                    "AND YEAR(date) = YEAR(CURDATE())\n" +
                    "AND MONTH(date) = MONTH(CURDATE())\n" +
                    "ORDER BY `date` DESC, `startHour` DESC;\n";
            info = consql.getAppointmentData(sqlQuery, _doctorId);
            filterName = "Bu Ay";

        }
        session.setAttribute("appointmentCount", Integer.toString(info.size()));


        String requestStr = "";
        String discroption = null;
        Boolean appointmentMade = null;
        String appointmentNotMadeStr = "";
        String messageHeader = "Işlemi sonucu";

        String messageParam = request.getParameter("message");
        String dicParam = request.getParameter("dic");

        if (messageParam != null && dicParam != null) {
            requestStr = URLDecoder.decode(messageParam, "UTF-8");
            discroption = URLDecoder.decode(dicParam, "UTF-8");
        }
        if (discroption == null) {
            discroption = "Randevunuz Başarılı Bir Şekilde Alındı.";
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
    <link href="assets/css/calendar.css" rel="stylesheet">


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
                <li class="breadcrumb-item active"><a href="pages-appointments.jsp">Randevular</a></li>
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

                            <div class="filter">
                                <a class="icon" href="#" data-bs-toggle="dropdown"><i class="bi bi-three-dots"></i></a>
                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow">
                                    <li class="dropdown-header text-start">
                                        <h6>Filter</h6>
                                    </li>
                                    <li><a class="dropdown-item" href="?filter=today">Bugün</a></li>
                                    <li><a class="dropdown-item" href="?filter=thisMonth">Bu Ay</a></li>
                                    <li><a class="dropdown-item" href="?filter=theseThreeMonths">Bu 3 Ay</a></li>
                                    <li><a class="dropdown-item" href="?filter=thisYear">Bu Yıl</a></li>
                                    <li><a class="dropdown-item" href="?filter=all">Hepsi</a></li>
                                    <li><a class="dropdown-item" href="?filter=receivedToday">Bugün Alınanlar</a></li>

                                </ul>
                            </div>

                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4">
                                        <h5 class="card-title">Randevular <span>| <%out.println(filterName);%></span>
                                        </h5>
                                    </div>
                                    <div class='col-md-2 ms-auto mt-3 d-grid gap-3 me-5 mb-3'>
                                        <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                                data-bs-target="#addModal">Ekle
                                        </button>
                                    </div>
                                </div>
                                <table class="table table-striped">
                                    <thead>
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Adı Soyadı</th>
                                        <th scope="col">Telefon</th>
                                        <th scope="col">Doktor Adı</th>
                                        <th scope="col">Yer</th>
                                        <th scope="col">Tarih</th>
                                        <th scope="col">Başlangıç Saati</th>
                                        <th scope="col">Bitiş Saati</th>
                                        <th scope="col">Randevu Türü</th>
                                        <th scope="col">Randevu Durumu</th>


                                        <th scope="col">Düzenle</th>
                                        <th scope="col">Sil</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%

                                        for (int i = 0; i < Integer.parseInt((String) session.getAttribute("appointmentCount")); i++) {
                                            revNameInfo = consql.getRezervationInfos(reverationNameQuery, info.get(i).getRezervationInterval());
                                            docNameInfo = consql.getInfos(doctorNameQuery, info.get(i).getDoctorName());
                                            locNameInfo = consql.getInfos(locationNameQuery, info.get(i).getAppLocation());

                                            session.setAttribute("custId", Integer.toString(info.get(i).getId()));
                                            session.setAttribute("custName", info.get(i).getCustName());
                                            session.setAttribute("custSurname", info.get(i).getCustSurname());
                                            session.setAttribute("custNameSurname", info.get(i).getCustNameSurname());
                                            session.setAttribute("CustPhone", info.get(i).getCustPhone());
                                            session.setAttribute("DoctorName1", info.get(i).getDoctorName());
                                            session.setAttribute("AppLocation1", info.get(i).getAppLocation());

                                            session.setAttribute("DoctorName", docNameInfo.get(0).getName());
                                            session.setAttribute("AppLocation", locNameInfo.get(0).getName());
                                            session.setAttribute("AppDate", info.get(i).getAppDate());
                                            session.setAttribute("AppStartHour", info.get(i).getAppStartHour());
                                            session.setAttribute("AppEndHour", info.get(i).getAppEndHour());
                                            session.setAttribute("AppIntervalValue", info.get(i).getRezervationInterval());
                                            session.setAttribute("rezervationStatus", info.get(i).getRezervationStatus());

                                            session.setAttribute("AppInterval", revNameInfo.get(0).getRezervationName());


                                    %>
                                    <tr>
                                        <th scope="row"><a href="#">#<%out.println(i + 1);%></a></th>
                                        <td><%out.println((String) session.getAttribute("custNameSurname"));%></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("CustPhone"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("DoctorName"));%></span></td>
                                        <%
                                            String appLocation = (String) session.getAttribute("AppLocation");
                                            int maxLength = 10;
                                            if (appLocation.length() > maxLength) {
                                                appLocation = appLocation.substring(0, maxLength) + "...";
                                            }
                                        %>
                                        <td><span class="badge" style="color:black; font-size: 12px;">
                                        <%=appLocation%>
                                        </span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppDate"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppStartHour"));%></span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("AppEndHour"));%></span></td>
                                        <%
                                            String appInterval = (String) session.getAttribute("AppInterval");
                                            int maxLength1 = 10;
                                            if (appInterval.length() > maxLength1) {
                                                appInterval = appInterval.substring(0, maxLength1) + "...";
                                            }
                                        %>
                                        <td><span class="badge" style="color:black; font-size: 12px;">
                                        <%=appInterval%>
                                        </span></td>
                                        <td><span class="badge" style="color:black; font-size: 12px;"><%
                                            out.println((String) session.getAttribute("rezervationStatus"));%></span></td>

                                        <td>
                                            <button type="button" class="btn btn-info" data-bs-toggle="modal"
                                                    data-bs-target="#editModal"
                                                    data-bs-id="<%
                        out.println(Integer.parseInt((String) session.getAttribute("custId")));%>"
                                                    data-bs-nameSurname="<%
                        out.println((String) session.getAttribute("custNameSurname"));%>"
                                                    data-bs-name="<%
                        out.println((String) session.getAttribute("custName"));%>"
                                                    data-bs-surname="<%
                        out.println((String) session.getAttribute("custSurname"));%>"

                                                    data-bs-phone="<%
                        out.println((String) session.getAttribute("CustPhone"));%>"
                                                    data-bs-date="<%
                        out.println((String) session.getAttribute("AppDate"));%>"
                                                    data-bs-doktorName="<%
                        out.println((String) session.getAttribute("DoctorName1"));%>"
                                                    data-bs-location="<%
                        out.println((String) session.getAttribute("AppLocation1"));%>"
                                                    data-bs-interval="<%
                        out.println((String) session.getAttribute("AppIntervalValue"));%>"
                                                    data-bs-startHour="<%
                        out.println((String) session.getAttribute("AppStartHour"));%>"
                                                    data-bs-rezervationStatus="<%
                        out.println((String) session.getAttribute("rezervationStatus"));%>"
                                                    data-bs-endHour="<%
                        out.println((String) session.getAttribute("AppEndHour"));%>">

                                                <i class="bi bi-info-circle"></i></button>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-danger"
                                                    data-bs-toggle="modal" data-bs-target="#deleteModal"
                                                    data-bs-idDel="<%
                        out.println(Integer.parseInt((String) session.getAttribute("custId")));%>">
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
                                                <form method="post" action="adminSqlCon.jsp" id="editForm">
                                                    <input type="text" class=" idInput" name="id" hidden>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="name" class="col-form-label">Adı:</label>
                                                            <input type="text" class="form-control validate-input nameInput" maxlength="20" required oninput="blockSpecialChars('name')"
                                                                   name="name" id="name">
                                                        </div>
                                                        <input type="text" value="appointmentEdit" name="iam" hidden>
                                                        <input type="text" value="pages-appointments.jsp" name="page" hidden>
                                                        <input type="text" class="appointAllHour" name="appointAllHour" id="appointAllHour" hidden>
                                                        <input type="text" id="editCookieUsername" name="editCookieUsername" value="<%= _doctorId %>" hidden>



                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="surname" class="col-form-label">Soyadı:</label>
                                                            <input type="text" class="form-control validate-input surnameInput" maxlength="20" required oninput="blockSpecialChars('surname')"
                                                                   name="surname" id="surname">
                                                        </div>

                                                    </div>

                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="phone" class="col-form-label">Telefon:</label>
                                                            <input type="text" class="form-control validate-input phoneInput"
                                                                   name="phone" id="phone">
                                                        </div>
                                                        <div class="mb-3 col-md-6">
                                                            <label for="date" class="col-form-label">Tarih:</label>
                                                            <input type="date" class="form-control validate-input dateInput"
                                                                   name="date" id="date">
                                                        </div>

                                                    </div>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="interval" class="col-form-label">Randevu
                                                                Türü:</label>
                                                            <select class="form-control validate-input intervalInput"
                                                                    name="interval"
                                                                    id="interval">
                                                                <option value="" selected hidden>Seçin</option>
                                                                <%
                                                                    for (int i = 0; i < revInfo.size(); i++) {
                                                                %>
                                                                <option value=<%
                                                                    out.println((revInfo.get(i).getRezervationNameTag()));%>>
                                                                    <%
                                                                        out.println(revInfo.get(i).getRezervationName());%>
                                                                </option>
                                                                <%
                                                                    }
                                                                %>
                                                            </select>
                                                        </div>
                                                        <div class="mb-3 col-md-6">
                                                            <label for="rezervationStatus" class="col-form-label">Randevu
                                                                Durumu:</label>
                                                            <select class="form-control rezervationStatus-input rezervationStatus"
                                                                    name="rezervationStatus"
                                                                    id="rezervationStatus">
                                                                <option value="" selected hidden>Seçin</option>
                                                                <option value="Onaylanıyor">Onaylanıyor</option>
                                                                <option value="Onaylandı">Onaylandı</option>

                                                            </select>
                                                        </div>
                                                    </div>

                                            <div class="row ms-2 me-2 mb-2">
                                                <div class="hoursIndex">
                                                    <p class="fw-bolder" id="warning-messageIndex"
                                                       name="warning-messageIndex"></p>

                                                    <div class="hour-buttonsIndex"></div>
                                                </div>
                                                <ul id="saatlerIndex" style="display: none;">

                                                </ul>
                                            </div>
                                            <div class="row">
                                                <div class="mb-3 col-md-6">
                                                    <label for="doktorName" class="col-form-label">Doktor
                                                        Adı:</label>
                                                    <select class="form-control validate-input doctorInput" name="doktorName"
                                                            id="doktorName">
                                                        <option value="" selected hidden>Seçin</option>

                                                        <option value=<%
                                                            out.println(_doctorId);%>>
                                                            <%out.println(_doctorName);%>
                                                        </option>

                                                    </select>
                                                </div>
                                                <div class="mb-3 col-md-6 ms-auto">
                                                    <label for="location" class="col-form-label">Yer:</label>
                                                    <select class="form-control validate-input locationInput" name="location"
                                                            id="location">
                                                        <option value="" selected hidden>Seçin</option>
                                                        <%
                                                            for (int i = 0; i < locInfo.size(); i++) {
                                                        %>
                                                        <option value=<%
                                                            out.println((locInfo.get(i).getId()));%>>
                                                            <%out.println(locInfo.get(i).getName());%>
                                                        </option>
                                                        <%
                                                            }
                                                        %>
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
                                <script>
                                    var modal = document.getElementById("editModal");
                                    var form = document.getElementById("editForm");

                                    // Form içindeki tıklamaları dinle
                                    form.addEventListener("click", function(event) {
                                        if (event.target && event.target.nodeName === "BUTTON") {
                                            event.preventDefault(); // Submit işlemini engelle

                                            const button = event.target; // Tıklanan buton öğesini alın

                                            // Tüm "active" sınıfına sahip butonları seçin
                                            var buttonsWithout = document.querySelectorAll(".active");

                                            // Her bir buton için "active" sınıfını "none-active" ile değiştirin
                                            buttonsWithout.forEach(function(button) {
                                                button.classList.remove("active");
                                                button.classList.add("none-active");
                                            });

                                            // Tıklanan butona "active" sınıfını ekleyin
                                            button.classList.remove("none-active");
                                            button.classList.add("active");

                                            var timeValue = button.getAttribute("data-bs-time");
                                            modal.querySelector('.modal-body .appointAllHour').value = timeValue.trim();
                                        }
                                    });





                                </script>
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

                            <%--add modal--%>
                            <div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel"
                                 aria-hidden="true">
                                <div class="modal-dialog modal-xl">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="addModalLabel">Ekle</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">

                                            <div class="row">
                                                <div class="mb-3 col-md-6">
                                                    <label for="name-input" class="col-form-label">Adı:</label>
                                                    <input type="text" class="form-control validate-input nameInput" maxlength="20" required oninput="blockSpecialChars('name-input')"
                                                           name="name-input" id="name-input">
                                                </div>
                                                <input type="text" value="appointmentAdd" name="iam" hidden>
                                                <input type="text" value="pages-appointments.jsp" name="page"
                                                       hidden>

                                                <div class="mb-3 col-md-6 ms-auto">
                                                    <label for="surname-input"
                                                           class="col-form-label">Soyadı:</label>
                                                    <input type="text" class="form-control validate-input surnameInput" maxlength="20" required oninput="blockSpecialChars('surname-input')"
                                                           name="surname-input" id="surname-input">
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="mb-3 col-md-6">
                                                    <label for="phone-input" class="col-form-label">Phone:</label>
                                                    <input type="text" class="form-control validate-input phoneInput"
                                                           name="phone-input" id="phone-input">
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label for="add-interval" class="col-form-label">Randevu
                                                        Turu:</label>
                                                    <select class="form-control validate-input intervalInput"
                                                            name="add-interval"
                                                            id="add-interval">
                                                        <option value="" selected hidden>Seçin</option>
                                                        <%
                                                            for (int i = 0; i < revInfo.size(); i++) {
                                                        %>
                                                        <option value=<%
                                                            out.println((revInfo.get(i).getRezervationNameTag()));%>>
                                                            <%
                                                                out.println(revInfo.get(i).getRezervationName());%>
                                                        </option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="row">
                                                <div class="mb-3 col-md-6">
                                                    <label for="add-doktorName" class="col-form-label">Doktor
                                                        Adı:</label>
                                                    <select class="form-control validate-input doctorInput"
                                                            name="add-doktorName"
                                                            id="add-doktorName">
                                                        <option value="" selected hidden>Seçin</option>

                                                        <option value=<%
                                                            out.println(_doctorId);%>>
                                                            <%out.println(_doctorName);%>
                                                        </option>

                                                    </select>
                                                </div>
                                                <div class="mb-3 col-md-6 ms-auto">
                                                    <label for="add-location"
                                                           class="col-form-label">Yer:</label>
                                                    <select class="form-control validate-input locationInput"
                                                            name="add-location"
                                                            id="add-location">
                                                        <option value="" selected hidden>Seçin</option>
                                                        <%
                                                            for (int i = 0; i < locInfo.size(); i++) {
                                                        %>
                                                        <option value=<%
                                                            out.println((locInfo.get(i).getId()));%>>
                                                            <%out.println(locInfo.get(i).getName());%>
                                                        </option>
                                                        <%
                                                            }
                                                        %>
                                                    </select>

                                                </div>

                                            </div>
                                            <div class="row">
                                                <div class="mb-3 col-md-6">


                                                    <div class="calendar">
                                                        <div class="calendar-header">
                                                            <button id="prev-month-btn">&lt;</button>
                                                            <h2 id="current-month"></h2>
                                                            <button id="next-month-btn">&gt;</button>
                                                        </div>
                                                        <div class="calendar-body">
                                                            <div class="weekdays">
                                                                <div class="weekday">Pzt</div>
                                                                <div class="weekday">Sal</div>
                                                                <div class="weekday">Çar</div>
                                                                <div class="weekday">Per</div>
                                                                <div class="weekday">Cum</div>
                                                                <div class="weekday">Cmt</div>
                                                                <div class="weekday">Paz</div>

                                                            </div>
                                                            <div class="days"></div>
                                                        </div>
                                                    </div>


                                                </div>
                                                <div class="mb-3 col-md-6 ms-auto">


                                                    <div class="hours">
                                                        <h3 id="selected-date"></h3>
                                                        <h2 id="selected-day"></h2>
                                                        <div class="hour-buttons"></div>
                                                        <p class="fw-bolder" id="warning-message"
                                                           name="warning-message">Önce gerekli bilgileri doldurmanız
                                                            gerekir.</p>

                                                        <form method="post" onsubmit="return validateForm()"
                                                              action="/take_appoint.jsp" id="form">
                                                            <input type="hidden" id="selected-year" name="selected-year"
                                                                   value="">
                                                            <input type="hidden" id="selected-month"
                                                                   name="selected-month" value="">
                                                            <input type="hidden" id="selected-dayIn"
                                                                   name="selected-dayIn" value="">
                                                            <input type="hidden" id="selected-hour" name="selected-hour"
                                                                   value="">
                                                            <input type="hidden" id="cust-name" name="cust-name"
                                                                   value="">
                                                            <input type="hidden" id="cust-surname" name="cust-surname"
                                                                   value="">
                                                            <input type="hidden" id="cust-phone" name="cust-phone"
                                                                   value="">
                                                            <input type="hidden" id="doctor-name" name="doctor-name"
                                                                   value="">
                                                            <input type="hidden" id="loc-name" name="loc-name" value="">
                                                            <input type="hidden" id="interval-type" name="interval-type"
                                                                   value="">
                                                            <input type="hidden" id="page-name" name="page-name"
                                                                   value="adminPages/pages-appointments.jsp">
                                                            <input type="hidden" id="cookie-username" name="cookie-username"value="<%= _doctorId %>">


                                                            <input type="submit" class="btn btn-primary btn-lg "
                                                                   id="schedule-appointment"
                                                                   name="schedule-appointment" onclick="clearInput()"
                                                                   value="Randevu Al">

                                                        </form>

                                                    </div>

                                                </div>
                                            </div>

                                            <ul id="saatler" style="display: none;">

                                            </ul>
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

<script src="assets/js/calendar.js"></script>


<script>
    `use strict`;
    var exampleModal = document.getElementById('editModal');
    var button = '';
    exampleModal.addEventListener('show.bs.modal', function (event) {
        button = event.relatedTarget;
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
        var rezervationStatus = button.getAttribute('data-bs-rezervationStatus');

        var modalBodyInputName = exampleModal.querySelector('.modal-body .nameInput');
        var modalBodyInputSurname = exampleModal.querySelector('.modal-body .surnameInput');

        var modalBodyInputId = exampleModal.querySelector('.modal-body .idInput');
        var modalBodyInputPhone = exampleModal.querySelector('.modal-body .phoneInput');
        var modalBodyInputDate = exampleModal.querySelector('.modal-body .dateInput');
        var modalBodyInputDoctor = exampleModal.querySelector('.modal-body .doctorInput');
        var modalBodyInputLocation = exampleModal.querySelector('.modal-body .locationInput');
        var modalBodyInputInterval = exampleModal.querySelector('.modal-body .intervalInput');
        var modalBodyInputTime = exampleModal.querySelector('.modal-body .appointAllHour');

        var modalBodyInputrezervationStatus = exampleModal.querySelector('.modal-body .rezervationStatus-input');


        modalBodyInputName.value = name;
        modalBodyInputSurname.value = surname;
        modalBodyInputTime.value = startHour + "-" + endHour;
        modalBodyInputId.value = id;
        modalBodyInputPhone.value = phone;
        modalBodyInputDate.value = date.trim();
        modalBodyInputDoctor.value = doctorName.trim();
        modalBodyInputLocation.value = location.trim();
        modalBodyInputInterval.value = interval.trim();
        modalBodyInputrezervationStatus.value = rezervationStatus.trim();

        var hourSql = startHour + "-" + endHour;

        //Add Hours
            var selectedFilter = date.trim();
            var selectedOption = interval.trim();
            var selectDoctor = doctorName.trim();


            // Eğer "filter" parametresi yoksa veya boşsa, varsayılan olarak "today" atama
            if (!selectedFilter) {
                selectedFilter = "today";
            }
            if (!selectedOption) {
                selectedOption = "";
            }

            console.log(selectedFilter);
            var hours = []; // Boş bir dizi oluşturun
            const warningMessage = document.getElementById("warning-messageIndex")

            var xhttp = new XMLHttpRequest();
            var url = "/get_available_hours.jsp" + "?selectedDate=" + encodeURIComponent(selectedFilter) + "&selectedOption=" + encodeURIComponent(selectedOption) + "&selectedDoktor=" + encodeURIComponent(selectDoctor);
            xhttp.open("GET", url, true);
            xhttp.send();

            xhttp.onreadystatechange = function () {
                if (this.readyState === 4 && this.status === 200) {
                    var hoursList = JSON.parse(this.responseText);
                    var hoursContainer = document.getElementById("saatlerIndex");
                    hoursContainer.innerHTML = ""; // Temizleme

                    for (var i = 0; i < hoursList.length; i++) {
                        var hourItem = document.createElement("li");
                        hourItem.textContent = hoursList[i].appHour;
                        hoursContainer.appendChild(hourItem);
                        console.log(hoursList[i]);
                        // hourlist'e saatleri ekleyelim
                        hours.push(hoursList[i].appHour);
                    }

                    if (hours.length === 0) {
                        let temp = "Maalesef, seçtiğiniz gün için alinan randevu seçeneğinden baska bulunmamaktadır.";
                        warningMessage.textContent = temp;
                        warningMessage.style.display = "inline";
                    } else {
                        warningMessage.style.display = "none";
                    }

                    // Filtre seçimine bakılmaksızın, saat düğmelerini oluştur
                    createHourButtons(hours);
                    function createHourButtons(hours) {
                        var hourButtonsContainer = document.querySelector(".hour-buttonsIndex");
                        hourButtonsContainer.innerHTML = "";
                        hours.push(hourSql);
                        customSort(hours);

                        for (let i = 0; i < hours.length; i++) {
                            console.log("om");
                            const hourButtonEl = document.createElement("button");
                            hourButtonEl.classList.add("hour-editButtonIndex");
                            if(hours[i] !== hourSql){
                                hourButtonEl.classList.add("none-active");
                            }
                            else{
                                hourButtonEl.classList.add("active");
                            }
                            hourButtonEl.classList.add("edit-hour");
                            hourButtonEl.setAttribute("data-bs-day", selectedFilter);
                            hourButtonEl.setAttribute("data-bs-interval", selectedOption);
                            hourButtonEl.setAttribute("data-bs-time", hours[i]);
                            hourButtonEl.setAttribute("id", "editHourListIndex");



                            hourButtonEl.innerHTML = hours[i];
                            hourButtonsContainer.appendChild(hourButtonEl);
                        }

                    }
                }
            };





    });

    var deleteModal = document.getElementById('deleteModal');

    deleteModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget;
        var delId = button.getAttribute('data-bs-idDel');
        var modalBodyInputDelId = deleteModal.querySelector('.modal-body .delIdInput');
        modalBodyInputDelId.value = delId;

    });

    var dateInput = document.getElementById('date');
    var intervalInput = document.getElementById('interval');
    var doctorInput = document.getElementById('doktorName');

    function getHours(){
        //Add Hours
        var startHour = button.getAttribute('data-bs-startHour');
        var endHour = button.getAttribute('data-bs-endHour');
        var date = button.getAttribute('data-bs-date');

        var hourSql = startHour + "-" + endHour;

            var selectedFilter = dateInput.value;
            var selectedOption = intervalInput.value;
            var selectedDoctor =  doctorInput.value;

            // Eğer "filter" parametresi yoksa veya boşsa, varsayılan olarak "today" atama
            if (!selectedFilter) {
                selectedFilter = "today";
            }
            if (!selectedOption) {
                selectedOption = "";
            }

            console.log(selectedFilter);
            var hours = []; // Boş bir dizi oluşturun
            const warningMessage = document.getElementById("warning-messageIndex")

            var xhttp = new XMLHttpRequest();
            var url = "/get_available_hours.jsp" + "?selectedDate=" + encodeURIComponent(selectedFilter) + "&selectedOption=" + encodeURIComponent(selectedOption) + "&selectedDoktor=" + encodeURIComponent(selectedDoctor);
            xhttp.open("GET", url, true);
            xhttp.send();

            xhttp.onreadystatechange = function () {
                if (this.readyState === 4 && this.status === 200) {
                    var hoursList = JSON.parse(this.responseText);
                    var hoursContainer = document.getElementById("saatlerIndex");
                    hoursContainer.innerHTML = ""; // Temizleme

                    for (var i = 0; i < hoursList.length; i++) {
                        var hourItem = document.createElement("li");
                        hourItem.textContent = hoursList[i].appHour;
                        hoursContainer.appendChild(hourItem);
                        console.log(hoursList[i]);
                        // hourlist'e saatleri ekleyelim
                        hours.push(hoursList[i].appHour);
                    }

                    if (hours.length === 0) {
                        let temp = "Maalesef, seçtiğiniz gün için alinan randevu seçeneğinden baska bulunmamaktadır.";
                        warningMessage.textContent = temp;
                        warningMessage.style.display = "inline";
                    } else {
                        warningMessage.style.display = "none";
                    }

                    // Filtre seçimine bakılmaksızın, saat düğmelerini oluştur
                    createHourButtons(hours);
                    function createHourButtons(hours) {
                        var hourButtonsContainer = document.querySelector(".hour-buttonsIndex");
                        hourButtonsContainer.innerHTML = "";
                        if(dateInput.value === date.trim()){
                            hours.push(hourSql);
                            customSort(hours);


                        }
                        for (let i = 0; i < hours.length; i++) {
                            console.log("om11");
                            const hourButtonEl = document.createElement("button");
                            hourButtonEl.classList.add("hour-editButtonIndex");

                            if(hours[i] !== hourSql || dateInput.value !== date.trim()){
                                hourButtonEl.classList.add("none-active");
                            }
                            else{
                                hourButtonEl.classList.add("active");
                            }
                            hourButtonEl.setAttribute("data-bs-day", selectedFilter);
                            hourButtonEl.setAttribute("data-bs-interval", selectedOption);
                            hourButtonEl.setAttribute("data-bs-time", hours[i]);
                            hourButtonEl.setAttribute("id", "aditHourListIndex");



                            hourButtonEl.innerHTML = hours[i];
                            hourButtonsContainer.appendChild(hourButtonEl);
                        }



                    }
                }
            };

        }
        dateInput.addEventListener('change', getHours);
        intervalInput.addEventListener('change', getHours);
        doctorInput.addEventListener('change', getHours);



    <% if (requestStr != null && requestStr.length() > 1) { %>
    clickButton();

    <% } %>

    function clickButton() {
        var myButton = document.getElementById("sucsessModalBtn");
        myButton.click();
    }

    // Select öğesi değiştiğinde çalışacak fonksiyonu tanımlayın
    document.getElementById("add-doktorName").onchange = function () {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("doctor-name").value = selectedValue;
    };
    document.getElementById("add-location").onchange = function () {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("loc-name").value = selectedValue;
    };
    document.getElementById("add-interval").onchange = function () {
        // Seçilen seçeneğin değerini alın
        let selectedValue = this.value;

        // Değerin başka bir input öğesine atanması
        document.getElementById("interval-type").value = selectedValue;
    };

    const custnNameIn = document.getElementById('name-input');
    const custnSurnameIn = document.getElementById('surname-input');
    const custnPhoneIn = document.getElementById('phone-input');


    const custnNameHid = document.getElementById('cust-name');
    const custnSurnameHid = document.getElementById('cust-surname');
    const custnPhoneHid = document.getElementById('cust-phone');


    custnNameIn.value = "";
    custnSurnameIn.value = "";
    custnPhoneIn.value = "";


    custnNameIn.addEventListener('input', function () {
        custnNameHid.value = this.value;
    });
    custnSurnameIn.addEventListener('input', function () {
        custnSurnameHid.value = this.value;
    });
    custnPhoneIn.addEventListener('input', function () {
        custnPhoneHid.value = this.value;
    });
    custnNameHid.value = "";
    custnSurnameHid.value = "";
    custnPhoneHid.value = "";




    let phoneInput = document.getElementById("phone");
    phoneInput.addEventListener("input", function (event) {
        let phone = phoneInput.value;

        // Parantez içerisindeki karakterleri sil
        if (event.inputType === "deleteContentBackward" && phone.charAt(phone.length - 1) === ")") {
            phone = phone.substring(0, phone.length - 2);
        }

        // Rakamları temizle
        phone = phone.replace(/\D/g, '');

        let phoneFormatted = "";
        if (phone.length > 0) {
            phoneFormatted = "(";
            phoneFormatted += phone.substr(0, 3);
            phoneFormatted += ") ";

            if (phone.length > 3) {
                phoneFormatted += phone.substr(3, 3);

                if (phone.length > 6) {
                    phoneFormatted += "-";
                    phoneFormatted += phone.substr(6);
                } else {
                    phoneFormatted += phone.substr(6);
                }
            } else {
                phoneFormatted += phone.substr(3);
            }
        }

        // Yeni formatlı telefon numarasını gösterin
        phoneInput.value = phoneFormatted;
    });


    // Sadece rakam girişine izin ver
    phoneInput.addEventListener("keypress", function (e) {
        // Sadece sayı tuşlarına izin ver (0-9 arası ASCII kodları 48-57 arasındadır)
        if (e.charCode < 48 || e.charCode > 57) {
            e.preventDefault();
        }

        // En fazla 10 rakam girilebilir
        if (phoneInput.value.length >= 14) {
            e.preventDefault();
        }
    });

    let addPhoneInput = document.getElementById("phone-input");
    addPhoneInput.addEventListener("input", function (event) {
        let phone = addPhoneInput.value;

        // Parantez içerisindeki karakterleri sil
        if (event.inputType === "deleteContentBackward" && phone.charAt(phone.length - 1) === ")") {
            phone = phone.substring(0, phone.length - 2);
        }

        // Rakamları temizle
        phone = phone.replace(/\D/g, '');

        let phoneFormatted = "";
        if (phone.length > 0) {
            phoneFormatted = "(";
            phoneFormatted += phone.substr(0, 3);
            phoneFormatted += ") ";

            if (phone.length > 3) {
                phoneFormatted += phone.substr(3, 3);

                if (phone.length > 6) {
                    phoneFormatted += "-";
                    phoneFormatted += phone.substr(6);
                } else {
                    phoneFormatted += phone.substr(6);
                }
            } else {
                phoneFormatted += phone.substr(3);
            }
        }

        // Yeni formatlı telefon numarasını gösterin
        addPhoneInput.value = phoneFormatted;
    });


    // Sadece rakam girişine izin ver
    addPhoneInput.addEventListener("keypress", function (e) {
        // Sadece sayı tuşlarına izin ver (0-9 arası ASCII kodları 48-57 arasındadır)
        if (e.charCode < 48 || e.charCode > 57) {
            e.preventDefault();
        }

        // En fazla 10 rakam girilebilir
        if (addPhoneInput.value.length >= 14) {
            e.preventDefault();
        }
    });

/*
function removeActiveClass(){
    const button = document.getElementById("editHourListIndex");
    const buttonWithout = document.getElementsByClassName("active");
    buttonWithout.classList.remove("active");
    buttonWithout.classList.add("none-active");

    button.classList.remove("none-active");
    button.classList.add("active");
}
    var editHourListIndex = document.getElementById('editHourListIndex');

    editHourListIndex.addEventListener('click', removeActiveClass);
*/



    function customSort(timeSlots) {
        for (let i = 0; i < timeSlots.length - 1; i++) {
            for (let j = i + 1; j < timeSlots.length; j++) {
                if (timeSlots[i].localeCompare(timeSlots[j]) > 0) {
                    // Swap the time slots if they are in the wrong order
                    let temp = timeSlots[i];
                    timeSlots[i] = timeSlots[j];
                    timeSlots[j] = temp;
                }
            }
        }
    }

    const inputElements = document.querySelectorAll('.validate-input');

    inputElements.forEach(input => {
        input.addEventListener('input', function () {
            const inputValue = this.value;
            if (inputValue.length > 0 && inputValue[0] === ' ') {
                this.value = inputValue.trimStart();
            }
        });
    });

</script>


</body>

</html>
<%
    }
%>