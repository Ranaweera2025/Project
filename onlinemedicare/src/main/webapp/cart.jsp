<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.Map" %>
<%@ page import="model.User" %>
<%@ page import="java.util.HashMap" %>

<%
    // Redirect to CartServlet if accessed directly
    if (request.getAttribute("cartProducts") == null) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    User user = (User) session.getAttribute("user");
    Map<String, Product> cartProducts = (Map<String, Product>) request.getAttribute("cartProducts");

    // Handle null values with defaults
    Double cartTotalObj = (Double) request.getAttribute("cartTotal");
    double cartTotal = (cartTotalObj != null) ? cartTotalObj : 0.0;

    Integer itemCountObj = (Integer) request.getAttribute("itemCount");
    int itemCount = (itemCountObj != null) ? itemCountObj : 0;

    // Get cart from session
    Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
    }

    if (cartProducts == null || cartProducts.isEmpty()) {
        cartTotal = 0.0;
        itemCount = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .my-gradiant {
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
        .btn-primary {
            @apply bg-green-600 hover:bg-green-700 text-white py-2 px-4 rounded-lg font-semibold transition duration-300 ease-in-out
        }
        .btn-secondary {
            @apply bg-gray-200 hover:bg-gray-300 text-gray-800 py-2 px-4 rounded-lg font-semibold transition duration-300 ease-in-out
        }
        .btn-danger {
            @apply bg-red-500 hover:bg-red-600 text-white py-2 px-4 rounded-lg font-semibold transition duration-300 ease-in-out
        }
        .quantity-btn {
            @apply bg-gray-200 hover:bg-gray-300 text-gray-800 w-8 h-8 rounded-full flex items-center justify-center transition duration-300 ease-in-out
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Include header -->
<%@ include file="header.jsp" %>

<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold mb-8 text-center">Your Shopping Cart</h1>

        <% if (cartProducts == null || cartProducts.isEmpty()) { %>
    <div class="bg-white rounded-lg shadow-md p-8 text-center">
        <div class="text-gray-400 mb-4">
            <i class="fas fa-shopping-cart text-6xl"></i>
        </div>
        <h2 class="text-2xl font-semibold mb-4">Your cart is empty</h2>
        <p class="text-gray-600 mb-6">Looks like you haven't added any products to your cart yet.</p>
        <a href="index.jsp" class="btn-primary inline-block">
            <i class="fas fa-arrow-left mr-2"></i> Continue Shopping
        </a>
    </div>
        <% } else { %>
    <div class="flex flex-col md:flex-row gap-8">
        <!-- Cart Items -->
        <div class="w-full md:w-2/3">
            <div class="bg-white rounded-lg shadow-md overflow-hidden">
                <div class="p-4 bg-gray-50 border-b">
                    <h2 class="text-xl font-semibold">Cart Items (<%= itemCount %>)</h2>
                </div>

                <div class="divide-y divide-gray-200">
                    <c:forEach var="entry" items="${cartProducts}">
                        <c:set var="product" value="${entry.value}" />
                        <c:set var="productId" value="${entry.key}" />
                        <c:set var="quantity" value="${cart[productId]}" />

                        <div class="p-4 flex flex-col sm:flex-row items-center">
                            <div class="w-24 h-24 flex-shrink-0 bg-gray-100 rounded-md overflow-hidden">
                                <img src="${pageContext.request.contextPath}/${product.imagePath}"
                                     alt="${product.name}"
                                     class="w-full h-full object-contain p-2">
                            </div>

                            <div class="flex-1 ml-0 sm:ml-4 mt-4 sm:mt-0">
                                <h3 class="text-lg font-semibold">${product.name}</h3>
                                <p class="text-sm text-gray-600 mb-2">${product.description}</p>
                                <p class="text-green-600 font-bold">${product.price}</p>
                            </div>

                            <div class="flex items-center mt-4 sm:mt-0">
                                <div class="flex items-center border rounded-lg overflow-hidden">
                                    <button class="quantity-btn"
                                            onclick="updateQuantity('${productId}', ${quantity - 1})">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                    <input type="number"
                                           value="${quantity}"
                                           min="1"
                                           max="99"
                                           class="w-12 text-center border-x py-1"
                                           onchange="updateQuantity('${productId}', this.value)">
                                    <button class="quantity-btn"
                                            onclick="updateQuantity('${productId}', ${quantity + 1})">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>

                                <button class="ml-4 text-red-500 hover:text-red-700"
                                        onclick="removeItem('${productId}')">
                                    <i class="fas fa-trash-alt"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="p-4 bg-gray-50 border-t flex justify-between">
                    <button class="btn-secondary" onclick="clearCart()">
                        <i class="fas fa-trash mr-2"></i> Clear Cart
                    </button>
                    <a href="index.jsp" class="btn-secondary">
                        <i class="fas fa-arrow-left mr-2"></i> Continue Shopping
                    </a>
                </div>
            </div>
        </div>

        <!-- Order Summary -->
        <div class="w-full md:w-1/3">
            <div class="bg-white rounded-lg shadow-md p-6">
                <h2 class="text-xl font-semibold mb-4">Order Summary</h2>

                <div class="space-y-4">
                    <div class="flex justify-between border-b pb-4">
                        <span>Subtotal</span>
                        <span>$<%= String.format("%.2f", cartTotal) %></span>
                    </div>

                    <div class="flex justify-between border-b pb-4">
                        <span>Shipping</span>
                        <span>$<%= String.format("%.2f", cartTotal > 50 ? 0.00 : 5.99) %></span>
                    </div>

                    <div class="flex justify-between font-semibold text-lg">
                        <span>Total</span>
                        <span>$<%= String.format("%.2f", cartTotal + (cartTotal > 50 ? 0.00 : 5.99)) %></span>
                    </div>

                    <div class="mt-6">
                        <% if (user != null) { %>
                        <a href="${pageContext.request.contextPath}/checkout" class="btn-primary w-full text-center block">
                            <i class="fas fa-credit-card mr-2"></i> Proceed to Checkout
                        </a>
                        <% } else { %>
                        <div class="text-center">
                            <p class="text-gray-600 mb-4">Please log in to complete your purchase</p>
                            <a href="login.jsp?redirect=cart" class="btn-primary inline-block">
                                <i class="fas fa-sign-in-alt mr-2"></i> Login to Continue
                            </a>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="bg-white rounded-lg shadow-md p-6 mt-6">
                <h3 class="font-semibold mb-4">Have a Prescription?</h3>
                <p class="text-sm text-gray-600 mb-4">If you're purchasing prescription medicines, please upload your prescription before checkout.</p>
                        <a href="prescriptionUpload.jsp" class="text-green-600 hover:text-green-800 flex items-center">
                            <i class="fas fa-file-medical mr-2"></i> Upload Prescription
                        </a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Include footer -->
    <%@ include file="footer.jsp" %>

    <!-- Form for cart operations -->
    <form id="cartForm" method="post" action="${pageContext.request.contextPath}/cart" style="display: none;">
        <input type="hidden" id="action" name="action" value="">
        <input type="hidden" id="productId" name="productId" value="">
        <input type="hidden" id="quantity" name="quantity" value="">
    </form>

    <script>
        function updateQuantity(productId, quantity) {
            if (quantity < 1) quantity = 1;

            document.getElementById('action').value = 'update';
            document.getElementById('productId').value = productId;
            document.getElementById('quantity').value = quantity;
            document.getElementById('cartForm').submit();
        }

        function removeItem(productId) {
            if (confirm('Are you sure you want to remove this item from your cart?')) {
                document.getElementById('action').value = 'remove';
                document.getElementById('productId').value = productId;
                document.getElementById('cartForm').submit();
            }
        }

        function clearCart() {
            if (confirm('Are you sure you want to clear your entire cart?')) {
                document.getElementById('action').value = 'clear';
                document.getElementById('cartForm').submit();
            }
        }

        // Update cart count in header
        document.addEventListener('DOMContentLoaded', function() {
            const cartCountElements = document.querySelectorAll('.cart-count');
            cartCountElements.forEach(element => {
                element.textContent = '<%= itemCount %>';
            });
        });
    </script>
</body>
</html>