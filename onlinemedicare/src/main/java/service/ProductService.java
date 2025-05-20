package service;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import dao.ProductDAO;
import model.Product;
import java.util.List;
import java.util.stream.Collectors;

public class ProductService {
    private final ProductDAO productDao;

    public ProductService() {
        this.productDao = new ProductDAO();
    }

    public boolean addProduct(Product product) {
        return productDao.createProduct(product);
    }

    public List<Product> getAllProducts() {
        return productDao.getAllProducts();
    }

    public Product getProductById(String productId) {
        return productDao.getAllProducts().stream()
                .filter(p -> p.getProductId().equals(productId))
                .findFirst()
                .orElse(null);
    }

    public List<Product> searchProducts(String query, String category) {
        return productDao.getAllProducts().stream()
                .filter(product ->
                        (query == null || query.isEmpty() || product.getName().toLowerCase().contains(query.toLowerCase())) &&
                                (category == null || category.isEmpty() || product.getCategory().equalsIgnoreCase(category)))
                .collect(Collectors.toList());
    }

    public boolean updateProduct(Product product) {
        return productDao.updateProduct(product);
    }

    public boolean deleteProduct(String productId) {
        return productDao.deleteProduct(productId);
    }

    public List<String> getAllCategories() {
        return productDao.getAllProducts().stream()
                .map(Product::getCategory)
                .distinct()
                .collect(Collectors.toList());
    }
    public Map<String, Product> getProductsById(Set<String> productIds) {
        Map<String, Product> result = new HashMap<>();
        List<Product> allProducts = productDao.getAllProducts();

        for (Product product : allProducts) {
            if (productIds.contains(product.getProductId())) {
                result.put(product.getProductId(), product);
            }
        }

        return result;
    }

}
