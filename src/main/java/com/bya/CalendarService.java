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
            throw new RuntimeException("Error initializing HTTP transport.", e);
        }
    }



    public Calendar getCalendarService() throws IOException, GeneralSecurityException {
        Credential credential = authorize();
        return new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }

    private GoogleCredential authorize() throws IOException, GeneralSecurityException {
        InputStream in = CalendarService.class.getResourceAsStream(SERVICE_ACCOUNT_FILE_PATH);
        GoogleCredential credentials = GoogleCredential.fromStream(in).createScoped(SCOPES);

        return credentials;
    }

    public List<CalendarListEntry> getCalendarList() throws IOException, GeneralSecurityException {
        try {
            CalendarList calendarList = getCalendarService().calendarList().list().execute();
            List<CalendarListEntry> items = calendarList.getItems();
            for (CalendarListEntry calendarListEntry : items) {
                System.out.println("Calendar Name: " + calendarListEntry.getSummary() + ", ID: " + calendarListEntry.getId());
            }
            return items;
        } catch (IOException | GeneralSecurityException e) {
            errorCount += 1;

            throw e;
        }
    }

    public String createEvent(String title, String description, String location, String startDateTimeStr,
                            String endDateTimeStr) throws IOException, GeneralSecurityException {
        String eventId = null;
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
            System.out.printf("Event created: %s\n Event ID: %s\n", event.getHtmlLink(), event.getId());
            eventId = event.getId();
        } catch (IOException | GeneralSecurityException e) {
            errorCount += 1;
            System.err.println(e);
            eventId = "Error - " + e.toString();
        }
        return eventId;
    }
    public void resetErrorCount(){
        errorCount = 0;
    }
    public int getErrorCount() {
        System.out.println("Hata Sayisi: " + errorCount);
        return errorCount;
    }

    public void updateEvent(String eventId, String newTitle, String newDescription,
                            String newLocation, String newStartDateTimeStr,
                            String newEndDateTimeStr) throws IOException, GeneralSecurityException {
        try {
            String CALENDAR_ID = "iroqeu1hcosib5emnd6u965tcs@group.calendar.google.com";

            Event event = getCalendarService().events().get(CALENDAR_ID, eventId).execute();

            // Update event properties
            event.setSummary(newTitle);
            event.setLocation(newLocation);
            event.setDescription(newDescription);

            DateTime newStartDateTime = new DateTime(newStartDateTimeStr);
            EventDateTime newStart = new EventDateTime()
                    .setDateTime(newStartDateTime)
                    .setTimeZone(TIMEZONE);
            event.setStart(newStart);

            DateTime newEndDateTime = new DateTime(newEndDateTimeStr);
            EventDateTime newEnd = new EventDateTime()
                    .setDateTime(newEndDateTime)
                    .setTimeZone(TIMEZONE);
            event.setEnd(newEnd);

            // Update the event in the calendar
            Event updatedEvent = getCalendarService().events().update(CALENDAR_ID, eventId, event).execute();
            System.out.printf("Event updated: %s\n", updatedEvent.getHtmlLink());
        } catch (IOException | GeneralSecurityException e) {
            errorCount += 1;
            System.err.println(e);
        }
    }


}

