package model;


import java.io.Serializable;

public class User implements Serializable {
    private String userId;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String address;
    private String role; // "admin" or "customer"

    // Constructor, getters, setters
    public User() {}

    public User(String userId, String username, String password, String email,
                String phone, String address, String role) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.role = role;
    }

    // Getters and setters for all fields


    public String getUserId() {return userId;}

    public String getUsername() {return username;}

    public String getPassword() {return password;}

    public String getEmail() {return email;}

    public String getPhone() {return phone;}

    public String getAddress() {return address;}

    public String getRole() {return role;}

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setRole(String role) {
        this.role = role;
    }

    // Example of polymorphism through method overriding
    @Override
    public String toString() {
        return userId + "," + username + "," + password + "," + email + "," +
                phone + "," + address + "," + role;
    }
}