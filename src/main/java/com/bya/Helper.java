package com.bya;

public class Helper {
    public int monthNameToNum(String monthNane) {
        int num;
        switch (monthNane.toLowerCase()) {
            case "ocak":
                num = 1;
                break;
            case "şubat":
                num = 2;
                break;
            case "mart":
                num = 3;
                break;
            case "nisan":
                num = 4;
                break;
            case "mayıs":
                num = 5;
                break;
            case "haziran":
                num = 6;
                break;
            case "temmuz":
                num = 7;
                break;
            case "ağustos":
                num = 8;
                break;
            case "eylül":
                num = 9;
                break;
            case "ekim":
                num = 10;
                break;
            case "kasım":
                num = 11;
                break;
            case "aralık":
                num = 12;
                break;
            default:
                num = -1;
                break;
        }
        return num;
    }

}
