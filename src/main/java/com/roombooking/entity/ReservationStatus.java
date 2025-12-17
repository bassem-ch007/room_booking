package com.roombooking.entity;

public enum ReservationStatus {
    APPROVED,      // Réservation validée
    PENDING,       // en attend
    CANCELLED,     // Annulée par admin
    CLIENT_CANCELLED // Annulée par utilisateur
}

