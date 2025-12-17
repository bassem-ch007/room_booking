package com.roombooking.controller;

import com.roombooking.entity.Room;
import com.roombooking.entity.RoomType;
import com.roombooking.service.RoomService;
import com.roombooking.util.Page;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "RoomServlet", urlPatterns = {"/rooms", "/rooms/*"})
public class RoomServlet extends HttpServlet {
    
    private final RoomService roomService;
    private static final int ITEMS_PER_PAGE = 9;
    public RoomServlet() {
        this.roomService = new RoomService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            listAndFilterRooms(request, response);
        } else if (pathInfo.startsWith("/details/")) {
            // Détails d'une salle
            String idStr = pathInfo.substring("/details/".length());
            try {
                Long id = Long.parseLong(idStr);
                showRoomDetails(request, response, id);
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     *  REFACTORISÉ: Unifiée list + search + pagination
     */
    private void listAndFilterRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //  Récupérer filtres
        String roomTypeStr = request.getParameter("roomType");
        String minCapacityStr = request.getParameter("minCapacity");
        String minSizeStr = request.getParameter("minSize");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String location = request.getParameter("location");
        String startDateTimeStr = request.getParameter("startDateTime");
        String endDateTimeStr = request.getParameter("endDateTime");

        //  Convertir filtres
        RoomType roomType = null;
        if (roomTypeStr != null && !roomTypeStr.isEmpty()) {
            try {
                roomType = RoomType.valueOf(roomTypeStr);
            } catch (IllegalArgumentException e) {
                // Ignore
            }
        }

        Integer minCapacity = null;
        if (minCapacityStr != null && !minCapacityStr.isEmpty()) {
            try {
                minCapacity = Integer.parseInt(minCapacityStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        Double minSize = null;
        if (minSizeStr != null && !minSizeStr.isEmpty()) {
            try {
                minSize = Double.parseDouble(minSizeStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        BigDecimal minPrice = null;
        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            try {
                minPrice = new BigDecimal(minPriceStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        BigDecimal maxPrice = null;
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            try {
                maxPrice = new BigDecimal(maxPriceStr);
            } catch (NumberFormatException e) {
                // Ignore
            }
        }

        LocalDateTime startDateTime = null;
        if (startDateTimeStr != null && !startDateTimeStr.isEmpty()) {
            startDateTime = com.roombooking.util.DateTimeUtil.parseDateTime(startDateTimeStr);
        }

        LocalDateTime endDateTime = null;
        if (endDateTimeStr != null && !endDateTimeStr.isEmpty()) {
            endDateTime = com.roombooking.util.DateTimeUtil.parseDateTime(endDateTimeStr);
        }

        //  Déterminer si filtre appliqué
        boolean filterApplied = roomType != null || minCapacity != null || minSize != null ||
                minPrice != null || maxPrice != null || location != null ||
                startDateTime != null || endDateTime != null;

        //  Appeler service unifié
        List<Room> rooms = roomService.searchRooms(
                roomType, minCapacity, minSize, minPrice, maxPrice,
                location, startDateTime, endDateTime);

        //  Récupérer page actuelle
        int currentPage = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException ignored) {
            }
        }

        //  Appliquer pagination générique
        Page<Room> page = roomService.findRoomsPaginated(rooms, currentPage, ITEMS_PER_PAGE);

        // setAttribute
        request.setAttribute("page", page);
        request.setAttribute("rooms", page.getContent());
        request.setAttribute("currentPage", page.getCurrentPage());
        request.setAttribute("totalPages", page.getTotalPages());
        request.setAttribute("totalRooms", page.getTotalItems());
        request.setAttribute("filterApplied", filterApplied);

        // Repasser filtres pour pré-remplir form
        if (roomTypeStr != null) request.setAttribute("selectedRoomType", roomTypeStr);
        if (minCapacityStr != null) request.setAttribute("selectedMinCapacity", minCapacityStr);
        if (minSizeStr != null) request.setAttribute("selectedMinSize", minSizeStr);
        if (minPriceStr != null) request.setAttribute("selectedMinPrice", minPriceStr);
        if (maxPriceStr != null) request.setAttribute("selectedMaxPrice", maxPriceStr);
        if (location != null) request.setAttribute("selectedLocation", location);
        if (startDateTimeStr != null) request.setAttribute("selectedStartDateTime", startDateTimeStr);
        if (endDateTimeStr != null) request.setAttribute("selectedEndDateTime", endDateTimeStr);

        //  Forward UNE SEULE JSP
        request.getRequestDispatcher("/jsp/rooms/list.jsp").forward(request, response);
    }


    
    private void showRoomDetails(HttpServletRequest request, HttpServletResponse response, Long id)
            throws ServletException, IOException {
        
        Room room = roomService.findById(id).orElse(null);
        if (room == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("room", room);
        request.getRequestDispatcher("/jsp/rooms/details.jsp").forward(request, response);
    }
}

//private void listRooms(HttpServletRequest request, HttpServletResponse response)
//        throws ServletException, IOException {
//
//    List<Room> rooms = roomService.findActiveRooms();
//
//    request.setAttribute("rooms", rooms);
//    request.getRequestDispatcher("/jsp/rooms/list.jsp").forward(request, response);
//}
//
//private void searchRooms(HttpServletRequest request, HttpServletResponse response)
//        throws ServletException, IOException {
//
//    // Récupérer les paramètres de recherche
//    String roomTypeStr = request.getParameter("roomType");
//    String minCapacityStr = request.getParameter("minCapacity");
//    String minSizeStr = request.getParameter("minSize");
//    String minPriceStr = request.getParameter("minPrice");
//    String maxPriceStr = request.getParameter("maxPrice");
//    String location = request.getParameter("location");
//    String startDateTimeStr = request.getParameter("startDateTime");
//    String endDateTimeStr = request.getParameter("endDateTime");
//
//    RoomType roomType = null;
//    if (roomTypeStr != null && !roomTypeStr.isEmpty()) {
//        try {
//            roomType = RoomType.valueOf(roomTypeStr);
//        } catch (IllegalArgumentException e) {
//            // Ignore invalid enum value
//        }
//    }
//
//    Integer minCapacity = null;
//    if (minCapacityStr != null && !minCapacityStr.isEmpty()) {
//        try {
//            minCapacity = Integer.parseInt(minCapacityStr);
//        } catch (NumberFormatException e) {
//            // Ignore invalid number
//        }
//    }
//
//    Double minSize = null;
//    if (minSizeStr != null && !minSizeStr.isEmpty()) {
//        try {
//            minSize = Double.parseDouble(minSizeStr);
//        } catch (NumberFormatException e) {
//            // Ignore invalid number
//        }
//    }
//
//    BigDecimal minPrice = null;
//    if (minPriceStr != null && !minPriceStr.isEmpty()) {
//        try {
//            minPrice = new BigDecimal(minPriceStr);
//        } catch (NumberFormatException e) {
//            // Ignore invalid number
//        }
//    }
//
//    BigDecimal maxPrice = null;
//    if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
//        try {
//            maxPrice = new BigDecimal(maxPriceStr);
//        } catch (NumberFormatException e) {
//            // Ignore invalid number
//        }
//    }
//
//    LocalDateTime startDateTime = null;
//    if (startDateTimeStr != null && !startDateTimeStr.isEmpty()) {
//        startDateTime = com.roombooking.util.DateTimeUtil.parseDateTime(startDateTimeStr);
//    }
//
//    LocalDateTime endDateTime = null;
//    if (endDateTimeStr != null && !endDateTimeStr.isEmpty()) {
//        endDateTime = com.roombooking.util.DateTimeUtil.parseDateTime(endDateTimeStr);
//    }
//
//    List<Room> rooms = roomService.searchAdvanced(
//            roomType, minCapacity, minSize, minPrice, maxPrice,
//            location, startDateTime, endDateTime);
//
//
//    request.setAttribute("rooms", rooms);
//    request.setAttribute("searchPerformed", true);
//    request.getRequestDispatcher("/jsp/rooms/search.jsp").forward(request, response);
//}