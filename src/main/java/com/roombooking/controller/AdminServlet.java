package com.roombooking.controller;

import com.roombooking.entity.*;
import com.roombooking.exception.UserAlreadyExistsException;
import com.roombooking.exception.ValidationException;
import com.roombooking.service.ReservationService;
import com.roombooking.service.RoomService;
import com.roombooking.service.UserService;
import com.roombooking.util.FileUploadUtil;
import com.roombooking.util.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin/*"})
@MultipartConfig(maxFileSize = 10485760 )// 10MB
public class AdminServlet extends HttpServlet {

    private  UserService userService;
    private  RoomService roomService;
    private  ReservationService reservationService;
    private  FileUploadUtil fileUploadUtil;
    private static final int ITEMS_PER_PAGE_USERS = 15;
    private static final int ITEMS_PER_PAGE_ROOMS = 12;
    private static final int ITEMS_PER_PAGE_RESERVATIONS = 20;
    @Override
    public void init() throws ServletException {
        super.init();
        this.userService = new UserService();
        this.roomService = new RoomService();
        this.reservationService = new ReservationService();
        this.fileUploadUtil = new FileUploadUtil(getServletContext());
    }


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().toString().equals("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            showDashboard(request, response);
        } else if (pathInfo.equals("/users")) {
            showUsers(request, response);
        } else if (pathInfo.equals("/users/create")) {
            showCreateUser(request, response);
        } else if (pathInfo.startsWith("/users/edit/")) {
            String idStr = pathInfo.substring("/users/edit/".length());
            try {
                Long id = Long.parseLong(idStr);
                showEditUser(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.equals("/rooms/create")) {
            showCreateRoom(request, response);
        } else if (pathInfo.equals("/rooms")) {
            showRooms(request, response);
        }else if (pathInfo.startsWith("/rooms/edit/")) {
            String idStr = pathInfo.substring("/rooms/edit/".length());
            try {
                Long id = Long.parseLong(idStr);
                showEditRoom(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo.startsWith("/reservations")) {
                showReservations(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.getRole().toString().equals("ADMIN")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/users/create")) {
            createUser(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/users/update/")) {
            String idStr = pathInfo.substring("/users/update/".length());
            try {
                Long id = Long.parseLong(idStr);
                updateUser(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo != null && pathInfo.startsWith("/users/delete/")) {
            String idStr = pathInfo.substring("/users/delete/".length());
            try {
                Long id = Long.parseLong(idStr);
                deleteUser(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo != null && pathInfo.equals("/rooms/create")) {
            createRoom(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/rooms/update/")) {
            String idStr = pathInfo.substring("/rooms/update/".length());
            try {
                Long id = Long.parseLong(idStr);
                updateRoom(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo != null && pathInfo.startsWith("/rooms/delete/")) {
            String idStr = pathInfo.substring("/rooms/delete/".length());
            try {
                Long id = Long.parseLong(idStr);
                deleteRoom(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else if (pathInfo != null && pathInfo.startsWith("/reservations/cancel/")) {
            String idStr = pathInfo.substring("/reservations/cancel/".length());
            try {
                Long id = Long.parseLong(idStr);
                cancelReservation(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }else if (pathInfo != null && pathInfo.startsWith("/reservations/updateStatus/")) {
            String idStr = pathInfo.substring("/reservations/updateStatus/".length());
            try {
                Long id = Long.parseLong(idStr);
                updateReservationStatus(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        }  else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    // ==================== DASHBOARD & LISTING ====================
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userService.findAllByRole(UserRole.USER);
        List<Room> rooms = roomService.findAll();
        List<Reservation> reservations = reservationService.findAll();

        request.setAttribute("totalUsers", users.size());
        request.setAttribute("totalRooms", rooms.size());
        request.setAttribute("totalReservations", reservations.size());
        request.setAttribute("recentReservations",
            reservations.stream().limit(10).toList());

        request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
    }

    /**
     * ✅ REFACTORISÉ: Avec pagination
     */
    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> allUsers = userService.findAllByRole(UserRole.USER);

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {
            }
        }

        Page<User> page = userService.findUsersPaginated(allUsers, currentPage, ITEMS_PER_PAGE_USERS);

        request.setAttribute("page", page);
        request.setAttribute("users", page.getContent());
        request.setAttribute("currentPage", page.getCurrentPage());
        request.setAttribute("totalPages", page.getTotalPages());

        request.getRequestDispatcher("/jsp/admin/users.jsp").forward(request, response);
    }


    /**
     * ✅ REFACTORISÉ: Avec pagination
     */
    private void showRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> allRooms = roomService.findAll();

        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {
            }
        }

        Page<Room> page = roomService.findRoomsPaginated(allRooms, currentPage, ITEMS_PER_PAGE_ROOMS);

        request.setAttribute("page", page);
        request.setAttribute("rooms", page.getContent());
        request.setAttribute("currentPage", page.getCurrentPage());
        request.setAttribute("totalPages", page.getTotalPages());

        request.getRequestDispatcher("/jsp/admin/rooms.jsp").forward(request, response);
    }

    // ==================== USER MANAGEMENT ====================
    private void showCreateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("usern", null);
        request.getRequestDispatcher("/jsp/admin/userForm.jsp").forward(request, response);
    }

    private void showEditUser(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        User user = userService.findById(id).orElse(null);
        if (user == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("usern", user);
        request.getRequestDispatcher("/jsp/admin/userForm.jsp").forward(request, response);
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleStr = request.getParameter("role");

        try {
            UserRole role = roleStr != null ? UserRole.valueOf(roleStr) : UserRole.USER;
            userService.createUser(username, email, password, role);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (UserAlreadyExistsException | ValidationException e) {
            request.setAttribute("error", e.getMessage());
            showUsers(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleStr = request.getParameter("role");

        try {
            UserRole role = roleStr != null ? UserRole.valueOf(roleStr) : UserRole.USER;
            userService.updateUser(id, username, email, role, password);
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (UserAlreadyExistsException | ValidationException e) {
            request.setAttribute("error", e.getMessage());
            showEditUser(request, response, id);
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        try {
            userService.deleteUser(id);
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
    // ==================== ROOM MANAGEMENT ====================
    private void showCreateRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("room", null);
        request.getRequestDispatcher("/jsp/admin/roomForm.jsp").forward(request, response);
    }

    private void showEditRoom(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        Room room = roomService.findById(id).orElse(null);
        if (room == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("/jsp/admin/roomForm.jsp").forward(request, response);
    }

    private void createRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomTypeStr = request.getParameter("roomType");
        String name = request.getParameter("name");
        String capacityStr = request.getParameter("capacity");
        String sizeStr = request.getParameter("size");
        String location = request.getParameter("location");
        String pricingStr = request.getParameter("pricing");
        Part imagePart = request.getPart("image");

        String imagePath = null;

        // Gérer l'upload d'image
        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                // sauvegarder sans tempId
                imagePath = fileUploadUtil.saveRoomImage(
                        imagePart.getInputStream(),
                        imagePart.getSubmittedFileName()
                );
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Erreur upload image: " + e.getMessage());
                showCreateRoom(request, response);
                return;
            }
        }

        try {
            RoomType roomType = RoomType.valueOf(roomTypeStr);
            Integer capacity = Integer.parseInt(capacityStr);
            Double size = Double.parseDouble(sizeStr);
            BigDecimal pricing = new BigDecimal(pricingStr);


            // Créer la salle
            roomService.createRoom(roomType, name, capacity, size, location, pricing, imagePath);

            request.getSession().setAttribute("success", "Salle créée avec succès.");
            response.sendRedirect(request.getContextPath() + "/admin/rooms");

        } catch (ValidationException | IllegalArgumentException e) {
            System.out.println("Erreur création: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            showCreateRoom(request, response);
        }
    }



    private void updateRoom(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        System.out.println("=== UPDATE ROOM " + id + " ===");

        String roomTypeStr = request.getParameter("roomType");
        String name = request.getParameter("name");
        String capacityStr = request.getParameter("capacity");
        String sizeStr = request.getParameter("size");
        String location = request.getParameter("location");
        String pricingStr = request.getParameter("pricing");
        String statusStr = request.getParameter("status");
        String deleteImageStr = request.getParameter("deleteImage");
        Part imagePart = request.getPart("image");

        System.out.println("Params: " + name + ", " + capacityStr + ", " + location);
        System.out.println("Delete Image: " + deleteImageStr);
        System.out.println("Image Part: " + (imagePart != null ? imagePart.getSize() : "null"));

        try {
            Room room = roomService.findById(id)
                    .orElseThrow(() -> new ValidationException("Room not found"));

            RoomType roomType = RoomType.valueOf(roomTypeStr);
            Integer capacity = Integer.parseInt(capacityStr);
            Double size = Double.parseDouble(sizeStr);
            BigDecimal pricing = new BigDecimal(pricingStr);
            RoomStatus status = RoomStatus.valueOf(statusStr);

            String imagePath = null;

            // Supprimer l'ancienne image si demandé
            if ("true".equals(deleteImageStr) && room.getImagePath() != null) {
                try {
                    System.out.println("Suppression image: " + room.getImagePath());
                    fileUploadUtil.deleteRoomImage(room.getImagePath());
                    imagePath = null;
                } catch (Exception e) {
                    System.out.println("Erreur suppression: " + e.getMessage());
                    request.setAttribute("error", "Erreur suppression image: " + e.getMessage());
                    showEditRoom(request, response, id);
                    return;
                }
            }

            // Upload nouvelle image
            if (imagePart != null && imagePart.getSize() > 0) {
                try {
                    System.out.println("Upload nouvelle image: " + imagePart.getSubmittedFileName());
                    if (room.getImagePath() != null && !room.getImagePath().isEmpty()) {
                        try {
                            fileUploadUtil.deleteRoomImage(room.getImagePath());
                        } catch (Exception ignored) {}
                    }

                    imagePath = fileUploadUtil.saveRoomImage(
                            imagePart.getInputStream(),
                            imagePart.getSubmittedFileName()
                    );
                    System.out.println("Image sauvegardée: " + imagePath);
                } catch (Exception e) {
                    System.out.println("Erreur upload: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Erreur upload image: " + e.getMessage());
                    showEditRoom(request, response, id);
                    return;
                }
            }

            System.out.println("Mise à jour room avec imagePath: " + imagePath);
            roomService.updateRoom(id, roomType, name, capacity, size, location, pricing, imagePath, status);

            request.getSession().setAttribute("success", "Salle mise à jour avec succès.");
            response.sendRedirect(request.getContextPath() + "/admin/rooms");

        } catch (ValidationException | IllegalArgumentException e) {
            System.out.println("Erreur validation: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            showEditRoom(request, response, id);
        }
    }




    private void deleteRoom(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        try {
            roomService.deleteRoom(id);
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/rooms");
    }

    private void showReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer status (optionnel)
        String statusStr = request.getParameter("status");
        ReservationStatus status = null;
        if (statusStr != null && !statusStr.isEmpty()) {
            try {
                status = ReservationStatus.valueOf(statusStr);
            } catch (IllegalArgumentException ignored) {

            }
        }

        // Récupérer les réservations (filtrées par status ou toutes)
        List<Reservation> allReservations = reservationService.findByStatus(status);

        // Pagination
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {
            }
        }

        Page<Reservation> page = reservationService.findReservationsPaginated(
                allReservations, currentPage, ITEMS_PER_PAGE_RESERVATIONS);

        // setAttribute
        request.setAttribute("page", page);
        request.setAttribute("reservations", page.getContent());
        request.setAttribute("currentPage", page.getCurrentPage());
        request.setAttribute("totalPages", page.getTotalPages());
        request.setAttribute("selectedStatus", statusStr);

        request.getRequestDispatcher("/jsp/admin/reservations.jsp").forward(request, response);
    }
    private void updateReservationStatus(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        String statusStr = request.getParameter("status");

        try {
            ReservationStatus newStatus = ReservationStatus.valueOf(statusStr);
            reservationService.updateStatus(id, newStatus);
            request.setAttribute("success", "Statut de la réservation mis à jour avec succès.");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Statut invalide.");
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        }
        showReservations(request, response);
    }
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {

        try {
            reservationService.cancelReservation(id, null, true);
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/admin/reservations");
    }
}

