<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bya.ConSql" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.IOException" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.List" %><%@ page import="com.bya.Helper"%>
<%
try {
    String selectedDate = request.getParameter("selectedDate");
    String selectedOption = request.getParameter("selectedOption");

    String appStartHoursQuery = "SELECT startHour FROM appointments WHERE date = ?";
    String appEndtHoursQuery = "SELECT endHour FROM appointments WHERE date = ?";

    ConSql conSql = new ConSql();
    ArrayList<GetInfo> appStartHours = conSql.readHourData(appStartHoursQuery, selectedDate);
    ArrayList<GetInfo> appEndHours = conSql.readHourData(appEndtHoursQuery, selectedDate);


     // Calculate the working hours
    String openingHour = "9"; // Opening hour is 9:00
    String closingHour = "18"; // Closing hour is 18:00
    String openingMunite = "00";
    String closingMunite = "00";

    // Convert the working hours to minutes for easier manipulation
    int openingMinutes = Integer.parseInt(openingHour) * 60;
    int closingMinutes = Integer.parseInt(closingHour) * 60;

    int avalibaleHourCount = (closingMinutes - openingMinutes) / 60;

    List<String> adjustedHours = new ArrayList<>();

    String tempStartHour =  openingHour + ":" + openingMunite;
    String tempEndHour =  "";


    if (openingMunite.equals("00")){
        if (selectedOption.equals("single")){
            tempEndHour = Integer.toString(Integer.parseInt(openingHour) + 1);
            tempEndHour = tempEndHour + ":" + openingMunite;
        }else if (selectedOption.equals("couple")){
            tempEndHour = Integer.toString(Integer.parseInt(openingHour) + 1);
            tempEndHour = tempEndHour + ":30";
        }
    }else if(openingMunite.equals("30")){
        if (selectedOption.equals("single")){
            tempEndHour = Integer.toString(Integer.parseInt(openingHour) + 1);
            tempEndHour = tempEndHour + ":" + openingMunite;
        }else if (selectedOption.equals("couple")){
            tempEndHour = Integer.toString(Integer.parseInt(openingHour) + 2);
            tempEndHour = tempEndHour + ":00";

        }
    }
    for (int i = 0; i < avalibaleHourCount ; i++){
        // Control hours if out of closing time
        if(((Integer.parseInt(closingHour) <= Integer.parseInt(tempEndHour.split(":")[0]) )
        && Integer.parseInt(tempEndHour.split(":")[0]) >= Integer.parseInt(closingHour))
        || (Integer.parseInt(tempEndHour.split(":")[0]) == Integer.parseInt(closingHour) - 1)
        && (Integer.parseInt(tempEndHour.split(":")[1]) == 30)){
            break;
        }
            String[] tempSplitStartHour = tempStartHour.split(":");

            String[] tempSplitEndHour = tempEndHour.split(":");

            int tempStartHourToMunite = Integer.parseInt(tempSplitStartHour[0]) * 60;
            int tempEndtHourToMunite = Integer.parseInt(tempSplitEndHour[0]) * 60;

            int tempStartHourWithMuniteToMunite = tempStartHourToMunite + Integer.parseInt(tempSplitStartHour[1]) ;
            int tempEndtHourWithMuniteToMunite = tempEndtHourToMunite + Integer.parseInt(tempSplitEndHour[1]) ;

            // add 0 if start or hour under 9 clock
        if(i == 0 && ((Integer.parseInt(tempEndHour.split(":")[1]) != 30)
        || (Integer.parseInt(tempEndHour.split(":")[1]) == 30))  ){

            if ((Integer.parseInt(tempStartHour.split(":")[0]) <= 9)
            && (tempStartHour.split(":")[0]).charAt(0) != '0'){
            tempStartHour = "0" + tempStartHour;
            }

            if (Integer.parseInt(tempEndHour.split(":")[0]) <= 9
            && (tempEndHour.split(":")[0]).charAt(0) != '0'){
                tempEndHour = "0" + tempEndHour;
            }
        }
        for (int j = 0; j < appStartHours.size(); j++){
            String tempAppStartHour =  appStartHours.get(j).getAppHour();
            String tempAppEndHour =  appEndHours.get(j).getAppHour();
            String[] tempAppSplitStartHour = tempAppStartHour.split(":");
            String[] tempAppSplitEndHour = tempAppEndHour.split(":");
            int tempAppStartHourToMunite = Integer.parseInt(tempAppSplitStartHour[0]) * 60;
            int tempAppEndtHourToMunite = Integer.parseInt(tempAppSplitEndHour[0]) * 60;

            int tempAppStartHourWithMuniteToMunite = tempAppStartHourToMunite + Integer.parseInt(tempAppSplitStartHour[1]);
            int tempAppEndHourWithMuniteToMunite = tempAppEndtHourToMunite + Integer.parseInt(tempAppSplitEndHour[1]);

            if (tempAppStartHourWithMuniteToMunite <= tempStartHourWithMuniteToMunite
            && tempStartHourWithMuniteToMunite < tempAppEndHourWithMuniteToMunite){

                tempStartHour = tempAppStartHour;
                tempEndHour = tempAppEndHour;

                tempSplitStartHour = tempStartHour.split(":");
                tempSplitEndHour = tempEndHour.split(":");

                tempStartHourToMunite = Integer.parseInt(tempSplitStartHour[0]) * 60;
                tempEndtHourToMunite = Integer.parseInt(tempSplitEndHour[0]) * 60;
                break;
            }

            else if (tempAppStartHourWithMuniteToMunite < tempEndtHourWithMuniteToMunite
            && tempEndtHourWithMuniteToMunite <= tempAppEndHourWithMuniteToMunite){

                tempStartHour = tempAppStartHour;
                tempEndHour = tempAppEndHour;
                tempSplitStartHour = tempStartHour.split(":");
                tempSplitEndHour = tempEndHour.split(":");

                tempStartHourToMunite = Integer.parseInt(tempSplitStartHour[0]) * 60;
                tempEndtHourToMunite = Integer.parseInt(tempSplitEndHour[0]) * 60;
                break;
            }
        }
        //control if endHour under closing hour
        if (tempEndtHourToMunite >= closingMinutes) {
            break;
        }

        if (i == 0){
            int _counter = 0;
            for (int j = 0; j < appStartHours.size(); j++){
                String tempAppStartHour =  appStartHours.get(j).getAppHour();
                String tempAppEndHour =  appEndHours.get(j).getAppHour();
                String[] tempAppSplitStartHour = tempAppStartHour.split(":");
                String[] tempAppSplitEndHour = tempAppEndHour.split(":");
                int tempAppStartHourToMunite = Integer.parseInt(tempAppSplitStartHour[0]) * 60;
                int tempAppEndtHourToMunite = Integer.parseInt(tempAppSplitEndHour[0]) * 60;

                int tempAppStartHourWithMuniteToMunite = tempAppStartHourToMunite + Integer.parseInt(tempAppSplitStartHour[1]);
                int tempAppEndHourWithMuniteToMunite = tempAppEndtHourToMunite + Integer.parseInt(tempAppSplitEndHour[1]);


                if ((tempAppStartHourWithMuniteToMunite <= tempStartHourWithMuniteToMunite
                && tempStartHourWithMuniteToMunite < tempAppEndHourWithMuniteToMunite)
                || tempAppStartHourWithMuniteToMunite < tempEndtHourWithMuniteToMunite
                && tempEndtHourWithMuniteToMunite < tempAppEndHourWithMuniteToMunite){
                    _counter++;
                    continue;
                }
            }
            if(_counter == 0){
                adjustedHours.add(tempStartHour + "-" + tempEndHour);
                continue;
            }
        }

        //Control to what the next time
        if(tempSplitStartHour[1].equals("30") && tempSplitEndHour[1].equals("00")){
             if (selectedOption.equals("single")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 2);
                tempStartHour = tempStartHour + ":00";
                tempEndHour = Integer.toString((tempEndtHourToMunite  / 60) + 1);
                tempEndHour = tempEndHour + ":00";
            }else if (selectedOption.equals("couple")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 2);
                tempStartHour = tempStartHour + ":00";
                tempEndHour = Integer.toString((tempEndtHourToMunite  / 60) + 1);
                tempEndHour = tempEndHour + ":30";
            }

        }else if(tempSplitStartHour[1].equals("30") && tempSplitEndHour[1].equals("30")){
            if (selectedOption.equals("single")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 1);
                tempStartHour = tempStartHour + ":30";
                tempEndHour = Integer.toString((tempEndtHourToMunite / 60) + 1);
                tempEndHour = tempEndHour + ":30";
            }else if (selectedOption.equals("couple")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 1);
                tempStartHour = tempStartHour + ":30";
                tempEndHour = Integer.toString((tempEndtHourToMunite / 60) + 2);
                tempEndHour = tempEndHour + ":00";

            }
        }
        else if(tempSplitStartHour[1].equals("00") && tempSplitEndHour[1].equals("30")){
            if (selectedOption.equals("single")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 1);
                tempStartHour = tempStartHour + ":30";
                tempEndHour = Integer.toString((tempEndtHourToMunite  / 60) + 1);
                tempEndHour = tempEndHour + ":30";
            }else if (selectedOption.equals("couple")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 1);
                tempStartHour = tempStartHour + ":30";
                tempEndHour = Integer.toString((tempEndtHourToMunite  / 60) + 2);
                tempEndHour = tempEndHour + ":00";
            }
        }
        else if(tempSplitStartHour[1].equals("00") && tempSplitEndHour[1].equals("00")){
            if (selectedOption.equals("single")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 1);
                tempStartHour = tempStartHour + ":00";
                tempEndHour = Integer.toString((tempEndtHourToMunite  / 60) + 1);
                tempEndHour = tempEndHour + ":00";
            }else if (selectedOption.equals("couple")){
                tempStartHour = Integer.toString((tempStartHourToMunite / 60) + 1);
                tempStartHour = tempStartHour + ":00";
                tempEndHour = Integer.toString((tempEndtHourToMunite  / 60) + 1);
                tempEndHour = tempEndHour + ":30";
            }
        }
///
        String[] _tempSplitStartHour = tempStartHour.split(":");
        String[] _tempSplitEndHour = tempEndHour.split(":");

        int _tempStartHourToMunite = Integer.parseInt(_tempSplitStartHour[0]) * 60;
        int _tempEndtHourToMunite = Integer.parseInt(_tempSplitEndHour[0]) * 60;

        int _tempStartHourWithMuniteToMunite = _tempStartHourToMunite + Integer.parseInt(_tempSplitStartHour[1]) ;
        int _tempEndtHourWithMuniteToMunite = _tempEndtHourToMunite + Integer.parseInt(_tempSplitEndHour[1]) ;
        int counter = 0;
        for (int j = 0; j < appStartHours.size(); j++){
            String tempAppStartHour =  appStartHours.get(j).getAppHour();
            String tempAppEndHour =  appEndHours.get(j).getAppHour();
            String[] tempAppSplitStartHour = tempAppStartHour.split(":");
            String[] tempAppSplitEndHour = tempAppEndHour.split(":");
            int tempAppStartHourToMunite = Integer.parseInt(tempAppSplitStartHour[0]) * 60;
            int tempAppEndtHourToMunite = Integer.parseInt(tempAppSplitEndHour[0]) * 60;

            int tempAppStartHourWithMuniteToMunite = tempAppStartHourToMunite + Integer.parseInt(tempAppSplitStartHour[1]);
            int tempAppEndHourWithMuniteToMunite = tempAppEndtHourToMunite + Integer.parseInt(tempAppSplitEndHour[1]);

            if ((tempAppStartHourWithMuniteToMunite <= _tempStartHourWithMuniteToMunite
            && _tempStartHourWithMuniteToMunite < tempAppEndHourWithMuniteToMunite)
            || tempAppStartHourWithMuniteToMunite < _tempEndtHourWithMuniteToMunite
            && _tempEndtHourWithMuniteToMunite <= tempAppEndHourWithMuniteToMunite){
                counter++;
                continue;
            }
        }
        if(counter == 0 ){
                adjustedHours.add(tempStartHour + "-" + tempEndHour);
        }
///

}
    // Sort the adjusted hours in ascending order
    Helper.customSort(adjustedHours);

    // Generate JSON response
    StringBuilder jsonResponse = new StringBuilder("[");
    for (int i = 0; i < adjustedHours.size(); i++) {
        jsonResponse.append("{\"appHour\": \"").append(adjustedHours.get(i)).append("\"}");
        if (i < adjustedHours.size() - 1) {
            jsonResponse.append(",");
        }
    }
    jsonResponse.append("]");
    out.println(jsonResponse.toString());

} catch (Exception e) {
    // Handle exceptions appropriately (e.g., log the error, return an error JSON, etc.)
    out.println("[]"); // Return an empty JSON array as a response if an error occurs
}
%>
