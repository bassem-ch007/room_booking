package com.roombooking.controller;

import com.roombooking.entity.Reservation;
import com.roombooking.exception.ReservationConflictException;
import com.roombooking.exception.ValidationException;
import com.roombooking.service.ReservationService;
import com.roombooking.util.DateTimeUtil;
import com.roombooking.util.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "ReservationServlet", urlPatterns = {"/reservations", "/reservations/*"})
public class ReservationServlet extends HttpServlet {
    
    private final ReservationService reservationService;
    private static final int ITEMS_PER_PAGE = 10;
    public ReservationServlet() {
        this.reservationService = new ReservationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Mes réservations
            showMyReservations(request, response);
        } else if (pathInfo.startsWith("/create")) {
            // Formulaire de création
            showCreateForm(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/create")) {
            createReservation(request, response);
        } else if (pathInfo != null && pathInfo.startsWith("/cancel/")) {
            String idStr = pathInfo.substring("/cancel/".length());
            try {
                Long id = Long.parseLong(idStr);
                cancelReservation(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * ✅ REFACTORISÉ: Avec pagination
     */
    private void showMyReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");

        // Récupérer toutes les réservations
        List<Reservation> allReservations = reservationService.findByUserId(userId);

        // Récupérer page actuelle
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {
            }
        }

        // Appliquer pagination
        Page<Reservation> page = reservationService.findReservationsPaginated(
                allReservations, currentPage, ITEMS_PER_PAGE);

        request.setAttribute("page", page);
        request.setAttribute("reservations", page.getContent());
        request.setAttribute("currentPage", page.getCurrentPage());
        request.setAttribute("totalPages", page.getTotalPages());
        request.setAttribute("totalReservations", page.getTotalItems());

        request.getRequestDispatcher("/jsp/reservations/myReservations.jsp").forward(request, response);
    }
    
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String roomIdStr = request.getParameter("roomId");
        request.setAttribute("roomId", roomIdStr);
        request.getRequestDispatcher("/jsp/reservations/create.jsp").forward(request, response);
    }
    
    private void createReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");
        
        String roomIdStr = request.getParameter("roomId");
        String startDateTimeStr = request.getParameter("startDateTime");
        String endDateTimeStr = request.getParameter("endDateTime");
        
        if (roomIdStr == null || startDateTimeStr == null || endDateTimeStr == null) {
            request.setAttribute("error", "Tous les champs sont obligatoires");
            request.setAttribute("roomId", roomIdStr);
            request.getRequestDispatcher("/jsp/reservations/create.jsp").forward(request, response);
            return;
        }
        
        try {
            Long roomId = Long.parseLong(roomIdStr);
            LocalDateTime startDateTime = DateTimeUtil.parseDateTime(startDateTimeStr);
            LocalDateTime endDateTime = DateTimeUtil.parseDateTime(endDateTimeStr);
            
            if (startDateTime == null || endDateTime == null) {
                request.setAttribute("error", "Format de date invalide");
                request.setAttribute("roomId", roomIdStr);
                request.getRequestDispatcher("/jsp/reservations/create.jsp").forward(request, response);
                return;
            }
            
            reservationService.createReservation(userId, roomId, startDateTime, endDateTime);
            response.sendRedirect(request.getContextPath() + "/reservations");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de salle invalide");
            request.setAttribute("roomId", roomIdStr);
            request.getRequestDispatcher("/jsp/reservations/create.jsp").forward(request, response);
        } catch (ReservationConflictException | ValidationException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("roomId", roomIdStr);
            request.getRequestDispatcher("/jsp/reservations/create.jsp").forward(request, response);
        }
    }
    
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Long userId = (Long) session.getAttribute("userId");
        
        try {
            reservationService.cancelReservation(id, userId, false);
            request.setAttribute("success", "Réservation annulée avec succès");
        } catch (ValidationException e) {
            request.setAttribute("error", e.getMessage());
        }
        
        showMyReservations(request, response);
    }
}

