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
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="com.bya.Helper" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bya.GetInfo" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String pageName = request.getParameter("page");
    String iam = request.getParameter("iam");
    Helper helper = new Helper();

    String appointmentMade = "true";
    String messageOk = "";
    if (pageName.equals("index.jsp") || pageName.equals("pages-appointments.jsp")) {
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
        }
        else if (iam != null && iam.equals("appointmentEdit")) {
            try {
                String startHour = null;
                String endHour = null;
                String updateId = request.getParameter("id");
                String name = request.getParameter("name");
                String surname = request.getParameter("surname");
                String phone = request.getParameter("phone");
                String date = request.getParameter("date");
                if(date == null){
                    date = request.getParameter("editDate");
                }
                String interval = request.getParameter("interval");
                if (interval == null){
                    interval = request.getParameter("editInterval");
                }
                String fullHour = request.getParameter("appointAllHour");
/*
                String startHour = request.getParameter("startHour");
                String endHour = request.getParameter("endHour");
*/
                String doktorName = request.getParameter("doktorName");
                String location = request.getParameter("location");

                startHour = fullHour.split("-")[0];
                endHour = fullHour.split("-")[1];


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
        else if (iam != null && iam.equals("appointmentAdd")) {
            try {

                String name = request.getParameter("add-name");
                String surname = request.getParameter("add-surname");
                String phone = request.getParameter("add-phone");
                String date = request.getParameter("add-date");
                String interval = request.getParameter("add-interval");
                String startHour = request.getParameter("add-startHour");
                String endHour = request.getParameter("add-endHour");
                String doktorName = request.getParameter("add-doktorName");
                String location = request.getParameter("add-location");

                String outputDateFormat = "yyyy-MM-dd";

                SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                SimpleDateFormat outputDateFormatter = new SimpleDateFormat(outputDateFormat);


                Date inputDate = inputDateFormat.parse(date);
                String formattedDate = outputDateFormatter.format(inputDate);


                String insertQuery = "INSERT INTO `appointments`(`name`, `surname`, `phone`, `doctorId`," +
                        " `locationId`, `date`, `startHour`, `endHour`, `intervalId`) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

                ConSql conSql = new ConSql();

                conSql.executeQuery(insertQuery, name, surname, phone, doktorName, location, formattedDate, startHour, endHour, interval);

                messageOk = "Kullanıcı başarılı bir şekilde Eklendi.";
                appointmentMade = "true";
                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


            } catch (Exception e) {
                appointmentMade = "false";
                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                out.println("Bir hata oluştu: " + e.getMessage());
            }
        }
    }
    else if (pageName.equals("settingsPage.jsp")) {
        try {

            String updateId = request.getParameter("id");
            String companyName = new String(request.getParameter("companyName").getBytes("ISO-8859-9"), "UTF-8");
            String holiday = request.getParameter("holiday");
            String openingHour = request.getParameter("openingHour");
            String closingHour = request.getParameter("closingHour");
            String appointMessageBody = new String(request.getParameter("appointMessageBody").getBytes("ISO-8859-9"), "UTF-8");
            String appointMessageTitle = new String(request.getParameter("appointMessageTitle").getBytes("ISO-8859-9"), "UTF-8");

            String updateQuery = "UPDATE `settings` SET `companyName`=?," +
                    "`openingHour`=?,`closingHour`=?,`appointMessageBody`=?," +
                    "`appointMessageTitle`=?,`holiday`=? WHERE `id`=?";

            ConSql conSql = new ConSql();

            conSql.executeQuery(updateQuery, companyName, openingHour, closingHour, appointMessageBody, appointMessageTitle, holiday, updateId);

            messageOk = "Kullanıcı başarılı bir şekilde guncellendi.";
            appointmentMade = "true";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


        } catch (Exception e) {
            appointmentMade = "false";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

            out.println("Bir hata oluştu: " + e.getMessage());
        }
    }
    else if (pageName.equals("avalibaleHoursAndDays.jsp")) {
        if(iam != null && iam.equals("editDailyOCHour")  ){


        try {

            String updateId = request.getParameter("id");
            String day = request.getParameter("day");
            day = helper.changePatternOfDate(day);
            String openingHour = request.getParameter("openingHour");
            String closingHour = request.getParameter("closingHour");

            //if day is holiday
            if(openingHour == null || closingHour == null){
                openingHour = "0";
                closingHour = "0";

            }

            String updateQuery = "UPDATE `dailyOCHour` SET `day`=?," +
                    "`openingHour`=?,`closingHour`=? WHERE `id`=?";

            ConSql conSql = new ConSql();

            conSql.executeQuery(updateQuery, day, openingHour, closingHour, updateId);

            messageOk = "Kullanıcı başarılı bir şekilde guncellendi.";
            appointmentMade = "true";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


        } catch (Exception e) {
            appointmentMade = "false";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

            out.println("Bir hata oluştu: " + e.getMessage());
        }

    }else if (iam != null && iam.equals("deleteDailyOCHour")) {
            try {

                String deleteId = request.getParameter("id");

                String deleteQuery = "DELETE FROM dailyOCHour WHERE id = ?";

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
        }else if (iam != null && iam.equals("addDailyOCHour")) {
            try {

                String day = request.getParameter("addDay");
                day = helper.changePatternOfDate(day);
                String openingHour = request.getParameter("addOpeningHour");
                String closingHour = request.getParameter("addClosingHour");
                //if day is holiday
                if(openingHour == null || closingHour == null){
                    openingHour = "0";
                    closingHour = "0";

                }
                ConSql conSql = new ConSql();
                ArrayList<GetInfo> countDayQuery = new ArrayList<>();
                //control if add two rule in one day
                String checkDayQuery = "SELECT * FROM `dailyOCHour` WHERE `day` = ?";
                countDayQuery = conSql.getDailyOCHour(checkDayQuery, day);
                if(countDayQuery.size() > 0){
                    messageOk = "Aynı Günde Birden Fazla Kural Yazılmaz.";
                    appointmentMade = "false";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                }
                else {


                    String insertQuery = "INSERT INTO `dailyOCHour`(`day`, `openingHour`, `closingHour`) " +
                            "VALUES (?, ?, ?)";

                    conSql.executeQuery(insertQuery, day, openingHour, closingHour);

                    messageOk = "Gün başarılı bir şekilde eklendi.";
                    appointmentMade = "true";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
                }

            } catch (Exception e) {
                appointmentMade = "false";
                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                out.println("Bir hata oluştu: " + e.getMessage());
            }
        }
    }
%>