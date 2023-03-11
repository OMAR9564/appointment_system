package com.bya;

import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

public class Helper {
    public String monthNameToNum(String monthName) {
        String num;
        switch (monthName.toLowerCase()) {
            case "ocak":
                num = "01";
                break;
            case "şubat":
                num = "02";
                break;
            case "mart":
                num = "03";
                break;
            case "nisan":
                num = "04";
                break;
            case "mayıs":
                num = "05";
                break;
            case "haziran":
                num = "06";
                break;
            case "temmuz":
                num = "07";
                break;
            case "ağustos":
                num = "08";
                break;
            case "eylül":
                num = "09";
                break;
            case "ekim":
                num = "10";
                break;
            case "kasım":
                num = "11";
                break;
            case "aralık":
                num = "12";
                break;
            default:
                num = "-1";
                break;
        }
        return num;
    }

    public String[] hourToParts(String hour){
        String[] partsOfHour = null;
        partsOfHour = hour.split("-");
        return partsOfHour;
    }

    public  String HourUnUtc(String timeString){
        // String değerini bir LocalTime nesnesine dönüştürün
        LocalTime localTime = LocalTime.parse(timeString, DateTimeFormatter.ofPattern("HH:mm"));

        // Mevcut ülkenin saat dilimini alın
        ZoneId zone = ZoneId.systemDefault();

        // Mevcut tarih ve saati ZonedDateTime nesnesinde oluşturun
        ZonedDateTime zonedDateTime = ZonedDateTime.now(zone).with(localTime);

        // UTC ofsetini alın
        ZoneOffset offset = zonedDateTime.getOffset();

        // 10:30'dan UTC ofsetini çıkarın
        LocalTime result = localTime.minusSeconds(offset.getTotalSeconds());

        return result.toString();
    }

}
