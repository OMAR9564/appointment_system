<%-- 
    Document   : pages-reversayon
    Created on : Dec 22, 2022, 5:21:03 AM
    Author     : omerfaruk
--%>

<%@page import="com.omar.hotelreservation.mySql"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.omar.hotelreservation.getInfo"%>
<%@page import="com.omar.hotelreservation.hotelData"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    try {


    if((((String)session.getAttribute("adminName")).length() > 1) || (String)session.getAttribute("adminName") == null ){

//    customers data
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://app.sobiad.com:3306/grup9?useUnicode=true&characterEncoding=UTF-8&useSSL=false", "grup9", "9564");
    String sqlQuery = "SELECT * FROM `reverasyonlar` ORDER BY `reverasyonlar`.`id` DESC";
    PreparedStatement ps = con.prepareStatement(sqlQuery);

    ArrayList<getInfo> info;
    mySql mysql = new mySql();
    ResultSet rls = ps.executeQuery();
    info = mysql.readReversaionData(rls);


    session.setAttribute("serRevPages-Rev", Integer.toString(info.size()));

//    rooms data

    ArrayList<getInfo> infoRoom;

    sqlQuery = "SELECT * FROM `room`";
    PreparedStatement ps1 = con.prepareStatement(sqlQuery);
    ResultSet rls1 = ps1.executeQuery();
    infoRoom = mysql.readRoomsData(rls1);
    session.setAttribute("roomCountPages-Rev", Integer.toString(infoRoom.size()));


%>
<!DOCTYPE html>
<html lang="tr">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>Admin Page</title>
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

</head>
    <body>

    <jsp:include page="adminHeader.jsp" flush="true"/>

    <jsp:include page="adminSidebar.jsp" flush="true"/>
      <main id="main" class="main">

    <div class="pagetitle">
      <h1>Reverasions</h1>
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item"><a href="index.jsp">Customerts</a></li>
          <li class="breadcrumb-item active">Reverasions</li>
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
            <div class="card-body">
                  <h5 class="card-title">Oda Reverasyonlari <span>| Today</span></h5>
                        <div class='col-md-2 ms-auto mt-3 d-grid gap-3 me-5 mb-3' >
                        <button onclick="location.href='../rezervasyonPage.jsp'" type="button" class="btn btn-primary" >Add</button>
                        </div>

                  <table class="table">
                    <thead>
                      <tr>
                        <th scope="col">#</th>
                        <th scope="col">Musteri</th>
                        <th scope="col">Oda</th>
                        <th scope="col">Giriş Tarihi</th>
                        <th scope="col">Çikiş Tarihi</th>
                        <th scope="col">Durum</th>
                        <th scope="col">Düzenle</th>
                        <th scope="col">Sil</th>
                      </tr>
                    </thead>
                    <tbody>
                        <%
                            for(int i = 0; i < Integer.parseInt((String)session.getAttribute("serRevPages-Rev")); i++){
                                hotelData.setReverasyonId(info.get(i).getReverasyonId());
                                System.out.println(hotelData.getReverasyonId() + "ssssssssssss");
                                hotelData.setCustomerName(info.get(i).getCustName());
                                hotelData.setCustCount(info.get(i).getCustCount());
                                hotelData.setGirisTarihi(info.get(i).getGirisTarihi());
                                hotelData.setCikisTarihi(info.get(i).getCikisTarihi());                               
                                hotelData.setCustMail(info.get(i).getCustMail());
                                hotelData.setCustPhone(info.get(i).getCustPhone());
                                hotelData.setRoomName(info.get(i).getRoomName());
                                hotelData.setReversayonStatus(info.get(i).getDurum());
                                hotelData.setGander(info.get(i).getGander());
                                                                System.out.println(hotelData.getGander() + "ssswwwsssssssss");

                        %>
                      <tr>
                        <th scope="row"><a href="#">#<%out.println(i + 1);%></a></th>
                        <td><%out.println(hotelData.getCustomerName());%></td>
                        <td><a href="#" class="text-primary"><%out.println(hotelData.getRoomName());%></a></td>
                        <td><a href="#" class="text-primary"><%out.println(hotelData.getGirisTarihi());%></a></td>
                        <td><a href="#" class="text-primary"><%out.println(hotelData.getCikisTarihi());%></a></td>
                        <td><span class="badge bg-success"><%out.println(hotelData.getReversayonStatus());%></span></td>
                        <td><button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#editModal" data-bs-id="<%out.println(hotelData.getReverasyonId());%>" data-bs-gander="<%out.println(hotelData.getGander());%>" data-bs-custName="<%out.println(hotelData.getCustomerName());%>" data-bs-roomId="<%out.println(hotelData.getRoomName());%>" data-bs-gTarihi="<%out.println(hotelData.getGirisTarihi());%>" data-bs-cTarihi="<%out.println(hotelData.getCikisTarihi());%>" data-bs-custCount="<%out.println(hotelData.getCustCount());%>" data-bs-custMail="<%out.println(hotelData.getCustMail());%>" data-bs-custPhone="<%out.println(hotelData.getCustPhone());%> "data-bs-reverasyonStatus="<%out.println(hotelData.getReversayonStatus());%>" ><i class="bi bi-info-circle" ></i></button></td>
                        <td><button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#deleteModal" data-bs-idDel="<%out.println(hotelData.getReverasyonId());%>"><i class="bi bi-x-octagon"></i></button></td>
                      </tr>
                      <%}%>
                    </tbody>
                  </table>

                </div>
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
                                <label for="name" class="col-form-label">Musteri Adı:</label>
                                <input type="text" class="form-control nameInput" name="name" id="name">
                              </div>
                              <div class="mb-3 col-md-6 ms-auto">
                                <label for="custCount" class="col-form-label">Kişi Sayısı:</label>
                                <input type="number" min="0" max="6" class="form-control cCountInput" id="custCount" name="count"></input>
                              </div>
                              </div>
                              <div class="row">                                    
                                <div class="mb-3 col-md-6">
                                <label for="gTarihi" class="col-form-label">Giriş Tarihi:</label>
                                <input type="date" class="form-control gTarihiInput" name="gTarihi" id="gTarihi" >
                              </div>
                                <div class="mb-3 col-md-6 ms-auto">
                                <label for="cTarihi" class="col-form-label">Çıkuş Tarihi:</label>
                                <input type="date" class="form-control cTarihiInput" name="cTarihi" id="cTarihi" >
                              </div>
                              </div>                                  
                              <div class="row">                                    
                                <div class="mb-3 col-md-6">
                                <label for="mail" class="col-form-label">E-Mail:</label>
                                <input type="email" class="form-control mailInput" name="mail" id="mail">
                              </div>
                                <div class="mb-3 col-md-6 ms-auto">
                                <label for="phone" class="col-form-label">Telefon:</label>
                                <input type="tel" class="form-control phoneInput" name="phone" id="phone">
                              </div>
                              </div>                                  
                              <div class="row">                                    
                                <div class="mb-3 col-md-6">
                                <label for="roomName" class="col-form-label">Oda Adı:</label>
                                <select class="form-control roomNameSelect" name="roomName" id="roomName" >
                                    <%
                                        for(int i = 0; i < Integer.parseInt((String)session.getAttribute("roomCountPages-Rev")); i++){
                                            String roomID = Integer.toString(infoRoom.get(i).getRoomId());
                                            String roomName = infoRoom.get(i).getRoomName();
                                        hotelData.setRoomId(Integer.parseInt(roomID));
                                        hotelData.setRoomName(roomName);
                                    %>
                                       <option value="<%out.println(((roomID).trim()));%>"><%out.println(roomName);%></option>
                                       <%}%>
                                </select>
                              </div>
                                <div class="mb-3 col-md-6 ms-auto">
                                <label for="status" class="col-form-label">Durum:</label>
                                <select class="form-control statusSelect" name="status" id="status">
                                       <option value="incilenyor">İnceleniyor</option>
                                       <option value="onaylandi">Onaylandı</option>
                                </select>
                                </div>
                                  <div class="mb-3 col-md-6">
                                    <label for="status" class="col-form-label">Cinsiyet:</label>
                                    <select class="form-control selectGander" name="statusGander" id="statusGander">
                                        <option value="erkek">Erkek</option>
                                        <option value="kadin">Kadın</option>
                                    </select>
                              </div>

                                <input type="text" value="reverasionEdit" name="iam" hidden>
                            
                          <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <input type="submit" class="btn btn-primary" value="Edit">
                          </div>
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
                                    Bu reversayonun tüm bilgilerini silenecektir!!
                                </div>
                              
                              <form method="post" action="adminSqlCon.jsp">
                                  <input type="text" class="delIdInput" name="id" hidden value ="">
                              
                                <input type="text" value="reverasyonDelete" name="iam" hidden>
                                <div class="modal-footer">
                              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                              <input type="submit" class="btn btn-danger" value="Delete this Reverasion">
                              
                            </div>
                              </form>
                        </div>
                      </div>
                </div>

              </div>
                    
        </div>
    </section>
      </main>
    
    
    </body>
</html>
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
  var custName = button.getAttribute('data-bs-custName');
  var id = button.getAttribute('data-bs-id');
  var roomId = button.getAttribute('data-bs-roomId');
  var gTarihi = button.getAttribute('data-bs-gTarihi');
  var cTarihi = button.getAttribute('data-bs-cTarihi');
  var custCount = button.getAttribute('data-bs-custCount');
  var custMail = button.getAttribute('data-bs-custMail');
  var custPhone = button.getAttribute('data-bs-custPhone');
  var reverasyonStatus = button.getAttribute('data-bs-reverasyonStatus');
  var gander = button.getAttribute('data-bs-gander');

  var modalBodyInputName = exampleModal.querySelector('.modal-body .nameInput');
  var modalBodyInputId = exampleModal.querySelector('.modal-body .idInput');
  var modalBodyInputcCount = exampleModal.querySelector('.modal-body .cCountInput');
  var modalBodyInputgTarihi = exampleModal.querySelector('.modal-body .gTarihiInput');
  var modalBodyInputgcTarih = exampleModal.querySelector('.modal-body .cTarihiInput');
  var modalBodyInputmail = exampleModal.querySelector('.modal-body .mailInput');
  var modalBodyInputphone = exampleModal.querySelector('.modal-body .phoneInput');
  var modalBodyInputroomName = exampleModal.querySelector('.modal-body .roomNameSelect');

  var modalBodyInputstatus = exampleModal.querySelector('.modal-body .statusSelect');
  var modalBodyInputGander = exampleModal.querySelector('.modal-body .selectGander');




        modalBodyInputName.value = custName;
  modalBodyInputId.value = id.trim();
  modalBodyInputcCount.value = parseInt(custCount);
  modalBodyInputgTarihi.value = gTarihi.trim();
  modalBodyInputgcTarih.value = cTarihi.trim();
  modalBodyInputmail.value = custMail;
  modalBodyInputphone.value = custPhone;
  modalBodyInputroomName.value = roomId;
  modalBodyInputstatus.value = reverasyonStatus.trim();
  modalBodyInputGander.value = gander.trim();
});
   var deleteModal = document.getElementById('deleteModal');

      deleteModal.addEventListener('show.bs.modal', function (event) {
            var button = event.relatedTarget;

  var delId = button.getAttribute('data-bs-idDel'); 
  var modalBodyInputDelId = deleteModal.querySelector('.modal-body .delIdInput');
    modalBodyInputDelId.value = delId.trim();

});

  </script>

<%
    }else{
        response.sendRedirect("../index.jsp");
    }
    }catch (Exception e){
        response.sendRedirect("../index.jsp");

    }
%>