package com.bya;

import java.io.*;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

import com.google.gson.Gson;
import java.io.FileWriter;
import java.io.IOException;

public class Helper {

    String rndNum = null;

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

    public int randNum(){
        int randomNumberSixDigits = new Random().nextInt(900000) + 100000;
        System.out.println("6 haneli rastgele sayı: " + randomNumberSixDigits);
        return randomNumberSixDigits;
    }

    public void insertRandomNumToTxt(String randNum, String startDateTimeStr){
        if(!checkRandomNumIsHere(randNum)) {
            try {
                FileWriter myWriter = new FileWriter("/Users/omerfaruk/Documents/My_GitHub/appointment_system/src/main/resources/rndNums.txt", true);
                myWriter.write("\n" + randNum() + "_" + startDateTimeStr);
                myWriter.close();
                System.out.println("Dosya başarıyla yazıldı.");
            } catch (IOException e) {
                System.out.println("Dosya yazılırken bir hata oluştu.");
                e.printStackTrace();
            }
        }else{
            System.out.println("Rakam mevcut");
        }
    }
    public Boolean checkRandomNumIsHere(String randNum){
        String rndNumIsFind = null;
        Boolean numIsHere = false;
        try {
            File myFile = new File("/Users/omerfaruk/Documents/My_GitHub/appointment_system/src/main/resources/rndNums.txt");
            Scanner myReader = new Scanner(myFile);
            String rN = randNum;
            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                if((data.equals(rN))){
                    numIsHere = true;
                    break;
                }
                else
                    numIsHere = false;
                System.out.println("Data===> " + data);
            }
            myReader.close();

        } catch (FileNotFoundException e) {
            System.out.println("Dosya bulunamadı.");
            e.printStackTrace();
        }
        return numIsHere;
    }
    public Boolean checkDateIsFinishInTxt(String startDateTimeStr){
        Boolean dateIsFinish = false;
        try {
            File myFile = new File("/Users/omerfaruk/Documents/My_GitHub/appointment_system/src/main/resources/rndNums.txt");
            Scanner myReader = new Scanner(myFile);
            String dF = startDateTimeStr;
            while (myReader.hasNextLine()) {
                String data = myReader.nextLine();
                if(!data.equals("")) {
                    String[] parts = data.split("_");
                    String afterUnderSc = parts[1];
                    if ((parts[1].equals(dF))) {
                        dateIsFinish = true;
                        removeLineOfTxt(data);
                        break;
                    } else
                        dateIsFinish = false;
                    System.out.println("Data===> " + data);
                }
            }
            myReader.close();

        } catch (FileNotFoundException e) {
            System.out.println("Dosya bulunamadı.");
            e.printStackTrace();
        }
        return dateIsFinish;
    }

    public void removeLineOfTxt(String str){
        try {
            File inputFile = new File("/Users/omerfaruk/Documents/My_GitHub/appointment_system/src/main/resources/rndNums.txt");
            File tempFile = new File("/Users/omerfaruk/Documents/My_GitHub/appointment_system/src/main/resources/temp.txt");

            BufferedReader reader = new BufferedReader(new FileReader(inputFile));
            BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile));

            String lineToRemove = str;
            String currentLine;

            while((currentLine = reader.readLine()) != null) {
                // check if the line contains the string to be removed
                if(currentLine.contains(lineToRemove)) continue;
                writer.write(currentLine + System.getProperty("line.separator"));
            }
            writer.close();
            reader.close();
            boolean successful = tempFile.renameTo(inputFile);
            if (!successful) {
                System.out.println("Dosya silinemedi.");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void JsonFileWriter() {
        ConSql conSql = new ConSql();
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        String query = "SELECT `hour` FROM `appointments` WHERE `date`= \"2023-03-17\"";
        Gson gson = new Gson();
        String jsonString = "";
        try (FileWriter fileWriter = new FileWriter("myArray.json")) {
            sqlInfo = conSql.readHourData(query);
            String[] hourArray = new String[sqlInfo.size()];
            for(int i = 0; i < sqlInfo.size(); i++){
                hourArray[i] = sqlInfo.get(i).getAppHour();
            }
            jsonString = gson.toJson(hourArray);
            fileWriter.write(jsonString);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    // Helper function to calculate the time difference in minutes between two HH:mm formatted times
    public int timeToMinutes(String time) {
        String[] timeArray = time.split(":");
        int hours = Integer.parseInt(timeArray[0]);
        int minutes = Integer.parseInt(timeArray[1]);

        return hours * 60 + minutes;
    }

    public static void customSort(List<String> timeSlots) {
        for (int i = 0; i < timeSlots.size() - 1; i++) {
            for (int j = i + 1; j < timeSlots.size(); j++) {
                if (timeSlots.get(i).compareTo(timeSlots.get(j)) > 0) {
                    // Swap the time slots if they are in the wrong order
                    String temp = timeSlots.get(i);
                    timeSlots.set(i, timeSlots.get(j));
                    timeSlots.set(j, temp);
                }
            }
        }
    }
}
