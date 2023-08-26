<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 26.08.2023
  Time: 10:17
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
    boolean isValidToken = helper.validateToken(sessionId, ip);
    if (clientIP == null || !(clientIP.equals(ip)) ||
            username == null || username.isEmpty() ||
                    name == null || name.isEmpty() ||
                    surname == null || surname.isEmpty() ||
                    email == null || email.isEmpty()
    ) {
        response.sendRedirect("loginPage.jsp");
    } else {


        //end control is login

        String sqlQuery = "";
        String doctorNameQuery = "";


        ArrayList<GetInfo> userInfo = new ArrayList<>();
        ArrayList<GetInfo> doctorName = new ArrayList<>();

        ConSql consql = new ConSql();
        sqlQuery = "SELECT * FROM user WHERE username=?";
        userInfo = consql.getUserInfos(sqlQuery, username);
        doctorNameQuery = "SELECT * FROM `doctorInfo` WHERE `userId`=?";

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

    <title>Sayfalar / Profil</title>
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
        <h1>Profil</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index.jsp">Ana Sayfa</a></li>
                <li class="breadcrumb-item active"><a href="profilPage.jsp">Profil</a></li>
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
                                        <h5 class="card-title">Profilim</h5>
                                    </div>

                                </div>
                                <table class="table table-striped table-hover table-bordered">
                                    <tbody>
                                    <%
                                        doctorName = consql.getInfos(doctorNameQuery, Integer.toString(userInfo.get(0).getId()));
                                        session.setAttribute("profilId", Integer.toString(userInfo.get(0).getId()));
                                        session.setAttribute("profilName", userInfo.get(0).getName());
                                        session.setAttribute("profilSurname", userInfo.get(0).getSurname());
                                        session.setAttribute("profilUserName", userInfo.get(0).getUserName());
                                        if (doctorName.size() == 0){
                                            session.setAttribute("profilDoctorName", "");

                                        }else {
                                            session.setAttribute("profilDoctorName", doctorName.get(0).getName());
                                        }
                                        session.setAttribute("profilEmail", userInfo.get(0).getEmail());
                                        int passLengh =  helper.decrypt(userInfo.get(0).getPass()).length();
                                        session.setAttribute("profilPass", String.valueOf("●").repeat(passLengh));

                                    %>
                                    <tr>
                                        <th>Kullanıcı Adınız</th>
                                        <td><%out.println((String) session.getAttribute("profilUserName"));%></td>
                                    </tr>
                                    <tr>
                                        <th>Adınız</th>
                                        <td><%
                                            out.println((String) session.getAttribute("profilName"));%></td>
                                    </tr>
                                    <tr>
                                        <th>Soyadınız</th>
                                        <td><%
                                            out.println((String) session.getAttribute("profilSurname"));%></td>
                                    </tr>
                                    <tr>
                                        <th>Lakabınız</th>
                                        <td><%
                                            out.println((String) session.getAttribute("profilDoctorName"));%></td>
                                    </tr>
                                    <tr>
                                        <th>E-Postanız</th>
                                        <td><%
                                            out.println((String) session.getAttribute("profilEmail"));%>
                                    </tr>
                                    <tr>
                                        <th>Şifreniz</th>
                                        <td><%
                                            out.println((String) session.getAttribute("profilPass"));%>
                                    </tr>

                                    </tbody>

                                    <div class='col-md-2 ms-auto mt-3 d-grid gap-3 me-5 mb-3'>
                                        <button type="button" class="btn btn-info" data-bs-toggle="modal"
                                                data-bs-target="#editModal"
                                                data-bs-id="<%out.println(Integer.parseInt((String)session.getAttribute("profilId")));%>"
                                                data-bs-profilName="<%out.println((String)session.getAttribute("profilName"));%>"
                                                data-bs-profilSurname="<%out.println((String)session.getAttribute("profilSurname"));%>"
                                                data-bs-profilUserName="<%out.println((String)session.getAttribute("profilUserName"));%>"
                                                data-bs-profilNickname="<%out.println((String)session.getAttribute("profilDoctorName"));%>"

                                                data-bs-profilOldPass="<%out.println((String)session.getAttribute("profilPass"));%>"

                                                data-bs-profilEmail="<%out.println((String)session.getAttribute("profilEmail"));%>">
                                            <i class="bi bi-info-circle"></i> Düzenle</button>
                                    </div>
                                </table>
                                <div class="d-grid gap-2">
                                    <button class="btn btn-success" type="button" data-bs-toggle="modal"
                                            data-bs-target="#addModal">
                                        <i class="bi bi-person"></i> Yeni Kişi Ekle</button>

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
                                                <form method="post" action="adminSqlCon.jsp" id="editForm">
                                                    <input type="text" class=" idInput" name="id" hidden>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="profilUserName" class="col-form-label">Kullanıcı Adınız:</label>
                                                            <input type="text" class="form-control validate-input validate-input profilUserNameInput"
                                                                   name="profilUserName" id="profilUserName" required>
                                                        </div>
                                                        <input type="text" value="profilEdit" name="iam" hidden>
                                                        <input type="text" value="profilPage.jsp" name="page"
                                                               hidden>

                                                        <div class="mb-3 col-md-6">
                                                            <label for="profilName" class="col-form-label">Adınız:</label>
                                                            <input type="text" class="form-control validate-input validate-input profilNameInput"
                                                                   name="profilName" id="profilName" required>
                                                        </div>
                                                    </div>

                                                    <div class="row">

                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="profilSurname" class="col-form-label">Soyadınız:</label>
                                                            <input type="text" class="form-control validate-input validate-input profilSurnameInput"
                                                                   name="profilSurname" id="profilSurname" required>
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="profilEmail" class="col-form-label">E-Postanız:</label>
                                                            <input type="text" class="form-control validate-input validate-input profilEmailInput"
                                                                   name="profilEmail" id="profilEmail" required>
                                                        </div>


                                                    </div>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="profilNicename" class="col-form-label">Lakabmınız:</label>
                                                            <input type="text" class="form-control validate-input validate-input profilNicenameInput"
                                                                   name="profilNicename" id="profilNicename" required>
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="oldPass" class="col-form-label">Eski Şifreniz:</label>
                                                            <input type="password"
                                                                   class="form-control validate-input validate-input oldPassInput"

                                                                   name="oldPass" id="oldPass">
                                                        </div>

                                                    </div>

                                                    <div class="row">
                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="newPass" class="col-form-label">Yeni Şifreniz:</label>
                                                            <input type="password"
                                                                   class="form-control validate-input validate-input newPassInput"
                                                                   name="newPass" id="newPass">
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="reNewPass" class="col-form-label">Tekrar Yeni Şifreniz:</label>
                                                            <input type="password"
                                                                   class="form-control validate-input validate-input reNewPassInput"
                                                                   name="reNewPass" id="reNewPass">
                                                        </div>

                                                    </div>


                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Kapat
                                                        </button>
                                                        <input type="submit"  class="btn btn-info" value="Düzenle">
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%--add modal--%>
                                <div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel"
                                     aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="addModalLabel">Yeni Kişi Ekle</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                        aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form method="post" action="adminSqlCon.jsp" id="addFrom">
                                                    <input type="text" class=" idInput" name="addId" hidden>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6">
                                                            <label for="addProfilUserName" class="col-form-label">Kullanıcı Adınız:</label>
                                                            <input type="text" class="form-control validate-input profilUserNameInput"
                                                                   name="addProfilUserName" id="addProfilUserName" required>
                                                        </div>
                                                        <input type="text" value="profilAdd" name="iam" hidden>
                                                        <input type="text" value="profilPage.jsp" name="page"
                                                               hidden>

                                                        <div class="mb-3 col-md-6">
                                                            <label for="addProfilName" class="col-form-label">Adınız:</label>
                                                            <input type="text"  class="form-control  validate-input addProfilNameInput"
                                                                   name="addProfilName" id="addProfilName" required>
                                                        </div>
                                                    </div>

                                                    <div class="row">

                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="addProfilSurname" class="col-form-label">Soyadınız:</label>
                                                            <input type="text" class="form-control  validate-input addProfilSurnameInput"
                                                                   name="addProfilSurname" id="addProfilSurname" required>
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="addProfilEmail" class="col-form-label">E-Postanız:</label>
                                                            <input type="email" class="form-control validate-input addProfilEmailInput"
                                                                   name="addProfilEmail" id="addProfilEmail" required>
                                                        </div>


                                                    </div>
                                                    <div class="row">
                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="addProfilNicename" class="col-form-label">Lakabmınız:</label>
                                                            <input type="text" class="form-control validate-input validate-input addProfilNicenameInput"
                                                                   name="addProfilNicename" id="addProfilNicename" required>
                                                        </div>
                                                        <div class="mb-3 col-md-6 ms-auto">
                                                            <label for="addNewPass" class="col-form-label">Yeni Şifreniz:</label>
                                                            <input type="password"
                                                                   class="form-control validate-input validate-input addNewPassInput"
                                                                   name="addNewPass" id="addNewPass" required minlength="8">
                                                        </div>
                                                    </div>
                                                    <div class="row">

                                                        <div class="mb-3 col-md-6 ">
                                                            <label for="addReNewPass" class="col-form-label">Tekrar Yeni Şifreniz:</label>
                                                            <input type="password"
                                                                   class="form-control validate-input validate-input addReNewPassInput"
                                                                   name="addReNewPass" id="addReNewPass" required minlength="8">
                                                        </div>
                                                    </div>


                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary"
                                                                data-bs-dismiss="modal">Kapat
                                                        </button>
                                                        <input type="submit" class="btn btn-success" value="Ekle">
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
        var profilName = button.getAttribute('data-bs-profilName');
        var profilSurname = button.getAttribute('data-bs-profilSurname');
        var profilId = button.getAttribute('data-bs-id');
        var profilUserName = button.getAttribute('data-bs-profilUserName');
        var profilEmail = button.getAttribute('data-bs-profilEmail');
        var profilOldPass = button.getAttribute('data-bs-profilOldPass');
        var profilNickname = button.getAttribute('data-bs-profilNickname');

        var modalBodyprofilUserNameInput = exampleModal.querySelector('.modal-body .profilUserNameInput');
        var modalBodyprofilNameInput = exampleModal.querySelector('.modal-body .profilNameInput');
        var modalBodyprofilSurnameInput = exampleModal.querySelector('.modal-body .profilSurnameInput');
        var modalBodyprofilEmailInputd = exampleModal.querySelector('.modal-body .profilEmailInput');
        var modalBodyInputId = exampleModal.querySelector('.modal-body .idInput');
        var modalBodyoldPassInput = exampleModal.querySelector('.modal-body .oldPassInput');
        var modalBodyprofilNicknameInput = exampleModal.querySelector('.modal-body .profilNicenameInput');

        modalBodyoldPassInput.value = profilOldPass;
        modalBodyprofilUserNameInput.value = profilUserName;
        modalBodyprofilNameInput.value = profilName.trim();
        modalBodyInputId.value = profilId;
        modalBodyprofilSurnameInput.value = profilSurname.trim();
        modalBodyprofilEmailInputd.value = profilEmail.trim();
        modalBodyprofilNicknameInput.value = profilNickname.trim();
    });


    <% if (requestStr != null && requestStr.length() > 1) { %>
    clickButton();

    <% } %>

    function clickButton() {
        var myButton = document.getElementById("sucsessModalBtn");
        myButton.click();
    }
    const addnewPasswordInput = document.getElementById('addNewPass');
    const addreEnteredPasswordInput = document.getElementById('addReNewPass');
    const editPasswordInput = document.getElementById('newPass');
    const editreEnteredPasswordInput = document.getElementById('reNewPass');
    const oldEnteredPasswordInput = document.getElementById('oldPass');

    addnewPasswordInput.addEventListener('input', addComparePasswords);
    addreEnteredPasswordInput.addEventListener('input', addComparePasswords);
    editPasswordInput.addEventListener('input', editComparePasswords);
    editreEnteredPasswordInput.addEventListener('input', editComparePasswords);
    oldEnteredPasswordInput.addEventListener('input', removeSpace);



    function addComparePasswords() {
        var newPassword = addnewPasswordInput.value;
        var reEnteredPassword = addreEnteredPasswordInput.value;
        var newPasswordSpace = addnewPasswordInput.value;
        var reEnteredPasswordSpace = addreEnteredPasswordInput.value;
        addnewPasswordInput.value = newPasswordSpace.replace(/\s/g, "");
        addreEnteredPasswordInput.value = reEnteredPasswordSpace.replace(/\s/g, "");

         newPassword = addnewPasswordInput.value;
         reEnteredPassword = addreEnteredPasswordInput.value;

        if (newPassword === reEnteredPassword) {
            addnewPasswordInput.classList.remove('mismatch');
            addnewPasswordInput.classList.add('match');
            addreEnteredPasswordInput.classList.remove('mismatch');
            addreEnteredPasswordInput.classList.add('match');
        } else {
            addnewPasswordInput.classList.remove('match');
            addnewPasswordInput.classList.add('mismatch');
            addreEnteredPasswordInput.classList.remove('match');
            addreEnteredPasswordInput.classList.add('mismatch');
        }
    }
    function editComparePasswords() {
        var newPassword = editPasswordInput.value;
        var reEnteredPassword = editreEnteredPasswordInput.value;
        var newPasswordSpace = editPasswordInput.value;
        var reEnteredPasswordSpace = editreEnteredPasswordInput.value;
        editPasswordInput.value = newPasswordSpace.replace(/\s/g, "");
        editreEnteredPasswordInput.value = reEnteredPasswordSpace.replace(/\s/g, "");
         newPassword = editPasswordInput.value;
         reEnteredPassword = editreEnteredPasswordInput.value;

        if (newPassword === reEnteredPassword) {
            editPasswordInput.classList.remove('mismatch');
            editPasswordInput.classList.add('match');
            editreEnteredPasswordInput.classList.remove('mismatch');
            editreEnteredPasswordInput.classList.add('match');
        } else {
            editPasswordInput.classList.remove('match');
            editPasswordInput.classList.add('mismatch');
            editreEnteredPasswordInput.classList.remove('match');
            editreEnteredPasswordInput.classList.add('mismatch');
        }
    }
    function removeSpace(){
        var oldEnteredPasswordSpace = oldEnteredPasswordInput.value;
        oldEnteredPasswordInput.value = oldEnteredPasswordSpace.replace(/\s/g, "");

    }
    document.getElementById('editForm').addEventListener('submit', function (event) {
        const newPassword = editPasswordInput.value;
        const reEnteredPassword = editreEnteredPasswordInput.value;

        if (newPassword !== reEnteredPassword) {
            event.preventDefault(); // Prevent form submission
        }
    });
    document.getElementById('addFrom').addEventListener('submit', function (event) {
        const newPassword = addnewPasswordInput.value;
        const reEnteredPassword = addreEnteredPasswordInput.value;

        if (newPassword !== reEnteredPassword) {
            event.preventDefault(); // Prevent form submission
        }
    });

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
<%}%>