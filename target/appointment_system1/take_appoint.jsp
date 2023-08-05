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

    String messageDic = "";
    boolean appointAvalible = true;

    Helper helper = new Helper();
    GetInfo getInfo = new GetInfo();
    ConSql conSql = new ConSql();

    String locationQuery = "SELECT * FROM locationInfo WHERE id = ?";
    String appStartHoursQuery = "SELECT startHour FROM appointments WHERE date = ?";
    String appEndtHoursQuery = "SELECT endHour FROM appointments WHERE date = ?";



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

     if (!(helper.checkForSpecialChars(appointYear) && helper.checkForSpecialChars(appointMonth) &&
            helper.checkForSpecialChars(appointDay) && helper.checkForSpecialChars(appointTime) &&
            helper.checkForSpecialChars(custName) && helper.checkForSpecialChars(custSurname) &&
            helper.checkForSpecialChars(custPhone) && helper.checkForSpecialChars(doctorName) &&
            helper.checkForSpecialChars(locName) && helper.checkForSpecialChars(intervalType))) {

        appointmentMade = "false";
        messageDic = "Lutfen ozel karakter kullanmayin :)";

        String encodedMessage = URLEncoder.encode(appointmentMade, "UTF-8");
        String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
        response.sendRedirect("index.jsp?message=" + encodedMessage + "&dic=" + encodedDescription);


    } else {

         // check if there is no zero at the beginning of the day
         appointDay = helper.checkZeroIfdayOfDate(appointDay);

         locName = helper.removeWord(locName, "loc");
         doctorName = helper.removeWord(doctorName, "doctor");

         ArrayList<GetInfo> dbLocationName = conSql.getInfos(locationQuery, locName);


         String numOfMonth = helper.monthNameToNum(appointMonth);
         String[] startEndHours = helper.hourToParts(appointTime);
         String startHour = helper.hourUnUtc(startEndHours[0]);
         String endHour = helper.hourUnUtc(startEndHours[1]);


         String title = custName + " " + custSurname;
         String description = custPhone + " - " + locName;
         String location = locName;
         String startDateTimeStr = appointYear + "-" + numOfMonth + "-" + appointDay + "T" + startHour + ":00";
         String endDateTimeStr = appointYear + "-" + numOfMonth + "-" + appointDay + "T" + endHour + ":00";

         dateInSec = helper.dateToSec(startDateTimeStr);


         CalendarService calendarService = new CalendarService();
         calendarService.resetErrorCount();

         int errorCount = calendarService.getErrorCount();

         try {
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


             firstNameCo.setMaxAge(((int) dateInSec));
             lastNameCo.setMaxAge(((int) dateInSec));
             appointDayCo.setMaxAge(((int) dateInSec));
             appointTimeCo.setMaxAge(((int) dateInSec));
             locNameCo.setMaxAge(((int) dateInSec));
             appointIdCo.setMaxAge(((int) dateInSec));


             response.addCookie(firstNameCo);
             response.addCookie(lastNameCo);
             response.addCookie(appointDayCo);
             response.addCookie(appointTimeCo);
             response.addCookie(locNameCo);
             response.addCookie(appointIdCo);

             helper.checkDateIsFinishInTxt(startDateTimeStr);
             helper.insertRandomNumToTxt(rndNum, startDateTimeStr);


             date = appointYear + "-" + numOfMonth + "-" + appointDay;
             ArrayList<GetInfo> appStartHours = conSql.readHourData(appStartHoursQuery, date);
             ArrayList<GetInfo> appEndHours = conSql.readHourData(appEndtHoursQuery, date);

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

             //check if appoint is avalibale
             String[] _tempSplitStartHour = appointStartHour.split(":");
             String[] _tempSplitEndHour = appointEndHour.split(":");
             int _tempStartHourToMunite = Integer.parseInt(_tempSplitStartHour[0]) * 60;
             int _tempEndtHourToMunite = Integer.parseInt(_tempSplitEndHour[0]) * 60;

             int _tempStartHourWithMuniteToMunite = _tempStartHourToMunite + Integer.parseInt(_tempSplitStartHour[1]);
             int _tempEndtHourWithMuniteToMunite = _tempEndtHourToMunite + Integer.parseInt(_tempSplitEndHour[1]);
             int counter = 0;

             for (int j = 0; j < appStartHours.size(); j++) {
                 String tempAppStartHour = appStartHours.get(j).getAppHour();
                 String tempAppEndHour = appEndHours.get(j).getAppHour();
                 String[] tempAppSplitStartHour = tempAppStartHour.split(":");
                 String[] tempAppSplitEndHour = tempAppEndHour.split(":");
                 int tempAppStartHourToMunite = Integer.parseInt(tempAppSplitStartHour[0]) * 60;
                 int tempAppEndtHourToMunite = Integer.parseInt(tempAppSplitEndHour[0]) * 60;

                 int tempAppStartHourWithMuniteToMunite = tempAppStartHourToMunite + Integer.parseInt(tempAppSplitStartHour[1]);
                 int tempAppEndHourWithMuniteToMunite = tempAppEndtHourToMunite + Integer.parseInt(tempAppSplitEndHour[1]);

                 if ((tempAppStartHourWithMuniteToMunite <= _tempStartHourWithMuniteToMunite
                         && _tempStartHourWithMuniteToMunite < tempAppEndHourWithMuniteToMunite)
                         || tempAppStartHourWithMuniteToMunite < _tempEndtHourWithMuniteToMunite
                         && _tempEndtHourWithMuniteToMunite <= tempAppEndHourWithMuniteToMunite) {
                     appointAvalible = false;

                 }
             }
             if (!appointAvalible) {
                 messageDic = "Seçtiğiniz saat aralığı başka bir kullanıcı tarafından rezerve edilmiştir. Lütfen başka bir saat aralığı seçin.";
                 String appointmentMade1 = "false";
                 String encodedMessage = URLEncoder.encode(appointmentMade1, "UTF-8");
                 String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                 response.sendRedirect("index.jsp?message=" + encodedMessage + "&dic=" + encodedDescription);

             } else {


                 conSql.insertData(custName, custSurname, custPhone, doctorName, locName
                         , rndNum, date, appointStartHour, appointEndHour, intervalType);

                 location = dbLocationName.get(0).getName();

                 calendarService.createEvent(title, description, location, startDateTimeStr, endDateTimeStr);

             } }catch(Exception e){
                 //System.out.println(e);
                 errorCount += 1;
             }

             try {
                 if (errorCount == 0) {
                     appointmentMade = "true";
                     response.sendRedirect("index.jsp?message=" + appointmentMade);

                 } else {
                     appointmentMade = "false";
                     response.sendRedirect("index.jsp?message=" + appointmentMade);

                 }
             } catch (Exception e) {

             }


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
