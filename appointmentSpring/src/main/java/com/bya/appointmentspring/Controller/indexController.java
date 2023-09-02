package com.bya.appointmentspring.Controller;

import com.bya.ConSql;
import com.bya.GetInfo;
import com.bya.Helper;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;
import java.util.ArrayList;

@Controller
public class indexController {


/*
    @RequestMapping("/index")
    public String randevuAl(
            @RequestParam(name = "message", required = false) String message,
            @RequestParam(name = "dic",required = false) String dic,
            HttpServletRequest request) {
        if (message != null && dic == null) {
            request.setAttribute("message", message);
            return "index";
        } else if (message != null && dic != null) {
            request.setAttribute("message", message);
            request.setAttribute("dic", dic);
            return "index";
        } else if (message == null && dic != null) {
            request.setAttribute("dic", dic);
            return "index";
        } else {
            // Parametre yoksa sadece /randevuAl sayfasına yönlendir
            return "redirect:/randevuAl";
        }
    }
*/


    @RequestMapping("/")
    public String slashRandevuAl() {
        return "redirect:/randevuAl";
    }


    @RequestMapping("/days")
    public ResponseEntity<String> getHolidayDays() throws SQLException {
        ConSql conSql = new ConSql();
        Helper helper = new Helper();

        String holidayQuery = "SELECT holiday FROM settings";

        ArrayList<GetInfo> holiday = new ArrayList<>();

        holiday = conSql.getSettingName(holidayQuery);

        String holidayName = holiday.get(0).getName();
        String day = helper.getDayOfWeek(holidayName);
        String jsonResponse = "{\"grayedOutDays\": [" + day + "]}";
        return ResponseEntity.ok(jsonResponse);
    }


    @GetMapping("/get_available_hours")
    public String getAvailableHours(
            @RequestParam(name = "selectedDate", required = false) String selectedDate,
            @RequestParam(name = "selectedOption", required = false) String selectedOption,
            @RequestParam(name = "selectedDoktor", required = false) String selectedDoktor,
            @RequestParam(name = "filter", required = false) String filter,
            HttpServletRequest request
    ) {

        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("selectedOption", selectedOption);
        request.setAttribute("selectedDoktor", selectedDoktor);

        return "get_available_hours";
    }

    @RequestMapping("/randevuAl")
    public String forwardToRandevuAl() {
        return "index";
    }

    @RequestMapping("/page404")
    public String page404(){

        return "adminPages/page404.html";
    }





    /*@GetMapping("/get_available_hours")
    public String goBackToIndex(
            @RequestParam String selectedDate,
            @RequestParam String selectedOption,
            @RequestParam String selectedDoktor,
            HttpServletRequest request
    ) {

        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("selectedOption", selectedOption);
        request.setAttribute("selectedDoktor", selectedDoktor);

        return "get_available_hours";
    }*/

}
