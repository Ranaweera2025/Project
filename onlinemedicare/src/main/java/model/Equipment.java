package model;

public class Equipment extends Product {
    private String warrantyPeriod;
    private String manufacturer;

    public Equipment(String productId, String name, String category,
                     double price, int stock, String description,
                     String warrantyPeriod, String manufacturer) {
        super(productId, name, category, price, stock, description);
        this.warrantyPeriod = warrantyPeriod;
        this.manufacturer = manufacturer;
    }

    // Getters for Equipment-specific properties
    public String getWarrantyPeriod() { return warrantyPeriod; }
    public String getManufacturer() { return manufacturer; }

    // Setters for Equipment-specific properties
    public void setWarrantyPeriod(String warrantyPeriod) { this.warrantyPeriod = warrantyPeriod; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    // Polymorphic display method
    @Override
    public String display() {
        return super.display() +
                String.format("\nWarranty: %s, Manufacturer: %s",
                        warrantyPeriod, manufacturer);
    }
}