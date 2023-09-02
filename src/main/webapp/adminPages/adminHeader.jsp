<%@ page import="com.bya.Helper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 27.02.2023
  Time: 17:08
  To change this template use File | Settings | File Templates.
--%>
<%
  Helper helper = new Helper();

  String username = null;

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
      }
    }
  }

  if (!finded) {
    HttpSession loginSession = request.getSession(false); // Yeni session oluşturulmasını engelle

    if (loginSession != null && loginSession.getAttribute("luna_token") != null) {
      username = helper.decodeJWT((String) loginSession.getAttribute("luna_token"));
      finded = true;
    }
  }



%>
<%--<%@page import="com.omar.hotelreservation.tags"%>--%>

  <!-- ======= Header ======= -->
  <header id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
      <a href="index.jsp" class="logo d-flex align-items-center">
        <img src="assets/img/logo.png" alt="">
        <span class="d-none d-lg-block">Yönetici Sayfası</span>
      </a>
      <i class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->

    <nav class="header-nav ms-auto">
      <ul class="d-flex align-items-center">
        <li class="nav-item dropdown pe-3">

          <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
            <span class="d-md-block dropdown-toggle ps-2"><%out.println(username);%></span>
          </a><!-- End Profile Iamge Icon -->

          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
            <li class="dropdown-header">
              <h6><%out.println(username);%></h6>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="profilPage.jsp">
                <i class="bi bi-person"></i>
                <span>Profilim</span>
              </a>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <hr class="dropdown-divider">
            </li>


            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
              <a class="dropdown-item d-flex align-items-center" href="adminSqlCon.jsp?page=loginPage.jsp&iam=logout">
                <i class="bi bi-box-arrow-right"></i>
                <span>Oturumu Kapat</span>
              </a>
            </li>

          </ul><!-- End Profile Dropdown Items -->
        </li><!-- End Profile Nav -->

      </ul>
    </nav><!-- End Icons Navigation -->

  </header><!-- End Header -->

