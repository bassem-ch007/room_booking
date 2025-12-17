package com.roombooking.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "rooms")
public class Room {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RoomType roomType;
    
    @Column(nullable = false, length = 100, unique = true)
    private String name;
    
    @Column(nullable = false)
    @Min(value = 1, message = "Capacité minimum 1")
    private Integer capacity;
    
    @Column(nullable = false)
    private Double size; // en m²
    
    @Column(nullable = false)
    private String location;
    
    @Column(nullable = false, precision = 10, scale = 2)
    @DecimalMin("0.0")
    private BigDecimal pricing;
    
    @Column(length = 255, nullable = true)
    private String imagePath; // Nullable: salle sans image
    
    @Column(name = "image_uploaded_at", nullable = true)
    private LocalDateTime imageUploadedAt; // Timestamp upload image
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, name = "availability_status")
    private RoomStatus availabilityStatus = RoomStatus.ACTIVE;
    
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @OneToMany(mappedBy = "room", cascade = CascadeType.PERSIST)
    private List<Reservation> reservations = new ArrayList<>();
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    // Constructors
    public Room() {
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public RoomType getRoomType() {
        return roomType;
    }
    
    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public Integer getCapacity() {
        return capacity;
    }
    
    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }
    
    public Double getSize() {
        return size;
    }
    
    public void setSize(Double size) {
        this.size = size;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public BigDecimal getPricing() {
        return pricing;
    }
    
    public void setPricing(BigDecimal pricing) {
        this.pricing = pricing;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public LocalDateTime getImageUploadedAt() {
        return imageUploadedAt;
    }
    
    public void setImageUploadedAt(LocalDateTime imageUploadedAt) {
        this.imageUploadedAt = imageUploadedAt;
    }
    
    public RoomStatus getAvailabilityStatus() {
        return availabilityStatus;
    }
    
    public void setAvailabilityStatus(RoomStatus availabilityStatus) {
        this.availabilityStatus = availabilityStatus;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public List<Reservation> getReservations() {
        return reservations;
    }
    
    public void setReservations(List<Reservation> reservations) {
        this.reservations = reservations;
    }

}

