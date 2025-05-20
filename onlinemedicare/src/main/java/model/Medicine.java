package model;

public class Medicine extends Product {
    private String dosage;
    private String expirationDate;

    public Medicine(String productId, String name, String category,
                    double price, int stock, String description,
                    String dosage, String expirationDate) {
        super(productId, name, category, price, stock, description);
        this.dosage = dosage;
        this.expirationDate = expirationDate;
    }

    // Getters for Medicine-specific properties
    public String getDosage() { return dosage; }
    public String getExpirationDate() { return expirationDate; }

    // Setters for Medicine-specific properties
    public void setDosage(String dosage) { this.dosage = dosage; }
    public void setExpirationDate(String expirationDate) { this.expirationDate = expirationDate; }

    // Polymorphic display method
    @Override
    public String display() {
        return super.display() +
                String.format("\nDosage: %s, Expires: %s", dosage, expirationDate);
    }
}