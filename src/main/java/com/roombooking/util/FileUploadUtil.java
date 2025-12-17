package com.roombooking.util;

import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class FileUploadUtil {

    private final ServletContext servletContext;
    private static final String UPLOAD_DIR = "uploads/rooms";

    /**
     * Constructeur avec ServletContext
     */
    public FileUploadUtil(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    /**
     * Sauvegarde un fichier image
     */
    public String saveRoomImage(InputStream inputStream, String fileName) throws Exception {
        if (inputStream == null || fileName == null || fileName.isEmpty()) {
            throw new IllegalArgumentException("Invalid file upload");
        }

        String extension = getFileExtension(fileName);
        if (!isValidImageExtension(extension)) {
            throw new IllegalArgumentException("Uploaded file is not a valid image (jpg, png, gif, webp)");
        }

        // ✅ Obtenir le chemin réel de l'application
        String realPath = servletContext.getRealPath("/") + UPLOAD_DIR;
        File uploadDir = new File(realPath);

        System.out.println("UPLOAD_DIR réel: " + uploadDir.getAbsolutePath());

        if (!uploadDir.exists()) {
            System.out.println("Création du dossier: " + uploadDir.getAbsolutePath());
            if (!uploadDir.mkdirs()) {
                throw new IOException("Could not create upload directory: " + uploadDir.getAbsolutePath());
            }
        }

        // Générer un nom unique
        String uniqueFileName = System.currentTimeMillis() + extension;
        File file = new File(uploadDir, uniqueFileName);

        System.out.println("Sauvegarde du fichier: " + file.getAbsolutePath());

        // Écrire le fichier
        try (FileOutputStream fos = new FileOutputStream(file)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
        }

        System.out.println("Fichier sauvegardé avec succès: " + uniqueFileName);
        return uniqueFileName;
    }

    /**
     * Lit un fichier image
     */
    public FileInputStream readRoomImage(String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) {
            throw new IOException("Invalid image path");
        }

        String realPath = servletContext.getRealPath("/") + UPLOAD_DIR;
        File file = new File(realPath, fileName);

        if (!file.exists() || !file.isFile()) {
            throw new IOException("Image not found: " + file.getAbsolutePath());
        }

        return new FileInputStream(file);
    }

    /**
     * Supprime un fichier image
     */
    public boolean deleteRoomImage(String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) {
            return false;
        }

        String realPath = servletContext.getRealPath("/") + UPLOAD_DIR;
        File file = new File(realPath, fileName);

        if (file.exists()) {
            System.out.println("Suppression: " + file.getAbsolutePath());
            return file.delete();
        }
        return false;
    }

    // ==================== UTILITAIRES ====================

    private String getFileExtension(String fileName) {
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex > 0 && dotIndex < fileName.length() - 1) {
            return fileName.substring(dotIndex).toLowerCase();
        }
        return "";
    }

    private boolean isValidImageExtension(String extension) {
        return extension.matches("\\.(jpg|jpeg|png|gif|webp)$");
    }

    public String getMimeType(String fileName) {
        String extension = getFileExtension(fileName).toLowerCase();
        return switch (extension) {
            case ".jpg", ".jpeg" -> "image/jpeg";
            case ".png" -> "image/png";
            case ".gif" -> "image/gif";
            case ".webp" -> "image/webp";
            default -> "application/octet-stream";
        };
    }
}
