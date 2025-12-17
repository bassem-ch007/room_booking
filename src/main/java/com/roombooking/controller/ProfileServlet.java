package com.roombooking.controller;


import com.roombooking.entity.User;
import com.roombooking.exception.UserAlreadyExistsException;
import com.roombooking.exception.ValidationException;
import com.roombooking.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile", "/profile/*"})
public class ProfileServlet extends HttpServlet {

    private final UserService userService;

    public ProfileServlet() {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showProfile(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            updateProfile(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        request.setAttribute("user", user);
        request.getRequestDispatcher("/jsp/profile.jsp").forward(request, response);
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Long userId = user.getId();

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // Valider les champs
            if (username == null || username.length() < 3) {
                throw new ValidationException("Le nom d'utilisateur doit faire au moins 3 caractères.");
            }
            if (email == null || email.isEmpty()) {
                throw new ValidationException("L'email est obligatoire.");
            }

            // Si mot de passe fourni, mettre à jour avec
            if (password != null && !password.isEmpty()) {
                if (password.length() < 6) {
                    throw new ValidationException("Le mot de passe doit faire au moins 6 caractères.");
                }
                userService.updateUser(userId, username, email, user.getRole(), password);
            } else {
                // Sinon, garder l'ancien mot de passe (passer null ou chaîne vide selon ton service)
                userService.updateUser(userId, username, email, user.getRole(), null);
            }

            // Mettre à jour la session
            user.setUsername(username);
            user.setEmail(email);
            session.setAttribute("user", user);
            session.setAttribute("success", "Profil mis à jour avec succès.");

            response.sendRedirect(request.getContextPath() + "/profile");

        } catch (ValidationException e) {
            session.setAttribute("error", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/profile");
        } catch (UserAlreadyExistsException e) {
            throw new RuntimeException(e);
        }
    }
}
