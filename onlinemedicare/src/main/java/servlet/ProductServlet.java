package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() {
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("details".equals(action)) {
            showProductDetails(request, response);
        } else {
            listProducts(request, response);
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String category = request.getParameter("category");
        String query = request.getParameter("query");

        // Get all products or filtered by category/search
        List<Product> products;
        if (category != null || query != null) {
            products = productService.searchProducts(query, category);
        } else {
            products = productService.getAllProducts();
        }

        // Get all categories for the filter dropdown
        List<String> categories = productService.getAllCategories();

        // Group products by category for display
        Map<String, List<Product>> productsByCategory = products.stream()
                .collect(Collectors.groupingBy(Product::getCategory));

        // Set attributes for the JSP
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("productsByCategory", productsByCategory);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("searchQuery", query);

        // Forward to the appropriate view
        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    private void showProductDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String productId = request.getParameter("productId");

        if (productId != null) {
            // Get the product
            Product product = productService.getProductById(productId);

            if (product != null) {
                // Get related products (same category, excluding current product)
                List<Product> relatedProducts = productService.searchProducts(null, product.getCategory())
                        .stream()
                        .filter(p -> !p.getProductId().equals(productId))
                        .limit(4)  // Limit to 4 related products
                        .collect(Collectors.toList());

                // Set attributes for the JSP
                request.setAttribute("product", product);
                request.setAttribute("relatedProducts", relatedProducts);

                // Forward to the product details page
                request.getRequestDispatcher("/productDetails.jsp").forward(request, response);
                return;
            }
        }

        // If product not found, redirect to products page
        response.sendRedirect("products");
    }
}
