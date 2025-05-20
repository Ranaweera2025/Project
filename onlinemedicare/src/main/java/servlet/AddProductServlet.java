package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Equipment;
import model.Medicine;
import model.Product;
import service.ProductService;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/AddProductServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1 MB
        maxFileSize = 1024 * 1024 * 10,       // 10 MB
        maxRequestSize = 1024 * 1024 * 50      // 50 MB
)
public class AddProductServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() {
        this.productService = new ProductService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form fields
            String productId = request.getParameter("productId");
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");
            String manufacturer = request.getParameter("manufacturer");
            boolean prescriptionRequired = request.getParameter("prescriptionRequired") != null;

            // Handle file upload
            Part filePart = request.getPart("productImage");
            String fileName = getSubmittedFileName(filePart);

            // Generate unique filename to prevent overwriting
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;

            // Define the relative path for storing images
            String relativePath = "resources/images/products/" + uniqueFileName;

            // Get the absolute path for saving the file
            String uploadPath = getServletContext().getRealPath("") + File.separator + relativePath;

            // Create directories if they don't exist
            File uploadDir = new File(getServletContext().getRealPath("") + File.separator + "resources/images/products");
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Save the file
            filePart.write(uploadPath);

            // Create the appropriate product type
            Product product;

            if ("Medicine".equals(category)) {
                String dosage = request.getParameter("dosage");
                String expirationDate = request.getParameter("expirationDate");
                product = new Medicine(productId, name, category, price, stock, description, dosage, expirationDate);
            } else if ("Equipment".equals(category) || "Medical Equipment".equals(category)) {
                String warrantyPeriod = request.getParameter("warrantyPeriod");
                String equipManufacturer = request.getParameter("manufacturer2");
                if (equipManufacturer != null && !equipManufacturer.isEmpty()) {
                    manufacturer = equipManufacturer;
                }
                product = new Equipment(productId, name, category, price, stock, description, warrantyPeriod, manufacturer);
            } else {
                product = new Product(productId, name, category, price, stock, description);
            }

            // Set additional properties
            // Store the relative path in the database for browser access
            product.setImagePath(relativePath);
            product.setManufacturer(manufacturer);
            product.setPrescriptionRequired(prescriptionRequired);

            // Save the product
            boolean success = productService.addProduct(product);

            if (success) {
                response.sendRedirect("addProduct.jsp?success=true");
            } else {
                response.sendRedirect("addProduct.jsp?error=Failed+to+add+product");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addProduct.jsp?error=" + e.getMessage());
        }
    }

    private String getSubmittedFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "unknown";
    }
}
