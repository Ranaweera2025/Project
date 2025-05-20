
package model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    private String userId;
    private Map<String, Integer> items; // Key: productId, Value: quantity

    public Cart(String userId) {
        this.userId = userId;
        this.items = new HashMap<>();
    }

    public void addItem(String productId, int quantity) {
        items.merge(productId, quantity, Integer::sum);
    }

    public void removeItem(String productId) {
        items.remove(productId);
    }

    public Map<String, Integer> getItems() {
        return new HashMap<>(items); // Return copy for immutability
    }

    public void clear() {
        items.clear();
    }
}