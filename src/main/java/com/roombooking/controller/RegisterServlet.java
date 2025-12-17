package com.roombooking.controller;

import com.roombooking.exception.UserAlreadyExistsException;
import com.roombooking.exception.ValidationException;
import com.roombooking.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register", "/register.do"})
public class RegisterServlet extends HttpServlet {
    
    private final AuthService authService;
    
    public RegisterServlet() {
        this.authService = new AuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation côté serveur
        if (username == null || email == null || password == null || 
            username.isEmpty() || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Tous les champs sont obligatoires");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }
        
        try {
            authService.register(username, email, password);
            request.setAttribute("success", "Inscription réussie ! Vous pouvez maintenant vous connecter.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        } catch (UserAlreadyExistsException | ValidationException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }
}

