package com.roombooking.service;

import com.roombooking.dao.RoomDao;
import com.roombooking.dao.ReservationDao;
import com.roombooking.entity.ReservationStatus;
import com.roombooking.entity.Room;
import com.roombooking.entity.RoomStatus;
import com.roombooking.entity.RoomType;
import com.roombooking.exception.ValidationException;
import com.roombooking.util.Page;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class RoomService {

    private final RoomDao roomDao;
    private final ReservationDao reservationDao;

    public RoomService() {
        this.roomDao = new RoomDao();
        this.reservationDao = new ReservationDao();
    }

    public Optional<Room> findById(Long id) {
        return roomDao.findById(id);
    }

    public List<Room> findAll() {
        return roomDao.findAll();
    }

    public List<Room> findActiveRooms() {
        return roomDao.findByStatus(RoomStatus.ACTIVE);
    }
    public List<Room> searchRooms(
            RoomType roomType,
            Integer minCapacity,
            Double minSize,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            String location,
            LocalDateTime startDateTime,
            LocalDateTime endDateTime) {

        boolean hasFilter = roomType != null || minCapacity != null || minSize != null ||
                minPrice != null || maxPrice != null || location != null ||
                startDateTime != null || endDateTime != null;

        if (!hasFilter) {
            return findActiveRooms();
        }

        return roomDao.searchAdvanced(
                roomType, minCapacity, minSize, minPrice, maxPrice,
                location, startDateTime, endDateTime);
    }

    /**
     * ✅ NOUVEAU: Pagination générique
     * USAGE: Page<Room> page = service.findRoomsPaginated(allRooms, 1, 9);
     */
    public Page<Room> findRoomsPaginated(List<Room> rooms, int currentPage, int itemsPerPage) {
        return Page.of(rooms, currentPage, itemsPerPage);
    }
    public List<Room> searchAdvanced(
            RoomType roomType,
            Integer minCapacity,
            Double minSize,
            BigDecimal minPrice,
            BigDecimal maxPrice,
            String location,
            LocalDateTime startDateTime,
            LocalDateTime endDateTime) {

        return roomDao.searchAdvanced(
            roomType, minCapacity, minSize, minPrice, maxPrice,
            location, startDateTime, endDateTime);
    }

    public void createRoom(
            RoomType roomType,
            String name,
            Integer capacity,
            Double size,
            String location,
            BigDecimal pricing,
            String imagePath) throws ValidationException {

        // Validation
        if (name == null || name.trim().isEmpty()) {
            throw new ValidationException("Le nom de la salle est obligatoire");
        }

        if (capacity == null || capacity < 1) {
            throw new ValidationException("La capacité doit être au moins 1");
        }

        if (size == null || size <= 0) {
            throw new ValidationException("La taille doit être positive");
        }

        if (location == null || location.trim().isEmpty()) {
            throw new ValidationException("La localisation est obligatoire");
        }

        if (pricing == null || pricing.compareTo(BigDecimal.ZERO) < 0) {
            throw new ValidationException("Le prix doit être positif ou nul");
        }

        Room room = new Room();
        room.setRoomType(roomType);
        room.setName(name);
        room.setCapacity(capacity);
        room.setSize(size);
        room.setLocation(location);
        room.setPricing(pricing);
        room.setImagePath(imagePath);
        room.setAvailabilityStatus(RoomStatus.ACTIVE);

        if (imagePath != null && !imagePath.isEmpty()) {
            room.setImageUploadedAt(LocalDateTime.now());
        }

        roomDao.save(room);
    }

    public void updateRoom(
            Long id,
            RoomType roomType,
            String name,
            Integer capacity,
            Double size,
            String location,
            BigDecimal pricing,
            String imagePath,
            RoomStatus status) throws ValidationException {

        Optional<Room> roomOpt = roomDao.findById(id);
        if (roomOpt.isEmpty()) {
            throw new ValidationException("Salle non trouvée");
        }

        Room room = roomOpt.get();

        // Validation
        if (name == null || name.trim().isEmpty()) {
            throw new ValidationException("Le nom de la salle est obligatoire");
        }

        if (capacity == null || capacity < 1) {
            throw new ValidationException("La capacité doit être au moins 1");
        }

        if (size == null || size <= 0) {
            throw new ValidationException("La taille doit être positive");
        }

        if (location == null || location.trim().isEmpty()) {
            throw new ValidationException("La localisation est obligatoire");
        }

        if (pricing == null || pricing.compareTo(BigDecimal.ZERO) < 0) {
            throw new ValidationException("Le prix doit être positif ou nul");
        }

        room.setRoomType(roomType);
        room.setName(name);
        room.setCapacity(capacity);
        room.setSize(size);
        room.setLocation(location);
        room.setPricing(pricing);
        room.setAvailabilityStatus(status);

        // Mettre à jour l'image si fournie
        if (imagePath != null && !imagePath.isEmpty()) {
            room.setImagePath(imagePath);
            room.setImageUploadedAt(LocalDateTime.now());
        }

        roomDao.update(room);

        // Si la salle est désactivée, annuler les réservations futures
        if (status == RoomStatus.INACTIVE) {
            cancelFutureReservations(id);
        }
    }

    public void deleteRoom(Long id) throws ValidationException {
        Optional<Room> roomOpt = roomDao.findById(id);
        if (roomOpt.isEmpty()) {
            throw new ValidationException("Salle non trouvée");
        }

        // Annuler les réservations futures
        cancelFutureReservations(id);

        roomDao.delete(id);
    }

    private void cancelFutureReservations(Long roomId) {
        List<com.roombooking.entity.Reservation> reservations =
            reservationDao.findByRoomId(roomId);

        LocalDateTime now = LocalDateTime.now();
        for (com.roombooking.entity.Reservation res : reservations) {
            if (res.getStartDateTime().isAfter(now) &&
                res.getStatus() == ReservationStatus.APPROVED) {
                res.setStatus(ReservationStatus.CANCELLED);
                reservationDao.update(res);
            }
        }
    }
}

