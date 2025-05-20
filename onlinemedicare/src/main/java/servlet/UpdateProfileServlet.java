package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import service.UserService;
import model.User;


import java.io.IOException;

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        this.userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get form data
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        // Verify the user is updating their own profile
        if (!currentUser.getUsername().equals(username)) {
            request.setAttribute("error", "You can only update your own profile");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            return;
        }

        // Update user details
        currentUser.setEmail(email);
        currentUser.setPhone(phone);
        currentUser.setAddress(address);

        // Update password if provided
        if (password != null && !password.isEmpty()) {
            currentUser.setPassword(password);
        }

        // Save changes
        boolean success = userService.updateProfile(currentUser);

        if (success) {
            // Refresh session user
            session.setAttribute("user", currentUser);
            response.sendRedirect("dashboard.jsp?updated=true#profile");
        } else {
            request.setAttribute("error", "Failed to update profile");
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
        }
    }
}