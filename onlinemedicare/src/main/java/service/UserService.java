package service;

import dao.UserDAO;
import model.User;
import model.Customer;
import model.Admin;

import java.util.List;

public class UserService {
    private UserDAO userDao;

    public UserService() {
        this.userDao = new UserDAO();
    }

    // Register a new user
    public boolean registerUser(User user) {
        // Check if username already exists
        if (userDao.findUserByUsername(user.getUsername()) != null) {
            return false;
        }

        // Set user ID
        user.setUserId(userDao.generateUserId());

        return userDao.createUser(user);
    }

    // Authenticate user
    public User authenticate(String username, String password) {
        User user = userDao.findUserByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    public boolean isAdmin(User user) {
        return user != null && "admin".equals(user.getRole());
    }

    // Update user profile
    public boolean updateProfile(User user) {
        return userDao.updateUser(user);
    }

    // Delete user account
    public boolean deleteAccount(String userId) {
        try {
            // First delete all related data (orders, prescriptions, etc.)
            // Then delete the user
            return userDao.deleteUser(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }


    }


    // Get all users (for admin)
    public List<User> getAllUsers() {
        return userDao.readAllUsers();
    }

    // Get user by ID
    public User getUserById(String userId) {
        List<User> users = userDao.readAllUsers();
        for (User user : users) {
            if (user.getUserId().equals(userId)) {
                return user;
            }
        }
        return null;
    }

}