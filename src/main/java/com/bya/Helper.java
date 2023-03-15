package com.bya;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;

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

    public  String hourUnUtc(String timeString){
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

    public String monthEki(int numOfDay){
        int sonucBol = 0;
        int sonucYuzde = numOfDay % 10;
        if(sonucYuzde == 0){
            sonucBol = numOfDay / 10;
        }
        String ek = null;
        if(sonucBol == 1 || sonucBol == 2 || sonucBol == 3){
            if(sonucBol == 1 || sonucBol == 3){
                ek = "'unda";
            }
            if(sonucBol == 2){
                ek = "'sinde";
            }
        }
        else{
            if(sonucYuzde ==  1 || sonucYuzde ==  5 || sonucYuzde ==  8){
                ek = "'inde";
            }
            if(sonucYuzde ==  2 || sonucYuzde ==  7){
                ek = "'sinde";
            }
            if(sonucYuzde ==  3 || sonucYuzde ==  4 || sonucYuzde == 9){
                ek = "'unde";
            }
            if(sonucYuzde ==  6){
                ek = "'sında";
            }
        }

        return ek;
    }

    public long dateToSec(String dateStr){
        DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.ENGLISH);

        long dateInSec;
        Date date = null;
        try {
            date = formatter.parse(dateStr);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }

        long plusUtc = (60*60)*6;

        Date now = new Date(); // Şu anki zaman
        long diffInMilliSec = date.getTime() - now.getTime();
        long diffInSec = (diffInMilliSec / 1000) + plusUtc;
        System.out.println(diffInSec);

            return diffInSec;


    }
}
