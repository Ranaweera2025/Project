package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Product;
import service.ProductService;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() {
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        // Handle cart count request
        if (pathInfo != null && pathInfo.equals("/count")) {
            HttpSession session = request.getSession();
            Map<String, Integer> cart = getCart(session);
            int cartSize = getCartSize(cart);

            response.setContentType("application/json");
            response.getWriter().write("{\"count\": " + cartSize + "}");
            return;
        }

        // Regular cart page request
        HttpSession session = request.getSession();
        Map<String, Integer> cart = getCart(session);

        // Calculate cart totals
        double total = 0.0;
        int itemCount = 0;

        Map<String, Product> cartProducts = new HashMap<>();
        for (Map.Entry<String, Integer> entry : cart.entrySet()) {
            Product product = productService.getProductById(entry.getKey());
            if (product != null) {
                cartProducts.put(entry.getKey(), product);
                total += product.getPrice() * entry.getValue();
                itemCount += entry.getValue();
            }
        }

        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("cartTotal", total);
        request.setAttribute("itemCount", itemCount);

        // Store cart in session for JSP access
        session.setAttribute("cart", cart);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String productId = request.getParameter("productId");
        HttpSession session = request.getSession();

        if (action == null || productId == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Map<String, Integer> cart = getCart(session);

        switch (action) {
            case "add":
                addToCart(cart, productId);
                break;
            case "update":
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                updateCart(cart, productId, quantity);
                break;
            case "remove":
                removeFromCart(cart, productId);
                break;
            case "clear":
                clearCart(session);
                cart = new HashMap<>(); // Reset cart after clearing
                break;
        }

        // Save updated cart back to session
        session.setAttribute("cart", cart);

        // Redirect based on the source of the request
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("cart.jsp")) {
            response.sendRedirect(request.getContextPath() + "/cart");
        } else {
            // Return JSON response for AJAX requests
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"cartSize\": " + getCartSize(cart) + "}");
        }
    }

    private Map<String, Integer> getCart(HttpSession session) {
        @SuppressWarnings("unchecked")
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");

        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        return cart;
    }

    private void addToCart(Map<String, Integer> cart, String productId) {
        Product product = productService.getProductById(productId);
        if (product != null) {
            int currentQuantity = cart.getOrDefault(productId, 0);
            cart.put(productId, currentQuantity + 1);
        }
    }

    private void updateCart(Map<String, Integer> cart, String productId, int quantity) {
        if (quantity > 0) {
            cart.put(productId, quantity);
        } else {
            cart.remove(productId);
        }
    }

    private void removeFromCart(Map<String, Integer> cart, String productId) {
        cart.remove(productId);
    }

    private void clearCart(HttpSession session) {
        session.removeAttribute("cart");
    }

    private int getCartSize(Map<String, Integer> cart) {
        return cart.values().stream().mapToInt(Integer::intValue).sum();
    }
}
