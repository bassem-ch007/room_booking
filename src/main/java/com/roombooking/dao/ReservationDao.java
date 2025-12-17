package com.roombooking.dao;

import com.roombooking.entity.Reservation;
import com.roombooking.entity.ReservationStatus;
import com.roombooking.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class ReservationDao {
    
    public Optional<Reservation> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Reservation reservation = em.find(Reservation.class, id);
            return Optional.ofNullable(reservation);
        } finally {
            em.close();
        }
    }
    
    public void save(Reservation reservation) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(reservation);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void update(Reservation reservation) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(reservation);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Reservation reservation = em.find(Reservation.class, id);
            if (reservation != null) {
                em.remove(reservation);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createQuery(
                "SELECT r FROM Reservation r ORDER BY r.startDateTime DESC", Reservation.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findByUserId(Long userId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createQuery(
                "SELECT r FROM Reservation r WHERE r.user.id = :userId " +
                "ORDER BY r.startDateTime DESC", Reservation.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findByRoomId(Long roomId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createQuery(
                "SELECT r FROM Reservation r WHERE r.room.id = :roomId " +
                "ORDER BY r.startDateTime DESC", Reservation.class);
            query.setParameter("roomId", roomId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public boolean existsOverlappingReservation(
            Long roomId,
            LocalDateTime startDt,
            LocalDateTime endDt) {
        
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(r) FROM Reservation r " +
                "WHERE r.room.id = :roomId " +
                "AND r.status NOT IN ('CANCELLED', 'CLIENT_CANCELLED') " +
                "AND (r.startDateTime < :endDt AND r.endDateTime > :startDt)",
                Long.class);
            query.setParameter("roomId", roomId);
            query.setParameter("startDt", startDt);
            query.setParameter("endDt", endDt);
            
            Long count = query.getSingleResult();
            return count > 0;
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findUserConflictingReservations(
            Long userId,
            LocalDateTime startDt,
            LocalDateTime endDt) {
        
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createQuery(
                "SELECT r FROM Reservation r " +
                "WHERE r.user.id = :userId " +
                "AND r.status = 'APPROVED' " +
                "AND (r.startDateTime < :endDt AND r.endDateTime > :startDt)",
                Reservation.class);
            query.setParameter("userId", userId);
            query.setParameter("startDt", startDt);
            query.setParameter("endDt", endDt);
            
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Reservation> findByStatus(ReservationStatus status) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Reservation> query = em.createQuery(
                "SELECT r FROM Reservation r WHERE r.status = :status " +
                "ORDER BY r.startDateTime DESC", Reservation.class);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}

