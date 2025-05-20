<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp?redirect=checkout");
        return;
    }

    Map<String, Product> cartProducts = (Map<String, Product>) request.getAttribute("cartProducts");
    double subtotal = (Double) request.getAttribute("subtotal");
    double shipping = (Double) request.getAttribute("shipping");
    double total = (Double) request.getAttribute("total");
    List<String> prescriptions = (List<String>) request.getAttribute("prescriptions");

    if (cartProducts == null || cartProducts.isEmpty()) {
        response.sendRedirect("cart");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - OnlineMediCare</title>
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
        .input-field {
            @apply w-full p-3 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 transition duration-300 ease-in-out
        }
        .checkout-step {
            @apply bg-white rounded-lg shadow-md p-6 mb-6
        }
        .checkout-step-header {
            @apply text-xl font-semibold mb-4 pb-2 border-b
        }
    </style>
</head>
<body class="bg-gray-50">
    <!-- Include header -->
    <%@ include file="header.jsp" %>

    <div class="container mx-auto px-4 py-8">
        <h1 class="text-3xl font-bold mb-8 text-center">Checkout</h1>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-exclamation-circle mr-2"></i> ${error}
            </div>
        </c:if>

        <div class="flex flex-col lg:flex-row gap-8">
            <!-- Checkout Form -->
            <div class="w-full lg:w-2/3">
                <form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
                    <!-- Customer Information -->
                    <div class="checkout-step">
                        <h2 class="checkout-step-header">
                            <i class="fas fa-user-circle mr-2 text-green-600"></i> Customer Information
                        </h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label for="name" class="block text-gray-700 mb-1">Full Name</label>
                                <input type="text" id="name" name="name" value="<%= user.getUsername() %>" class="input-field" readonly>
                            </div>
                            <div>
                                <label for="email" class="block text-gray-700 mb-1">Email Address</label>
                                <input type="email" id="email" name="email" value="<%= user.getEmail() %>" class="input-field" readonly>
                            </div>
                            <div>
                                <label for="phone" class="block text-gray-700 mb-1">Phone Number</label>
                                <input type="tel" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" class="input-field" required>
                            </div>
                        </div>
                    </div>

                    <!-- Shipping Address -->
                    <div class="checkout-step">
                        <h2 class="checkout-step-header">
                            <i class="fas fa-shipping-fast mr-2 text-green-600"></i> Shipping Address
                        </h2>
                        <div>
                            <label for="shippingAddress" class="block text-gray-700 mb-1">Delivery Address</label>
                            <textarea id="shippingAddress" name="shippingAddress" rows="3" class="input-field" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                        </div>
                    </div>

                    <!-- Prescription Selection (if needed) -->
                    <% if (prescriptions != null && !prescriptions.isEmpty()) { %>
                    <div class="checkout-step">
                        <h2 class="checkout-step-header">
                            <i class="fas fa-prescription mr-2 text-green-600"></i> Prescription
                        </h2>
                        <div>
                            <label for="prescriptionId" class="block text-gray-700 mb-1">Select Prescription (if applicable)</label>
                            <select id="prescriptionId" name="prescriptionId" class="input-field">
                                <option value="">No prescription needed</option>
                                <c:forEach var="prescription" items="${prescriptions}">
                                    <option value="${prescription}">${prescription}</option>
                                </c:forEach>
                            </select>
                            <p class="text-sm text-gray-600 mt-2">
                                <i class="fas fa-info-circle mr-1"></i>
                                If you're purchasing prescription medicines, please select your uploaded prescription.
                            </p>
                        </div>
                    </div>
                    <% } %>

                    <!-- Payment Method -->
                    <div class="checkout-step">
                        <h2 class="checkout-step-header">
                            <i class="fas fa-credit-card mr-2 text-green-600"></i> Payment Method
                        </h2>
                        <div class="space-y-4">
                            <div class="flex items-center">
                                <input type="radio" id="payment-cod" name="paymentMethod" value="cod" checked class="mr-2">
                                <label for="payment-cod">Cash on Delivery</label>
                            </div>
                            <div class="flex items-center">
                                <input type="radio" id="payment-card" name="paymentMethod" value="card" class="mr-2">
                                <label for="payment-card">Credit/Debit Card</label>
                            </div>

                            <!-- Card details (hidden by default) -->
                            <div id="card-details" class="hidden mt-4 p-4 border rounded-lg">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label for="cardNumber" class="block text-gray-700 mb-1">Card Number</label>
                                        <input type="text" id="cardNumber" name="cardNumber" placeholder="1234 5678 9012 3456" class="input-field">
                                    </div>
                                    <div>
                                        <label for="cardName" class="block text-gray-700 mb-1">Name on Card</label>
                                        <input type="text" id="cardName" name="cardName" placeholder="John Doe" class="input-field">
                                    </div>
                                    <div>
                                        <label for="expiry" class="block text-gray-700 mb-1">Expiry Date</label>
                                        <input type="text" id="expiry" name="expiry" placeholder="MM/YY" class="input-field">
                                    </div>
                                    <div>
                                        <label for="cvv" class="block text-gray-700 mb-1">CVV</label>
                                        <input type="text" id="cvv" name="cvv" placeholder="123" class="input-field">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-6 flex justify-between">
                        <a href="${pageContext.request.contextPath}/cart" class="btn-secondary">
                            <i class="fas fa-arrow-left mr-2"></i> Back to Cart
                        </a>
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-check-circle mr-2"></i> Place Order
                        </button>
                    </div>
                </form>
            </div>

            <!-- Order Summary -->
            <div class="w-full lg:w-1/3">
                <div class="bg-white rounded-lg shadow-md p-6 sticky top-24">
                    <h2 class="text-xl font-semibold mb-4 pb-2 border-b">Order Summary</h2>

                    <div class="max-h-80 overflow-y-auto mb-4">
                        <c:forEach var="entry" items="${cartProducts}">
                            <c:set var="product" value="${entry.value}" />
                            <c:set var="productId" value="${entry.key}" />
                            <c:set var="quantity" value="${cart[productId]}" />

                            <div class="flex items-start py-2 border-b">
                                <div class="w-12 h-12 bg-gray-100 rounded overflow-hidden flex-shrink-0">
                                    <img src="${pageContext.request.contextPath}/${product.imagePath}"
                                         alt="${product.name}"
                                         class="w-full h-full object-contain p-1">
                                </div>
                                <div class="ml-3 flex-1">
                                    <h4 class="text-sm font-medium">${product.name}</h4>
                                    <div class="flex justify-between text-sm text-gray-600">
                                        <span>Qty: ${quantity}</span>
                                        <span>$${String.format("%.2f", product.price * quantity)}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="space-y-2">
                        <div class="flex justify-between text-gray-600">
                            <span>Subtotal</span>
                            <span>$${String.format("%.2f", subtotal)}</span>
                        </div>
                        <div class="flex justify-between text-gray-600">
                            <span>Shipping</span>
                            <span>$${String.format("%.2f", shipping)}</span>
                        </div>
                        <div class="flex justify-between font-semibold text-lg pt-2 border-t">
                            <span>Total</span>
                            <span>$${String.format("%.2f", total)}</span>
                        </div>
                    </div>

                    <div class="mt-6 bg-green-50 p-3 rounded-lg text-sm text-green-800">
                        <i class="fas fa-shield-alt mr-2"></i> Your personal data will be used to process your order, support your experience, and for other purposes described in our privacy policy.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include footer -->
    <%@ include file="footer.jsp" %>

    <script>
        // Toggle card payment details
        document.addEventListener('DOMContentLoaded', function() {
            const paymentCard = document.getElementById('payment-card');
            const paymentCod = document.getElementById('payment-cod');
            const cardDetails = document.getElementById('card-details');

            paymentCard.addEventListener('change', function() {
                if (this.checked) {
                    cardDetails.classList.remove('hidden');
                }
            });

            paymentCod.addEventListener('change', function() {
                if (this.checked) {
                    cardDetails.classList.add('hidden');
                }
            });

            // Form validation
            document.getElementById('checkoutForm').addEventListener('submit', function(e) {
                const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;

                if (paymentMethod === 'card') {
                    const cardNumber = document.getElementById('cardNumber').value;
                    const cardName = document.getElementById('cardName').value;
                    const expiry = document.getElementById('expiry').value;
                    const cvv = document.getElementById('cvv').value;

                    if (!cardNumber || !cardName || !expiry || !cvv) {
                        e.preventDefault();
                        alert('Please fill in all card details');
                    }
                }
            });
        });
    </script>
</body>
</html>
