package model;

public class Admin extends User {
    private String adminLevel;

    public Admin() {
        super();
        this.setRole("admin");
    }

    public Admin(String userId, String username, String password, String email,
                 String phone, String address, String adminLevel) {
        super(userId, username, password, email, phone, address, "admin");
        this.adminLevel = adminLevel;
    }

    // Getters and setters


    public String getAdminLevel() {
        return adminLevel;
    }

    public void setAdminLevel(String adminLevel) {
        this.adminLevel = adminLevel;
    }

    @Override
    public String toString() {
        return super.toString() + "," + adminLevel;
    }
}