package com.bya;

import java.sql.*;
import java.util.ArrayList;

public class ConSql {

    public void insertData(String name, String surname, String phone,
                           String doktorName, String appLocation,
                           String tempId, String appDate, String appHour) {
        String nameSurname = null;
        nameSurname = name + " " + surname;

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.jdbc.Driver");

            conn = getDatabaseConnection(); // veritabanı bağlantısı oluşturma metodu

            String sql = "INSERT INTO `appointments`(`nameSurname`, `phone`, `doctorName`, `location`, `tempId`, `date`, `hour`) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, nameSurname);
            pstmt.setString(2, phone);
            pstmt.setString(3, doktorName);
            pstmt.setString(4, appLocation);
            pstmt.setString(5, tempId);
            pstmt.setString(6, appDate);
            pstmt.setString(7, appHour);


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
    public void executeUpdate(String query) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        conn = getDatabaseConnection(); // veritabanı bağlantısı oluşturma metodu


        pstmt = conn.prepareStatement(query);
        pstmt.executeUpdate();
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
                temp.setCustNameSurname(rs.getString("nameSurname"));
                temp.setAppHour(rs.getString("hour"));
                temp.setCustPhone(rs.getString("phone"));
                temp.setAppLocation(rs.getString("location"));
                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }


    public ArrayList<GetInfo> readHourData(String query) throws SQLException {
//        sqlQuery = SELECT `hour` FROM `appointments` WHERE `date`= "2023-03-17";
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
                temp.setAppHour(rs.getString(1));
                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }


    // veritabanı bağlantısı oluşturma metodu
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

    public ArrayList<GetInfo> getAppointmentData(String query) throws SQLException {
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
                temp.setCustId(rs.getInt("id"));
                temp.setCustNameSurname(rs.getString("nameSurname"));
                temp.setCustPhone(rs.getString("phone"));
                temp.setDoctorName(rs.getString("doctorName"));
                temp.setAppLocation(rs.getString("location"));
                temp.setAppDate(rs.getString("date"));
                temp.setAppHour(rs.getString("hour"));

                sqlInfo.add(temp);

            }
            conn.close();
        }catch (Exception e){
            System.err.println(e);
        }
        return sqlInfo;
    }

}
