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
    String appHoursQuery = "SELECT hour FROM appointments WHERE date = '" + selectedDate + "'";
    String allHoursQuery = "SELECT hour FROM availableHours WHERE type = '" + selectedOption + "'";

    ConSql conSql = new ConSql();
    ArrayList<GetInfo> allHours = conSql.readHourData(allHoursQuery);
    ArrayList<GetInfo> appHours = conSql.readHourData(appHoursQuery);

    List<String> availableHours = new ArrayList<>();
    for (GetInfo allHour : allHours) {
        String allTemp = allHour.getAppHour();
        boolean isAvailable = true;

        for (GetInfo appHour : appHours) {
            String appTemp = appHour.getAppHour();

            String[] splitTemp = allTemp.split("-");
            String[] splitAppTemp = appTemp.split("-");

            String startAll = splitTemp[0];
            String endAll = splitTemp[1];
            String startApp = splitAppTemp[0];
            String endApp = splitAppTemp[1];

            // Check for overlapping time slots
            if ((startAll.compareTo(startApp) >= 0 && startAll.compareTo(endApp) < 0)
                || (endAll.compareTo(startApp) > 0 && endAll.compareTo(endApp) <= 0)) {
                isAvailable = false;
                break;
            }
        }

        if (isAvailable) {
            availableHours.add(allTemp);
        }
    }

    // Calculate the working hours
    String openingHour = "9"; // Opening hour is 9:00
    String closingHour = "18"; // Closing hour is 18:00

    // Convert the working hours to minutes for easier manipulation
    int openingMinutes = Integer.parseInt(openingHour) * 60;
    int closingMinutes = Integer.parseInt(closingHour) * 60;

    List<String> adjustedHours = new ArrayList<>();
    for (String hour : availableHours) {
        String[] splitHour = hour.split("-");
        String startHour = splitHour[0];
        String endHour = splitHour[1];

        int startMinutes = Integer.parseInt(startHour.split(":")[0]) * 60 + Integer.parseInt(startHour.split(":")[1]);
        int endMinutes = Integer.parseInt(endHour.split(":")[0]) * 60 + Integer.parseInt(endHour.split(":")[1]);

        // Adjust the time slot if there's a 30-minute gap
        if (endMinutes - startMinutes == 30) {
            endMinutes += 30;
            endHour = String.format("%02d:%02d", endMinutes / 60, endMinutes % 60);
        }

        // Add the adjusted time slot to the list
        adjustedHours.add(startHour + "-" + endHour);
    }
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
