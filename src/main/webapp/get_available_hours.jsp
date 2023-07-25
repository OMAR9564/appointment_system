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

    // Assuming your MySQL query to get available hours based on selectedDate
    String query = "SELECT `hour` FROM `appointments` WHERE `date` = '"+selectedDate+"' ";
    ConSql conSql = new ConSql();
    ArrayList<GetInfo> availableHours = conSql.readHourData(query);

     out.println("[");
    for (int i = 0; i < availableHours.size(); i++) {
        out.println("{\"appHour\": \"" + availableHours.get(i).getAppHour() + "\"}");
        if (i < availableHours.size() - 1) {
            out.println(",");
        }
    }
    out.println("]");
%>

