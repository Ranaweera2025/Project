package model;

public class Customer extends User {
    private String healthCardNumber;
    private String allergies;

    public Customer() {
        super();
        this.setRole("customer");
    }

    // Constructor using super
    public Customer(String userId, String username, String password, String email,
                    String phone, String address, String healthCardNumber, String allergies) {
        super(userId, username, password, email, phone, address, "customer");
        this.healthCardNumber = healthCardNumber;
        this.allergies = allergies;
    }

    // Getters and setters


    public String getHealthCardNumber() {return healthCardNumber;}

    public String getAllergies() {return allergies;}

    public void setHealthCardNumber(String healthCardNumber) {
        this.healthCardNumber = healthCardNumber;
    }

    public void setAllergies(String allergies) {
        this.allergies = allergies;
    }

    @Override
    public String toString() {
        return super.toString() + "," + healthCardNumber + "," + allergies;
    }
}