<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="service.ProductService" %>
<%@ page import="model.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.stream.Collectors" %>

<%
    // Get all products and group them by category
    ProductService productService = new ProductService();
    List<Product> allProducts = productService.getAllProducts();

    // Get featured products (limit to 5)
    List<Product> featuredProducts = allProducts.stream()
            .limit(5)
            .collect(Collectors.toList());

    // Group products by category
    Map<String, List<Product>> productsByCategory = allProducts.stream()
            .collect(Collectors.groupingBy(Product::getCategory));

    // Get all categories
    List<String> categories = productService.getAllCategories();
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OnlineMediCare - Home</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/webjars/font-awesome/6.4.0/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style type="text/tailwindcss">
        .my-gradiant{
            @apply bg-gradient-to-b from-green-900 to-green-300 bg-gradient-to-r from-green-700 to-green-500
        }
        .menu-items{
            @apply rounded py-[5px] px-[5px] my-[8px] hover:bg-gray-100 transition delay-10 duration-600 ease-in-out cursor-pointer
        }
        .gray-border{
            @apply border-t-[8px] border-blue-100 py-6
        }
        .product-categories-items-li{
            @apply rounded shadow-md hover:shadow-lg transition-shadow hover:-translate-y-1 hover:scale-105 p-[10px]
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
            @apply grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-6 px-8
        }
        .product-container-title{
            @apply text-3xl font-bold text-center mb-4
        }
        .product-container-title-div{
            @apply container mx-auto px-4 py-8 flex flex-col
        }
        .section-main-div{
            @apply mx-[2rem]
        }
        .product-container-main-div{
            @apply flex flex-col gap-6
        }
        .section-highlight {
            @apply transition-all duration-500 transform scale-105;
        }
        .toast {
            @apply fixed top-20 right-5 bg-green-600 text-white py-2 px-4 rounded-md shadow-lg z-50 transition-all duration-300 transform translate-x-full;
        }
        .toast-show {
            @apply translate-x-0;
        }
    </style>
</head>
<body>
<!-- Toast notification for add to cart -->
<div id="toast" class="toast">
    <div class="flex items-center">
        <i class="fas fa-check-circle mr-2"></i>
        <span id="toast-message">Item added to cart!</span>
    </div>
</div>

<!--hero section-->
<div class="bg-[url('${pageContext.request.contextPath}/resources/images/storebackground.jpg')] h-[95vh] w-full bg-cover bg-center relative">
    <!--navbar-->
    <header class="fixed top-0 left-0 right-0 z-50 w-full ">
        <div class="flex py-[6px] px-[50px] justify-between items-center w-full my-gradiant">
            <a href="index.jsp" class="text-[#ffff] text-3xl bg-green-700 py-[10px] px-[15px] rounded-full">MEDICARE CENTER</a>
            <!--search bar-->
            <div class="flex gap-2 bg-white py-[5px] px-[15px] rounded-[20px] border w-full max-w-3xl items-center " >
                <input type="search" placeholder="Search medicines..." class="grow focus:outline-none text-sm">
                <a href="#"><i class="fa-solid fa-magnifying-glass text-xl"></i></a>
            </div>
        </div>
        <!-- Second header bar -->
        <%@ include file="header.jsp" %>
    </header>

    <div class="flex flex-col items-center pt-[20%] gap-8">
        <div class="flex flex-col gap-2 text-center cursor-text">
            <h1 class="text-white text-5xl ">Your Health, Our Priority</h1>
            <p class="text-white text-2xl ">Buy genuine medicines at affordable prices</p>
        </div>
        <div>
            <button class="bg-green-500 py-[5px] px-[10px] max-w-[150px] rounded-[5px] text-xl cursor-pointer hover:bg-green-600 hover:text-white hover:scale-110 transition-all duration-300">
                <a href="#categories" class="smooth-scroll">SHOP NOW</a>
            </button>
        </div>
    </div>
</div>

<!--second section Shop by Categories-->
<section class="gray-border" id="categories">
    <div class="flex flex-col my-[160px] items-center gap-[4rem] my-[3rem] mx-[2rem]">
        <div>
            <h1 class="text-4xl py-[5px] px-[8px] font-bold"> Shop by Categories </h1>
        </div>
        <!--product categories-->
        <div>
            <ul class="flex flex-wrap gap-[2rem] md:gap-[5rem] py-[5px] px-[8px] justify-center text-center font-bold ">
                <%
                // Display each category with its own icon
                for (String category : categories) {
                    // Skip if no products in this category
                    if (productsByCategory.get(category) == null || productsByCategory.get(category).isEmpty())
                        continue;

                    // Create a category ID for anchor links
                    String categoryId = category.replaceAll("\\s+", "");

                    // Choose an appropriate icon based on category
                    String iconImage = "miscellaneousItems.jpg"; // default
                    if (category.contains("Medicine")) {
                        iconImage = "CProduct1.jpg";
                    } else if (category.contains("Equipment")) {
                        iconImage = "healthitems.jpg";
                    } else if (category.contains("Wellness")) {
                        iconImage = "CProduct2.webp";
                    } else if (category.contains("Personal")) {
                        iconImage = "CProduct3.jpeg";
                    }
                %>
                <li class="product-categories-items-li" >
                    <a href="#<%= categoryId %>" class="flex flex-col gap-5 smooth-scroll">
                        <img src="${pageContext.request.contextPath}/resources/images/<%= iconImage %>" class="w-[170px] h-[150px] object-contain"  >
                        <h3 class="max-w-40"><%= category %></h3>
                    </a>
                </li>
                <% } %>
            </ul>
        </div>
    </div>
</section>

<!-- third section-->
<section class="gray-border ">
    <div class="section-main-div">
        <!--product container title-->
        <div class="product-container-title-div">
            <h3 class="product-container-title">
                Featured Products
            </h3>
            <div class="w-30 h-1.5 bg-green-500 mx-auto rounded-full"></div>
        </div>
        <!--product container-->
        <div class="product-container">
            <%
            // Display featured products
            for (Product product : featuredProducts) {
                String imagePath = product.getImagePath() != null && !product.getImagePath().isEmpty()
                                  ? product.getImagePath()
                                  : "resources/images/CProduct1.jpg";
            %>
            <div class="product-main">
                <img src="${pageContext.request.contextPath}/<%= imagePath %>"
                     alt="<%= product.getName() %>" class="product-image" >
                <div class="p-4">
                    <h4 class="product-title"><%= product.getName() %></h4>
                    <p class="product-price">$<%= String.format("%.2f", product.getPrice()) %></p>
                    <button class="product-button add-to-cart"
                            data-id="<%= product.getProductId() %>"
                            data-name="<%= product.getName() %>"
                            data-price="<%= product.getPrice() %>"
                            data-image="<%= imagePath %>">
                        <i class="fas fa-cart-plus mr-2"></i> Add to Cart
                    </button>
                </div>
            </div>
            <% } %>

            <% if (featuredProducts.isEmpty()) { %>
            <!-- Display default products if no products exist -->
            <div class="product-main">
                <img src="${pageContext.request.contextPath}/resources/images/CProduct1.jpg" alt="Hand Sanitizer" class="product-image" >
                <div class="p-4">
                    <h4 class="product-title">Hand Sanitizer</h4>
                    <p class="product-price">$8.99</p>
                    <button class="product-button add-to-cart" data-id="1" data-name="Hand Sanitizer" data-price="8.99" data-image="CProduct1.jpg">
                        <i class="fas fa-cart-plus mr-2"></i> Add to Cart
                    </button>
                </div>
            </div>
            <!-- Add more default products as needed -->
            <% } %>
        </div>
    </div>
</section>

<!-- Dynamic category sections -->
<%
// For each category, create a section
for (String category : categories) {
    List<Product> categoryProducts = productsByCategory.get(category);

    // Skip if no products in this category
    if (categoryProducts == null || categoryProducts.isEmpty()) continue;

    // Create a category ID for anchor links
    String categoryId = category.replaceAll("\\s+", "");
%>
<section class="gray-border" id="<%= categoryId %>">
    <div class="section-main-div">
        <!--product container title-->
        <div class="product-container-title-div">
            <h3 class="product-container-title">
                <%= category %>
            </h3>
            <div class="w-30 h-1.5 bg-green-500 mx-auto rounded-full"></div>
        </div>
        <!--product container-->
        <div class="product-container-main-div">
            <div class="product-container">
                <%
                for (Product product : categoryProducts) {
                    String imagePath = product.getImagePath() != null && !product.getImagePath().isEmpty()
                                      ? product.getImagePath()
                                      : "resources/images/CProduct1.jpg";
                %>
                <div class="product-main">
                    <img src="${pageContext.request.contextPath}/<%= imagePath %>"
                         alt="<%= product.getName() %>" class="product-image" >
                    <div class="p-4">
                        <h4 class="product-title"><%= product.getName() %></h4>
                        <p class="product-price">$<%= String.format("%.2f", product.getPrice()) %></p>
                        <button class="product-button add-to-cart"
                                data-id="<%= product.getProductId() %>"
                                data-name="<%= product.getName() %>"
                                data-price="<%= product.getPrice() %>"
                                data-image="<%= imagePath %>">
                            <i class="fas fa-cart-plus mr-2"></i> Add to Cart
                        </button>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</section>
<% } %>

<!-- About Section -->
<section class="py-10 h-[800px]  bg-gradient-to-br from-blue-50 to-green-50 gray-border " id="about">
    <div class="container mx-auto px-4 max-w-6xl pt-[80px]">
        <!-- Header -->
        <div class="text-center mb-12">
            <h2 class="text-4xl font-bold text-gray-800 mb-4">About MediCare Center</h2>
            <div class="w-30 h-1.5 bg-green-500 mx-auto rounded-full"></div>
        </div>

        <!-- Content Box -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <div class="md:flex">
                <!-- Image Side -->
                <div class="md:w-1/2">
                    <img src="${pageContext.request.contextPath}/resources/images/about.jpeg"
                         alt="Our Medical Center"
                         class="w-full h-full object-cover">
                </div>

                <!-- Text Side -->
                <div class="md:w-1/2 p-8 md:p-10">
                    <h3 class="text-2xl font-semibold text-gray-800 mb-4">Your Trusted Online Healthcare Partner</h3>
                    <p class="text-gray-600 mb-6 leading-relaxed">
                        At MediCare Center, we're revolutionizing healthcare access by bringing quality medical
                        products and services directly to your doorstep. Our platform connects you with genuine
                        medicines, health essentials, and professional advice - all from the comfort of your home.
                    </p>

                    <div class="space-y-4">
                        <div class="flex place-items-start ">
                            <div class="flex-shrink-0 mt-1 text-green-500">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <p class="ml-3 text-gray-600">100% authentic pharmaceutical products</p>
                        </div>

                        <div class="flex items-start">
                            <div class="flex-shrink-0 mt-1 text-green-500">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <p class="ml-3 text-gray-600">Verified doctors and pharmacists on call</p>
                        </div>

                        <div class="flex items-start">
                            <div class="flex-shrink-0 mt-1 text-green-500">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <p class="ml-3 text-gray-600">Fast, discreet delivery nationwide</p>
                        </div>
                    </div>

                    <a href="#" class="inline-block mt-8 bg-green-500 hover:bg-green-600 text-white font-medium py-3 px-8 rounded-full transition duration-300 shadow-md hover:shadow-lg">
                        Discover Our Story
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- footer section-->
<%@ include file="footer.jsp" %>

<!-- JavaScript for cart functionality -->
<!-- Replace the JavaScript for cart functionality in index.jsp with this: -->
<script>
    // Add to cart functionality
    document.querySelectorAll('.add-to-cart').forEach(button => {
        button.addEventListener('click', function() {
            const productId = this.getAttribute('data-id');
            const productName = this.getAttribute('data-name');

            // Send AJAX request to add item to cart
            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=add&productId=${productId}`
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // Update cart count in header
                        const cartCountElements = document.querySelectorAll('.cart-count');
                        cartCountElements.forEach(element => {
                            element.textContent = data.cartSize;
                        });

                        // Show toast notification
                        showToast(`${productName} added to cart!`);

                        // Add animation to button
                        this.classList.add('bg-green-700');
                        setTimeout(() => {
                            this.classList.remove('bg-green-700');
                        }, 300);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        });
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

    // Smooth scrolling for anchor links
    document.querySelectorAll('.smooth-scroll').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();

            const targetId = this.getAttribute('href');
            const targetElement = document.querySelector(targetId);

            if (targetElement) {
                // Remove highlight from all sections
                document.querySelectorAll('section').forEach(section => {
                    section.classList.remove('section-highlight');
                });

                // Scroll to the target section
                window.scrollTo({
                    top: targetElement.offsetTop - 100,
                    behavior: 'smooth'
                });

                // Add highlight effect to the target section
                setTimeout(() => {
                    targetElement.classList.add('section-highlight');

                    // Remove highlight after animation
                    setTimeout(() => {
                        targetElement.classList.remove('section-highlight');
                    }, 1500);
                }, 500);
            }
        });
    });

    // Update cart count on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateCartCount();
    });
</script>

</body>
</html>
