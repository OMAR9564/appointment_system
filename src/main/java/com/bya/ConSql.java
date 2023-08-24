package com.bya;

import java.sql.*;
import java.util.ArrayList;

public class ConSql {

    public void insertData(String name, String surname, String phone,
                           String doktorName, String appLocation,
                           String tempId, String appDate, String appStartHour,
                           String appEndHour, String intervalType, String eventID) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");

            conn = getDatabaseConnection(); // veritabanı bağlantısı oluşturma metodu


            String sql = "INSERT INTO `appointments`(`name`, `surname`, `phone`, `doctorId`, `locationId`, `tempId`, `date`, `startHour`, `EndHour`, `intervalId`, `eventID`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, name);
            pstmt.setString(2, surname);
            pstmt.setString(3, phone);
            pstmt.setString(4, doktorName);
            pstmt.setString(5, appLocation);
            pstmt.setString(6, tempId);
            pstmt.setString(7, appDate);
            pstmt.setString(8, appStartHour);
            pstmt.setString(9, appEndHour);
            pstmt.setString(10, intervalType);
            pstmt.setString(11, eventID);


            pstmt.executeUpdate();


        }

        catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException(e);

        } finally {
            try {
                if (pstmt != null) {
                    pstmt.close();
                }

                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void executeQuery(String query, String... params){
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);

            for (int i = 0; i < params.length; i++){
                stmt.setString(i+1, params[i]);
            }

            stmt.executeUpdate();

            conn.close();
        }catch (SQLException e){
            System.err.println(e);
        }
    }
    public ArrayList<GetInfo> readData(String query) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setCustNameSurname(rs.getString("name"));
                temp.setAppHour(rs.getString("startHour"));
                temp.setCustPhone(rs.getString("phone"));
                temp.setAppLocation(rs.getString("locationId"));
                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    public ArrayList<GetInfo> readHourData(String query, String date) throws SQLException {
//        sqlQuery = SELECT `hour` FROM `appointments` WHERE `date`= "2023-03-17";
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            stmt.setString(1, date);

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setAppHour(rs.getString(1));
                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    private Connection getDatabaseConnection() {
        // bağlantı bilgileri
        String url = "jdbc:mysql://localhost:3306/appointment_system";
        String username = "root";
        String password = "";
        Connection conn = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");

            conn = DriverManager.getConnection(url, username, password);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException(e);

        }

        return conn;
    }
    public ArrayList<GetInfo> getAppointmentData(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            for (int i = 0; i < params.length; i++){
                stmt.setString(i+1, params[i]);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setId(rs.getInt("id"));
                temp.setCustName(rs.getString("name"));
                temp.setCustSurname(rs.getString("surname"));
                temp.setCustNameSurname(temp.getCustName() + " " + temp.getCustSurname());
                temp.setCustPhone(rs.getString("phone"));
                temp.setDoctorName(rs.getString("doctorId"));
                temp.setAppLocation(rs.getString("locationId"));
                temp.setAppDate(rs.getString("date"));
                temp.setAppStartHour(rs.getString("startHour"));
                temp.setAppEndHour(rs.getString("endHour"));
                temp.setRezervationInterval(rs.getString("intervalId"));


                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    public ArrayList<GetInfo> getInfos(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            if(params.length != 0){
                stmt.setString(1, params[0]);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setId(rs.getInt("id"));
                temp.setName(rs.getString("name"));

                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    //
    public ArrayList<GetInfo> getRezervationInfos(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            if(params.length != 0){
                stmt.setString(1, params[0]);
            }
            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setId(rs.getInt("id"));
                temp.setRezervationName(rs.getString("name"));
                temp.setRezervationInterval(rs.getString("hourInterval"));
                temp.setRezervationNameTag(rs.getString("tagName"));


                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    public ArrayList<GetInfo> getOpeningClosingHours(String query) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setOpeningHour(rs.getString("openingHour"));
                temp.setClosingHour(rs.getString("closingHour"));

                sqlInfo.add(temp);
            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    public ArrayList<GetInfo> getSettingName(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            if(params.length != 0){
                stmt.setString(1, params[0]);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setName(rs.getString(1));
                sqlInfo.add(temp);
            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    public ArrayList<GetInfo> getDailyOpeningClosingHours(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            if(params.length != 0){
                stmt.setString(1, params[0]);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setOpeningHour(rs.getString("openingHour"));
                temp.setClosingHour(rs.getString("closingHour"));

                sqlInfo.add(temp);
            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    public ArrayList<GetInfo> getSettings(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            if(params.length != 0){
                stmt.setString(1, params[0]);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setId(rs.getInt("id"));
                temp.setCompanyName(rs.getString("companyName"));
                temp.setOpeningHour(rs.getString("openingHour"));
                temp.setClosingHour(rs.getString("closingHour"));
                temp.setAppointMessageBody(rs.getString("appointMessageBody"));
                temp.setAppointMessageTitle(rs.getString("appointMessageTitle"));
                temp.setHoliday(rs.getString("holiday"));
                temp.setCalendarId(rs.getString("calendarID"));




                sqlInfo.add(temp);
            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }

    public ArrayList<GetInfo> getDailyOCHour(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            if(params.length != 0){
                stmt.setString(1, params[0]);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setId(rs.getInt("id"));
                temp.setDay(rs.getString("day"));
                temp.setOpeningHour(rs.getString("openingHour"));
                temp.setClosingHour(rs.getString("closingHour"));



                sqlInfo.add(temp);
            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }
    public ArrayList<GetInfo> getUserInfos(String query, String... params) throws SQLException {
        ArrayList<GetInfo> sqlInfo = new ArrayList<>();
        try {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            conn = getDatabaseConnection();

            stmt = conn.prepareStatement(query);
            for (int i = 0; i < params.length; i++){
                stmt.setString(i+1, params[i]);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                GetInfo temp = new GetInfo();
                temp.setId(rs.getInt("id"));
                temp.setName(rs.getString("name"));
                temp.setSurname(rs.getString("surname"));
                temp.setUserName(rs.getString("username"));
                temp.setEmail(rs.getString("email"));
                temp.setPass(rs.getString("pass"));

                sqlInfo.add(temp);
            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);

        }
        return sqlInfo;
    }

}
