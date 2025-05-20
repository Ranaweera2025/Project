<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Catalog - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .my-gradiant {
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
        .product-card {
            @apply bg-white rounded-lg shadow-md overflow-hidden hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1
        }
        .product-image {
            @apply w-full h-48 object-contain p-4 bg-gray-50
        }
        .product-button {
            @apply w-full bg-green-600 hover:bg-green-700 text-white py-2 rounded-md transition-colors duration-300 ease-in-out flex items-center justify-center
        }
        .badge {
            @apply px-2 py-1 rounded-full text-xs font-semibold
        }
        .badge-success {
            @apply bg-green-100 text-green-800
        }
        .badge-warning {
            @apply bg-yellow-100 text-yellow-800
        }
        .badge-danger {
            @apply bg-red-100 text-red-800
        }
        .toast {
            @apply fixed top-20 right-5 bg-green-600 text-white py-2 px-4 rounded-md shadow-lg z-50 transition-all duration-300 transform translate-x-full;
        }
        .toast-show {
            @apply translate-x-0;
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Toast notification for add to cart -->
<div id="toast" class="toast">
    <div class="flex items-center">
        <i class="fas fa-check-circle mr-2"></i>
        <span id="toast-message">Item added to cart!</span>
    </div>
</div>

<!-- Include header -->
<%@ include file="header.jsp" %>

<div class="container mx-auto px-4 py-8 mt-16">
    <!-- Page Header -->
    <div class="bg-white rounded-lg shadow-md p-6 mb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-4">Medical Products Catalog</h1>
        <p class="text-gray-600 mb-6">Browse our selection of high-quality medical products for your healthcare needs.</p>

        <!-- Search and Filter -->
        <form action="products" method="get" class="flex flex-col md:flex-row gap-4">
            <div class="relative flex-grow">
                <input type="text" name="query" value="${param.query}" placeholder="Search products..."
                       class="pl-10 pr-4 py-3 w-full border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
            </div>

            <select name="category" class="border rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-green-500">
                <option value="">All Categories</option>
                <option value="Medicine" ${param.category == 'Medicine' ? 'selected' : ''}>Medicine</option>
                <option value="Equipment" ${param.category == 'Equipment' ? 'selected' : ''}>Equipment</option>
                <option value="Supplies" ${param.category == 'Supplies' ? 'selected' : ''}>Supplies</option>
                <option value="Wellness" ${param.category == 'Wellness' ? 'selected' : ''}>Wellness</option>
            </select>

            <button type="submit" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg font-semibold transition duration-300 ease-in-out">
                <i class="fas fa-filter mr-2"></i> Filter
            </button>
        </form>
    </div>

    <!-- Category Pills -->
    <div class="flex flex-wrap gap-2 mb-8">
        <a href="products" class="px-4 py-2 rounded-full ${empty param.category ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'} transition duration-300">
            All Products
        </a>
        <a href="products?category=Medicine" class="px-4 py-2 rounded-full ${param.category == 'Medicine' ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'} transition duration-300">
            Medicine
        </a>
        <a href="products?category=Equipment" class="px-4 py-2 rounded-full ${param.category == 'Equipment' ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'} transition duration-300">
            Equipment
        </a>
        <a href="products?category=Supplies" class="px-4 py-2 rounded-full ${param.category == 'Supplies' ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'} transition duration-300">
            Supplies
        </a>
        <a href="products?category=Wellness" class="px-4 py-2 rounded-full ${param.category == 'Wellness' ? 'bg-green-600 text-white' : 'bg-gray-200 text-gray-700 hover:bg-gray-300'} transition duration-300">
            Wellness
        </a>
    </div>

    <!-- Products Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <c:forEach var="product" items="${products}">
            <div class="product-card">
                <div class="relative">
                    <img src="${pageContext.request.contextPath}/resources/images/products/${product.productId}.jpg"
                         onerror="this.src='${pageContext.request.contextPath}/resources/images/product-placeholder.jpg'"
                         alt="${product.name}" class="product-image">

                    <c:choose>
                        <c:when test="${product.stock > 10}">
                            <span class="badge badge-success absolute top-2 right-2">In Stock</span>
                        </c:when>
                        <c:when test="${product.stock > 0}">
                            <span class="badge badge-warning absolute top-2 right-2">Low Stock</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-danger absolute top-2 right-2">Out of Stock</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="p-4">
                    <div class="flex justify-between items-start">
                        <div>
                            <h3 class="font-semibold text-lg mb-1">${product.name}</h3>
                            <p class="text-sm text-gray-500 mb-2">${product.category}</p>
                        </div>
                        <p class="text-green-600 font-bold">$${product.price}</p>
                    </div>

                    <p class="text-sm text-gray-600 mb-3 line-clamp-2">${product.description}</p>

                    <div class="flex flex-col gap-2">
                        <a href="products?action=details&productId=${product.productId}" class="text-blue-500 hover:text-blue-700 text-sm">
                            <i class="fas fa-info-circle mr-1"></i> View Details
                        </a>

                        <button class="product-button add-to-cart ${product.stock <= 0 ? 'opacity-50 cursor-not-allowed' : ''}"
                                ${product.stock <= 0 ? 'disabled' : ''}
                                data-id="${product.productId}"
                                data-name="${product.name}"
                                data-price="${product.price}"
                                data-image="${product.productId}.jpg">
                            <i class="fas fa-cart-plus mr-2"></i> Add to Cart
                        </button>
                    </div>
                </div>
            </div>
        </c:forEach>

        <!-- Empty state -->
        <c:if test="${empty products}">
            <div class="col-span-full py-12 flex flex-col items-center justify-center text-gray-500">
                <i class="fas fa-box-open text-5xl mb-4"></i>
                <h3 class="text-xl font-medium mb-2">No products found</h3>
                <p class="mb-4">Try adjusting your search or filter criteria</p>
                <a href="products" class="bg-green-600 hover:bg-green-700 text-white px-6 py-2 rounded-lg font-semibold transition duration-300 ease-in-out">
                    View All Products
                </a>
            </div>
        </c:if>
    </div>
</div>

<!-- Include footer -->
<%@ include file="footer.jsp" %>

<!-- JavaScript for cart functionality -->
<script>
    // Initialize cart in localStorage if it doesn't exist
    if (!localStorage.getItem('cart')) {
        localStorage.setItem('cart', JSON.stringify([]));
    }

    // Update cart count in header
    function updateCartCount() {
        const cart = JSON.parse(localStorage.getItem('cart')) || [];
        const count = cart.reduce((total, item) => total + item.quantity, 0);
        const cartCountElements = document.querySelectorAll('.cart-count');
        cartCountElements.forEach(element => {
            element.textContent = count;
        });
    }

    // Add to cart functionality
    document.querySelectorAll('.add-to-cart').forEach(button => {
        if (!button.disabled) {
            button.addEventListener('click', function() {
                const productId = this.getAttribute('data-id');
                const productName = this.getAttribute('data-name');
                const productPrice = parseFloat(this.getAttribute('data-price'));
                const productImage = this.getAttribute('data-image');

                // Get current cart
                const cart = JSON.parse(localStorage.getItem('cart')) || [];

                // Check if product already in cart
                const existingProductIndex = cart.findIndex(item => item.id === productId);

                if (existingProductIndex > -1) {
                    // Increment quantity if product already in cart
                    cart[existingProductIndex].quantity += 1;
                } else {
                    // Add new product to cart
                    cart.push({
                        id: productId,
                        name: productName,
                        price: productPrice,
                        image: productImage,
                        quantity: 1
                    });
                }

                // Save updated cart
                localStorage.setItem('cart', JSON.stringify(cart));

                // Update cart count
                updateCartCount();

                // Show toast notification
                showToast(`${productName} added to cart!`);

                // Add animation to button
                this.classList.add('bg-green-700');
                setTimeout(() => {
                    this.classList.remove('bg-green-700');
                }, 300);
            });
        }
    });

    // Show toast notification
    function showToast(message) {
        const toast = document.getElementById('toast');
        const toastMessage = document.getElementById('toast-message');

        toastMessage.textContent = message;
        toast.classList.add('toast-show');

        setTimeout(() => {
            toast.classList.remove('toast-show');
        }, 3000);
    }

    // Update cart count on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateCartCount();
    });
</script>
</body>
</html>