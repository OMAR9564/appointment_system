/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.bya;
import java.io.IOException;
import java.io.InputStream;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.PasswordAuthentication;
/**
 *
 * @author omerfaruk
 */
public class SendMail {
    public static String mailInfo(String messageText, String to) throws IOException {
    String from = "mysite9564@gmail.com";
    
    Properties properties = new Properties();

    InputStream inputStream = SendMail.class.getClassLoader().getResourceAsStream("config.properties");
    properties.load(inputStream);


    final String username = "mysite9564@gmail.com";
    final String password = properties.getProperty("send.key");
    
    String reddirectURL = "index.jsp";
    
    String host = "smtp.gmail.com";
//    System.setProperty("https.protocols", "TLSv1.2");

    Properties props = new Properties();
    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.socketFactory.port", "587");
    props.put("mail.smtp.starttls.enable", "true"); // STARTTLS isteği göndermek için ekledik.
    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    props.put("mail.smtp.starttls.required", "true");
    props.put("mail.smtp.ssl.protocols", "TLSv1.2");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.port", "587");

    Session session1 = Session.getDefaultInstance(props, new Authenticator() {
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(username, password);
        }
    });
    try{
        Message message = new MimeMessage(session1);
        message.setFrom(new InternetAddress(from));
        message.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
        message.setSubject("Sifre");
        message.setText(messageText);
        Transport.send(message);
                
        
    }
    catch(Exception e){
        System.out.println(e);
        return e.toString();
    }
    
    return "okBYA";
}
   


}