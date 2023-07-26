<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bya.ConSql" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.IOException" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.List" %>
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
        boolean found = false;

        for (GetInfo appHour : appHours) {
            String appTemp = appHour.getAppHour();

            String[] splitTemp = allTemp.split("-");
            String[] splitAppTemp = appTemp.split("-");

            if (splitTemp[0].equals(splitAppTemp[0])) {
                found = true;
                break;
            }
        }

        if (!found) {
            availableHours.add(allTemp);
        }
    }

    // Generate JSON response
    StringBuilder jsonResponse = new StringBuilder("[");
    for (int i = 0; i < availableHours.size(); i++) {
        jsonResponse.append("{\"appHour\": \"").append(availableHours.get(i)).append("\"}");
        if (i < availableHours.size() - 1) {
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
