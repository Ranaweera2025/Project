package dao;

import model.Product;
import model.Medicine;
import model.Equipment;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class ProductDAO {
    private static final String PRODUCTS_FILE = "D:\\WebSite\\OnlineMediCare\\src\\data\\products.txt";

    public boolean createProduct(Product product) {
        try (PrintWriter out = new PrintWriter(new FileWriter(PRODUCTS_FILE, true))) {
            out.println(serializeProduct(product));
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(PRODUCTS_FILE))) {
            String line;
            while ((line = br.readLine()) != null) {
                Product product = deserializeProduct(line);
                if (product != null) {
                    products.add(product);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return products;
    }

    public boolean updateProduct(Product updatedProduct) {
        List<Product> products = getAllProducts();
        boolean found = false;

        for (int i = 0; i < products.size(); i++) {
            if (products.get(i).getProductId().equals(updatedProduct.getProductId())) {
                products.set(i, updatedProduct);
                found = true;
                break;
            }
        }

        return found && writeAllProducts(products);
    }

    public boolean deleteProduct(String productId) {
        List<Product> products = getAllProducts();
        List<Product> updatedProducts = products.stream()
                .filter(product -> !product.getProductId().equals(productId))
                .collect(Collectors.toList());

        return writeAllProducts(updatedProducts);
    }

    private boolean writeAllProducts(List<Product> products) {
        try (PrintWriter out = new PrintWriter(new FileWriter(PRODUCTS_FILE))) {
            for (Product product : products) {
                out.println(serializeProduct(product));
            }
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String serializeProduct(Product product) {
        StringBuilder sb = new StringBuilder();

        // Common product fields
        sb.append(String.join(",",
                product.getProductId(),
                product.getName(),
                product.getCategory(),
                String.valueOf(product.getPrice()),
                String.valueOf(product.getStock()),
                product.getDescription()));

        // Add image path, manufacturer, and prescription required
        sb.append(",")
                .append(product.getImagePath() != null ? product.getImagePath() : "")
                .append(",")
                .append(product.getManufacturer() != null ? product.getManufacturer() : "")
                .append(",")
                .append(product.isPrescriptionRequired());

        // Add specialized fields based on product type
        if (product instanceof Medicine) {
            Medicine medicine = (Medicine) product;
            sb.append(",MEDICINE,")
                    .append(medicine.getDosage())
                    .append(",")
                    .append(medicine.getExpirationDate());
        } else if (product instanceof Equipment) {
            Equipment equipment = (Equipment) product;
            sb.append(",EQUIPMENT,")
                    .append(equipment.getWarrantyPeriod())
                    .append(",")
                    .append(equipment.getManufacturer());
        }

        return sb.toString();
    }

    private Product deserializeProduct(String line) {
        String[] parts = line.split(",");
        if (parts.length >= 6) {
            String productId = parts[0];
            String name = parts[1];
            String category = parts[2];
            double price = Double.parseDouble(parts[3]);
            int stock = Integer.parseInt(parts[4]);
            String description = parts[5];

            // Create basic product
            Product product = new Product(productId, name, category, price, stock, description);

            // Set additional fields if available
            if (parts.length >= 7 && !parts[6].isEmpty()) {
                product.setImagePath(parts[6]);
            }

            if (parts.length >= 8 && !parts[7].isEmpty()) {
                product.setManufacturer(parts[7]);
            }

            if (parts.length >= 9) {
                product.setPrescriptionRequired(Boolean.parseBoolean(parts[8]));
            }

            // Check if this is a specialized product type
            if (parts.length >= 12) {
                String productType = parts[9];

                if ("MEDICINE".equals(productType)) {
                    String dosage = parts[10];
                    String expirationDate = parts[11];
                    Medicine medicine = new Medicine(productId, name, category, price, stock, description, dosage, expirationDate);
                    medicine.setImagePath(product.getImagePath());
                    medicine.setManufacturer(product.getManufacturer());
                    medicine.setPrescriptionRequired(product.isPrescriptionRequired());
                    return medicine;
                } else if ("EQUIPMENT".equals(productType)) {
                    String warrantyPeriod = parts[10];
                    String manufacturer = parts[11];
                    Equipment equipment = new Equipment(productId, name, category, price, stock, description, warrantyPeriod, manufacturer);
                    equipment.setImagePath(product.getImagePath());
                    equipment.setPrescriptionRequired(product.isPrescriptionRequired());
                    return equipment;
                }
            }

            // If not a specialized type or missing specialized fields, return the basic Product
            return product;
        }
        return null;
    }
}
