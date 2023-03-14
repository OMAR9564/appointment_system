<%-- 
    Document   : adminSqlCon
    Created on : Dec 22, 2022, 12:16:50 AM
    Author     : omerfaruk
--%>

<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="com.omar.hotelreservation.mySql"%>
<%@ page import="java.sql.ResultSet" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    if(((String)session.getAttribute("adminName")) == null){
        response.sendRedirect("../index.jsp");
    }else {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://app.sobiad.com:3306/grup9?useUnicode=true&characterEncoding=UTF-8&useSSL=false", "grup9", "9564");

        String _page = request.getParameter("iam");
        System.out.println(request.getParameter("iam") + "---------------------111");

        if (_page.equals("customerEdit")) {
            try {
                String id = request.getParameter("id");
                String name = new String(request.getParameter("name").getBytes("ISO-8859-9"), "UTF-8");
                String mail = request.getParameter("mail");
                String phone = request.getParameter("phone");

                String sqlQuery = "UPDATE `customer` SET `name`=?,`email`=?,`phone`=? WHERE `id` = ?";
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, name);
                ps.setString(2, mail);
                ps.setString(3, phone);
                ps.setString(4, id);
                ps.execute();
                session.setAttribute("adminAlertLog", "Müşteri başarılı bir şekilde düzenlendi.");
                session.setAttribute("adminShowAlert", "show");
                session.setAttribute("adminAlertOk", "success");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");

            } catch (Exception e) {
                System.out.println("Müşteri bilgileri düzllerken bir hata oluştur");
                System.out.println(e);
            }


            response.sendRedirect("pages-customers.jsp");

        }
        if (_page.equals("customerDelete")) {
            try {
                String id = request.getParameter("id");

                String sqlQuery = "DELETE FROM `customer` WHERE `id` = ?";
                mySql mysql = new mySql();
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, id);
                ps.execute();

                session.setAttribute("adminAlertLog", "Müşteri başarılı bir şekilde Silindi.");
                session.setAttribute("adminShowAlert", "show");
                session.setAttribute("adminAlertOk", "success");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");
                response.sendRedirect("pages-customers.jsp");

            } catch (Exception e) {
                session.setAttribute("adminAlertLog", "Üzgünüz bir hata oluştur. Müşteri Silinmedi.");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertOk", "danger");
                session.setAttribute("adminAlertIcon", "bi bi-exclamation-octagon me-1");
                response.sendRedirect("pages-customers.jsp");
            }


        }
        if (_page.equals("customerAdd")) {
            try {
                String name = new String(request.getParameter("name").getBytes("ISO-8859-9"), "UTF-8");
                String mail = request.getParameter("mail");
                String phone = request.getParameter("phone");
                String pass = request.getParameter("pass");

                String sqlQuery = "INSERT INTO `customer`(`name`, `email`, `phone`, `Pass`) VALUES (?,?,?,?)";
                mySql mysql = new mySql();
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, name);
                ps.setString(2, mail);
                ps.setString(3, phone);
                ps.setString(4, pass);
                ps.execute();

                session.setAttribute("adminAlertLog", "Müşteri başarılı bir şekilde Eklendi.");
                session.setAttribute("adminShowAlert", "show");
                session.setAttribute("adminAlertOk", "success");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");
                response.sendRedirect("pages-customers.jsp");

            } catch (Exception e) {
                session.setAttribute("adminAlertLog", "Üzgünüz bir hata oluştur. Müşteri Eklenmedi.");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertOk", "danger");
                session.setAttribute("adminAlertIcon", "bi bi-exclamation-octagon me-1");
                response.sendRedirect("pages-customers.jsp");
            }


        }
        if (_page.equals("reverasyonDelete")) {
            try {
                String id = request.getParameter("id");

                String sqlQuery = "DELETE FROM `reverasyonlar` WHERE `id` = ?";
                mySql mysql = new mySql();
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, id);
                ps.execute();

                session.setAttribute("adminAlertLog", "Reversayon başarılı bir şekilde Silindi.");
                session.setAttribute("adminShowAlert", "show");
                session.setAttribute("adminAlertOk", "success");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");
                response.sendRedirect("pages-reversayon.jsp");

            } catch (Exception e) {
                session.setAttribute("adminAlertLog", "Üzgünüz bir hata oluştur. Reverasyon Silinmedi.");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertOk", "danger");
                session.setAttribute("adminAlertIcon", "bi bi-exclamation-octagon me-1");
                response.sendRedirect("pages-reversayon.jsp");
            }


        }
         if (_page.equals("reverasionEdit")) {
            try {
                String id = request.getParameter("id");
                String name = new String(request.getParameter("name").getBytes("ISO-8859-9"), "UTF-8");
                String mail = request.getParameter("mail");
                String phone = request.getParameter("phone");
                String count = request.getParameter("count");
                String gTarihi = request.getParameter("gTarihi");
                String cTarihi = request.getParameter("cTarihi");
                String roomName = request.getParameter("roomName").trim();
                String status = request.getParameter("status");
                String gander = request.getParameter("statusGander");

                String sqlQuery = "UPDATE `reverasyonlar` SET `musteriAdi`=?,`kisiSayisi`=?,`girisTarihi`=?,`cikisTarihi`=?,`email`=?,`telefon`=?,`odaAdi`=?,`durum`=?,`cinsiyet`=? WHERE `id` =?";
                mySql mysql = new mySql();
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, name);
                ps.setString(2, count);
                ps.setString(3, gTarihi);
                ps.setString(4, cTarihi);
                ps.setString(5, mail);
                ps.setString(6, phone);
                ps.setString(7, roomName);
                ps.setString(8, status);
                ps.setString(9, gander);
                ps.setString(10, id);
                ps.execute();
                session.setAttribute("adminAlertLog", "Reversayon başarılı bir şekilde düzeldi.");
                session.setAttribute("adminShowAlert", "show");
                session.setAttribute("adminAlertOk", "success");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");
                response.sendRedirect("pages-reversayon.jsp");

            } catch (Exception e) {
                session.setAttribute("adminAlertLog", "Üzgünüz bir hata oluştur. Reversayon alınmadı.");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertOk", "danger");
                session.setAttribute("adminAlertIcon", "bi bi-exclamation-octagon me-1");
                response.sendRedirect("pages-reversayon.jsp");
                System.out.println(e);
            }


        }
        if (_page.equals("roomInsert")) {
            try {

//        FileInputStream fis=null;

                String id = request.getParameter("id");
                String name = new String(request.getParameter("roomName").getBytes("ISO-8859-9"), "UTF-8");
                String roomCount = request.getParameter("roomCount");
                String soldCount = request.getParameter("soldCount");
                String roomPrice = request.getParameter("roomPrice");
                String roomSalePrice = request.getParameter("roomSalePrice");
                String roomSaleActive = request.getParameter("roomSaleActive");
                String roomActive = request.getParameter("roomActive");
                String maxCustCount = request.getParameter("maxCust");
//        String roomImg = request.getParameter("uploadImg");

//        File image = new File();
//                InputStream in = new FileInputStream("/Users/omerfaruk/Desktop/omer.png");


                String sqlQuery = "INSERT INTO `room`( `name`, `price`, `soldCount`, `maxRoomCount`, `salePrice`, `avabilve`, `saleActive`, `maxCust`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                mySql mysql = new mySql();
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, name);
                ps.setString(2, roomPrice);
//                ps.setBinaryStream(3, in);
                ps.setString(3, soldCount);
                ps.setString(4, roomCount);
                ps.setString(5, roomSalePrice);
                ps.setString(6, roomActive);
                ps.setString(7, roomSaleActive);
                ps.setString(8, maxCustCount);
                ps.execute();

//PreparedStatement pstmt = null; 

//        FileInputStream fis=null;


//        File image= new File(img); 


//            Class.forName("com.mysql.jdbc.Driver");
//            Connection con = DriverManager.getConnection("jdbc:mysql://app.sobiad.com:3306/grup9?useUnicode=true&characterEncoding=UTF-8&useSSL=false", "grup9", "9564");
//            pstmt = con.prepareStatement("INSERT INTO `room`( `name`, `price`, `image`, `soldCount`, `maxRoomCount`, `salePrice`, `avabilve`, `saleActive`, `maxCust`) " + "values(?,?,?,?,?,?,?,?,?)");
//            pstmt.setString(1, name);             
//            pstmt.setString(2, roomPrice);
//            pstmt.setString(4, soldCount);
//            pstmt.setString(5, roomCount);
//            pstmt.setString(6, roomSalePrice);
//            pstmt.setString(7, roomActive);
//            pstmt.setString(8, roomSaleActive);
//            pstmt.setString(9, maxCustCount);
//            
//            
//            
//            fis=new FileInputStream(image); 
//            pstmt.setBinaryStream(3, (InputStream) fis, (int) (image.length())); 
//        
//            
//            		int count = pstmt.executeUpdate();
//                        if(count > 0){
//                        System.out.println("qqqqqqqq111qqqq1111");
//    }
                session.setAttribute("adminAlertLog", "Oda başarılı bir şekilde Kayıtedildi.");
                session.setAttribute("adminShowAlert", "show");
                session.setAttribute("adminAlertOk", "success");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");


                response.sendRedirect("pages-rooms.jsp");

            } catch (Exception e) {
                session.setAttribute("adminAlertLog", "Üzgünüz bir hata oluştur. Oda Kayıt edilmedi.");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertOk", "danger");
                session.setAttribute("adminAlertIcon", "bi bi-exclamation-octagon me-1");
                response.sendRedirect("pages-rooms.jsp");
                System.out.println(e);

            }

        }
        if (_page.equals("roomEdit")) {
            try {
                String id = request.getParameter("id");
                String img = request.getParameter("uploadImg");
                String name =  new String(request.getParameter("roomName").getBytes("ISO-8859-9"), "UTF-8");
                String roomCount = request.getParameter("roomCount");
                String soldCount = request.getParameter("soldCount");
                String roomPrice = request.getParameter("roomPrice");
                String roomSalePrice = request.getParameter("roomSalePrice");
                String roomSaleActive = request.getParameter("roomSaleActive");
                String roomActive = request.getParameter("roomActive");
                String maxCustCount = request.getParameter("maxCust");

                String sqlQuery = "UPDATE `room` SET `name`=?,`price`=?, `soldCount`=?,`maxRoomCount`=?,`salePrice`=?,`avabilve`=?,`saleActive`=?,`maxCust`=? WHERE `id` = ?";
                mySql mysql = new mySql();
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, name);
                ps.setString(2, roomPrice);
                ps.setString(3, soldCount);
                ps.setString(4, roomCount);
                ps.setString(5, roomSalePrice);
                ps.setString(6, roomActive);
                ps.setString(7, roomSaleActive);
                ps.setString(8, maxCustCount);
                ps.setString(9, id);


                ps.execute();

                session.setAttribute("adminAlertLog", "Oda başarılı bir şekilde güncellendi.");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertOk", "true");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");


                response.sendRedirect("pages-rooms.jsp");


            } catch (Exception e) {
                session.setAttribute("adminAlertLog", "Üzügünüz bir hata oluştu.Odaya düzelme işlemi olmadı!!");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertIcon", "bi bi-exclamation-octagon me-1");

                session.setAttribute("adminAlertOk", "false");
                response.sendRedirect("pages-rooms.jsp");

            }
        }
        if (_page.equals("roomDelete")) {
            try {
                String id = request.getParameter("id");
                String sqlQuery = "DELETE FROM `room` WHERE `id` = ?";
                mySql mysql = new mySql();
                PreparedStatement ps = con.prepareStatement(sqlQuery);
                ps.setString(1, id);
                ps.execute();

                session.setAttribute("adminAlertLog", "Oda başarılı bir şekilde silindi.");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertOk", "true");
                session.setAttribute("adminAlertIcon", "bi bi-check-circle me-1");

                response.sendRedirect("pages-rooms.jsp");
            } catch (Exception e) {
                session.setAttribute("adminAlertLog", "Üzügünüz bir hata oluştu.Odaya silme işlemi olmadı!!");
                session.setAttribute("adminShowAlert", "true");
                session.setAttribute("adminAlertIcon", "bi bi-exclamation-octagon me-1");
                System.out.println(e);
                session.setAttribute("adminAlertOk", "false");
                response.sendRedirect("pages-rooms.jsp");

            }


        }
    }
%>