<%--
  Created by IntelliJ IDEA.
  User: omerfaruk
  Date: 25.07.2023
  Time: 18:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bya.ConSql" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.IOException" %>
<%@ page import="com.bya.GetInfo" %>
<%@ page import="java.util.List" %>
<%
    String selectedDate = request.getParameter("selectedDate");
    String selectedOption = request.getParameter("selectedOption");

    // Assuming your MySQL query to get available hours based on selectedDate
    String query = "SELECT ah.hour\n" +
                    "FROM availableHours AS ah\n" +
                    "LEFT JOIN appointments AS a \n" +
                    "ON ah.hour = a.hour AND a.date = '"+selectedDate+"'\n" +
                    "WHERE ah.type = '"+selectedOption+"' AND a.hour IS NULL;\n";
    ConSql conSql = new ConSql();
    ArrayList<GetInfo> availableHours = conSql.readHourData(query);


    String[] omer = null;

     out.println("[");
    for (int i = 0; i < availableHours.size(); i++) {
        String hour =  availableHours.get(i).getAppHour();
        // get hours from appiontments table



            out.println("{\"appHour\": \"" + hour + "\"}");
            if (i < availableHours.size() - 1) {
                out.println(",");
            }




    }
    out.println("]");
%>

