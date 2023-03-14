package com.bya;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.CalendarScopes;
import com.google.api.services.calendar.model.*;
import java.io.IOException;
import java.io.InputStream;
import java.security.GeneralSecurityException;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;



public class CalendarService {

    private static final String APPLICATION_NAME = "Web client 1";
    private static final String TIMEZONE = "Europe/Istanbul";
    private static final int REMINDER_MINUTES = 30;
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final List<String> SCOPES = Collections.singletonList(CalendarScopes.CALENDAR);

    private static final String SERVICE_ACCOUNT_FILE_PATH = "/credentials.json";
    private static final String CREDENTIALS_FILE_PATH = "/credentials.json";
    String homeDirectory = System.getProperty("user.home");
    String TOKENS_DIRECTORY_PATH = homeDirectory + "/tokens";

    static int errorCount = 0;

    private static final NetHttpTransport HTTP_TRANSPORT;

    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
        } catch (GeneralSecurityException | IOException e) {
            errorCount += 1;
            throw new RuntimeException("Error initializing HTTP transport.", e);
        }
    }

    public Calendar getCalendarService() throws IOException {
        Credential credential = null;
        try {
            credential = authorize();
        } catch (GeneralSecurityException e) {
            errorCount += 1;
            throw new RuntimeException(e);
        }
        return new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }

    private GoogleCredential authorize() throws IOException, GeneralSecurityException {
        // Load service account credentials from a file or other source
        InputStream in = CalendarService.class.getResourceAsStream(SERVICE_ACCOUNT_FILE_PATH);
        GoogleCredential credentials = GoogleCredential.fromStream(in).createScoped(SCOPES);

        return credentials;
    }


    public List<CalendarListEntry> getCalendarList() throws IOException, GeneralSecurityException {
        CalendarList calendarList = getCalendarService().calendarList().list().execute();
        List<CalendarListEntry> items = calendarList.getItems();
        for (CalendarListEntry calendarListEntry : items) {
            System.out.println("Calendar Name: " + calendarListEntry.getSummary() + ", ID: " + calendarListEntry.getId());
        }
        return items;
    }

    public void createEvent(String title, String description, String location, String startDateTimeStr,
                            String endDateTimeStr) throws IOException, GeneralSecurityException {

        try {
            Event event = new Event()
                    .setSummary(title)
                    .setLocation(location)
                    .setDescription(description);

            DateTime startDateTime = new DateTime(startDateTimeStr);
            EventDateTime start = new EventDateTime()
                    .setDateTime(startDateTime)
                    .setTimeZone(TIMEZONE);
            event.setStart(start);

            DateTime endDateTime = new DateTime(endDateTimeStr);
            EventDateTime end = new EventDateTime()
                    .setDateTime(endDateTime)
                    .setTimeZone(TIMEZONE);
            event.setEnd(end);

            EventReminder[] reminderOverrides = new EventReminder[]{
                    new EventReminder().setMethod("email").setMinutes(REMINDER_MINUTES),
                    new EventReminder().setMethod("popup").setMinutes(REMINDER_MINUTES),
            };
            String CALENDAR_ID = "iroqeu1hcosib5emnd6u965tcs@group.calendar.google.com";

            Event.Reminders reminders = new Event.Reminders()
                    .setUseDefault(false)
                    .setOverrides(Arrays.asList(reminderOverrides));
            event.setReminders(reminders);
            event = getCalendarService().events().insert(CALENDAR_ID, event).execute();
            System.out.printf("Event created: %s\n", event.getHtmlLink());
        }catch (Exception e){
            errorCount += 1;
            System.out.println("------>" + e);
        }
    }

    public int getErrorCount(){
        return errorCount;
    }
}

