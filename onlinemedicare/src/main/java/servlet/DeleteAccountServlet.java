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

@WebServlet("/deleteAccount")
public class DeleteAccountServlet extends HttpServlet {
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
            response.sendRedirect("login.jsp?error=not_logged_in");
            return;
        }

        try {
            String userIdToDelete = request.getParameter("userId");

            // Verify the user is deleting their own account
            if (!currentUser.getUserId().equals(userIdToDelete)) {
                session.setAttribute("error", "You can only delete your own account");
                response.sendRedirect("dashboard.jsp");
                return;
            }

            // Delete account
            boolean success = userService.deleteAccount(userIdToDelete);

            if (success) {
                // Invalidate session and redirect
                session.invalidate();
                response.sendRedirect("login.jsp?accountDeleted=true");
            } else {
                session.setAttribute("error", "Failed to delete account. Please try again.");
                response.sendRedirect("dashboard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while deleting your account: " + e.getMessage());
            response.sendRedirect("dashboard.jsp");
        }
    }
}