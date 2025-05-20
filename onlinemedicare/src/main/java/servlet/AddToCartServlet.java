// src/main/java/servlet/AddToCartServlet.java
package servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Cart;

import java.io.IOException;

public class AddToCartServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        String productId = request.getParameter("productId");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart(userId);
            session.setAttribute("cart", cart);
        }

        cart.addItem(productId, quantity);
        response.sendRedirect("products.jsp?added=true");
    }
}