<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.api.client.auth.oauth2.Credential" %>
<%@ page import="com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp" %>
<%@ page import="com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver" %>
<%@ page import="com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow" %>
<%@ page import="com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets" %>
<%@ page import="com.google.api.client.googleapis.javanet.GoogleNetHttpTransport" %>
<%@ page import="com.google.api.client.http.javanet.NetHttpTransport" %>
<%@ page import="com.google.api.client.json.JsonFactory" %>
<%@ page import="com.google.api.client.json.jackson2.JacksonFactory" %>
<%@ page import="com.google.api.client.util.DateTime" %>
<%@ page import="com.google.api.client.util.store.FileDataStoreFactory" %>
<%@ page import="com.google.api.services.calendar.Calendar" %>
<%@ page import="com.google.api.services.calendar.CalendarScopes" %>
<%@ page import="com.google.api.services.calendar.model.Event" %>
<%@ page import="com.google.api.services.calendar.model.EventDateTime" %>

<%
    final String APPLICATION_NAME = "My Calendar App";
    final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    final String CREDENTIALS_FILE_PATH = "/Credential.json";
    final List<String> SCOPES = Arrays.asList(CalendarScopes.CALENDAR);
    final String TIME_ZONE = "GMT+02:00"; // değiştirmeniz gerekebilir
    final String TOKENS_DIRECTORY_PATH = "tokens";

    try {
      // HTTP istekleri için NetHttpTransport nesnesi oluştur
      final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
      // Kimlik doğrulama için Credential nesnesi oluştur
      Credential credential = getCredentials(HTTP_TRANSPORT);
      // Calendar servis nesnesi oluştur
      Calendar service = new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
              .setApplicationName(APPLICATION_NAME)
              .build();

      // Etkinlik oluşturma
      Event event = new Event()
              .setSummary("Örnek Etkinlik")
              .setLocation("İstanbul, Türkiye")
              .setDescription("Bu bir örnek etkinliktir.");

      DateTime startDateTime = new DateTime("2023-03-11T10:00:00" + TIME_ZONE);
      EventDateTime start = new EventDateTime()
              .setDateTime(startDateTime)
              .setTimeZone(TIME_ZONE);
      event.setStart(start);

      DateTime endDateTime = new DateTime("2023-03-11T11:00:00" + TIME_ZONE);
      EventDateTime end = new EventDateTime()
              .setDateTime(endDateTime)
              .setTimeZone(TIME_ZONE);
      event.setEnd(end);

      // Etkinliği kaydet
      String calendarId = "primary"; // varsayılan takvim
      event = service.events().insert(calendarId, event).execute();
      out.printf("Etkinlik oluşturuldu: %s\n", event.getHtmlLink());
