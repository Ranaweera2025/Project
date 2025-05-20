package dao;

import model.User;
import model.Customer;
import model.Admin;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private static final String USERS_FILE = "D:\\WebSite\\OnlineMediCare\\src\\data\\users.txt";

    // Create a new user
    public boolean createUser(User user) {
        try (PrintWriter out = new PrintWriter(new FileWriter(USERS_FILE, true))) {
            out.println(user.toString());
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read all users
    public List<User> readAllUsers() {
        List<User> users = new ArrayList<>();
        File file = new File(USERS_FILE);

        if (!file.exists()) {
            return users;
        }

        try (BufferedReader br = new BufferedReader(new FileReader(USERS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 7) {
                    if ("admin".equals(parts[6])) {
                        users.add(new Admin(parts[0], parts[1], parts[2], parts[3],
                                parts[4], parts[5], parts[7]));
                    } else {
                        if (parts.length >= 9) {
                            users.add(new Customer(parts[0], parts[1], parts[2], parts[3],
                                    parts[4], parts[5], parts[7], parts[8]));
                        } else {
                            users.add(new User(parts[0], parts[1], parts[2], parts[3],
                                    parts[4], parts[5], parts[6]));
                        }
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Update a user
    public boolean updateUser(User updatedUser) {
        List<User> users = readAllUsers();
        boolean found = false;

        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getUserId().equals(updatedUser.getUserId())) {
                users.set(i, updatedUser);
                found = true;
                break;
            }
        }

        if (!found) return false;

        return writeAllUsers(users);
    }

    // Delete a user
    public boolean deleteUser(String userId) {
        // Read all users
        List<User> users = readAllUsers();
        if (users == null) return false;

        // Check if user exists
        boolean userExists = users.stream()
                .anyMatch(user -> user.getUserId().equals(userId));

        if (!userExists) return false;

        // Create backup file
        File originalFile = new File(USERS_FILE);
        File backupFile = new File(USERS_FILE + ".bak");

        try {
            // Create backup
            Files.copy(originalFile.toPath(), backupFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

            // Filter out the user to delete
            List<User> updatedUsers = users.stream()
                    .filter(user -> !user.getUserId().equals(userId))
                    .collect(java.util.stream.Collectors.toList());

            // Write updated users
            try (PrintWriter out = new PrintWriter(new FileWriter(USERS_FILE))) {
                for (User user : updatedUsers) {
                    out.println(user.toString());
                }
            }

            // Delete backup if successful
            backupFile.delete();
            return true;

        } catch (IOException e) {
            e.printStackTrace();
            // Restore from backup if error occurs
            try {
                if (backupFile.exists()) {
                    Files.copy(backupFile.toPath(), originalFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    backupFile.delete();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
            return false;
        }
    }
    // Helper method to write all users to file
    private boolean writeAllUsers(List<User> users) {
        try (PrintWriter out = new PrintWriter(new FileWriter(USERS_FILE))) {
            for (User user : users) {
                out.println(user.toString());
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Find user by username
    public User findUserByUsername(String username) {
        List<User> users = readAllUsers();
        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return user;
            }
        }
        return null;
    }

    // Generate new user ID
    public String generateUserId() {
        List<User> users = readAllUsers();
        return "U" + (users.size() + 1);
    }
}