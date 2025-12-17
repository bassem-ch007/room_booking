package com.roombooking.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class FileUtil {
    
    public static void createDirectoryIfNotExists(String directoryPath) throws IOException {
        Path path = Paths.get(directoryPath);
        if (!Files.exists(path)) {
            Files.createDirectories(path);
        }
    }
    
    public static boolean deleteFile(String filePath) {
        if (filePath == null || filePath.isEmpty()) {
            return false;
        }
        try {
            File file = new File(filePath);
            return file.exists() && file.delete();
        } catch (SecurityException e) {
            return false;
        }
    }
    
    public static String generateUniqueFileName(String prefix, String extension) {
        return prefix + "_" + System.currentTimeMillis() + "." + extension;
    }
}

