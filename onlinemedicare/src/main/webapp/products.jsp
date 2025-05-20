<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .menu-items{
            @apply rounded py-[5px] px-[5px] my-[8px] hover:bg-gray-100 transition delay-10 duration-600 ease-in-out cursor-pointer
        }
        .my-gradiant{
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
        .product-main{
            @apply bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow hover:-translate-y-1 hover:scale-105
        }
        .product-image{
            @apply w-full h-48 object-contain p-4
        }
        .product-button{
            @apply w-full bg-green-600 hover:-translate-y-1 hover:scale-105 hover:bg-green-700 text-white py-2 rounded-md mt-3 transition-colors transition delay-150 duration-300 ease-in-out
        }
        .product-title{
            @apply font-semibold text-lg mb-1
        }
        .product-price{
            @apply text-green-600 font-bold text-xl
        }
        .product-container{
            @apply grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 px-8
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Include header -->
<%@ include file="header.jsp" %>

<div class="container mx-auto px-4 py-8 mt-16">
    <!-- Page Header -->
    <div class="flex flex-col md:flex-row justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-gray-800 mb-4 md:mb-0">Browse Products</h1>

        <!-- Search and Filter -->
        <div class="w-full md:w-auto flex flex-col md:flex-row gap-4">
            <form action="products" method="get" class="flex gap-2">
                <input type="text" name="query" value="${searchQuery}" placeholder="Search products..."
                       class="px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">

                <select name="category" class="px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${cat eq selectedCategory ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>

                    <i class="fas fa-search mr-2"></i> Search
                </button>
            </form>
        </div>
    </div>

    <!-- No Products Found Message -->
    <c:if test="${empty products}">
        <div class="text-center py-12">
            <i class="fas fa-box-open text-gray-400 text-5xl mb-4"></i>
            <h2 class="text-2xl font-semibold text-gray-700 mb-2">No Products Found</h2>
            <p class="text-gray-500 mb-6">We couldn't find any products matching your criteria.</p>
            <a href="products" class="bg-green-600 hover:bg-green-700 text-white px-6 py-3 rounded-lg inline-block">
                View All Products
            </a>
        </div>
    </c:if>

    <!-- Products Display -->
    <c:if test="${not empty products}">
        <!-- For each category, display products -->
        <c:forEach var="categoryEntry" items="${productsByCategory}">
            <div class="mb-12">
                <h2 class="text-2xl font-bold text-gray-800 mb-6 pb-2 border-b border-gray-200">
                    ${categoryEntry.key}
                </h2>

                <div class="product-container">
                    <c:forEach var="product" items="${categoryEntry.value}">
                        <div class="product-main">
                            <c:choose>
                                <c:when test="${not empty product.imagePath}">
                                    <img src="${pageContext.request.contextPath}/${product.imagePath}"
                                         alt="${product.name}" class="product-image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/resources/images/CProduct1.jpg"
                                         alt="${product.name}" class="product-image">
                                </c:otherwise>
                            </c:choose>

                            <div class="p-4">
                                <h4 class="product-title">${product.name}</h4>
                                <p class="text-sm text-gray-600 mb-2">${product.category}</p>
                                <p class="product-price">$${product.price}</p>

                                <c:if test="${product.stock > 0}">
                                    <p class="text-sm text-green-600 mb-2">
                                        <i class="fas fa-check-circle mr-1"></i> In Stock (${product.stock})
                                    </p>
                                </c:if>
                                <c:if test="${product.stock <= 0}">
                                    <p class="text-sm text-red-600 mb-2">
                                        <i class="fas fa-times-circle mr-1"></i> Out of Stock
                                    </p>
                                </c:if>

                                <a href="products?action=details&productId=${product.productId}" class="block text-blue-600 hover:underline mb-2">
                                    View Details
                                </a>

                                <button class="product-button add-to-cart"
                                        data-id="${product.productId}"
                                        data-name="${product.name}"
                                        data-price="${product.price}"
                                        data-image="${not empty product.imagePath ? product.imagePath : 'resources/images/CProduct1.jpg'}">
                                    <i class="fas fa-cart-plus mr-2"></i> Add to Cart
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </c:if>
</div>

<!-- Toast notification for add to cart -->
<div id="toast" class="fixed top-20 right-5 bg-green-600 text-white py-2 px-4 rounded-md shadow-lg z-50 transition-all duration-300 transform translate-x-full">
    <div class="flex items-center">
        <i class="fas fa-check-circle mr-2"></i>
        <span id="toast-message">Item added to cart!</span>
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
    });

    // Show toast notification
    function showToast(message) {
        const toast = document.getElementById('toast');
        const toastMessage = document.getElementById('toast-message');

        toastMessage.textContent = message;
        toast.classList.add('translate-x-0');
        toast.classList.remove('translate-x-full');

        setTimeout(() => {
            toast.classList.add('translate-x-full');
            toast.classList.remove('translate-x-0');
        }, 3000);
    }

    // Update cart count on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateCartCount();
    });
</script>
</body>
</html>