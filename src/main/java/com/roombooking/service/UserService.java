package com.roombooking.service;

import com.roombooking.dao.UserDao;
import com.roombooking.entity.User;
import com.roombooking.entity.UserRole;
import com.roombooking.exception.UserAlreadyExistsException;
import com.roombooking.exception.ValidationException;
import com.roombooking.util.Page;
import org.mindrot.jbcrypt.BCrypt;
import java.util.List;
import java.util.Optional;

public class UserService {
    
    private final UserDao userDao;
    
    public UserService() {
        this.userDao = new UserDao();
    }
    
    public Optional<User> findById(Long id) {
        return userDao.findById(id);
    }
    
    public List<User> findAll() {
        return userDao.findAll();
    }
    
    public List<User> findAllByRole(UserRole role) {
        return userDao.findAllByRole(role);
    }

    public Page<User> findUsersPaginated(List<User> users, int currentPage, int itemsPerPage) {
        return Page.of(users, currentPage, itemsPerPage);
    }

    public void createUser(String username, String email, String password, UserRole role)
            throws UserAlreadyExistsException, ValidationException {
        
        // Vérifier unicité email
        if (userDao.findByEmail(email).isPresent()) {
            throw new UserAlreadyExistsException("Cet email est déjà utilisé");
        }
        
        // Vérifier unicité username
        if (userDao.findByUsername(username).isPresent()) {
            throw new UserAlreadyExistsException("Ce nom d'utilisateur est déjà utilisé");
        }
        
        // Validation
        if (username == null || username.length() < 5) {
            throw new ValidationException("Le nom d'utilisateur doit contenir au moins 5 caractères");
        }
        
        if (password == null || password.length() < 8) {
            throw new ValidationException("Le mot de passe doit contenir au moins 8 caractères");
        }
        
        // Hash password
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));
        
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setRole(role != null ? role : UserRole.USER);
        
        userDao.save(user);
    }
    
    public void updateUser(Long id, String username, String email, UserRole role, String password)
            throws UserAlreadyExistsException, ValidationException {
        
        Optional<User> userOpt = userDao.findById(id);
        if (userOpt.isEmpty()) {
            throw new ValidationException("Utilisateur non trouvé");
        }
        
        User user = userOpt.get();
        
        // Vérifier unicité email si modifié
        if (!user.getEmail().equals(email)) {
            if (userDao.findByEmail(email).isPresent()) {
                throw new UserAlreadyExistsException("Cet email est déjà utilisé");
            }
            user.setEmail(email);
        }
        
        // Vérifier unicité username si modifié
        if (!user.getUsername().equals(username)) {
            if (userDao.findByUsername(username).isPresent()) {
                throw new UserAlreadyExistsException("Ce nom d'utilisateur est déjà utilisé");
            }
            user.setUsername(username);
        }
        
        // Validation
        if (username == null || username.length() < 5) {
            throw new ValidationException("Le nom d'utilisateur doit contenir au moins 5 caractères");
        }
        
        // Mettre à jour le mot de passe si fourni
        if (password != null && !password.isEmpty()) {
            if (password.length() < 8) {
                throw new ValidationException("Le mot de passe doit contenir au moins 8 caractères");
            }
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));
            user.setPassword(hashedPassword);
        }
        
        user.setRole(role);
        userDao.update(user);
    }
    
    public void deleteUser(Long id) throws ValidationException {
        Optional<User> userOpt = userDao.findById(id);
        if (userOpt.isEmpty()) {
            throw new ValidationException("Utilisateur non trouvé");
        }
        
        // Note: Les réservations ne sont pas supprimées, user_id → NULL
        userDao.delete(id);
    }
}

