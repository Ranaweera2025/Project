package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.ProductService;
import model.Product;
import model.Medicine;
import model.Equipment;
import java.io.File;
import java.io.IOException;
import java.util.List;
//Product Management
@WebServlet("/manageProducts")
public class ProductManagementServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() {
        this.productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String productId = request.getParameter("productId");

        if ("edit".equals(action) && productId != null) {
            Product product = productService.getProductById(productId);
            request.setAttribute("product", product);
            request.getRequestDispatcher("/editProduct.jsp").forward(request, response);
        } else {
            List<Product> products = productService.getAllProducts();
            request.setAttribute("products", products);
            request.getRequestDispatcher("/adminProductManagement.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            handleAddProduct(request, response);
        } else if ("update".equals(action)) {
            handleUpdateProduct(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteProduct(request, response);
        }
    }

    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Product product = createProductFromRequest(request);
        boolean success = productService.addProduct(product);

        if (success) {
            request.setAttribute("message", "Product added successfully!");
        } else {
            request.setAttribute("error", "Failed to add product");
        }
        response.sendRedirect("manageProducts");
    }

    private void handleUpdateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Product product = createProductFromRequest(request);
        boolean success = productService.updateProduct(product);

        if (success) {
            request.setAttribute("message", "Product updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update product");
        }
        response.sendRedirect("manageProducts");
    }

    private void handleDeleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productId = request.getParameter("productId");

        // Get the product to delete (to find its image path)
        Product product = productService.getProductById(productId);

        boolean success = false;

        if (product != null) {
            // Delete the image file if it exists
            if (product.getImagePath() != null && !product.getImagePath().isEmpty()) {
                String applicationPath = request.getServletContext().getRealPath("");
                String imagePath = applicationPath + File.separator + product.getImagePath();
                File imageFile = new File(imagePath);
                if (imageFile.exists()) {
                    imageFile.delete();
                    System.out.println("Deleted image file: " + imagePath);
                }
            }

            // Delete the product from database
            success = productService.deleteProduct(productId);
        }

        if (success) {
            request.setAttribute("message", "Product deleted successfully!");
        } else {
            request.setAttribute("error", "Failed to delete product");
        }
        response.sendRedirect("manageProducts");
    }

    private Product createProductFromRequest(HttpServletRequest request) {
        String productId = request.getParameter("productId");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String description = request.getParameter("description");

        Product product;

        // Create the appropriate product type based on category
        if ("Medicine".equals(category)) {
            String dosage = request.getParameter("dosage");
            String expirationDate = request.getParameter("expirationDate");
            product = new Medicine(productId, name, category, price, stock, description, dosage, expirationDate);
        } else if ("Equipment".equals(category)) {
            String warrantyPeriod = request.getParameter("warrantyPeriod");
            String manufacturer = request.getParameter("manufacturer");
            product = new Equipment(productId, name, category, price, stock, description, warrantyPeriod, manufacturer);
        } else {
            product = new Product(productId, name, category, price, stock, description);
        }

        // Set additional fields
        String manufacturer = request.getParameter("manufacturer");
        if (manufacturer != null && !manufacturer.isEmpty()) {
            product.setManufacturer(manufacturer);
        }

        boolean prescriptionRequired = request.getParameter("prescriptionRequired") != null;
        product.setPrescriptionRequired(prescriptionRequired);

        return product;
    }
}
