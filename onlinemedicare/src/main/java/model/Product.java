package model;

public class Product {
    private String productId;
    private String name;
    private String category;
    private double price;
    private int stock;
    private String description;
    private String imagePath;
    private String manufacturer;
    private boolean prescriptionRequired;

    // Constructor
    public Product(String productId, String name, String category,
                   double price, int stock, String description) {
        this.productId = productId;
        this.name = name;
        this.category = category;
        this.price = price;
        this.stock = stock;
        this.description = description;
        this.prescriptionRequired = false;
    }

    // Getters and Setters
    public String getProductId() { return productId; }
    public String getName() { return name; }
    public String getCategory() { return category; }
    public double getPrice() { return price; }
    public int getStock() { return stock; }
    public String getDescription() { return description; }
    public String getImagePath() { return imagePath; }
    public String getManufacturer() { return manufacturer; }
    public boolean isPrescriptionRequired() { return prescriptionRequired; }

    public void setPrice(double price) { this.price = price; }
    public void setStock(int stock) { this.stock = stock; }
    public void setDescription(String description) { this.description = description; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }
    public void setPrescriptionRequired(boolean prescriptionRequired) { this.prescriptionRequired = prescriptionRequired; }

    // Display method (will be overridden by subclasses)
    public String display() {
        return String.format("%s - %s ($%.2f, Stock: %d)",
                productId, name, price, stock);
    }
}
