<%@ page import="com.bya.ConSql" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="com.bya.SendMail" %>
<%@ page import="com.bya.Helper" %>
<%@ page import="jakarta.servlet.http.Cookie" %><%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 27.08.2023
  Time: 16:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  Helper helper = new Helper();

  //get user ip
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

  Boolean finded = false;
  String usernameCookie = null;

  Cookie[] cookies = request.getCookies();
  if (cookies != null) {
    for (Cookie cookie : cookies) {
      if (cookie.getName().equals("luna_token")) {
        if (!cookie.getValue().isEmpty()) {
          usernameCookie = helper.decodeJWT(cookie.getValue());
          finded = true;
        } else {
          finded = false;
          break;
        }
      }
    }
  }

  if (!finded) {
    HttpSession loginSession = (HttpSession) request.getSession(false); // Yeni session oluşturulmasını engelle
    if (loginSession != null && loginSession.getAttribute("luna_token") != null) {
      usernameCookie = helper.decodeJWT((String) loginSession.getAttribute("luna_token"));
      finded = true;
    }
  }


  ConSql conSql = new ConSql();

  String message = null;
  String dic = null;

  String checkMailUserQuery = "SELECT * FROM `user` WHERE `username`=? AND `email`=?";

  String forgetMail = request.getParameter("forgetEmail");
  String forgetUsername = request.getParameter("forgetUsername");

  //control if user avalibalve
  if(forgetMail != null && forgetUsername != null){
    try {
      ArrayList<GetInfo> infos = new ArrayList<>();
      infos = conSql.getUserInfos(checkMailUserQuery, forgetUsername, forgetMail);
      if (infos.size() > 0){
        //send mail
        String id = Integer.toString(infos.get(0).getId());
        String name = infos.get(0).getName();
        String surname = infos.get(0).getSurname();
        String username = infos.get(0).getUserName();
        String email = infos.get(0).getEmail();
        String newPass = helper.generatePassword();

        String mailMessage = "Merhaba "+name+" "+surname+". "+username+" Kullanıcı adınla yeni bir şifre talep ettiniz\n" +
                "Şifreniz: "+newPass;

        SendMail sendMail = new SendMail();
        String mailOk = sendMail.mailInfo(mailMessage, email);

        if(mailOk.equals("okBYA")){
          try {
            String passUpdateQuery = "UPDATE `user` SET `pass`=? WHERE `username`=? AND `id`=?";
            newPass = helper.encrypt(newPass);
            conSql.executeQuery(passUpdateQuery, newPass, username, id);
            message = "true";
            dic = "Şifreniz e-posta adresinize gönderildi.";
            helper.createLog(dic, usernameCookie, clientIP, "TrueForgetPass");

            response.sendRedirect("girisYap" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic, "UTF-8"));

          }catch (Exception e ){
            message = "false";
            dic = "Maalesef, bir hata oluştu.";
            helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorForgetPass");

            response.sendRedirect("girisYap" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic, "UTF-8"));

          }



        }else{
          helper.createLog(name, usernameCookie, clientIP, "ErrorForgetPass");

          message = "false";
          dic = "Maalesef, e-posta gönderilirken bir hata oluştu.";
          helper.createLog(dic, usernameCookie, clientIP, "ErrorForgetPass");

          response.sendRedirect("girisYap" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic, "UTF-8"));

        }



      }else{

        message = "false";
        dic = "Böyle bir kullanıcı bulunmamaktadır.";
        helper.createLog(dic, usernameCookie, clientIP, "ErrorForgetPass");

        response.sendRedirect("girisYap" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic, "UTF-8"));

      }

    }catch (Exception e){
      message = "false";
      dic = "Maalesef, bir hata oluştu.";
      helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorForgetPass");

      response.sendRedirect("girisYap" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic, "UTF-8"));

    }
    }
    else{
    String temp = "E-Mail"+forgetMail;
    helper.createLog(temp, usernameCookie, clientIP, "ErrorForgetPass");
    message = "false";
    dic = "Bilgileri Yanlış Girdiniz.";
    helper.createLog(dic, usernameCookie, clientIP, "ErrorForgetPass");
    response.sendRedirect("girisYap" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic, "UTF-8"));
  }




%>

<html>

<body>

</body>
</html>
