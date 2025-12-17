package com.roombooking.service;

import com.roombooking.dao.ReservationDao;
import com.roombooking.dao.RoomDao;
import com.roombooking.dao.UserDao;
import com.roombooking.entity.Reservation;
import com.roombooking.entity.ReservationStatus;
import com.roombooking.entity.RoomStatus;
import com.roombooking.exception.ReservationConflictException;
import com.roombooking.exception.ValidationException;
import com.roombooking.util.DateTimeUtil;
import com.roombooking.util.Page;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class ReservationService {
    
    private final ReservationDao reservationDao;
    private final RoomDao roomDao;
    private final UserDao userDao;
    
    public ReservationService() {
        this.reservationDao = new ReservationDao();
        this.roomDao = new RoomDao();
        this.userDao = new UserDao();
    }
    
    public Optional<Reservation> findById(Long id) {
        return reservationDao.findById(id);
    }
    
    public List<Reservation> findAll() {
        return reservationDao.findAll();
    }
    public List<Reservation> findByStatus(ReservationStatus status)
    {
        if (status != null) return reservationDao.findByStatus(status);
        else return reservationDao.findAll();
    }

    public List<Reservation> findByUserId(Long userId) {
        return reservationDao.findByUserId(userId);
    }
    
    public List<Reservation> findByRoomId(Long roomId) {
        return reservationDao.findByRoomId(roomId);
    }

    public Page<Reservation> findReservationsPaginated(List<Reservation> reservations, int currentPage, int itemsPerPage) {
        return Page.of(reservations, currentPage, itemsPerPage);
    }



    /**
     * Créer une réservation avec vérifications métier
     */
    public void createReservation(Long userId, Long roomId,
            LocalDateTime start, LocalDateTime end)
            throws ReservationConflictException, ValidationException {
        
        // 1. Valider dates
        if (!DateTimeUtil.isValidDateRange(start, end)) {
            throw new ValidationException("La date de début doit être antérieure à la date de fin");
        }
        
        // 2. Vérifier que les dates ne sont pas dans le passé
        if (DateTimeUtil.isPast(start)) {
            throw new ValidationException("Impossible de réserver dans le passé");
        }
        
        // 3. Vérifier que la salle existe et est active
        Optional<com.roombooking.entity.Room> roomOpt = roomDao.findById(roomId);
        if (roomOpt.isEmpty()) {
            throw new ValidationException("Salle non trouvée");
        }
        
        com.roombooking.entity.Room room = roomOpt.get();
        if (room.getAvailabilityStatus() != RoomStatus.ACTIVE) {
            throw new ValidationException("Cette salle n'est pas disponible");
        }
        
        // 4. Vérifier que l'utilisateur existe
        Optional<com.roombooking.entity.User> userOpt = userDao.findById(userId);
        if (userOpt.isEmpty()) {
            throw new ValidationException("Utilisateur non trouvé");
        }
        
        // 5. Vérifier chevauchement pour cette salle
        if (reservationDao.existsOverlappingReservation(roomId, start, end)) {
            throw new ReservationConflictException(
                "Cette salle n'est pas disponible pour ce créneau");
        }
        
        // 6. Vérifier que l'utilisateur n'a pas déjà une réservation en même temps
        List<Reservation> conflictingReservations = 
            reservationDao.findUserConflictingReservations(userId, start, end);
        
        if (!conflictingReservations.isEmpty()) {
            throw new ReservationConflictException(
                "Vous avez déjà une réservation à cette heure");
        }
        
        // 7. Créer la réservation
        Reservation res = new Reservation();
        res.setUser(userOpt.get());
        res.setRoom(room);
        res.setStartDateTime(start);
        res.setEndDateTime(end);
        res.setStatus(ReservationStatus.PENDING);
        
        reservationDao.save(res);
    }
    
    /**
     * Annuler une réservation (client ou admin)
     */
    public void cancelReservation(Long reservationId, Long userId, boolean isAdmin)
            throws ValidationException {
        
        Optional<Reservation> resOpt = reservationDao.findById(reservationId);
        if (resOpt.isEmpty()) {
            throw new ValidationException("Réservation non trouvée");
        }
        
        Reservation res = resOpt.get();
        
        // Vérifier que la réservation n'est pas passée
        if (DateTimeUtil.isPast(res.getEndDateTime())) {
            throw new ValidationException(
                "Impossible d'annuler une réservation passée");
        }
        
        if (isAdmin) {
            res.setStatus(ReservationStatus.CANCELLED);
        } else {
            // Vérifier que c'est le propriétaire
            if (!res.getUser().getId().equals(userId)) {
                throw new ValidationException("Non autorisé");
            }
            res.setStatus(ReservationStatus.CLIENT_CANCELLED);
        }
        
        reservationDao.update(res);
    }

    public void updateStatus(Long reservationId, ReservationStatus newStatus) throws ValidationException {
        Reservation reservation = reservationDao.findById(reservationId)
                .orElseThrow(() -> new ValidationException("Réservation introuvable"));

        reservation.setStatus(newStatus);
        reservationDao.update(reservation);
    }
}

