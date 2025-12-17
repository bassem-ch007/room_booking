package com.roombooking.dao;

import com.roombooking.entity.Room;
import com.roombooking.entity.RoomStatus;
import com.roombooking.entity.RoomType;
import com.roombooking.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RoomDao {
    
    public Optional<Room> findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Room room = em.find(Room.class, id);
            return Optional.ofNullable(room);
        } finally {
            em.close();
        }
    }
    
    public void save(Room room) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(room);
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
    
    public void update(Room room) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(room);
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
            Room room = em.find(Room.class, id);
            if (room != null) {
                em.remove(room);
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
    
    public List<Room> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Room> query = em.createQuery("SELECT r FROM Room r", Room.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Room> findByStatus(RoomStatus status) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Room> query = em.createQuery(
                "SELECT r FROM Room r WHERE r.availabilityStatus = :status", Room.class);
            query.setParameter("status", status);
            return query.getResultList();
        } finally {
            em.close();
        }
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
        
        EntityManager em = JPAUtil.getEntityManager();
        try {
            StringBuilder jpql = new StringBuilder("SELECT DISTINCT r FROM Room r WHERE 1=1");
            List<Object> parameters = new ArrayList<>();
            int paramIndex = 0;
            
            if (roomType != null) {
                jpql.append(" AND r.roomType = ?").append(++paramIndex);
                parameters.add(roomType);
            }
            
            if (minCapacity != null) {
                jpql.append(" AND r.capacity >= ?").append(++paramIndex);
                parameters.add(minCapacity);
            }
            
            if (minSize != null) {
                jpql.append(" AND r.size >= ?").append(++paramIndex);
                parameters.add(minSize);
            }
            
            if (minPrice != null) {
                jpql.append(" AND r.pricing >= ?").append(++paramIndex);
                parameters.add(minPrice);
            }
            
            if (maxPrice != null) {
                jpql.append(" AND r.pricing <= ?").append(++paramIndex);
                parameters.add(maxPrice);
            }
            
            if (location != null && !location.isEmpty()) {
                jpql.append(" AND LOWER(r.location) LIKE ?").append(++paramIndex);
                parameters.add("%" + location.toLowerCase() + "%");
            }
            
            if (startDateTime != null) {
                if (endDateTime != null) {
                    jpql.append(" AND r.id NOT IN (")
                        .append("SELECT res.room.id FROM Reservation res ")
                        .append("WHERE res.status NOT IN ('CANCELLED', 'CLIENT_CANCELLED') ")
                        .append("AND res.startDateTime < ?").append(++paramIndex)
                        .append(" AND res.endDateTime > ?").append(++paramIndex)
                        .append(")");
                    parameters.add(endDateTime);
                    parameters.add(startDateTime);
                }
                else {
                    jpql.append(" AND r.id NOT IN (")
                        .append("SELECT res.room.id FROM Reservation res ")
                        .append("WHERE res.status NOT IN ('CANCELLED', 'CLIENT_CANCELLED') ")
                        .append("AND res.startDateTime < ?").append(++paramIndex)
                        .append(")");
                    parameters.add(startDateTime);
                }
            }
            
            jpql.append(" AND r.availabilityStatus = 'ACTIVE'");
            
            TypedQuery<Room> query = em.createQuery(jpql.toString(), Room.class);
            for (int i = 0; i < parameters.size(); i++) {
                query.setParameter(i + 1, parameters.get(i));
            }
            
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}

