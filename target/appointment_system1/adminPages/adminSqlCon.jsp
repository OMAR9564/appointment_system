<%-- 
    Document   : adminSqlCon
    Created on : August 2, 2023, 07:16:50 PM
    Author     : omerfaruk
--%>

<%@ page import="com.bya.ConSql" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.bya.Helper" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="com.bya.CalendarService" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String pageName = request.getParameter("page");
    String iam = request.getParameter("iam");
    Helper helper = new Helper();
    ArrayList<GetInfo> calendarSqlId = new ArrayList<>();

    String appointmentMade = "true";
    String messageOk = "";
    if (pageName.equals("index.jsp") || pageName.equals("pages-appointments.jsp")) {
        if (iam != null && iam.equals("appoitnmentDelete")) {
            try {
                CalendarService calendarService = new CalendarService();
                String deleteId = request.getParameter("id");

                String deleteQuery = "DELETE FROM appointments WHERE id = ?";



                ConSql conSql = new ConSql();
                ArrayList<GetInfo> getEventID;
                String eventIdQuert = "SELECT eventID FROM `appointments` WHERE `id` = ?";

                String calendarIdQuery = "SELECT calendarID FROM `settings`";

                calendarSqlId = conSql.getSettingName(calendarIdQuery);
                String calID = calendarSqlId.get(0).getName();

                getEventID = conSql.getSettingName(eventIdQuert, deleteId);
                String eventID = getEventID.get(0).getName();

                String deleted = calendarService.deleteEvent(eventID, calID);
                if(deleted.equals("true")) {
                    conSql.executeQuery(deleteQuery, deleteId);

                    messageOk = "Kullanıcı Başarılı Bir Şekilde Silindi.";
                    appointmentMade = "true";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
                }

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

                CalendarService calendarService = new CalendarService();
                ConSql conSql = new ConSql();
                ArrayList<GetInfo> getEventID;
                String eventIdQuert = "SELECT eventID FROM `appointments` WHERE `id` = ?";
                getEventID = conSql.getSettingName(eventIdQuert, updateId);

                ArrayList<GetInfo> getLocName;
                String locNameQuery = "SELECT * FROM `locationInfo` WHERE `id` = ?";
                getLocName = conSql.getInfos(locNameQuery, location);

                String updateQuery = "UPDATE `appointments` SET `name`= ?,`surname`=?," +
                        "`phone`=?,`doctorId`=?,`locationId`=?," +
                        "`date`=?,`startHour`=?," +
                        "`endHour`=?,`intervalId`=? WHERE `id`=?";

                String eventID = getEventID.get(0).getName();
                String title = name + " " + surname;
                String locationName = getLocName.get(0).getName();
                String description = "Düzeltildi" + " - " + phone;
                String _startHour = helper.hourUnUtc(startHour);
                String _endHour = helper.hourUnUtc(endHour);

                String startDateTimeStr = date.split("-")[0] + "-" + date.split("-")[1] + "-" + date.split("-")[2] + "T" + _startHour + ":00";
                String endDateTimeStr = date.split("-")[0] + "-" + date.split("-")[1] + "-" + date.split("-")[2] + "T" + _endHour + ":00";

                String calendarIdQuery = "SELECT calendarID FROM `settings`";

                calendarSqlId = conSql.getSettingName(calendarIdQuery);
                String calID = calendarSqlId.get(0).getName();

                String updated = calendarService.updateEvent(eventID, title, description, locationName, startDateTimeStr, endDateTimeStr, calID);
                if(updated.equals("true")) {
                    conSql.executeQuery(updateQuery, name, surname, phone, doktorName, location, date, startHour, endHour, interval, updateId);
                    messageOk = "Kullanıcı Başarılı Bir Şekilde Güncellendi.";
                    appointmentMade = "true";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                }


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

                messageOk = "Kullanıcı Başarılı Bir Şekilde Eklendi.";
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
            String holiday = new String (request.getParameter("holiday").getBytes("ISO-8859-9"), "UTF-8");
            String openingHour = request.getParameter("openingHour");
            String closingHour = request.getParameter("closingHour");
            String appointMessageBody = new String(request.getParameter("appointMessageBody").getBytes("ISO-8859-9"), "UTF-8");
            String appointMessageTitle = new String(request.getParameter("appointMessageTitle").getBytes("ISO-8859-9"), "UTF-8");
            String calenarId = request.getParameter("calendarId");

            String updateQuery = "UPDATE `settings` SET `companyName`=?," +
                    "`openingHour`=?,`closingHour`=?,`appointMessageBody`=?," +
                    "`appointMessageTitle`=?,`holiday`=?, `calendarID`=? WHERE `id`=?";

            ConSql conSql = new ConSql();

            conSql.executeQuery(updateQuery, companyName, openingHour, closingHour, appointMessageBody, appointMessageTitle, holiday, calenarId, updateId);

            messageOk = "Kullanıcı Başarılı Bir Şekilde Güncellendi.";
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

            messageOk = "Kullanıcı Başarılı Bir Şekilde Güncellendi.";
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

                messageOk = "Gün Başarılı Bir Şekilde Silindi.";
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

                    messageOk = "Gün Başarılı Bir Şekilde Eklendi.";
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