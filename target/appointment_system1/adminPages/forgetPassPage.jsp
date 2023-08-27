<%@ page import="com.bya.ConSql" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="com.bya.SendMail" %>
<%@ page import="com.bya.Helper" %><%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 27.08.2023
  Time: 16:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
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
      Helper helper = new Helper();
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
            response.sendRedirect("loginPage.jsp" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic));

          }catch (Exception e ){
            message = "false";
            dic = "Maalesef, bir hata oluştu.";
            response.sendRedirect("loginPage.jsp" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic));

          }



        }else{
          message = "false";
          dic = "Maalesef, e-posta gönderilirken bir hata oluştu.";
          response.sendRedirect("loginPage.jsp" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic));

        }



      }else{
        message = "false";
        dic = "Böyle bir kullanıcı bulunmamaktadır.";
        response.sendRedirect("loginPage.jsp" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic));

      }

    }catch (Exception e){
      message = "false";
      dic = "Maalesef, bir hata oluştu.";
      response.sendRedirect("loginPage.jsp" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic));

    }
    }
    else{
    message = "false";
    dic = "Bilgileri Yanlış Girdiniz.";
    response.sendRedirect("loginPage.jsp" + "?message=" + URLEncoder.encode(message) + "&dic=" + URLEncoder.encode(dic));
  }




%>

<html>

<body>

</body>
</html>
