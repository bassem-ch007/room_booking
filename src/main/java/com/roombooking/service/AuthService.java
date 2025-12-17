package com.roombooking.service;

import com.roombooking.dao.UserDao;
import com.roombooking.entity.User;
import com.roombooking.entity.UserRole;
import com.roombooking.exception.UserAlreadyExistsException;
import com.roombooking.exception.ValidationException;
import org.mindrot.jbcrypt.BCrypt;
import java.util.Optional;

public class AuthService {
    
    private final UserDao userDao;
    
    public AuthService() {
        this.userDao = new UserDao();
    }
    
    /**
     * Inscription: hash le mot de passe avec BCrypt
     */
    public void register(String username, String email, String plainPassword)
            throws UserAlreadyExistsException, ValidationException {
        
        // Vérifier l'unicité email
        if (userDao.findByEmail(email).isPresent()) {
            throw new UserAlreadyExistsException("Cet email est déjà utilisé");
        }
        
        // Vérifier l'unicité username
        if (userDao.findByUsername(username).isPresent()) {
            throw new UserAlreadyExistsException("Ce nom d'utilisateur est déjà utilisé");
        }
        
        // Valider longueur username
        if (username == null || username.length() < 5) {
            throw new ValidationException("Le nom d'utilisateur doit contenir au moins 5 caractères");
        }
        
        // Valider longueur password
        if (plainPassword == null || plainPassword.length() < 8) {
            throw new ValidationException("Le mot de passe doit contenir au moins 8 caractères");
        }
        
        // Hash BCrypt
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
        
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setEmail(email);
        newUser.setPassword(hashedPassword); // Stocké hashé
        newUser.setRole(UserRole.USER);
        
        userDao.save(newUser);
    }
    
    /**
     * Connexion: vérifie le mot de passe avec BCrypt.checkpw()
     */
    public Optional<User> login(String email, String plainPassword) {
        Optional<User> userOpt = userDao.findByEmail(email);
        
        if (userOpt.isEmpty()) {
            return Optional.empty(); // User not found
        }
        
        User user = userOpt.get();
        
        // Vérifier: plainPassword vs hash stocké (ne pas re-hasher!)
        if (BCrypt.checkpw(plainPassword, user.getPassword())) {
            return Optional.of(user);
        }
        
        return Optional.empty(); // Password incorrect
    }
}

