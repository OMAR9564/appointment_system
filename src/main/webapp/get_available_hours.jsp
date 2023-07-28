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

    // Assuming your MySQL query to get available hours based on selectedDate
    String appStartHoursQuery = "SELECT startHour FROM appointments WHERE date = '" + selectedDate + "'";
    String appEndtHoursQuery = "SELECT endHour FROM appointments WHERE date = '" + selectedDate + "'";

    //String allHoursQuery = "SELECT hour FROM availableHours WHERE type = '" + selectedOption + "'";

    ConSql conSql = new ConSql();
    //ArrayList<GetInfo> allHours = conSql.readHourData(allHoursQuery);
    ArrayList<GetInfo> appStartHours = conSql.readHourData(appStartHoursQuery);
    ArrayList<GetInfo> appEndHours = conSql.readHourData(appEndtHoursQuery);



     // Calculate the working hours
    String openingHour = "9"; // Opening hour is 9:00
    String closingHour = "18"; // Closing hour is 18:00
    String openingMunite = "00";
    String closingMunite = "00";

    // Convert the working hours to minutes for easier manipulation
    int openingMinutes = Integer.parseInt(openingHour) * 60;
    int closingMinutes = Integer.parseInt(closingHour) * 60;

    int startHourGlobal = openingMinutes;
    int endHourGlobal = closingMinutes;

    int addMunites = 0;

    int avalibaleHourCount = (closingMinutes - openingMinutes) / 60;



    double finalStartHour = 0.0;
    double finalEndHour = 0.0;

    List<String> adjustedHours = new ArrayList<>();

/*    if (selectedOption.equals("single")){
        addMunites = 60;
    }else if (selectedOption.equals("couple")){
        addMunites = 90;
    }*/

    /*if (Integer.parseInt(openingHour) <= 9){
        openingHour = "0" + openingHour;
    }*/
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


        for (int j = 0; j < appStartHours.size(); j++){
            String tempAppStartHour =  appStartHours.get(j).getAppHour();
            String tempAppEndHour =  appEndHours.get(j).getAppHour();
            String[] tempAppSplitStartHour = tempAppStartHour.split(":");
            String[] tempAppSplitEndHour = tempAppEndHour.split(":");
            int tempAppStartHourToMunite = Integer.parseInt(tempAppSplitStartHour[0]) * 60;
            int tempAppEndtHourToMunite = Integer.parseInt(tempAppSplitEndHour[0]) * 60;

            int tempAppStartHourWithMuniteToMunite = tempAppStartHourToMunite + Integer.parseInt(tempAppSplitStartHour[1]);
            int tempAppEndHourWithMuniteToMunite = tempAppEndtHourToMunite + Integer.parseInt(tempAppSplitEndHour[1]);

            // app          / normal
            // 1020 - 1080 / 990 - 1080
            //1050 <= 990 && 990 < 1080
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
            //1050 <= 1080 && 1080 < 1080
            if (tempAppStartHourWithMuniteToMunite <= tempEndtHourWithMuniteToMunite + 30
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
        if (tempEndtHourToMunite >= closingMinutes) {
            break;
        }
        if(i == 0 && ((Integer.parseInt(tempEndHour.split(":")[1]) != 30) || (Integer.parseInt(tempEndHour.split(":")[1]) == 30))  ){
                if (Integer.parseInt(tempStartHour.split(":")[0]) <= 9){
                tempStartHour = "0" + tempStartHour;
                }
                if (Integer.parseInt(tempEndHour.split(":")[0]) <= 9){
                    tempEndHour = "0" + tempEndHour;
                }
                adjustedHours.add(tempStartHour + "-" + tempEndHour);
                continue;
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
        
            adjustedHours.add(tempStartHour + "-" + tempEndHour);

}
    // Add the adjusted time slot to the list

    Helper.customSort(adjustedHours);
    // Sort the adjusted hours in ascending order

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