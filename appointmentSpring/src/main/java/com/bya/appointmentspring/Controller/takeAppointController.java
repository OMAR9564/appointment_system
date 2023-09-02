package com.bya.appointmentspring.Controller;

import com.bya.CalendarService;
import com.bya.ConSql;
import com.bya.GetInfo;
import com.bya.Helper;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;

@Controller
public class takeAppointController {
    @RequestMapping("/take_appoint")
    public String takeAppoint(
            HttpServletResponse response,
            HttpServletRequest request) throws UnsupportedEncodingException, SQLException {

  /*      @RequestParam("selected-year") String selectedYear,
        @RequestParam("selected-month") String selectedMonth,
        @RequestParam("selected-dayIn") String selectedDay,
        @RequestParam("selected-hour") String selectedHour,
        @RequestParam("cust-name") String custName,
        @RequestParam("cust-surname") String custSurname,
        @RequestParam("cust-phone") String custPhone,
        @RequestParam("doctor-name") String doctorName,
        @RequestParam("loc-name") String locName,
        @RequestParam("interval-type") String intervalType,
        @RequestParam("page-name") String pageName,
*/

        final String appointmentMade;
        long dateInSec;

        String messageDic = "";
        boolean appointAvalible = true;

        Helper helper = new Helper();
        GetInfo getInfo = new GetInfo();
        ConSql conSql = new ConSql();

        ArrayList<GetInfo> calendarSqlId = new ArrayList<>();

        ArrayList<GetInfo> doctorCount = new ArrayList<>();
        ArrayList<String> _doctorCount = new ArrayList<>();

        ArrayList<GetInfo> reverationTagNames = new ArrayList<>();
        ArrayList<String> _reverationTagNames = new ArrayList<>();

        ArrayList<GetInfo> locationCount = new ArrayList<>();
        ArrayList<String> _locationCount = new ArrayList<>();

        ArrayList<GetInfo> approvalStatus = new ArrayList<>();

        String appointYear = request.getParameter("selected-year");
        String appointMonth = (request.getParameter("selected-month"));
        String appointDay = request.getParameter("selected-dayIn");
        String appointTime = request.getParameter("selected-hour");
        String custName = (request.getParameter("cust-name"));
        String custSurname = new String(request.getParameter("cust-surname"));
        String custPhone = request.getParameter("cust-phone");
        String doctorName = request.getParameter("doctor-name");
        String locName = request.getParameter("loc-name");
        String intervalType = request.getParameter("interval-type");
        String pageName = request.getParameter("page-name");
        String approvalString = null;

        //remove .jsp for spring
        pageName = helper.removeWord(pageName, ".jsp");

        //if from adminpage or normal user
        String selectedDoktor = request.getParameter("cookie-username");
        if (selectedDoktor == null || selectedDoktor.equals("")){
            selectedDoktor = helper.removeWord(doctorName, "doctor");
        }


        String locationQuery = "SELECT * FROM locationInfo WHERE id = ?";
        String appStartHoursQuery = "SELECT startHour FROM appointments WHERE date = ? AND `doctorId`=?";
        String appEndtHoursQuery = "SELECT endHour FROM appointments WHERE date = ? AND `doctorId`=?";
        String doctorCountQuery = "SELECT * FROM `doctorInfo`";
        String reverationTagNamesQuery = "SELECT * FROM `reservationInfo`";
        String locationCountQuery = "SELECT * FROM `locationInfo`";
        String calendarIdQuery = "SELECT calendarID FROM `settings` WHERE `userId`=?";
        String approvalQuery = "SELECT `appointmentStatus` FROM `settings` WHERE `userId`=?";

        //control inputs
        doctorCount = conSql.getInfos(doctorCountQuery);
        for (int i = 1; i <= doctorCount.size(); i++){
            _doctorCount.add(Integer.toString(i));
        }
        reverationTagNames = conSql.getRezervationInfos(reverationTagNamesQuery);
        for (int i = 0; i < reverationTagNames.size(); i++){
            _reverationTagNames.add(reverationTagNames.get(i).getRezervationNameTag());
        }
        locationCount = conSql.getInfos(locationCountQuery);
        for (int i = 1; i <= doctorCount.size(); i++){
            _locationCount.add(Integer.toString(i));
        }


        if(pageName == null ||pageName.equals("")){
            return "page404.jsp";

        }else {

            //control inputs
            if (!(helper.checkForSpecialChars(appointYear) && helper.checkForSpecialChars(appointMonth) &&
                    helper.checkForSpecialChars(appointDay) && helper.checkForSpecialChars(appointTime) &&
                    helper.checkForSpecialChars(custName) && helper.checkForSpecialChars(custSurname) &&
                    helper.checkForSpecialChars(custPhone) && helper.checkForSpecialChars(doctorName) &&
                    helper.checkForSpecialChars(locName) && helper.checkForSpecialChars(intervalType))) {

                appointmentMade = "false";
                messageDic = "Lutfen ozel karakter kullanmayin :)";

                String encodedMessage = URLEncoder.encode(appointmentMade, "UTF-8");
                String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                return "redirect:" + pageName + "?message=" + encodedMessage + "&dic=" + encodedDescription;

                // 2 > 1 < 2
            } else if (!(_locationCount.contains(helper.removeWord(locName, "loc")))) {
                appointmentMade = "false";
                messageDic = "Lütfen size sunulan seçeneklerden seçin.";

                String encodedMessage = URLEncoder.encode(appointmentMade, "UTF-8");
                String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                return "redirect:" + pageName + "?message=" + encodedMessage + "&dic=" + encodedDescription;

                //   2 > 5 < 2
            } else if (!(_doctorCount.contains(helper.removeWord(doctorName, "doctor")))) {
                appointmentMade = "false";
                messageDic = "Lütfen size sunulan seçeneklerden seçin.";

                String encodedMessage = URLEncoder.encode(appointmentMade, "UTF-8");
                String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                return "redirect:" + pageName + "?message=" + encodedMessage + "&dic=" + encodedDescription;


            } else if (!(_reverationTagNames.contains(intervalType))) {
                appointmentMade = "false";
                messageDic = "Lütfen size sunulan seçeneklerden seçin.";

                String encodedMessage = URLEncoder.encode(appointmentMade, "UTF-8");
                String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                return "redirect:" + pageName + "?message=" + encodedMessage + "&dic=" + encodedDescription;


            }
            else if (!helper.isPhoneNumber(custPhone)) {
                appointmentMade = "false";
                messageDic = "Lütfen telefon numarasını doğru şekilde giriniz.";

                String encodedMessage = URLEncoder.encode(appointmentMade, "UTF-8");
                String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                return "redirect:" + pageName + "?message=" + encodedMessage + "&dic=" + encodedDescription;


            }
            else {
                calendarSqlId = conSql.getSettingName(calendarIdQuery, selectedDoktor);

                approvalStatus = conSql.getSettingName(approvalQuery, selectedDoktor);
                approvalString = approvalStatus.get(0).getName();


                // check if there is no zero at the beginning of the day
                appointDay = helper.checkZeroIfdayOfDate(appointDay);

                locName = helper.removeWord(locName, "loc");
                doctorName = helper.removeWord(doctorName, "doctor");

                ArrayList<GetInfo> dbLocationName = conSql.getInfos(locationQuery, locName);


                String numOfMonth = helper.monthNameToNum(appointMonth);
                String[] startEndHours = helper.hourToParts(appointTime);

                String startHour = helper.checkZeroIfHourOfDate(startEndHours[0]);
                String endHour = helper.checkZeroIfHourOfDate(startEndHours[1]);

                startHour = helper.hourUnUtc(startHour);
                endHour = helper.hourUnUtc(endHour);

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
                    ArrayList<GetInfo> appStartHours = conSql.readHourData(appStartHoursQuery, date, selectedDoktor);
                    ArrayList<GetInfo> appEndHours = conSql.readHourData(appEndtHoursQuery, date, selectedDoktor);

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
                        messageDic = "Seçtiğiniz saat aralığı başka bir kullanıcı tarafından rezerve edilmiştir. Lütfen başka bir saat aralığı seçin.";
                        String appointmentMade1 = "false";
                        String encodedMessage = URLEncoder.encode(appointmentMade1, "UTF-8");
                        String encodedDescription = URLEncoder.encode(messageDic, "UTF-8");
                        return "redirect:" + (pageName + "?message=" + encodedMessage + "&dic=" + encodedDescription);

                    } else {



                        location = dbLocationName.get(0).getName();
                        String calID = calendarSqlId.get(0).getName();
                        String eventID = calendarService.createEvent(title, description, location, startDateTimeStr, endDateTimeStr, calID);
                        if (!(eventID.split("-")[0].equals("Error"))){
                            conSql.insertData(custName, custSurname, custPhone, doctorName, locName
                                    , rndNum, date, appointStartHour, appointEndHour, intervalType, eventID, approvalString);

                        }
                    }
                } catch (Exception e) {
                    System.out.println(e);
                    errorCount += 1;
                }

                try {
                    if (errorCount == 0) {
                        appointmentMade = "true";
                        return "redirect:" +(pageName + "?message=" + appointmentMade);

                    } else {
                        appointmentMade = "false";
                        return  "redirect:" +(pageName + "?message=" + appointmentMade);

                    }
                } catch (Exception e) {

                }


            }
        }









        return pageName;
    }
}
