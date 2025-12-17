package com.roombooking.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateTimeUtil {
    
    public static final DateTimeFormatter DATE_TIME_FORMATTER = 
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    
    public static final DateTimeFormatter DATE_FORMATTER = 
        DateTimeFormatter.ofPattern("yyyy-MM-dd");
    
    public static final DateTimeFormatter TIME_FORMATTER = 
        DateTimeFormatter.ofPattern("HH:mm");
    
    public static final DateTimeFormatter DISPLAY_FORMATTER = 
        DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    
    public static LocalDateTime parseDateTime(String dateTimeString) {
        if (dateTimeString == null || dateTimeString.isEmpty()) {
            return null;
        }
        try {
            return LocalDateTime.parse(dateTimeString, DATE_TIME_FORMATTER);
        } catch (Exception e) {
            return null;
        }
    }
    
    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(DISPLAY_FORMATTER);
    }
    
    public static boolean isPast(LocalDateTime dateTime) {
        return dateTime != null && dateTime.isBefore(LocalDateTime.now());
    }
    
    public static boolean isValidDateRange(LocalDateTime start, LocalDateTime end) {
        return start != null && end != null && start.isBefore(end);
    }
}

