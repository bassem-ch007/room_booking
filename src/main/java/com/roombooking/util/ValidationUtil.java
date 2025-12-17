package com.roombooking.util;

import java.util.Arrays;
import java.util.List;

public class ValidationUtil {
    
    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = 
        Arrays.asList("jpg", "jpeg", "png", "webp");
    
    private static final List<String> ALLOWED_MIME_TYPES = 
        Arrays.asList("image/jpeg", "image/png", "image/webp");
    
    public static boolean isValidImageExtension(String extension) {
        if (extension == null) {
            return false;
        }
        return ALLOWED_IMAGE_EXTENSIONS.contains(extension.toLowerCase());
    }
    
    public static boolean isValidImageMimeType(String mimeType) {
        if (mimeType == null) {
            return false;
        }
        return ALLOWED_MIME_TYPES.contains(mimeType.toLowerCase());
    }
    
    public static boolean isValidFileSize(long fileSize, long maxSize) {
        return fileSize > 0 && fileSize <= maxSize;
    }
    
    public static String extractFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDot = fileName.lastIndexOf(".");
        if (lastDot == -1 || lastDot == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(lastDot + 1).toLowerCase();
    }
}

