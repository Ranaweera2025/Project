package model;

import java.time.LocalDate;
import java.util.List;

public class Order {
    private String orderId;
    private String userId;
    private List<String> productIds; // Format: ["PANADOL:2", "BAND-AID:1"]
    private double totalAmount;
    private String status; // PENDING, PROCESSING, SHIPPED, DELIVERED, CANCELLED
    private LocalDate orderDate;

    public Order(String orderId, String userId, List<String> productIds, double totalAmount) {
        this.orderId = orderId;
        this.userId = userId;
        this.productIds = productIds;
        this.totalAmount = totalAmount;
        this.status = "PENDING";
        this.orderDate = LocalDate.now();
    }

    // Getters and Setters
    public String getOrderId() { return orderId; }
    public String getUserId() { return userId; }
    public List<String> getProductIds() { return productIds; }
    public double getTotalAmount() { return totalAmount; }
    public String getStatus() { return status; }
    public LocalDate getOrderDate() { return orderDate; }

    public void setStatus(String status) {
        if (List.of("PENDING", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED").contains(status)) {
            this.status = status;
        }
    }
}