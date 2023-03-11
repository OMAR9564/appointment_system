<%--<%@page import="com.google.api.services.calendar.Calendar"%>
<%@page import="com.google.api.services.calendar.model.CalendarListEntry"%>
<%@page import="com.google.api.services.calendar.model.CalendarListEntry"%>--%>
<%@page import="java.util.List"%>
<%@page import="java.security.GeneralSecurityException"%>
<%@page import="java.io.IOException"%>
<%@page import="com.bya.CalendarService"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.util.List"%>
<%--<%@page import="com.google.api.services.calendar.model.CalendarListEntry"%>
<%@ page import="com.google.api.services.calendar.CalendarService" %>--%>

<%@page import="com.bya.CalendarService"%>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 27.02.2023
  Time: 17:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bya.CalendarService.*" %>
<%@ page import="com.bya.Helper" %>

<%

    Helper helper = new Helper();


    String appointYear = request.getParameter("selected-year");
    String appointMonth = new String(request.getParameter("selected-month").getBytes("ISO-8859-9"), "UTF-8");
    String appointDay = request.getParameter("selected-dayIn");
    String appointTime = request.getParameter("selected-hour");
    String custName = request.getParameter("cust-name");
    String custSurname = request.getParameter("cust-surname");
    String custPhone = request.getParameter("cust-phone");
    String doctorName = request.getParameter("doctor-name");
    String locName = request.getParameter("loc-name");

    String numOfMonth = String.valueOf(helper.monthNameToNum(appointMonth));

    String title = custName + " " + custSurname;
    String description = custPhone + "-" + locName;
    String  location= locName;
    String startDateTimeStr = appointYear + "-" numOfMonth + "-" + appointDay + "T" + appointTime + ":00";

    LocalDateTime startDateTime = LocalDateTime.parse("2023-03-08T11:00");
    LocalDateTime endDateTime = LocalDateTime.parse("2023-03-08T19:00");



//    try {
//        CalendarService calendarService = new CalendarService();
//
////      calendarService.createEvent("sdf", "sdf", "2023-03-08T11:00", "2023-03-08T19:00");
//        calendarService.createEvent(title, description, location, startDateTime, endDateTime);
//        out.println("Etkinlik başarıyla oluşturuldu.");
//    } catch (IOException | GeneralSecurityException e) {
//        out.println("Etkinlik oluşturulurken bir hata oluştu: " + e.getMessage() + "\n");
//    }
//    try{
//                CalendarService calendarService = new CalendarService();
//
//    if(calendarService.getCalendarList().size()<0){
//        out.println("Takvim listesi bos");
//    }else{
//        for(int i = 0; i < calendarService.getCalendarList().size(); i++){
//            out.println(calendarService.getCalendarList().get(i));
//        }
//    }
//    }catch(IOException | GeneralSecurityException e){
//        out.println("\nTakvim listesi islerken bir hata oluştu: " + e.getMessage());
//    }
%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>hello</h1>



<h1><%out.println(appointYear);%></h1>
<h1><%out.println(appointMonth);%></h1>
<h1><%out.println(appointDay);%></h1>
<h1><%out.println(appointTime);%></h1>
<h1><%out.println(custName);%></h1>
<h1><%out.println(custSurname);%></h1>
<h1><%out.println(custPhone);%></h1>
<h1><%out.println(doctorName);%></h1>
<h1><%out.println(locName);%></h1>




</body>
</html>
