package com.roombooking.controller;

import com.roombooking.entity.User;
import com.roombooking.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/login.do"})
public class LoginServlet extends HttpServlet {
    
    private final AuthService authService;
    
    public LoginServlet() {
        this.authService = new AuthService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Si déjà connecté, rediriger selon le rôle
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.getRole().toString().equals("ADMIN")) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/rooms");
            }
            return;
        }
        
        request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Email et mot de passe requis");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            return;
        }
        
        Optional<User> userOpt = authService.login(email, password);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userRole", user.getRole().toString());
            
            // Redirection selon le rôle
            if (user.getRole().toString().equals("ADMIN")) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/rooms");
            }
        } else {
            request.setAttribute("error", "Email ou mot de passe incorrect");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }
}

