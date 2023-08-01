<%--<%@page import="com.google.api.services.calendar.Calendar"%>
<%@page import="com.google.api.services.calendar.model.CalendarListEntry"%>
<%@page import="com.google.api.services.calendar.model.CalendarListEntry"%>--%>
<%@page import="java.security.GeneralSecurityException"%>
<%@page import="java.io.IOException"%>
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
<%@ page import="com.google.api.client.util.DateTime" %>
<%@ page import="java.util.Timer" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="com.bya.*" %>

<%
    final String appointmentMade;
    long dateInSec;



    Helper helper = new Helper();
    GetInfo getInfo = new GetInfo();
    ConSql conSql = new ConSql();

    String locationQuery = "SELECT * FROM locationInfo WHERE id = ?";

    String appointYear = request.getParameter("selected-year");
    String appointMonth = new String(request.getParameter("selected-month").getBytes("ISO-8859-9"), "UTF-8");
    String appointDay = request.getParameter("selected-dayIn");
    String appointTime = request.getParameter("selected-hour");
    String custName = new String(request.getParameter("cust-name").getBytes("ISO-8859-9"), "UTF-8");
    String custSurname = new String(request.getParameter("cust-surname").getBytes("ISO-8859-9"), "UTF-8");
    String custPhone = request.getParameter("cust-phone");
    String doctorName = request.getParameter("doctor-name");
    String locName = request.getParameter("loc-name");
    String intervalType = request.getParameter("interval-type");

    // check if there is no zero at the beginning of the day
    appointDay = helper.checkZeroIfdayOfDate(appointDay);

    locName = helper.removeWord(locName ,"loc");
    doctorName = helper.removeWord(doctorName ,"doctor");

    ArrayList<GetInfo> dbLocationName = conSql.getInfos(locationQuery, locName);


    String numOfMonth = helper.monthNameToNum(appointMonth);
    String[] startEndHours = helper.hourToParts(appointTime);
    String startHour = helper.hourUnUtc(startEndHours[0]);
    String endHour = helper.hourUnUtc(startEndHours[1]);





    String title = custName + " " + custSurname;
    String description = custPhone + " - " + locName;
    String  location = locName;
    String startDateTimeStr = appointYear + "-" + numOfMonth + "-" + appointDay + "T" + startHour + ":00";
    String endDateTimeStr = appointYear + "-" + numOfMonth + "-" + appointDay + "T" + endHour + ":00";

    dateInSec = helper.dateToSec(startDateTimeStr);


    CalendarService calendarService = new CalendarService();
    calendarService.resetErrorCount();

    int errorCount = calendarService.getErrorCount();

    try{
        String rndNum = null;
        String custNameWithOutSpace = custName.replace(" ", "-");
        String custSurnameWithOutSpace = custSurname.replace(" ", "-");
        String date = null;

        rndNum = String.valueOf(helper.randNum());


        Cookie firstNameCo = new Cookie("firN", URLEncoder.encode(custNameWithOutSpace, "UTF-8"));
        Cookie lastNameCo = new Cookie("lasN", URLEncoder.encode(custSurnameWithOutSpace, "UTF-8"));
        Cookie appointDayCo = new Cookie("appD", appointDay);
        Cookie appointTimeCo = new Cookie("appT", appointTime);
        Cookie locNameCo = new Cookie("locN", locName);
        Cookie appointIdCo = new Cookie("appId", rndNum);


        firstNameCo.setMaxAge(((int)dateInSec));
        lastNameCo.setMaxAge(((int)dateInSec));
        appointDayCo.setMaxAge(((int)dateInSec));
        appointTimeCo.setMaxAge(((int)dateInSec));
        locNameCo.setMaxAge(((int)dateInSec));
        appointIdCo.setMaxAge(((int)dateInSec));


        response.addCookie( firstNameCo );
        response.addCookie( lastNameCo );
        response.addCookie( appointDayCo );
        response.addCookie( appointTimeCo );
        response.addCookie( locNameCo );
        response.addCookie( appointIdCo );

        helper.checkDateIsFinishInTxt(startDateTimeStr);
        helper.insertRandomNumToTxt(rndNum, startDateTimeStr);


        date = appointYear + "-" + numOfMonth + "-" + appointDay;

        //set sql setters
        getInfo.setCustName(custName);
        getInfo.setCustSurname(custSurname);
        getInfo.setCustPhone(custPhone);
        getInfo.setDoctorName(doctorName);
        getInfo.setAppLocation(locName);
        getInfo.setTempId(rndNum);
        getInfo.setAppDate(date);
        getInfo.setAppHour(appointTime);

        String appointStartHour = appointTime.split("-")[0];
        String appointEndHour = appointTime.split("-")[1];

        conSql.insertData(custName, custSurname, custPhone, doctorName, locName
                            , rndNum, date, appointStartHour, appointEndHour, intervalType);

        location = dbLocationName.get(0).getName();

        calendarService.createEvent(title, description, location, startDateTimeStr, endDateTimeStr);

    }catch(Exception e){
        //System.out.println(e);
        errorCount += 1;
    }



    if(errorCount == 0) {
        appointmentMade = "true";
        response.sendRedirect("index.jsp?message=" + appointmentMade);

    }
    else {
        appointmentMade = "false";
        response.sendRedirect("index.jsp?message=" + appointmentMade);

    }

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
