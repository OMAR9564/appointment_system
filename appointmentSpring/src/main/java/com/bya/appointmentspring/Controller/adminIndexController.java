package com.bya.appointmentspring.Controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class adminIndexController {
    private void setAttributes(HttpServletRequest request, String message, String dic) {
        if (message != null) {
            request.setAttribute("message", message);
        }
        if (dic != null) {
            request.setAttribute("dic", dic);
        }
    }
    @RequestMapping({"/kontrolPaneli", "/kontrolPaneli/"})
    public String controlPanel(
            @RequestParam(name = "message", required = false) String message,
            @RequestParam(name = "dic",required = false) String dic,
            HttpServletRequest request) {
        setAttributes(request, message, dic);
        return "adminPages/index";
    }





    @RequestMapping("/admin_get_available_hours")
    public String adminGetAvailableHours() {
        return "adminPages/get_available_hours";
    }



    //Start Login Page

    @RequestMapping("/girisYap")
    public String LoginPageRedirect(
            @RequestParam(name = "message", required = false) String message,
            @RequestParam(name = "dic",required = false) String dic,
            HttpServletRequest request
            ) {
        setAttributes(request, message, dic);
        return "adminPages/loginPage";


    }
    //End Login Page



    @RequestMapping("/tumRandevular")
    public String TumRandvular() {
        return "adminPages/pages-appointments";
    }

    @RequestMapping("/ayarlar")
    public String settingPage() {
        return "adminPages/settingsPage";
    }

    @RequestMapping("/musaitGunlerVeSaatler")
    public String avalibaleHoursAndDays() {
        return "adminPages/avalibaleHoursAndDays";
    }

    @RequestMapping("/profilim")
    public String profilPage(){
        return "adminPages/profilPage";
    }
    @RequestMapping("/forgetPassPage")
    public String forgetPassPage(){
        return "adminPages/forgetPassPage";
    }
}

