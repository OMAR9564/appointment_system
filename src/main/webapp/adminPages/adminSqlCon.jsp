<%-- 
    Document   : adminSqlCon
    Created on : August 2, 2023, 07:16:50 PM
    Author     : omerfaruk
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.bya.ConSql" %>
<%@ page import="java.net.URLEncoder" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String pageName = request.getParameter("page");
    String iam = request.getParameter("iam");

    String appointmentMade = "true";
    String messageOk = "";

    if (iam != null && iam.equals("appoitnmentDelete")) {
        try {

            String deleteId = request.getParameter("id");

            String deleteQuery = "DELETE FROM appointments WHERE id = ?";

            ConSql conSql = new ConSql();

            conSql.executeQuery(deleteQuery, deleteId);

            messageOk = "Kullanıcı başarılı bir şekilde silindi.";
            appointmentMade = "true";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


        } catch (Exception e) {
            appointmentMade = "false";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

            out.println("Bir hata oluştu: " + e.getMessage());
        }
    } else if (iam != null && iam.equals("appointmentEdit")) {
        try {

            String updateId = request.getParameter("id");
            String name = request.getParameter("name");
            String surname = request.getParameter("surname");
            String phone = request.getParameter("phone");
            String date = request.getParameter("date");
            String interval = request.getParameter("interval");
            String startHour = request.getParameter("startHour");
            String endHour = request.getParameter("endHour");
            String doktorName = request.getParameter("doktorName");
            String location = request.getParameter("location");

            String updateQuery = "UPDATE `appointments` SET `name`= ?,`surname`=?," +
                                    "`phone`=?,`doctorId`=?,`locationId`=?," +
                                    "`date`=?,`startHour`=?," +
                                    "`endHour`=?,`intervalId`=? WHERE `id`=?";

            ConSql conSql = new ConSql();

            conSql.executeQuery(updateQuery, name, surname, phone, doktorName, location, date, startHour, endHour, interval, updateId);

            messageOk = "Kullanıcı başarılı bir şekilde guncellendi.";
            appointmentMade = "true";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


        } catch (Exception e) {
            appointmentMade = "false";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

            out.println("Bir hata oluştu: " + e.getMessage());
        }
    }
%>