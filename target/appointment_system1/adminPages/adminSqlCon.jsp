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
<%@ page import="java.sql.SQLException" %>
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
        HttpSession loginSession = request.getSession(false); // Yeni session oluşturulmasını engelle
        if (loginSession != null && loginSession.getAttribute("luna_token") != null) {
            usernameCookie = helper.decodeJWT((String) loginSession.getAttribute("luna_token"));
            finded = true;
        }
    }


    String pageName = request.getParameter("page");
    String iam = request.getParameter("iam");
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
                    helper.createLog(messageOk, usernameCookie, clientIP, "deleteAppiontment");

                    appointmentMade = "true";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
                }

            } catch (Exception e) {
                appointmentMade = "false";
                helper.createLog(appointmentMade, usernameCookie, clientIP, "deleteAppiontment");

                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                out.println("Bir hata oluştu: " + e.getMessage());
            }
        }
        else if (iam != null && iam.equals("appointmentEdit")) {
            try {
                ConSql conSql = new ConSql();

                String startHour = null;
                String endHour = null;
                String updateId = request.getParameter("id");
                String name = request.getParameter("name");
                String surname = request.getParameter("surname");
                String phone = request.getParameter("phone");
                String date = request.getParameter("date");
                if (date == null) {
                    date = request.getParameter("editDate");
                }
                String interval = request.getParameter("interval");
                if (interval == null) {
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

                //control if hour is avalibale
                String appStartHoursQuery = "SELECT startHour FROM appointments WHERE date = ? AND `doctorId`=?";
                String appEndtHoursQuery = "SELECT endHour FROM appointments WHERE date = ? AND `doctorId`=?";
                String selectedDoktor = request.getParameter("editCookieUsername");

                String appointStartHour = fullHour.split("-")[0];
                String appointEndHour = fullHour.split("-")[1];
                Boolean appointAvalible = true;
                ArrayList<GetInfo> appStartHours = conSql.readHourData(appStartHoursQuery, date, selectedDoktor);
                ArrayList<GetInfo> appEndHours = conSql.readHourData(appEndtHoursQuery, date, selectedDoktor);


                String[] _tempSplitStartHour = appointStartHour.split(":");
                String[] _tempSplitEndHour = appointEndHour.split(":");
                int _tempStartHourToMunite = Integer.parseInt(_tempSplitStartHour[0]) * 60;
                int _tempEndtHourToMunite = Integer.parseInt(_tempSplitEndHour[0]) * 60;

                int _tempStartHourWithMuniteToMunite = _tempStartHourToMunite + Integer.parseInt(_tempSplitStartHour[1]);
                int _tempEndtHourWithMuniteToMunite = _tempEndtHourToMunite + Integer.parseInt(_tempSplitEndHour[1]);
                int counter = 0;

                //control if other user and I take appointment in one time
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

                    String messageDic = "Seçtiğiniz saat aralığı başka bir kullanıcı tarafından rezerve edilmiştir. Lütfen başka bir saat aralığı seçin.";
                    helper.createLog(messageDic, usernameCookie, clientIP, "ErrorAddAppiontment");

                    String appointmentMade1 = "false";
                    String encodedMessage = URLEncoder.encode(appointmentMade1, "UTF-8");
                    String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                    response.sendRedirect(pageName + "?message=" + encodedMessage + "&dic=" + encodedDescription);

                } else {


                    CalendarService calendarService = new CalendarService();
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
                    if (updated.equals("true")) {
                        conSql.executeQuery(updateQuery, name, surname, phone, doktorName, location, date, startHour, endHour, interval, updateId);
                        messageOk = "Kullanıcı Başarılı Bir Şekilde Güncellendi.";
                        helper.createLog(messageOk, usernameCookie, clientIP, "UpdateAppointment");

                        appointmentMade = "true";
                        response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                    }
                }

                } catch(Exception e){

                    appointmentMade = "false";
                helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorUpdateAppointment");

                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                    out.println("Bir hata oluştu: " + e.getMessage());
                }
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
                helper.createLog(messageOk, usernameCookie, clientIP, "AddAppointment");

                appointmentMade = "true";
                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


            } catch (Exception e) {

                appointmentMade = "false";
                helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorAddAppointment");

                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                out.println("Bir hata oluştu: " + e.getMessage());
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
            String userId = request.getParameter("settingsUsernameCookie");
            String updateQuery = "UPDATE `settings` SET `companyName`=?," +
                    "`openingHour`=?,`closingHour`=?,`appointMessageBody`=?," +
                    "`appointMessageTitle`=?,`holiday`=?, `calendarID`=? WHERE `id`=? AND `userId`=?";

            ConSql conSql = new ConSql();

            conSql.executeQuery(updateQuery, companyName, openingHour, closingHour, appointMessageBody, appointMessageTitle, holiday, calenarId, updateId, userId);

            messageOk = "Kullanıcı Başarılı Bir Şekilde Güncellendi.";
            helper.createLog(messageOk, usernameCookie, clientIP, "UpdateSettings");

            appointmentMade = "true";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


        } catch (Exception e) {

            appointmentMade = "false";
            helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorUpdateSettings");

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
            String userId = request.getParameter("edit-cookie-userId-HD");

            //if day is holiday
            if(openingHour == null || closingHour == null){
                openingHour = "0";
                closingHour = "0";

            }

            String updateQuery = "UPDATE `dailyOCHour` SET `day`=?," +
                    "`openingHour`=?,`closingHour`=? WHERE `id`=? AND `userId`=?";

            ConSql conSql = new ConSql();

            conSql.executeQuery(updateQuery, day, openingHour, closingHour, updateId, userId);

            messageOk = "Kullanıcı Başarılı Bir Şekilde Güncellendi.";
            helper.createLog(messageOk, usernameCookie, clientIP, "EditDailyOCHour");

            appointmentMade = "true";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


        } catch (Exception e) {

            appointmentMade = "false";
            helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorEditDailyOCHour");

            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

            out.println("Bir hata oluştu: " + e.getMessage());
        }

    }else if (iam != null && iam.equals("deleteDailyOCHour")) {
            try {

                String deleteId = request.getParameter("id");

                String deleteQuery = "DELETE FROM dailyOCHour WHERE id = ?";

                ConSql conSql = new ConSql();

                conSql.executeQuery(deleteQuery, deleteId);
                helper.createLog(deleteId, usernameCookie, clientIP, "DeleteDailyOCHour");
                messageOk = "Gün Başarılı Bir Şekilde Silindi.";
                appointmentMade = "true";
                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));


            } catch (Exception e) {
                appointmentMade = "false";
                helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorDeleteDailyOCHour");

                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                out.println("Bir hata oluştu: " + e.getMessage());
            }
        }else if (iam != null && iam.equals("addDailyOCHour")) {
            try {

                String day = request.getParameter("addDay");
                day = helper.changePatternOfDate(day);
                String openingHour = request.getParameter("addOpeningHour");
                String closingHour = request.getParameter("addClosingHour");
                String userId = request.getParameter("add-cookie-userId-HD");

                //if day is holiday
                if(openingHour == null || closingHour == null){
                    openingHour = "0";
                    closingHour = "0";

                }
                ConSql conSql = new ConSql();
                ArrayList<GetInfo> countDayQuery = new ArrayList<>();
                //control if add two rule in one day
                String checkDayQuery = "SELECT * FROM `dailyOCHour` WHERE `day` = ? AND `userID` =?";
                countDayQuery = conSql.getDailyOCHour(checkDayQuery, day, userId);
                if(countDayQuery.size() > 0){

                    messageOk = "Aynı Günde Birden Fazla Kural Yazılmaz.";
                    helper.createLog(messageOk, usernameCookie, clientIP, "ErrorAddDailyOCHour");

                    appointmentMade = "false";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                }
                else {


                    String insertQuery = "INSERT INTO `dailyOCHour`(`day`, `openingHour`, `closingHour`, `userId`) " +
                            "VALUES (?, ?, ?, ?)";

                    conSql.executeQuery(insertQuery, day, openingHour, closingHour, userId);

                    messageOk = "Gün Başarılı Bir Şekilde Eklendi.";
                    helper.createLog(messageOk, usernameCookie, clientIP, "AddDailyOCHour");

                    appointmentMade = "true";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
                }

            } catch (Exception e) {
                helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorAddDailyOCHour");

                appointmentMade = "false";
                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                out.println("Bir hata oluştu: " + e.getMessage());
            }
        }
    }
    else if (pageName.equals("loginPage.jsp")) {
        if(iam != null && iam.equals("login")  ){
            try {


                String userName = request.getParameter("logeuser");
                String password = request.getParameter("logpass");
                String remember = request.getParameter("rememberMe");
                String userIPAddress = request.getRemoteAddr();

                ConSql conSql = new ConSql();
                ArrayList<GetInfo> userInfo = new ArrayList<>();
                String decryptPass = null;
                String userQuery = "SELECT * FROM `user` WHERE `username` = ?";

                userInfo = conSql.getUserInfos(userQuery, userName);
                //kullanici adi konrolu
                if (userInfo.size() > 0) {
                    //sifre kontrolu
                    String depass = helper.decrypt(userInfo.get(0).getPass());
                    if (depass.equals(password)){
                        //beni hatirla
                        if (remember != null) {

                            //start cookie
                            long expirationTime = 30L * 24 * 60 * 60 * 1000; // 30 gün

                            String surnameToken = null;
                            String usernameToken = null;
                            String ipToken = null;
                            String nameToken = null;
                            String emailToken = null;
                            try {
                                 usernameToken = helper.JWT(userName, expirationTime);
                                 ipToken = helper.JWT(clientIP, expirationTime);
                                 nameToken = helper.JWT(userInfo.get(0).getName(), expirationTime);

                                surnameToken = helper.JWT(userInfo.get(0).getSurname(), expirationTime);
                                 emailToken = helper.JWT(userInfo.get(0).getEmail(), expirationTime);

                            } catch (Exception e) {
                                throw new RuntimeException(e);
                            }

                            Cookie _usernameCookie = new Cookie("luna_token", usernameToken);
                            Cookie nameCookie = new Cookie("lna_token", nameToken);
                            Cookie surnameCookie = new Cookie("lsna_token", surnameToken);
                            Cookie emailCookie = new Cookie("lema_token", emailToken);
                            Cookie ipCookie = new Cookie("lipad_token", ipToken);

                            _usernameCookie.setMaxAge((int) (expirationTime / 1000)); //saniye cinsinden
                            nameCookie.setMaxAge((int) (expirationTime / 1000));
                            surnameCookie.setMaxAge((int) (expirationTime / 1000));
                            emailCookie.setMaxAge((int) (expirationTime / 1000));
                            ipCookie.setMaxAge((int) (expirationTime / 1000));

                            response.addCookie(_usernameCookie);
                            response.addCookie(nameCookie);
                            response.addCookie(surnameCookie);
                            response.addCookie(emailCookie);
                            response.addCookie(ipCookie);
                            //end cookie


                            appointmentMade = "true";
                            String dic = "Giriş başarılı bir şekilde yapıldı.";
                            helper.createLog(dic, usernameCookie, clientIP, "login");

                            response.sendRedirect("index.jsp" + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(dic));

                        }
                        //beni hatirlama
                        else{
                            //start session

                            Cookie _usernameCookie = new Cookie("luna_token", null);
                            Cookie nameCookie = new Cookie("lna_token", null);
                            Cookie surnameCookie = new Cookie("lsna_token", null);
                            Cookie emailCookie = new Cookie("lema_token", null);
                            Cookie ipCookie = new Cookie("lipad_token", null);

                            _usernameCookie.setMaxAge(0); //saniye cinsinden
                            nameCookie.setMaxAge(0);
                            surnameCookie.setMaxAge(0);
                            emailCookie.setMaxAge(0);
                            ipCookie.setMaxAge(0);

                            response.addCookie(_usernameCookie);
                            response.addCookie(nameCookie);
                            response.addCookie(surnameCookie);
                            response.addCookie(emailCookie);
                            response.addCookie(ipCookie);


                            HttpSession loginSession = request.getSession(false); // Yeni oturum oluşturmasını engelle

                            if (loginSession != null) {
                                loginSession.invalidate(); // Oturumu geçersiz kıl
                            }

                            loginSession = request.getSession();

                            long expirationTime =  12 * 60 * 60 * 1000;

                            String usernameToken = helper.JWT(userName, expirationTime);
                            String ipToken = helper.JWT(clientIP, expirationTime);
                            String nameToken = helper.JWT(userInfo.get(0).getName(), expirationTime);
                            String surnameToken = helper.JWT(userInfo.get(0).getSurname(), expirationTime);
                            String emailToken = helper.JWT(userInfo.get(0).getEmail(), expirationTime);

                            loginSession.setAttribute("luna_token", usernameToken);
                            loginSession.setAttribute("lna_token", nameToken);
                            loginSession.setAttribute("lsna_token", surnameToken);
                            loginSession.setAttribute("lema_token", emailToken);
                            loginSession.setAttribute("lipad_token", ipToken);

                            loginSession.setMaxInactiveInterval(Math.toIntExact(expirationTime / 1000));
                            //end session


                            appointmentMade = "true";

                            String dic = "Giriş başarılı bir şekilde yapıldı.";
                            helper.createLog(dic, usernameCookie, clientIP, "login");

                            response.sendRedirect("index.jsp" + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(dic));

                        }
                    }
                    //sifre yanlis
                    else {
                        appointmentMade = "false";
                        String dic = "Girdiğiniz şifre yanlıştır.";
                        helper.createLog(dic, usernameCookie, clientIP, "ErrorLogin");

                        response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(dic));

                    }
                }
                //kullanici yanlis
                else {
                    appointmentMade = "false";
                    String dic = "Böyle bir kullanıcı adı bulunamadı.";
                    helper.createLog(dic, usernameCookie, clientIP, "ErrorLogin");

                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(dic));
                }

            }catch (SQLException e){
                appointmentMade = "false";
                helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorLogin");

                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(e.getMessage()));

                e.printStackTrace();
            }


        } else if (iam != null && iam.equals("forgetPass")) {

        } else if (iam != null && iam.equals("logout")) {
            Cookie _usernameCookie = new Cookie("luna_token", null);
            Cookie nameCookie = new Cookie("lna_token", null);
            Cookie surnameCookie = new Cookie("lsna_token", null);
            Cookie emailCookie = new Cookie("lema_token", null);
            Cookie ipCookie = new Cookie("lipad_token", null);

            _usernameCookie.setMaxAge(0); //saniye cinsinden
            nameCookie.setMaxAge(0);
            surnameCookie.setMaxAge(0);
            emailCookie.setMaxAge(0);
            ipCookie.setMaxAge(0);

            response.addCookie(_usernameCookie);
            response.addCookie(nameCookie);
            response.addCookie(surnameCookie);
            response.addCookie(emailCookie);
            response.addCookie(ipCookie);


            HttpSession loginSession = request.getSession(false); // Yeni oturum oluşturmasını engelle

            if (loginSession != null) {
                loginSession.invalidate(); // Oturumu geçersiz kıl
            }

            response.sendRedirect(pageName);

        }
    }
    else if (pageName.equals("profilPage.jsp")) {
        try {
            ConSql conSql = new ConSql();
            if (iam.equals("profilEdit")) {

                String id = request.getParameter("id");
                String name = new String(request.getParameter("profilName").getBytes("ISO-8859-9"), "UTF-8");
                String surname = new String(request.getParameter("profilSurname").getBytes("ISO-8859-9"), "UTF-8");
                String username = new String(request.getParameter("profilUserName").getBytes("ISO-8859-9"), "UTF-8");
                String email = request.getParameter("profilEmail");
                String oldPass = request.getParameter("oldPass");
                String newPass = request.getParameter("newPass");
                String reNewPass = request.getParameter("reNewPass");
                String nicename = new String(request.getParameter("profilNicename").getBytes("ISO-8859-9"), "UTF-8");;

                oldPass = oldPass.replace(" ", "");
                newPass = newPass.replace(" ", "");
                reNewPass = reNewPass.replace(" ", "");

                ArrayList<GetInfo> userInfo = new ArrayList<>();
                String decryptPass = null;
                String userQuery = "SELECT * FROM `user` WHERE `id` = ?";
                userInfo = conSql.getUserInfos(userQuery, id);

                String prfilUpdateQuery = null;
                if ((newPass == null && reNewPass == null) || (newPass.isEmpty() && reNewPass.isEmpty())) {
                    if(nicename.isEmpty() || nicename == null){
                        prfilUpdateQuery = "UPDATE `user` SET `name`=?,`surname`=?,`username`=?,`email`=? WHERE `id`=?";
                        conSql.executeQuery(prfilUpdateQuery, name, surname, username, email, id);
                    }else{
                        String profilDoctorQuery = "UPDATE `doctorInfo` SET `name`=? WHERE `userId`=?";
                        prfilUpdateQuery = "UPDATE `user` SET `name`=?,`surname`=?,`username`=?,`email`=? WHERE `id`=?";
                        conSql.executeQuery(prfilUpdateQuery, name, surname, username, email, id);
                        conSql.executeQuery(profilDoctorQuery, nicename, id);

                    }
                    messageOk = "Profil Başarılı Bir Şekilde Güncellendi.";
                    helper.createLog(messageOk, usernameCookie, clientIP, "ProfilEdit");

                    appointmentMade = "true";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                    //sifreler yanilenecek
                } else if ((newPass != null && reNewPass != null) || !(newPass.isEmpty() && reNewPass.isEmpty())) {
                    try {

                        if (newPass.equals(reNewPass) && !newPass.equals("") && !reNewPass.equals("")) {
                            if(oldPass.equals(helper.decrypt(userInfo.get(0).getPass()))) {


                                prfilUpdateQuery = "UPDATE `user` SET `name`=?,`surname`=?,`username`=?,`email`=?, `pass`=? WHERE `id`=?";
                                conSql.executeQuery(prfilUpdateQuery, name, surname, username, email, helper.encrypt(newPass), id);
                                messageOk = "Profil Başarılı Bir Şekilde Güncellendi.";
                                helper.createLog(messageOk, usernameCookie, clientIP, "ProfilEdit");

                                appointmentMade = "true";
                                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
                            }else {
                                messageOk = "Önceki Şifre Doğru Değil.";
                                helper.createLog(messageOk, usernameCookie, clientIP, "ErrorProfilEdit");

                                appointmentMade = "false";
                                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                            }
                        } else {
                            messageOk = "Yazdığınız Şifreler Aynı Olmalı. Ve Boşluk Kullanmyaın!";
                            helper.createLog(messageOk, usernameCookie, clientIP, "ErrorProfilEdit");

                            appointmentMade = "false";
                            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
                        }
                    } catch (Exception e) {
                        messageOk = "Bir Hata Oluştu.";
                        helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorProfilEdit");

                        appointmentMade = "false";
                        response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
                    }
                } else {
                    messageOk = "Bir Hata Oluştu.";
                    helper.createLog(messageOk, usernameCookie, clientIP, "ErrorProfilEdit");

                    appointmentMade = "false";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                }


            } else if (iam.equals("profilAdd")) {
                try {
                    String id = null;
                    String docktorSizeQuery = "SELECT * FROM `user`";
                    id = Integer.toString(conSql.getUserInfos(docktorSizeQuery).size() + 1);

                    String name = new String(request.getParameter("addProfilName").getBytes("ISO-8859-9"), "UTF-8");
                    String surname = new String(request.getParameter("addProfilSurname").getBytes("ISO-8859-9"), "UTF-8");
                    String username = new String(request.getParameter("addProfilUserName").getBytes("ISO-8859-9"), "UTF-8");
                    String email = request.getParameter("addProfilEmail");
                    String newPass = request.getParameter("addNewPass");
                    String reNewPass = request.getParameter("addReNewPass");
                    String nicename = new String(request.getParameter("addProfilNicename").getBytes("ISO-8859-9"), "UTF-8");

                    if(newPass.equals(reNewPass)){
                        String addQuery = "INSERT INTO `user`(`id`, `name`, `surname`, `username`, `email`, `pass`) " +
                                "VALUES (?,?,?,?,?,?)";
                        String doctorAddQuery = "INSERT INTO `doctorInfo`(`name`, `userId`) VALUES (?,?)";
                        conSql.executeQuery(addQuery,id, name, surname, username, email, helper.encrypt(newPass));
                        conSql.executeQuery(doctorAddQuery, nicename, id);
                        messageOk = "Profil Başarılı Bir Şekilde Eklendi.";
                        helper.createLog(messageOk, usernameCookie, clientIP, "profilAdd");

                        appointmentMade = "true";
                        response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                    }else{
                        messageOk = "Yazdığınız Şifreler Aynı Olmalı.";
                        helper.createLog(messageOk, usernameCookie, clientIP, "ErrorProfilAdd");

                        appointmentMade = "false";
                        response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                    }

                } catch (Exception e) {
                    messageOk = "Bir Hata Oluştu.";
                    helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorProfilAdd");

                    appointmentMade = "false";
                    response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));

                }

            } else {
                messageOk = "Bir Hata Oluştu.";
                helper.createLog(messageOk, usernameCookie, clientIP, "ErrorProfilAdd");

                appointmentMade = "false";
                response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
            }
        }catch (Exception e){
            messageOk = "Bir Hata Oluştu.";
            helper.createLog(e.getMessage(), usernameCookie, clientIP, "ErrorProfilAdd");

            appointmentMade = "false";
            response.sendRedirect(pageName + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
        }
    }
    else{
        messageOk = "Bir Hata Oluştu.";
        helper.createLog(messageOk, usernameCookie, clientIP, "ErrorProfilAdd");

        appointmentMade = "false";
        response.sendRedirect("index.jsp" + "?message=" + URLEncoder.encode(appointmentMade) + "&dic=" + URLEncoder.encode(messageOk));
    }

%>