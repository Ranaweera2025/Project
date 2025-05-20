<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - OnlineMediCare</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <style type="text/tailwindcss">
        .menu-items{
            @apply rounded py-[5px] px-[5px] my-[8px] hover:bg-gray-100 transition delay-10 duration-600 ease-in-out cursor-pointer
        }
        .my-gradiant{
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
        .btn-primary {
            @apply bg-green-600 hover:bg-green-700 text-white py-3 px-6 rounded-lg font-semibold transition duration-300 ease-in-out
        }
        .btn-secondary {
            @apply bg-gray-200 hover:bg-gray-300 text-gray-800 py-3 px-6 rounded-lg font-semibold transition duration-300 ease-in-out
        }
    </style>
</head>
<body class="bg-gray-50">
<!-- Include header -->
<div id="toast" class="fixed top-20 right-5 bg-green-600 text-white py-2 px-4 rounded-md shadow-lg z-50 transition-all duration-300 transform translate-x-full">

<div class="container mx-auto px-4 py-8 mt-16">
    <!-- Breadcrumb -->
    <nav class="flex mb-8" aria-label="Breadcrumb">
        <ol class="inline-flex items-center space-x-1 md:space-x-3">
            <li class="inline-flex items-center">
                <a href="index.jsp" class="text-gray-700 hover:text-green-600">
                    <i class="fas fa-home mr-2"></i> Home
                </a>
            </li>
            <li>
                <div class="flex items-center">
                    <i class="fas fa-chevron-right text-gray-400 mx-2"></i>
                    <a href="products" class="text-gray-700 hover:text-green-600">Products</a>
                </div>
            </li>
            <li>
                <div class="flex items-center">
                    <i class="fas fa-chevron-right text-gray-400 mx-2"></i>
                    <a href="products?category=${product.category}" class="text-gray-700 hover:text-green-600">${product.category}</a>
                </div>
            </li>
            <li aria-current="page">
                <div class="flex items-center">
                    <i class="fas fa-chevron-right text-gray-400 mx-2"></i>
                    <span class="text-gray-500">${product.name}</span>
                </div>
            </li>
        </ol>
    </nav>

    <!-- Product Details -->
    <div class="bg-white rounded-lg shadow-md overflow-hidden">
        <div class="md:flex">
            <!-- Product Image -->
            <div class="md:w-1/2 p-6 flex items-center justify-center bg-gray-50">
                <c:choose>
                    <c:when test="${not empty product.imagePath}">
                        <img src="${pageContext.request.contextPath}/${product.imagePath}"
                             alt="${product.name}" class="max-h-96 object-contain">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/resources/images/CProduct1.jpg"
                             alt="${product.name}" class="max-h-96 object-contain">
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Product Info -->
            <div class="md:w-1/2 p-6 md:p-8">
                <div class="mb-4">
                    <span class="inline-block bg-green-100 text-green-800 text-xs font-semibold px-2.5 py-0.5 rounded">
                        ${product.category}
                    </span>

                    <c:if test="${product.prescriptionRequired}">
                        <span class="inline-block bg-blue-100 text-blue-800 text-xs font-semibold px-2.5 py-0.5 rounded ml-2">
                            Prescription Required
                        </span>
                    </c:if>
                </div>

                <h1 class="text-3xl font-bold text-gray-900 mb-2">${product.name}</h1>

                <div class="flex items-center mb-4">
                    <div class="flex items-center">
                        <i class="fas fa-star text-yellow-400"></i>
                        <i class="fas fa-star text-yellow-400"></i>
                        <i class="fas fa-star text-yellow-400"></i>
                        <i class="fas fa-star text-yellow-400"></i>
                        <i class="fas fa-star-half-alt text-yellow-400"></i>
                    </div>
                    <span class="text-gray-600 ml-2">4.5 (24 reviews)</span>
                </div>

                <p class="text-4xl font-bold text-green-600 mb-6">$${product.price}</p>

                <div class="mb-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-2">Description</h2>
                    <p class="text-gray-700">${product.description}</p>
                </div>

                <div class="mb-6">
                    <h2 class="text-lg font-semibold text-gray-900 mb-2">Product Details</h2>
                    <ul class="space-y-2 text-gray-700">
                        <li><span class="font-medium">Product ID:</span> ${product.productId}</li>
                        <c:if test="${not empty product.manufacturer}">
                            <li><span class="font-medium">Manufacturer:</span> ${product.manufacturer}</li>
                        </c:if>
                        <li>
                            <span class="font-medium">Availability:</span>
                            <c:choose>
                                <c:when test="${product.stock > 10}">
                                    <span class="text-green-600">In Stock (${product.stock} available)</span>
                                </c:when>
                                <c:when test="${product.stock > 0}">
                                    <span class="text-yellow-600">Low Stock (${product.stock} left)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-red-600">Out of Stock</span>
                                </c:otherwise>
                            </c:choose>
                        </li>

                        <!-- Display specialized fields based on product type -->
                        <c:if test="${product['class'].simpleName eq 'Medicine'}">
                            <li><span class="font-medium">Dosage:</span> ${product.dosage}</li>
                            <li><span class="font-medium">Expiration Date:</span> ${product.expirationDate}</li>
                        </c:if>

                        <c:if test="${product['class'].simpleName eq 'Equipment'}">
                            <li><span class="font-medium">Warranty Period:</span> ${product.warrantyPeriod}</li>
                        </c:if>
                    </ul>
                </div>

                <div class="flex flex-col sm:flex-row gap-4">
                    <div class="flex border rounded-lg overflow-hidden">
                        <button id="decrease-quantity" class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700">
                            <i class="fas fa-minus"></i>
                        </button>
                        <input type="number" id="quantity" value="1" min="1" max="${product.stock}"
                               class="w-16 text-center focus:outline-none" readonly>
                        <button id="increase-quantity" class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>

                    <button id="add-to-cart-btn" class="btn-primary flex-grow flex items-center justify-center"
                            data-id="${product.productId}"
                            data-name="${product.name}"
                            data-price="${product.price}"
                            data-image="${not empty product.imagePath ? product.imagePath : 'resources/images/CProduct1.jpg'}">
                        <i class="fas fa-cart-plus mr-2"></i> Add to Cart
                    </button>
                </div>

                <c:if test="${product.prescriptionRequired}">
                    <div class="mt-4 p-4 bg-blue-50 rounded-lg">
                        <p class="text-blue-800 flex items-start">
                            <i class="fas fa-prescription mr-2 mt-1"></i>
                            <span>This product requires a valid prescription. Please upload your prescription during checkout.</span>
                        </p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Related Products -->
    <div class="mt-12">
        <h2 class="text-2xl font-bold text-gray-800 mb-6">Related Products</h2>

        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <c:forEach var="relatedProduct" items="${relatedProducts}">
                <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow">
                    <c:choose>
                        <c:when test="${not empty relatedProduct.imagePath}">
                            <img src="${pageContext.request.contextPath}/${relatedProduct.imagePath}"
                                 alt="${relatedProduct.name}" class="w-full h-48 object-contain p-4">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/resources/images/CProduct1.jpg"
                                 alt="${relatedProduct.name}" class="w-full h-48 object-contain p-4">
                        </c:otherwise>
                    </c:choose>

                    <div class="p-4">
                        <h4 class="font-semibold text-lg mb-1">${relatedProduct.name}</h4>
                        <p class="text-green-600 font-bold text-xl">$${relatedProduct.price}</p>

                        <a href="products?action=details&productId=${relatedProduct.productId}"
                           class="block text-blue-600 hover:underline mb-2">
                            View Details
                        </a>

                        <button class="w-full bg-green-600 hover:bg-green-700 text-white py-2 rounded-md mt-3 transition-colors add-to-cart"
                                data-id="${relatedProduct.productId}"
                                data-name="${relatedProduct.name}"
                                data-price="${relatedProduct.price}"
                                data-image="${not empty relatedProduct.imagePath ? relatedProduct.imagePath : 'resources/images/CProduct1.jpg'}">
                            <i class="fas fa-cart-plus mr-2"></i> Add to Cart
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Include footer -->
<%@ include file="footer.jsp" %>

<!-- JavaScript for product details page -->
<script>
    // Quantity controls
    const quantityInput = document.getElementById('quantity');
    const decreaseBtn = document.getElementById('decrease-quantity');
    const increaseBtn = document.getElementById('increase-quantity');
    const maxStock = ${product.stock};

    decreaseBtn.addEventListener('click', function() {
        let currentValue = parseInt(quantityInput.value);
        if (currentValue > 1) {
            quantityInput.value = currentValue - 1;
        }
    });

    increaseBtn.addEventListener('click', function() {
        let currentValue = parseInt(quantityInput.value);
        if (currentValue < maxStock) {
            quantityInput.value = currentValue + 1;
        }
    });

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

    // Add to cart functionality for main product
    document.getElementById('add-to-cart-btn').addEventListener('click', function() {
        const productId = this.getAttribute('data-id');
        const productName = this.getAttribute('data-name');
        const productPrice = parseFloat(this.getAttribute('data-price'));
        const productImage = this.getAttribute('data-image');
        const quantity = parseInt(document.getElementById('quantity').value);

        // Get current cart
        const cart = JSON.parse(localStorage.getItem('cart')) || [];

        // Check if product already in cart
        const existingProductIndex = cart.findIndex(item => item.id === productId);

        if (existingProductIndex > -1) {
            // Update quantity if product already in cart
            cart[existingProductIndex].quantity += quantity;
        } else {
            // Add new product to cart
            cart.push({
                id: productId,
                name: productName,
                price: productPrice,
                image: productImage,
                quantity: quantity
            });
        }

        // Save updated cart
        localStorage.setItem('cart', JSON.stringify(cart));

        // Update cart count
        updateCartCount();

        // Show toast notification
        showToast(`${quantity} ${quantity > 1 ? 'items' : 'item'} added to cart!`);

        // Add animation to button
        this.classList.add('bg-green-700');
        setTimeout(() => {
            this.classList.remove('bg-green-700');
        }, 300);
    });

    // Add to cart functionality for related products
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